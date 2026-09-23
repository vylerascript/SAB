- ============================================================
--  VividCheats GUI  ?  Easy Builder Edition
-- ============================================================
--
--  +------------------------------------------------------+
--  ¦              HOW TO ADD NEW STUFF                    ¦
--  ¦------------------------------------------------------¦
--  ¦                                                      ¦
--  ¦  1. Scroll to "YOUR TABS & OPTIONS GO HERE"          ¦
--  ¦                                                      ¦
--  ¦  2. Make a tab:                                      ¦
--  ¦       local myTab = GUI:Tab("Tab Name")              ¦
--  ¦                                                      ¦
--  ¦  3. Add options to it:                               ¦
--  ¦       myTab:Label("Section Title")                   ¦
--  ¦       myTab:Toggle("Feature Name", false, callback)  ¦
--  ¦       myTab:Slider("Speed", 1, 100, 16, callback)    ¦
--  ¦       myTab:Input("Label", "placeholder", callback)  ¦
--  ¦       myTab:Button("Click Me", callback)             ¦
--  ¦       myTab:Dropdown("Pick One",                     ¦
--  ¦           {"Option A","Option B"}, callback)         ¦
--  ¦                                                      ¦
--  ¦  That's it. Nothing else to touch.                   ¦
--  +------------------------------------------------------+
--
-- ============================================================

-- ============================================================
--  SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")
local VirtualUser      = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Camera      = Workspace.CurrentCamera
local Mouse       = LocalPlayer:GetMouse()

-- ============================================================
--  THEME  (edit colours here)
-- ============================================================
local Theme = {
	MainBG     = Color3.fromRGB(26,  51,  77),
	TabBG      = Color3.fromRGB(26,  51,  77),
	SectionBG  = Color3.fromRGB(18,  36,  56),
	Accent     = Color3.fromRGB(0,  170, 127),
	BtnText    = Color3.fromRGB(255, 255, 255),
	LabelText  = Color3.fromRGB(200, 220, 255),
	ToggleON   = Color3.fromRGB(0,  200, 140),
	ToggleOFF  = Color3.fromRGB(80,  80,  80),
	SliderFill = Color3.fromRGB(0,  170, 127),
	InputBG    = Color3.fromRGB(14,  28,  45),
	SettingsBG = Color3.fromRGB(20,  40,  62),
	ButtonBG   = Color3.fromRGB(0,  140, 100),
	DropBG     = Color3.fromRGB(14,  28,  45),
	TitleColor = Color3.fromRGB(0,  170, 127), -- custom title
}

local defaultTabName = "Main" --you can replace this to Self,PVP.. any Tab you make/have

-- live theming registry
local themedObjects = {}
local function reg(inst, prop, key)
	table.insert(themedObjects, {inst=inst, prop=prop, key=key})
end
local function applyTheme()
	for _, t in ipairs(themedObjects) do
		t.inst[t.prop] = Theme[t.key]
	end
end

-- ============================================================
--  ROOT GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
local rng = Random.new()

local function randomUnicodeChar()
	local ranges = {
		{0x0030, 0x0039}, -- 0-9
		{0x0041, 0x005A}, -- A-Z
		{0x0061, 0x007A}, -- a-z
		{0x0370, 0x03FF}, -- Greek
		{0x0400, 0x04FF}, -- Cyrillic
		{0x0600, 0x06FF}, -- Arabic
	}

	local r = ranges[rng:NextInteger(1, #ranges)]
	local codepoint = rng:NextInteger(r[1], r[2])
	return utf8.char(codepoint)
end

local function generateId(len)
	local t = table.create(len)
	for i = 1, len do
		t[i] = randomUnicodeChar()
	end
	return table.concat(t)
end


ScreenGui.Name = generateId(24) -- generated ScreenGui Name UI NAME
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn    = false
ScreenGui.Parent          = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3       = Theme.MainBG
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel        = 0
MainFrame.Position               = UDim2.new(0.2, 0, 0.25, 0)
MainFrame.Size                   = UDim2.new(0, 680, 0, 420)
MainFrame.Parent                 = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MFStroke = Instance.new("UIStroke", MainFrame)
MFStroke.Color = Theme.Accent; MFStroke.Thickness = 2; MFStroke.Transparency = 0.4
reg(MainFrame, "BackgroundColor3", "MainBG")
table.insert(themedObjects, {inst=MFStroke, prop="Color", key="Accent"})

-- drag
do
	local dragging, dragStart, startPos
	MainFrame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = i.Position; startPos = MainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
			or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			MainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
end

-- title VividCheats
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 36)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1


TitleLabel.Text = "VividCheats©"


local RunService = game:GetService("RunService")

local gradient = Instance.new("UIGradient")
gradient.Rotation = 0
gradient.Parent = TitleLabel



local function themeShift(base, offset)
	local h, s, v = base:ToHSV()
	return Color3.fromHSV((h + offset) % 1, s, v)
end

RunService.RenderStepped:Connect(function()
	local t = os.clock() * 0.3

	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, themeShift(Theme.TitleColor, t)),
		ColorSequenceKeypoint.new(0.25, themeShift(Theme.TitleColor, t + 0.25)),
		ColorSequenceKeypoint.new(0.5, themeShift(Theme.TitleColor, t + 0.5)),
		ColorSequenceKeypoint.new(0.75, themeShift(Theme.TitleColor, t + 0.75)),
		ColorSequenceKeypoint.new(1, themeShift(Theme.TitleColor, t + 1)),
	})

	gradient.Rotation = (t * 180) % 360
end)

TitleLabel.TextColor3 = Theme.TitleColor
TitleLabel.Font = Enum.Font.GrenzeGotisch
TitleLabel.TextSize = 25
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

reg(TitleLabel, "TextColor3", "TitleColor")

-- top buttons helper
local function makeTopButton(text, xOffset)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 36, 0, 28)
	btn.Position = UDim2.new(1, -xOffset, 0, 4)
	btn.BackgroundColor3 = Theme.Accent
	btn.BackgroundTransparency = 0.15
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Theme.BtnText
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextScaled = true
	btn.Parent = MainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
	local s = Instance.new("UIStroke", btn)
	s.Color = Theme.Accent; s.Thickness = 1.5; s.Transparency = 0.5
	reg(btn, "BackgroundColor3", "Accent"); reg(btn, "TextColor3", "BtnText")
	table.insert(themedObjects, {inst=s, prop="Color", key="Accent"})
	return btn
end

local ExitBtn     = makeTopButton("X",  44)
local MinBtn      = makeTopButton("-",  84)
local SettingsBtn = makeTopButton("?", 126)

-- tab bar
local TabBar = Instance.new("Frame")
TabBar.BackgroundColor3 = Theme.TabBG
TabBar.BackgroundTransparency = 0.3
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 8, 0, 40)
TabBar.Size = UDim2.new(1, -16, 0, 44)
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 6)
local tbl = Instance.new("UIListLayout", TabBar)
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.Padding = UDim.new(0, 6)
tbl.VerticalAlignment = Enum.VerticalAlignment.Center
Instance.new("UIPadding", TabBar).PaddingLeft = UDim.new(0, 8)
reg(TabBar, "BackgroundColor3", "TabBG")

-- content area
local ContentArea = Instance.new("Frame")
ContentArea.BackgroundColor3 = Theme.SectionBG
ContentArea.BackgroundTransparency = 0.1
ContentArea.BorderSizePixel = 0
ContentArea.Position = UDim2.new(0, 8, 0, 92)
ContentArea.Size = UDim2.new(1, -16, 1, -100)
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainFrame
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 6)
reg(ContentArea, "BackgroundColor3", "SectionBG")

-- ============================================================
--  INTERNAL WIDGET BUILDERS
--  (these are used by the GUI builder below ? don't call directly)
-- ============================================================
local function _makeScrollSection()
	local sf = Instance.new("ScrollingFrame")
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.Size = UDim2.new(1, 0, 1, 0)
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.ScrollBarThickness = 4
	sf.ScrollBarImageColor3 = Theme.Accent
	sf.Visible = false
	sf.Parent = ContentArea
	local list = Instance.new("UIListLayout", sf)
	list.Padding = UDim.new(0, 6)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	local pad = Instance.new("UIPadding", sf)
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingTop  = UDim.new(0, 6)
	table.insert(themedObjects, {inst=sf, prop="ScrollBarImageColor3", key="Accent"})
	return sf
end

local function _label(section, text)
	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, -14, 0, 22)
	lbl.Text = "-- " .. text .. " --"
	lbl.TextColor3 = Theme.Accent
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = section
	reg(lbl, "TextColor3", "Accent")
	return lbl
end

local function _toggle(section, label, default, callback)
	local state = default == true
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -14, 0, 38)
	row.Parent = section

	local lbl = Instance.new("TextLabel", row)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(0.75, 0, 1, 0)
	lbl.Text = label
	lbl.TextColor3 = Theme.LabelText
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	reg(lbl, "TextColor3", "LabelText")

	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(0, 46, 0, 22)
	track.Position = UDim2.new(1, -50, 0.5, -11)
	track.BackgroundColor3 = state and Theme.ToggleON or Theme.ToggleOFF
	track.BorderSizePixel = 0
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", track)
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(1,0,1,0)
	btn.BackgroundTransparency = 1
	btn.Text = ""

	-- returns a set() function so code can change state programmatically
	local function set(v)
		state = v
		TweenService:Create(track, TweenInfo.new(0.15), {
			BackgroundColor3 = state and Theme.ToggleON or Theme.ToggleOFF
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
		}):Play()
		if callback then callback(state) end
	end

	btn.MouseButton1Click:Connect(function() set(not state) end)
	return row, set
end
local function _slider(section, label, minVal, maxVal, default, callback)
	local UserInputService = game:GetService("UserInputService")

	local value = default or minVal

	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -14, 0, 52)
	row.Parent = section

	local lbl = Instance.new("TextLabel", row)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, 0, 0, 18)
	lbl.TextColor3 = Theme.LabelText
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	reg(lbl, "TextColor3", "LabelText")

	local function setLabelText()
		lbl.Text = label .. ": " .. tostring(value)
	end

	setLabelText()

	-- INPUT MODE (INLINE EDIT)
	local editing = false

	lbl.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if editing then return end

		editing = true

		local oldText = lbl.Text

		local box = Instance.new("TextBox")
		box.Size = lbl.Size
		box.Position = lbl.Position
		box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		box.TextColor3 = Theme.LabelText
		box.Font = Enum.Font.Gotham
		box.TextSize = 13
		box.ClearTextOnFocus = false
		box.Text = tostring(value)
		box.Parent = lbl.Parent
		box.ZIndex = lbl.ZIndex + 1

		lbl.Visible = false
		box:CaptureFocus()

		local function commit()
			local num = tonumber(box.Text)
			if num then
				value = math.clamp(math.round(num), minVal, maxVal)
			end

			box:Destroy()
			lbl.Visible = true
			editing = false

			setLabelText()
			if callback then
				callback(value)
			end
		end

		box.FocusLost:Connect(commit)
	end)

	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(1, -4, 0, 8)
	track.Position = UDim2.new(0, 0, 0, 28)
	track.BackgroundColor3 = Color3.fromRGB(50, 70, 90)
	track.BorderSizePixel = 0
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local rel0 = (value - minVal) / (maxVal - minVal)

	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new(rel0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.SliderFill
	fill.BorderSizePixel = 0
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", track)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(rel0, -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local dragging = false

	local hit = Instance.new("TextButton", row)
	hit.Size = UDim2.new(1, 0, 0, 24)
	hit.Position = UDim2.new(0, 0, 0, 22)
	hit.BackgroundTransparency = 1
	hit.Text = ""

	local function apply(v)
		v = math.clamp(v, minVal, maxVal)
		value = math.round(v)

		local rel = (value - minVal) / (maxVal - minVal)

		fill.Size = UDim2.new(rel, 0, 1, 0)
		knob.Position = UDim2.new(rel, -7, 0.5, -7)

		setLabelText()

		if callback then
			callback(value)
		end
	end

	local function updateFromX(screenX)
		local absX = track.AbsolutePosition.X
		local width = track.AbsoluteSize.X
		if width <= 0 then return end

		local rel = math.clamp((screenX - absX) / width, 0, 1)
		local v = minVal + rel * (maxVal - minVal)

		apply(v)
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			updateFromX(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			updateFromX(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	return row
end
local function _input(section, label, placeholder, callback)
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1,-14,0,56)
	row.Parent = section

	local lbl = Instance.new("TextLabel", row)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1,0,0,18)
	lbl.Text = label
	lbl.TextColor3 = Theme.LabelText
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	reg(lbl, "TextColor3", "LabelText")

	local box = Instance.new("TextBox", row)
	box.Size = UDim2.new(1,-4,0,30)
	box.Position = UDim2.new(0,0,0,20)
	box.BackgroundColor3 = Theme.InputBG
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholder or ""
	box.PlaceholderColor3 = Color3.fromRGB(100,130,160)
	box.Text = ""
	box.TextColor3 = Theme.LabelText
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.ClearTextOnFocus = false

	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	local bs = Instance.new("UIStroke", box)
	bs.Color = Theme.Accent
	bs.Thickness = 1
	bs.Transparency = 0.6

	reg(box, "BackgroundColor3", "InputBG")
	reg(box, "TextColor3", "LabelText")
	table.insert(themedObjects, {inst=bs, prop="Color", key="Accent"})

	local function submit()
		if not callback then return end

		local text = (box.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")

		if text == "" then
			box.Text = ""
			return
		end

		-- optional auto number conversion (safe)
		local num = tonumber(text)
		if num then
			callback(num)
		else
			callback(text)
		end
	end

	box.FocusLost:Connect(function(enterPressed)
		submit()
	end)

	box.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.Return then
				submit()
			end
		end
	end)

	return row
end

local function _button(section, label, callback)
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1,-14,0,36)
	row.Parent = section

	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(1,0,0,28)
	btn.Position = UDim2.new(0,0,0,4)
	btn.BackgroundColor3 = Theme.ButtonBG
	btn.BorderSizePixel = 0
	btn.Text = label
	btn.TextColor3 = Theme.BtnText
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	reg(btn, "BackgroundColor3", "ButtonBG"); reg(btn, "TextColor3", "BtnText")

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {
			BackgroundTransparency = 0.4
		}):Play()
		task.delay(0.12, function()
			TweenService:Create(btn, TweenInfo.new(0.08), {
				BackgroundTransparency = 0
			}):Play()
		end)
		if callback then callback() end
	end)
	return row
end

local function _dropdown(section, label, options, callback)
	local selected = options[1]
	local open = false

	local wrapper = Instance.new("Frame")
	wrapper.BackgroundTransparency = 1
	wrapper.Size = UDim2.new(1,-14,0,54)
	wrapper.ClipsDescendants = false
	wrapper.Parent = section

	local lbl = Instance.new("TextLabel", wrapper)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1,0,0,18)
	lbl.Text = label
	lbl.TextColor3 = Theme.LabelText
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	reg(lbl, "TextColor3", "LabelText")

	local header = Instance.new("TextButton", wrapper)
	header.Size = UDim2.new(1,-4,0,28)
	header.Position = UDim2.new(0,0,0,20)
	header.BackgroundColor3 = Theme.DropBG
	header.BorderSizePixel = 0
	header.Text = "  " .. selected .. "  ?"
	header.TextColor3 = Theme.LabelText
	header.Font = Enum.Font.Gotham
	header.TextSize = 13
	header.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)
	local hs = Instance.new("UIStroke", header)
	hs.Color = Theme.Accent; hs.Thickness = 1; hs.Transparency = 0.6
	reg(header, "BackgroundColor3", "DropBG"); reg(header, "TextColor3", "LabelText")
	table.insert(themedObjects, {inst=hs, prop="Color", key="Accent"})

	local dropList = Instance.new("Frame", wrapper)
	dropList.Position = UDim2.new(0,0,0,50)
	dropList.Size = UDim2.new(1,-4,0,#options*26+4)
	dropList.BackgroundColor3 = Theme.DropBG
	dropList.BorderSizePixel = 0
	dropList.ZIndex = 50
	dropList.Visible = false
	Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 4)
	local ds = Instance.new("UIStroke", dropList)
	ds.Color = Theme.Accent; ds.Thickness = 1; ds.Transparency = 0.5
	reg(dropList, "BackgroundColor3", "DropBG")
	table.insert(themedObjects, {inst=ds, prop="Color", key="Accent"})

	local dlist = Instance.new("UIListLayout", dropList)
	dlist.Padding = UDim.new(0, 0)
	dlist.SortOrder = Enum.SortOrder.LayoutOrder
	Instance.new("UIPadding", dropList).PaddingTop = UDim.new(0, 2)

	for _, opt in ipairs(options) do
		local item = Instance.new("TextButton", dropList)
		item.Size = UDim2.new(1,0,0,24)
		item.BackgroundTransparency = 1
		item.Text = "  " .. opt
		item.TextColor3 = Theme.LabelText
		item.Font = Enum.Font.Gotham
		item.TextSize = 12
		item.TextXAlignment = Enum.TextXAlignment.Left
		item.ZIndex = 51
		reg(item, "TextColor3", "LabelText")
		item.MouseButton1Click:Connect(function()
			selected = opt
			header.Text = "  " .. selected .. "  ?"
			dropList.Visible = false
			open = false
			if callback then callback(selected) end
		end)
		item.MouseEnter:Connect(function()
			item.BackgroundTransparency = 0.7
			item.BackgroundColor3 = Theme.Accent
		end)
		item.MouseLeave:Connect(function()
			item.BackgroundTransparency = 1
		end)
	end

	header.MouseButton1Click:Connect(function()
		open = not open
		dropList.Visible = open
		wrapper.Size = UDim2.new(1,-14, 0, open and (54 + #options*26+4) or 54)
	end)

	return wrapper
end

-- ============================================================
--  TAB SYSTEM
-- ============================================================
local allTabs = {}
local activeTab = nil

local function selectTab(tabData)
	for _, t in ipairs(allTabs) do
		t.section.Visible = false
		t.btn.BackgroundTransparency = 0.6
	end
	tabData.section.Visible = true
	tabData.btn.BackgroundTransparency = 0.0
	activeTab = tabData
end

-- ============================================================
--  GUI BUILDER  ?  this is what you call in your features
-- ============================================================
local GUI = {}

function GUI:Tab(name)
	-- make the tab button
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 0, 30)
	btn.BackgroundColor3 = Theme.Accent
	btn.BackgroundTransparency = 0.6
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = Theme.BtnText
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = TabBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	reg(btn, "BackgroundColor3", "Accent"); reg(btn, "TextColor3", "BtnText")

	local section = _makeScrollSection()

	local tabData = {btn=btn, section=section}
	table.insert(allTabs, tabData)
	btn.MouseButton1Click:Connect(function() selectTab(tabData) end)

	-- if first tab, select it
	task.defer(function()
		if name == defaultTabName then
			selectTab(tabData)
		end
	end)

	-- -- Tab object ------------------------------------------
	local Tab = {}

	-- myTab:Label("Section Title")
	function Tab:Label(text)
		_label(section, text)
	end

	-- myTab:Toggle("Name", defaultBool, function(on) end)
	-- returns a setter: setter(true/false) to change programmatically
	function Tab:Toggle(label, default, callback)
		local _, setter = _toggle(section, label, default, callback)
		return setter
	end

	-- myTab:Slider("Name", min, max, default, function(val) end)
	function Tab:Slider(label, minVal, maxVal, default, callback)
		_slider(section, label, minVal, maxVal, default, callback)
	end

	-- myTab:Input("Label", "placeholder text", function(text) end)
	function Tab:Input(label, placeholder, callback)
		_input(section, label, placeholder, callback)
	end

	-- myTab:Button("Click Me", function() end)
	function Tab:Button(label, callback)
		_button(section, label, callback)
	end

	-- myTab:Dropdown("Pick one", {"A","B","C"}, function(choice) end)
	function Tab:Dropdown(label, options, callback)
		_dropdown(section, label, options, callback)
	end

	return Tab
end

-- ============================================================
--  HELPERS
-- ============================================================
local function getHumanoid()
	local c = LocalPlayer.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRootPart()
	local c = LocalPlayer.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

-- persist stats across respawns
local pending = {WalkSpeed=16, JumpPower=50, AutoJump=false}
LocalPlayer.CharacterAdded:Connect(function(c)
	Character = c
	local h = c:WaitForChild("Humanoid")
	task.wait()
	h.WalkSpeed       = pending.WalkSpeed
	h.AutoJumpEnabled = pending.AutoJump
	if h.UseJumpPower then h.JumpPower = pending.JumpPower
	else h.JumpHeight = pending.JumpPower * 0.225 end
end)

-- ============================================================
--  STATE
-- ============================================================
local SelfState = {
	InfJump    = false,
	AutoJump   = false,
	NoClip     = false,
	AntiAFK    = false,
	AntiKick   = false,
	Flying     = false,
	FlySpeed   = 50,
	AntiVoid   = false,
	FlingTouch = false,

}

local PVPState = {
	HitboxExpand = false,
	HitboxSize   = 4,
	Reach        = false,
	ReachDist    = 15,
}

-- ============================================================
--  EXTERNAL SCRIPT LOADER  (for loadstring toggles)
-- ============================================================
local ActiveScripts = {}

local function runExternal(key, url)
	if ActiveScripts[key] and ActiveScripts[key].running then return end
	ActiveScripts[key] = {running=true, threads={}}
	task.spawn(function()
		local ok, result = pcall(function()
			return loadstring(game:HttpGet(url))()
		end)
		if not ok then ActiveScripts[key].running = false; return end
		if type(result) == "function" then
			ActiveScripts[key].cleanup = result
		end
	end)
end

local function stopExternal(key)
	local entry = ActiveScripts[key]
	if not entry then return end
	entry.running = false
	if type(entry.cleanup) == "function" then pcall(entry.cleanup) end
	if entry.threads then
		for _, t in ipairs(entry.threads) do pcall(function() t:Disconnect() end) end
	end
	ActiveScripts[key] = nil
end

-- ============================================================
-- +----------------------------------------------------------+
-- ¦          YOUR TABS & OPTIONS GO HERE                     ¦
-- ¦                                                          ¦
-- ¦  Pattern:                                                ¦
-- ¦    local myTab = GUI:Tab("Name")                         ¦
-- ¦    myTab:Label("Section")                                ¦
-- ¦    myTab:Toggle("Feature", false, function(on) end)      ¦
-- ¦    myTab:Slider("Speed", 1, 100, 16, function(v) end)    ¦
-- ¦    myTab:Button("Do Thing", function() end)              ¦
-- ¦    myTab:Dropdown("Mode",{"A","B"},function(v) end)      ¦
-- +----------------------------------------------------------+
-- ============================================================

-- -- SELF TAB ------------------------------------------------
local selfTab = GUI:Tab("Self")

SelfState.ShowAccountAge = false
local AccountAgeLabel = nil
selfTab:Toggle("Show Account Age", false, function(on)
	SelfState.ShowAccountAge = on

	if on then
		if not AccountAgeLabel then
			AccountAgeLabel = Instance.new("TextLabel")
			AccountAgeLabel.BackgroundTransparency = 1
			AccountAgeLabel.Size = UDim2.new(1, -14, 0, 22)
			AccountAgeLabel.Position = UDim2.new(0, 300, 0, 20)
			AccountAgeLabel.TextColor3 = Theme.LabelText
			AccountAgeLabel.Font = Enum.Font.GothamBold
			AccountAgeLabel.TextSize = 30
			AccountAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
			AccountAgeLabel.Parent = ContentArea
			reg(AccountAgeLabel, "TextColor3", "LabelText")
		end

		AccountAgeLabel.Visible = true
	else
		if AccountAgeLabel then
			AccountAgeLabel.Visible = false
		end
	end
end)
RunService.RenderStepped:Connect(function()
	if SelfState.ShowAccountAge and AccountAgeLabel then
		AccountAgeLabel.Text = "Account Age: " .. tostring(LocalPlayer.AccountAge) .. " days"
	end
end)
selfTab:Label("Movement")

selfTab:Toggle("Auto Jump", false, function(on)
	SelfState.AutoJump = on
	pending.AutoJump = on
	local h = getHumanoid()
	if h then h.AutoJumpEnabled = on end
end)

selfTab:Toggle("Infinite Jump", false, function(on)
	SelfState.InfJump = on
end)

selfTab:Slider("Walk Speed", 1, 100, 16, function(val)
	pending.WalkSpeed = val
	local h = getHumanoid()
	if h then h.WalkSpeed = val end
end)

selfTab:Slider("Jump Power", 1, 200, 50, function(val)
	pending.JumpPower = val
	local h = getHumanoid()
	if h then
		if h.UseJumpPower then h.JumpPower = val
		else h.JumpHeight = val * 0.225 end
	end
end)

selfTab:Label("Flying")

selfTab:Toggle("Fly", false, function(on)
	SelfState.Flying = on
	if on then _startFly() else _stopFly() end
end)

selfTab:Slider("Fly Speed", 10, 300, 50, function(val)
	SelfState.FlySpeed = val
end)

selfTab:Label("Misc")



selfTab:Toggle("No Clip", false, function(on)
	SelfState.NoClip = on
end)

selfTab:Toggle("Anti Void", false, function(on)
	SelfState.AntiVoid = on
end)

selfTab:Label("Protection")

selfTab:Toggle("Anti AFK", false, function(on)
	SelfState.AntiAFK = on
end)

selfTab:Toggle("Anti Kick", false, function(on)
	SelfState.AntiKick = on
	if on then
		pcall(function()
			local mt = getrawmetatable(game)
			setreadonly(mt, false)
			local oldNC = mt.__namecall
			mt.__namecall = newcclosure(function(self, ...)
				if self == LocalPlayer and getnamecallmethod() == "Kick" then return nil end
				return oldNC(self, ...)
			end)
			setreadonly(mt, true)
		end)
	end
end)

-- -- MAIN TAB ------------------------------------------------
local mainTab = GUI:Tab("Main")

mainTab:Label("General")


local StarterGui = game:GetService("StarterGui")

local devConsoleEnabled = false

mainTab:Toggle("Dev Console (F9)", false, function(on)
	devConsoleEnabled = on

	pcall(function()
		StarterGui:SetCore("DevConsoleVisible", on)
	end)
end)



mainTab:Toggle("Fling Other Players(OnTouch)", false, function(on)
	SelfState.FlingTouch = on

	if on then
		task.spawn(function()
			local movel = 0.1
			local lp = Players.LocalPlayer

			while SelfState.FlingTouch do
				RunService.Heartbeat:Wait()

				local char = lp.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if not hrp then continue end

				-- check touch proximity
				local touching = false

				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= lp then
						local c = plr.Character
						local other = c and c:FindFirstChild("HumanoidRootPart")

						if other and (hrp.Position - other.Position).Magnitude < 5 then
							touching = true
							break
						end
					end
				end

				if touching then
					local vel = hrp.Velocity

					hrp.Velocity = vel * 1000000 + Vector3.new(0, 1000000, 0)

					RunService.RenderStepped:Wait()

					if hrp then
						hrp.Velocity = vel
					end

					RunService.Stepped:Wait()

					if hrp then
						hrp.Velocity = vel + Vector3.new(0, movel, 0)
						movel = movel * -1
					end
				end
			end
		end)
	end
end)




mainTab:Label("Scripts")
--SAMPLE--how to create a toggle that executes scripts---
--[[ inside maintab create toggle with name
mainTab:Toggle("ToggleNAME", false, function(on)
	if on then
		runExternal("gamepass", "ScriptSourceLink.lua")
	else
		stopExternal("gamepass")
	end
end)
]]

mainTab:Toggle("Gamepass Unlocker Method Attempt To Buy Free", false, function(on)
	if on then runExternal("gamepass", "https://rawscripts.net/raw/Universal-Script-Gamepass-Product-212343")
	else stopExternal("gamepass") end
end)

mainTab:Toggle("Keyless MOIS7 ADMIN+AntiVCBan", false, function(on)
	if on then runExternal("MOIS7 ADMIN", "https://mois7.xyz/loader")
	else stopExternal("MOIS7 ADMIN") end
end)

mainTab:Toggle("Keyless AK Admin -- KEY: AK ADMIN", false, function(on)
	if on then runExternal("MOIS7 ADMIN", "https://icegod.vercel.app/loader.lua")
	else stopExternal("Keyless AK Admin") end
end)

mainTab:Toggle("Dex++", false, function(on)
	if on then
		runExternal("Dex++", "https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua")
	else
		stopExternal("Dex++")
	end
end)

mainTab:Toggle("infYield. Always up to date", false, function(on)
	if on then
		runExternal("infYield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
	else
		stopExternal("infYield")
	end
end)

mainTab:Toggle("LDS HUB. For Work At Pizza Place By Dued1", false, function(on)
	if on then
		runExternal("LDSHUB", "https://api.luarmor.net/files/v3/loaders/49f02b0d8c1f60207c84ae76e12abc1e.lua")
	else
		stopExternal("LDSHUB")
	end
end)


mainTab:Toggle("CH HUB. For Work At Pizza Place By Dued1", false, function(on)
	if on then
		runExternal("CHHUB", "https://raw.githubusercontent.com/RobloxHackingProject/CHHub/main/CHHub.lua")
	else
		stopExternal("CHHUB")
	end
end)



mainTab:Toggle("EzHub - random op scripts", false, function(on)
	if on then
		runExternal("EzHub", "https://raw.githubusercontent.com/debug420/Ez-Industries-Launcher-Data/master/Launcher.lua")
	else
		stopExternal("EzHub")
	end
end)




mainTab:Toggle("WolfHub. Contains collection of scripts", false, function(on)
	if on then
		runExternal("WolfHub", "https://raw.githubusercontent.com/Podroka626/Scripts/main/Universal")
	else
		stopExternal("WolfHub")
	end
end)

mainTab:Toggle("ZeldaHub. For Restaurant tycoon 2 ", false, function(on)
	if on then
		runExternal("ZeldaHub", "https://raw.githubusercontent.com/iz037/Zeld-Hub/main/Script/Restaurant%20Tycoon%202.lua")
	else
		stopExternal("ZeldaHub")
	end
end)




mainTab:Toggle("Octo-Spy. Remote Spy Script. ", false, function(on)
	if on then
		runExternal("OctoSpy", "https://raw.githubusercontent.com/InfernusScripts/Octo-Spy/refs/heads/main/Main.lua")
	else
		stopExternal("OctoSpy")
	end
end)


-- -- PVP TAB -------------------------------------------------
local pvpTab = GUI:Tab("PVP")

--[[ pvpTab SAMPLE
local pvpTab = GUI:Tab("Combat")

pvpTab:Label("Aim Assist")

pvpTab:Toggle("Aim Assist", false, function(on)
	PVPState.AimAssist = on
end)
]]

PVPState.CustomFOVEnabled = false
PVPState.CustomFOV = 70
pvpTab:Label("Camera")

pvpTab:Toggle("Custom FOV", false, function(on)
	PVPState.CustomFOVEnabled = on

	local cam = Workspace.CurrentCamera
	if cam then
		if not on then
			cam.FieldOfView = 70
		else
			cam.FieldOfView = PVPState.CustomFOV
		end
	end
end)

pvpTab:Slider("FOV Value", 50, 100000, 70, function(val)
	PVPState.CustomFOV = val

	local cam = Workspace.CurrentCamera
	if cam and PVPState.CustomFOVEnabled then
		cam.FieldOfView = val
	end
end)

RunService.RenderStepped:Connect(function()
	if PVPState.CustomFOVEnabled then
		local cam = Workspace.CurrentCamera
		if cam and cam.FieldOfView ~= PVPState.CustomFOV then
			cam.FieldOfView = PVPState.CustomFOV
		end
	end
end)


pvpTab:Label("Hitbox")

pvpTab:Toggle("Hitbox Expander", false, function(on)
	PVPState.HitboxExpand = on
end)

pvpTab:Slider("Hitbox Size", 2, 25, 4, function(val)
	PVPState.HitboxSize = val
end)

pvpTab:Label("Reach")

pvpTab:Toggle("Reach", false, function(on)
	PVPState.Reach = on
end)

pvpTab:Slider("Reach Distance", 1, 100000, 15, function(val)
	PVPState.ReachDist = val
end)

-- -- ADD MORE TABS BELOW THIS LINE ---------------------------
--
-- Example:
--
--   local myNewTab = GUI:Tab("Visuals")
--
--   myNewTab:Label("ESP")
--   myNewTab:Toggle("Player ESP", false, function(on) end)
--   myNewTab:Slider("ESP Range", 10, 500, 100, function(val) end)
--
--   myNewTab:Label("Misc")
--   myNewTab:Button("Teleport to Spawn", function()
--       -- your teleport code here
--   end)
--
--   myNewTab:Dropdown("Team", {"Red","Blue","Auto"}, function(choice)
--       -- do something with choice
--   end)
--
-- ============================================================
--  END OF FEATURE DEFINITIONS
-- ============================================================

-- ============================================================
--  FLY SYSTEM
-- ============================================================
local flyBV, flyBG = nil, nil

function _startFly()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local h = char:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = true end
	if flyBV then flyBV:Destroy() end
	if flyBG then flyBG:Destroy() end
	flyBV = Instance.new("BodyVelocity")
	flyBV.Velocity = Vector3.zero
	flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
	flyBV.Parent   = hrp
	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
	flyBG.P         = 1e6
	flyBG.CFrame    = hrp.CFrame
	flyBG.Parent    = hrp
end

function _stopFly()
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if flyBG then flyBG:Destroy(); flyBG = nil end
	local char = LocalPlayer.Character
	if not char then return end
	local h = char:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
end

-- ============================================================
--  RUNTIME LOOPS
-- ============================================================

-- auto jump
RunService.Heartbeat:Connect(function()
	if not SelfState.AutoJump then return end
	local h = getHumanoid(); if not h then return end
	local s = h:GetState()
	if s == Enum.HumanoidStateType.Running
		or s == Enum.HumanoidStateType.RunningNoPhysics then
		h:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- infinite jump
UserInputService.JumpRequest:Connect(function()
	if SelfState.InfJump then
		local h = getHumanoid()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)


-- -- ESP TAB -------------------------------------------------
local espTab = GUI:Tab("ESP")

-- ============================================================
--  ESP STATE
-- ============================================================
local ESPState = {
	Enabled       = false,
	Boxes         = true,
	Names         = true,
	Distance      = true,
	Tracers       = false,
	HealthBar     = true,
	Skeletons     = false,
	Team          = false,  -- only show enemies
	MaxDist       = 1000,
	BoxColor      = Color3.fromRGB(255, 50, 50),
	NameColor     = Color3.fromRGB(255, 255, 255),
	TracerColor   = Color3.fromRGB(255, 255, 0),
	HealthBarGood = Color3.fromRGB(0, 220, 80),
	HealthBarLow  = Color3.fromRGB(220, 50, 50),
	SkeletonColor = Color3.fromRGB(200, 200, 255),
	BoxThickness  = 1,
	TextSize      = 13,
	TracerOrigin  = "Bottom", -- "Bottom" | "Center" | "Top"
}

-- ============================================================
--  ESP INTERNALS
-- ============================================================
local ESPObjects = {}  -- [player] = { highlight, drawings... }

local SKELETON_PAIRS = {
	{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
	{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
	{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
	{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
	{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local function newDrawing(type, props)
	local d = Drawing.new(type)
	for k,v in pairs(props) do d[k] = v end
	return d
end

local function createESPForPlayer(pl)
	if ESPObjects[pl] then return end
	local obj = {}

	-- 2D Box (4 lines)
	obj.boxLines = {}
	for i = 1, 4 do
		obj.boxLines[i] = newDrawing("Line", {
			Thickness = ESPState.BoxThickness,
			Color = ESPState.BoxColor,
			Transparency = 1,
			Visible = false,
		})
	end

	-- Corner box (8 corners x 2 lines = 16 lines)
	obj.cornerLines = {}
	for i = 1, 16 do
		obj.cornerLines[i] = newDrawing("Line", {
			Thickness = ESPState.BoxThickness + 1,
			Color = ESPState.BoxColor,
			Transparency = 1,
			Visible = false,
		})
	end

	-- Name label
	obj.nameLabel = newDrawing("Text", {
		Size = ESPState.TextSize,
		Color = ESPState.NameColor,
		Outline = true,
		OutlineColor = Color3.fromRGB(0,0,0),
		Center = true,
		Visible = false,
		Font = 2,
	})

	-- Distance label
	obj.distLabel = newDrawing("Text", {
		Size = ESPState.TextSize - 2,
		Color = ESPState.NameColor,
		Outline = true,
		OutlineColor = Color3.fromRGB(0,0,0),
		Center = true,
		Visible = false,
		Font = 2,
	})

	-- Tracer line
	obj.tracer = newDrawing("Line", {
		Thickness = 1,
		Color = ESPState.TracerColor,
		Transparency = 1,
		Visible = false,
	})

	-- Health bar (background + fill)
	obj.healthBG = newDrawing("Line", {
		Thickness = 4,
		Color = Color3.fromRGB(0,0,0),
		Transparency = 1,
		Visible = false,
	})
	obj.healthFill = newDrawing("Line", {
		Thickness = 3,
		Color = ESPState.HealthBarGood,
		Transparency = 1,
		Visible = false,
	})

	-- Skeleton lines
	obj.skelLines = {}
	for i = 1, #SKELETON_PAIRS do
		obj.skelLines[i] = newDrawing("Line", {
			Thickness = 1,
			Color = ESPState.SkeletonColor,
			Transparency = 1,
			Visible = false,
		})
	end

	ESPObjects[pl] = obj
end

local function removeESPForPlayer(pl)
	local obj = ESPObjects[pl]
	if not obj then return end
	for _, ln in ipairs(obj.boxLines)    do ln:Remove() end
	for _, ln in ipairs(obj.cornerLines) do ln:Remove() end
	for _, ln in ipairs(obj.skelLines)   do ln:Remove() end
	obj.nameLabel:Remove()
	obj.distLabel:Remove()
	obj.tracer:Remove()
	obj.healthBG:Remove()
	obj.healthFill:Remove()
	ESPObjects[pl] = nil
end

local function clearAllESP()
	for pl in pairs(ESPObjects) do removeESPForPlayer(pl) end
end

-- World -> Screen helper (returns screenPos, onScreen, depth)
local function worldToScreen(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

-- Draw corner-style box helper
local function drawCornerBox(lines, x, y, w, h, color, thickness)
	local cx = w * 0.2
	local cy = h * 0.2
	-- TL, TR, BL, BR corners, each 2 lines
	local corners = {
		-- TL
		{Vector2.new(x,y),        Vector2.new(x+cx,y)},
		{Vector2.new(x,y),        Vector2.new(x,y+cy)},
		-- TR
		{Vector2.new(x+w,y),      Vector2.new(x+w-cx,y)},
		{Vector2.new(x+w,y),      Vector2.new(x+w,y+cy)},
		-- BL
		{Vector2.new(x,y+h),      Vector2.new(x+cx,y+h)},
		{Vector2.new(x,y+h),      Vector2.new(x,y+h-cy)},
		-- BR
		{Vector2.new(x+w,y+h),    Vector2.new(x+w-cx,y+h)},
		{Vector2.new(x+w,y+h),    Vector2.new(x+w,y+h-cy)},
	}
	for i, seg in ipairs(corners) do
		local ln = lines[i]
		if ln then
			ln.From = seg[1]; ln.To = seg[2]
			ln.Color = color; ln.Thickness = thickness
			ln.Visible = true
		end
	end
end
local VoiceChatService = game:GetService("VoiceChatService")

SelfState.AutoVoiceCheck = false

local function tryVoiceConnect()
	pcall(function()
		VoiceChatService:JoinVoice()
	end)
end

task.spawn(function()
	while true do
		if SelfState.AutoVoiceCheck then
			tryVoiceConnect()
		end
		task.wait(0.1)
	end
end)

selfTab:Toggle("Auto Voice Rejoin", false, function(on)
	SelfState.AutoVoiceCheck = on
end)
-- Main ESP render loop
RunService.RenderStepped:Connect(function()
	if not ESPState.Enabled then
		-- hide everything but keep objects alive for re-enable
		for pl, obj in pairs(ESPObjects) do
			for _, ln in ipairs(obj.boxLines)    do ln.Visible = false end
			for _, ln in ipairs(obj.cornerLines) do ln.Visible = false end
			for _, ln in ipairs(obj.skelLines)   do ln.Visible = false end
			obj.nameLabel.Visible = false; obj.distLabel.Visible = false
			obj.tracer.Visible = false
			obj.healthBG.Visible = false; obj.healthFill.Visible = false
		end
		return
	end

	local myChar = LocalPlayer.Character
	local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local vp     = Camera.ViewportSize

	for _, pl in ipairs(Players:GetPlayers()) do
		if pl == LocalPlayer then
			if ESPObjects[pl] then removeESPForPlayer(pl) end
		else
			if ESPState.Team and pl.Team == LocalPlayer.Team then
				if ESPObjects[pl] then removeESPForPlayer(pl) end
			else
				createESPForPlayer(pl)
				local obj = ESPObjects[pl]
				local char = pl.Character
				local hrp  = char and char:FindFirstChild("HumanoidRootPart")
				local hum  = char and char:FindFirstChildOfClass("Humanoid")

				if not hrp or not char then
					for _, ln in ipairs(obj.boxLines) do ln.Visible = false end
					for _, ln in ipairs(obj.cornerLines) do ln.Visible = false end
					for _, ln in ipairs(obj.skelLines) do ln.Visible = false end
					obj.nameLabel.Visible = false; obj.distLabel.Visible = false
					obj.tracer.Visible = false
					obj.healthBG.Visible = false; obj.healthFill.Visible = false
				else
					local dist = myHRP and (hrp.Position - myHRP.Position).Magnitude or 0

					if dist > ESPState.MaxDist then
						for _, ln in ipairs(obj.boxLines) do ln.Visible = false end
						for _, ln in ipairs(obj.cornerLines) do ln.Visible = false end
						for _, ln in ipairs(obj.skelLines) do ln.Visible = false end
						obj.nameLabel.Visible = false; obj.distLabel.Visible = false
						obj.tracer.Visible = false
						obj.healthBG.Visible = false; obj.healthFill.Visible = false
					else
						local head = char:FindFirstChild("Head")
						local rootTop    = hrp.Position + Vector3.new(0, 3, 0)
						local rootBottom = hrp.Position - Vector3.new(0, 3, 0)

						local topScreen, _, topD = worldToScreen(rootTop)
						local bottomScreen, _, bottomD = worldToScreen(rootBottom)

						local onScreen = topD > 0

						if not onScreen then
							for _, ln in ipairs(obj.boxLines) do ln.Visible = false end
							for _, ln in ipairs(obj.cornerLines) do ln.Visible = false end
							for _, ln in ipairs(obj.skelLines) do ln.Visible = false end
							obj.nameLabel.Visible = false; obj.distLabel.Visible = false
							obj.tracer.Visible = false
							obj.healthBG.Visible = false; obj.healthFill.Visible = false
						else
							local boxH = math.abs(topScreen.Y - bottomScreen.Y)
							local boxW = boxH * 0.55
							local boxX = topScreen.X - boxW / 2
							local boxY = topScreen.Y

							if ESPState.Boxes then
								local pts = {
									Vector2.new(boxX, boxY),
									Vector2.new(boxX+boxW, boxY),
									Vector2.new(boxX+boxW, boxY+boxH),
									Vector2.new(boxX, boxY+boxH),
								}

								for i = 1, 4 do
									local ln = obj.boxLines[i]
									ln.From = pts[i]
									ln.To = pts[i % 4 + 1]
									ln.Color = ESPState.BoxColor
									ln.Thickness = ESPState.BoxThickness
									ln.Visible = true
								end

								drawCornerBox(obj.cornerLines, boxX, boxY, boxW, boxH,
									ESPState.BoxColor, ESPState.BoxThickness + 1)

								for i = 9, 16 do
									obj.cornerLines[i].Visible = false
								end
							else
								for _, ln in ipairs(obj.boxLines) do ln.Visible = false end
								for _, ln in ipairs(obj.cornerLines) do ln.Visible = false end
							end

							if ESPState.Names then
								obj.nameLabel.Text = pl.DisplayName
								obj.nameLabel.Size = ESPState.TextSize
								obj.nameLabel.Color = ESPState.NameColor
								obj.nameLabel.Position = Vector2.new(topScreen.X, boxY - ESPState.TextSize - 2)
								obj.nameLabel.Visible = true
							else
								obj.nameLabel.Visible = false
							end

							if ESPState.Distance then
								obj.distLabel.Text = string.format("[%.0fm]", dist)
								obj.distLabel.Size = math.max(9, ESPState.TextSize - 2)
								obj.distLabel.Color = ESPState.NameColor
								obj.distLabel.Position = Vector2.new(topScreen.X, boxY + boxH + 2)
								obj.distLabel.Visible = true
							else
								obj.distLabel.Visible = false
							end

							if ESPState.Tracers then
								local origin
								if ESPState.TracerOrigin == "Bottom" then
									origin = Vector2.new(vp.X/2, vp.Y)
								elseif ESPState.TracerOrigin == "Top" then
									origin = Vector2.new(vp.X/2, 0)
								else
									origin = Vector2.new(vp.X/2, vp.Y/2)
								end

								obj.tracer.From = origin
								obj.tracer.To = bottomScreen
								obj.tracer.Color = ESPState.TracerColor
								obj.tracer.Visible = true
							else
								obj.tracer.Visible = false
							end

							if ESPState.HealthBar and hum then
								local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
								local barX = boxX - 6
								local barTop = Vector2.new(barX, boxY)
								local barBot = Vector2.new(barX, boxY + boxH)
								local fillBot = Vector2.new(barX, boxY + boxH - boxH * hpRatio)

								local hpColor = ESPState.HealthBarGood:Lerp(ESPState.HealthBarLow, 1 - hpRatio)

								obj.healthBG.From = barTop
								obj.healthBG.To = barBot
								obj.healthBG.Visible = true

								obj.healthFill.From = fillBot
								obj.healthFill.To = barBot
								obj.healthFill.Color = hpColor
								obj.healthFill.Visible = true
							else
								obj.healthBG.Visible = false
								obj.healthFill.Visible = false
							end

							-- == SKELETON (R6 + R15 FIXED) ==
							if ESPState.Skeletons then
								local function getPart(names)
									for _, n in ipairs(names) do
										local p = char:FindFirstChild(n)
										if p and p:IsA("BasePart") then
											return p
										end
									end
									return nil
								end

								local function bone(i, a, b)
									local ln = obj.skelLines[i]
									if not a or not b then
										ln.Visible = false
										return
									end

									local s0, _, d0 = worldToScreen(a.Position)
									local s1, _, d1 = worldToScreen(b.Position)

									if d0 > 0 and d1 > 0 then
										ln.From = s0
										ln.To = s1
										ln.Color = ESPState.SkeletonColor
										ln.Visible = true
									else
										ln.Visible = false
									end
								end

								local TORSO = getPart({"UpperTorso","Torso"})
								local LOWER = getPart({"LowerTorso","Torso"})
								local HEAD  = getPart({"Head"})

								bone(1, HEAD, TORSO)
								bone(2, TORSO, LOWER)

								bone(3, TORSO, getPart({"LeftUpperArm","Left Arm"}))
								bone(4, getPart({"LeftUpperArm","Left Arm"}), getPart({"LeftLowerArm"}))
								bone(5, getPart({"LeftLowerArm"}), getPart({"LeftHand","Left Arm"}))

								bone(6, TORSO, getPart({"RightUpperArm","Right Arm"}))
								bone(7, getPart({"RightUpperArm","Right Arm"}), getPart({"RightLowerArm"}))
								bone(8, getPart({"RightLowerArm"}), getPart({"RightHand","Right Arm"}))

								bone(9, LOWER, getPart({"LeftUpperLeg","Left Leg"}))
								bone(10, getPart({"LeftUpperLeg","Left Leg"}), getPart({"LeftLowerLeg"}))
								bone(11, getPart({"LeftLowerLeg"}), getPart({"LeftFoot","Left Leg"}))

								bone(12, LOWER, getPart({"RightUpperLeg","Right Leg"}))
								bone(13, getPart({"RightUpperLeg","Right Leg"}), getPart({"RightLowerLeg"}))
								bone(14, getPart({"RightLowerLeg"}), getPart({"RightFoot","Right Leg"}))

								for i = 15, #obj.skelLines do
									obj.skelLines[i].Visible = false
								end
							else
								for _, ln in ipairs(obj.skelLines) do
									ln.Visible = false
								end
							end
						end
					end
				end
			end
		end
	end

	for pl in pairs(ESPObjects) do
		if not Players:FindFirstChild(pl.Name) then
			removeESPForPlayer(pl)
		end
	end
end)

-- cleanup on character respawn
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
end)

Players.PlayerRemoving:Connect(function(pl)
	removeESPForPlayer(pl)
end)


-- ============================================================
--  LIGHTING TAB (REAL ENGINE RANGES)
-- ============================================================
local Lighting = game:GetService("Lighting")

local base = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart,
	ExposureCompensation = Lighting.ExposureCompensation,
	ShadowSoftness = Lighting.ShadowSoftness,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

local function get(class)
	local obj = Lighting:FindFirstChild(class)
	if not obj then
		obj = Instance.new(class)
		obj.Parent = Lighting
	end
	return obj
end


-- SERVICES

-- AIMBOT TAB
local aimTab = GUI:Tab("Aimbot")

-- STATE
local AimbotState = {
	Enabled        = false,
	Smoothing      = 10,
	TargetPart     = "Head",
	TeamCheck      = false,
	VisCheck       = false,
	StickyTarget   = false,
	StickyStrength = 5,
	PredictMotion  = false,
	PredictFactor  = 5,
	TargetColor    = Color3.fromRGB(255, 50, 50),
	ShowIndicator  = true,
	ClosestTarget  = nil,

	-- NEW FEATURES
	LockOn         = false,
	MouseLock      = false,
	ToggleKey      = Enum.KeyCode.Q
}

-- INPUT CONTROL
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == AimbotState.ToggleKey then
		AimbotState.Enabled = not AimbotState.Enabled
		if AimbotState.Enabled then
			startAimbot()
		else
			stopAimbot()
		end
	end
end)

-- SAFE DRAWING
local function newDrawingSafe(drawType, props)
	if not Drawing then return nil end
	local ok, obj = pcall(Drawing.new, drawType)
	if not ok or not obj then return nil end
	for k, v in pairs(props) do
		pcall(function() obj[k] = v end)
	end
	return obj
end

local function setDP(obj, key, val)
	if obj then pcall(function() obj[key] = val end) end
end

local function hideD(obj)
	setDP(obj, "Visible", false)
end

-- DRAW OBJECTS
local TargetLine = newDrawingSafe("Line", {
	Thickness = 1,
	Color = AimbotState.TargetColor,
	Transparency = 1,
	Visible = false,
})

local TargetDot = newDrawingSafe("Circle", {
	Thickness = 1,
	Color = AimbotState.TargetColor,
	Filled = true,
	Visible = false,
	NumSides = 16,
	Radius = 5,
})

local TargetLabel = newDrawingSafe("Text", {
	Size = 13,
	Color = Color3.fromRGB(255,255,255),
	Outline = true,
	Center = true,
	Visible = false,
	Font = 2,
})

-- HELPERS
local function getViewportCenter()
	local v = Camera.ViewportSize
	return Vector2.new(v.X/2, v.Y/2)
end

local function isAlive(char)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

local function getTargetPart(char)
	return char:FindFirstChild(AimbotState.TargetPart)
		or char:FindFirstChild("Head")
		or char:FindFirstChildOfClass("BasePart")
end

-- >>> ADDED UI FOR TARGET PART SELECTION <<<
aimTab:Dropdown("Target Part", {
	"Head",
	"HumanoidRootPart",
	"UpperTorso",
	"LowerTorso",
	"LeftUpperArm",
	"RightUpperArm",
	"LeftLowerLeg",
	"RightLowerLeg"
}, function(part)
	AimbotState.TargetPart = part
end)

local function screenDist(pos)
	local v, ok = Camera:WorldToViewportPoint(pos)
	if not ok then return math.huge end
	return (Vector2.new(v.X, v.Y) - getViewportCenter()).Magnitude
end

local function isOccluded(fromPos, toPos)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {LocalPlayer.Character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local dir = toPos - fromPos
	local hit = Workspace:Raycast(fromPos, dir, params)

	return hit and (hit.Position - fromPos).Magnitude < dir.Magnitude
end

local function isNPC(model)
	if not model or not model:IsA("Model") then return false end
	if Players:GetPlayerFromCharacter(model) then return false end

	local hum = model:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

local function findClosestTarget()
	local best, bestPart, bestDist = nil, nil, math.huge

	-- PLAYERS
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LocalPlayer and pl.Character and isAlive(pl.Character) then

			if AimbotState.TeamCheck and pl.Team == LocalPlayer.Team then
				continue
			end

			local part = getTargetPart(pl.Character)
			if part then

				if AimbotState.VisCheck then
					local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if root and isOccluded(root.Position, part.Position) then
						continue
					end
				end

				local dist = screenDist(part.Position)
				if dist < bestDist then
					bestDist = dist
					best = pl
					bestPart = part
				end
			end
		end
	end

	-- NPCS / ZOMBIES (workspace scan)
	for _, obj in ipairs(workspace:GetChildren()) do
		if isNPC(obj) and obj ~= LocalPlayer.Character then

			local part = getTargetPart(obj)
			if part then

				if AimbotState.VisCheck then
					local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if root and isOccluded(root.Position, part.Position) then
						continue
					end
				end

				local dist = screenDist(part.Position)
				if dist < bestDist then
					bestDist = dist
					best = obj
					bestPart = part
				end
			end
		end
	end

	AimbotState.ClosestTarget = best
	return best, bestPart
end

-- RUNTIME
local conn

function startAimbot()
	if conn then conn:Disconnect() end

	conn = RunService.RenderStepped:Connect(function(dt)
		if not AimbotState.Enabled then
			hideD(TargetLine)
			hideD(TargetDot)
			hideD(TargetLabel)
			return
		end

		local ok = pcall(function()
			local pl, part = findClosestTarget()
			if not pl or not part then return end

			local aimPos = part.Position

			if AimbotState.PredictMotion then
				local vel = part.AssemblyLinearVelocity
				local t = (Camera.CFrame.Position - aimPos).Magnitude * 0.001 * AimbotState.PredictFactor
				aimPos = aimPos + vel * t
			end

			local v, onScreen = Camera:WorldToViewportPoint(aimPos)
			if not onScreen then return end

			local sp = Vector2.new(v.X, v.Y)
			local center = getViewportCenter()

			if AimbotState.ShowIndicator then
				setDP(TargetLine, "From", center)
				setDP(TargetLine, "To", sp)
				setDP(TargetLine, "Visible", true)

				setDP(TargetDot, "Position", sp)
				setDP(TargetDot, "Visible", true)

				setDP(TargetLabel, "Text", pl.DisplayName or "???")
				setDP(TargetLabel, "Position", Vector2.new(sp.X, sp.Y - 18))
				setDP(TargetLabel, "Visible", true)
			end

			local smooth = math.clamp(dt * (100 / math.max(1, AimbotState.Smoothing)), 0, 1)
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position, aimPos),
				AimbotState.LockOn and 1 or smooth
			)

			if AimbotState.MouseLock then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
		end)
	end)
end

function stopAimbot()
	if conn then conn:Disconnect() conn = nil end
	hideD(TargetLine)
	hideD(TargetDot)
	hideD(TargetLabel)
	AimbotState.ClosestTarget = nil
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

-- UI CONTROLS
aimTab:Toggle("Aimbot Enabled", false, function(v)
	AimbotState.Enabled = v
	if v then startAimbot() else stopAimbot() end
end)

aimTab:Toggle("Lock-On Target", false, function(v)
	AimbotState.LockOn = v
end)

aimTab:Toggle("Mouse Lock", false, function(v)
	AimbotState.MouseLock = v
end)

aimTab:Slider("Smoothing", 1, 50, 10, function(v)
	AimbotState.Smoothing = v
end)

aimTab:Toggle("Team Check", false, function(v)
	AimbotState.TeamCheck = v
end)

aimTab:Toggle("Visibility Check", false, function(v)
	AimbotState.VisCheck = v
end)

aimTab:Toggle("Prediction", false, function(v)
	AimbotState.PredictMotion = v
end)

aimTab:Slider("Predict Factor", 1, 30, 5, function(v)
	AimbotState.PredictFactor = v
end)

aimTab:Dropdown("Toggle Key", {
	"Q","W","E","R","T","Y","U","I","O","P",
	"A","S","D","F","G","H","J","K","L",
	"Z","X","C","V","B","N","M",

	"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",

	"LeftShift","RightShift",
	"LeftControl","RightControl",
	"LeftAlt","RightAlt",
	"Space",

	"Return",
	"Tab",
	"Backspace",
	"Escape"
}, function(key)
	AimbotState.ToggleKey = Enum.KeyCode[key]
end)

aimTab:Button("Reset", function()
	stopAimbot()
	AimbotState.Enabled = false
	AimbotState.LockOn = false
	AimbotState.MouseLock = false
	AimbotState.Smoothing = 10
	AimbotState.TeamCheck = false
	AimbotState.VisCheck = false
	AimbotState.PredictMotion = false
	AimbotState.PredictFactor = 5
end)


local bloom = get("BloomEffect")
local blur = get("BlurEffect")
local color = get("ColorCorrectionEffect")
local sun = get("SunRaysEffect")
local atm = get("Atmosphere")

bloom.Enabled = false
blur.Enabled = false
color.Enabled = false
sun.Enabled = false

local lightingTab = GUI:Tab("Lighting")

lightingTab:Label("Core Lighting")

lightingTab:Slider("Brightness", 0, 20, Lighting.Brightness, function(v)
	Lighting.Brightness = v
end)

lightingTab:Slider("Clock Time", 0, 24, Lighting.ClockTime, function(v)
	Lighting.ClockTime = v
end)

lightingTab:Slider("Exposure", -10, 10, Lighting.ExposureCompensation, function(v)
	Lighting.ExposureCompensation = v
end)

lightingTab:Toggle("Global Shadows", Lighting.GlobalShadows, function(v)
	Lighting.GlobalShadows = v
end)

lightingTab:Slider("Shadow Softness", 0, 1, Lighting.ShadowSoftness, function(v)
	Lighting.ShadowSoftness = v
end)

lightingTab:Slider("Env Diffuse", 0, 5, Lighting.EnvironmentDiffuseScale, function(v)
	Lighting.EnvironmentDiffuseScale = v
end)

lightingTab:Slider("Env Specular", 0, 5, Lighting.EnvironmentSpecularScale, function(v)
	Lighting.EnvironmentSpecularScale = v
end)

lightingTab:Label("Fog System")

lightingTab:Slider("Fog Start", 0, 5000, Lighting.FogStart, function(v)
	Lighting.FogStart = v
end)

lightingTab:Slider("Fog End", 0, 500000, Lighting.FogEnd, function(v)
	Lighting.FogEnd = v
end)

lightingTab:Label("Atmosphere")

lightingTab:Slider("Density", 0, 2, atm.Density, function(v)
	atm.Density = v
end)

lightingTab:Slider("Haze", 0, 20, atm.Haze, function(v)
	atm.Haze = v
end)

lightingTab:Slider("Glare", 0, 20, atm.Glare, function(v)
	atm.Glare = v
end)

lightingTab:Slider("Offset", -5, 5, atm.Offset, function(v)
	atm.Offset = v
end)

lightingTab:Label("Ambient")

lightingTab:Input("Ambient RGB", "0-255,0-255,0-255", function(txt)
	local r,g,b = txt:match("(%d+),(%d+),(%d+)")
	if r then
		Lighting.Ambient = Color3.fromRGB(r,g,b)
	end
end)

lightingTab:Input("Outdoor RGB", "0-255,0-255,0-255", function(txt)
	local r,g,b = txt:match("(%d+),(%d+),(%d+)")
	if r then
		Lighting.OutdoorAmbient = Color3.fromRGB(r,g,b)
	end
end)

lightingTab:Label("Post Processing")

lightingTab:Toggle("Bloom", false, function(on)
	bloom.Enabled = on
end)

lightingTab:Slider("Bloom Intensity", 0, 10, bloom.Intensity, function(v)
	bloom.Intensity = v
end)

lightingTab:Slider("Bloom Size", 0, 100, bloom.Size, function(v)
	bloom.Size = v
end)

lightingTab:Slider("Bloom Threshold", 0, 1, bloom.Threshold, function(v)
	bloom.Threshold = v
end)

lightingTab:Toggle("Blur", false, function(on)
	blur.Enabled = on
end)

lightingTab:Slider("Blur Size", 0, 56, blur.Size, function(v)
	blur.Size = v
end)

lightingTab:Toggle("Color Correction", false, function(on)
	color.Enabled = on
end)

lightingTab:Slider("Saturation", -3, 3, color.Saturation, function(v)
	color.Saturation = v
end)

lightingTab:Slider("Contrast", -3, 3, color.Contrast, function(v)
	color.Contrast = v
end)

lightingTab:Slider("Brightness", -3, 3, color.Brightness, function(v)
	color.Brightness = v
end)

lightingTab:Toggle("Sun Rays", false, function(on)
	sun.Enabled = on
end)

lightingTab:Slider("Sun Intensity", 0, 5, sun.Intensity, function(v)
	sun.Intensity = v
end)

lightingTab:Slider("Sun Spread", 0, 1, sun.Spread, function(v)
	sun.Spread = v
end)

lightingTab:Button("Reset Lighting", function()
	for k,v in pairs(base) do
		Lighting[k] = v
	end

	bloom.Enabled = false
	blur.Enabled = false
	color.Enabled = false
	sun.Enabled = false

	bloom.Intensity = 1
	bloom.Size = 24
	bloom.Threshold = 0.8
	blur.Size = 0
	color.Saturation = 0
	color.Contrast = 0
	color.Brightness = 0
	sun.Intensity = 1
	sun.Spread = 0.5
end)


-- ============================================================
--  ESP TAB UI
-- ============================================================

espTab:Label("Main")

espTab:Toggle("ESP Enabled", false, function(on)
	ESPState.Enabled = on
	if not on then clearAllESP() end
end)

espTab:Toggle("Boxes", true, function(on)
	ESPState.Boxes = on
end)

espTab:Toggle("Names", true, function(on)
	ESPState.Names = on
end)

espTab:Toggle("Distance", true, function(on)
	ESPState.Distance = on
end)

espTab:Toggle("Tracers", false, function(on)
	ESPState.Tracers = on
end)

espTab:Toggle("Health Bar", true, function(on)
	ESPState.HealthBar = on
end)

espTab:Toggle("Skeleton", false, function(on)
	ESPState.Skeletons = on
end)

espTab:Toggle("Enemies Only (Team Filter)", false, function(on)
	ESPState.Team = on
end)

espTab:Label("Settings")

espTab:Slider("Max Distance", 50, 2000, 1000, function(val)
	ESPState.MaxDist = val
end)

espTab:Slider("Box Thickness", 1, 5, 1, function(val)
	ESPState.BoxThickness = val
end)

espTab:Slider("Text Size", 8, 24, 13, function(val)
	ESPState.TextSize = val
end)

espTab:Dropdown("Tracer Origin", {"Bottom", "Center", "Top"}, function(choice)
	ESPState.TracerOrigin = choice
end)

espTab:Label("Box Color  (R / G / B)")
espTab:Slider("Box R", 0, 255, 255, function(v)
	ESPState.BoxColor = Color3.fromRGB(v, ESPState.BoxColor.G*255, ESPState.BoxColor.B*255)
end)
espTab:Slider("Box G", 0, 255, 50, function(v)
	ESPState.BoxColor = Color3.fromRGB(ESPState.BoxColor.R*255, v, ESPState.BoxColor.B*255)
end)
espTab:Slider("Box B", 0, 255, 50, function(v)
	ESPState.BoxColor = Color3.fromRGB(ESPState.BoxColor.R*255, ESPState.BoxColor.G*255, v)
end)

espTab:Label("Name Color  (R / G / B)")
espTab:Slider("Name R", 0, 255, 255, function(v)
	ESPState.NameColor = Color3.fromRGB(v, ESPState.NameColor.G*255, ESPState.NameColor.B*255)
end)
espTab:Slider("Name G", 0, 255, 255, function(v)
	ESPState.NameColor = Color3.fromRGB(ESPState.NameColor.R*255, v, ESPState.NameColor.B*255)
end)
espTab:Slider("Name B", 0, 255, 255, function(v)
	ESPState.NameColor = Color3.fromRGB(ESPState.NameColor.R*255, ESPState.NameColor.G*255, v)
end)

espTab:Label("Tracer Color  (R / G / B)")
espTab:Slider("Tracer R", 0, 255, 255, function(v)
	ESPState.TracerColor = Color3.fromRGB(v, ESPState.TracerColor.G*255, ESPState.TracerColor.B*255)
end)
espTab:Slider("Tracer G", 0, 255, 255, function(v)
	ESPState.TracerColor = Color3.fromRGB(ESPState.TracerColor.R*255, v, ESPState.TracerColor.B*255)
end)
espTab:Slider("Tracer B", 0, 255, 0, function(v)
	ESPState.TracerColor = Color3.fromRGB(ESPState.TracerColor.R*255, ESPState.TracerColor.G*255, v)
end)

espTab:Label("Skeleton Color  (R / G / B)")
espTab:Slider("Skel R", 0, 255, 200, function(v)
	ESPState.SkeletonColor = Color3.fromRGB(v, ESPState.SkeletonColor.G*255, ESPState.SkeletonColor.B*255)
end)
espTab:Slider("Skel G", 0, 255, 200, function(v)
	ESPState.SkeletonColor = Color3.fromRGB(ESPState.SkeletonColor.R*255, v, ESPState.SkeletonColor.B*255)
end)
espTab:Slider("Skel B", 0, 255, 255, function(v)
	ESPState.SkeletonColor = Color3.fromRGB(ESPState.SkeletonColor.R*255, ESPState.SkeletonColor.G*255, v)
end)

espTab:Button("Reset ESP", function()
	clearAllESP()
	ESPState.Enabled = false
end)
-- no clip (fixed: per-frame apply, smooth restore, all BasePart subtypes)
local originalCollide = {}

RunService.Stepped:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end

	if SelfState.NoClip then
		-- Apply every frame so newly added parts (accessories, tools) get caught
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				-- Save original state only once per part
				if originalCollide[p] == nil then
					originalCollide[p] = p.CanCollide
				end
				p.CanCollide = false
			end
		end
	else
		-- Restore only parts we actually modified
		for p, v in pairs(originalCollide) do
			-- Guard: part may have been destroyed
			if p and p.Parent then
				p.CanCollide = v
			end
		end
		table.clear(originalCollide)
	end
end)

-- anti AFK
LocalPlayer.Idled:Connect(function()
	if SelfState.AntiAFK then
		VirtualUser:Button2Down(Vector2.zero, Camera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.zero, Camera.CFrame)
	end
end)

-- anti void
local lastSafeCFrame = nil
RunService.Heartbeat:Connect(function()
	if not SelfState.AntiVoid then return end
	local char = LocalPlayer.Character; if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	local groundHit = Workspace:Raycast(hrp.Position, Vector3.new(0,-5,0), params)
	local velocityY = hrp.AssemblyLinearVelocity.Y
	if groundHit and math.abs(velocityY) < 1 then lastSafeCFrame = hrp.CFrame end
	if hrp.Position.Y < -50 and lastSafeCFrame then
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
		hrp.CFrame = lastSafeCFrame
	end
end)

-- fly loop
RunService.RenderStepped:Connect(function()
	if not SelfState.Flying or not flyBV or not flyBG then return end
	local hrp = getRootPart(); if not hrp then return end
	local camCF = Camera.CFrame; local dir = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector  end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector  end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir = dir + Vector3.new(0,1,0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
	flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * SelfState.FlySpeed or Vector3.zero
	flyBG.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
end)



-- hitbox expander
RunService.RenderStepped:Connect(function()
	if not PVPState.HitboxExpand then return end
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LocalPlayer and pl.Character then
			local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local s = PVPState.HitboxSize
				hrp.Size = Vector3.new(s,s,s)
				hrp.CanCollide = false
				hrp.Transparency = 0.3
			end
		end
	end
end)

-- reach
RunService.Stepped:Connect(function()
	if not PVPState.Reach then return end
	local char = LocalPlayer.Character; if not char then return end
	local sword = char:FindFirstChildOfClass("Tool")
		or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
	if not sword or not sword:FindFirstChild("Handle") then return end
	local playerHRP = char:FindFirstChild("HumanoidRootPart"); if not playerHRP then return end
	pcall(function()
		local fireTouch = firetouchinterest; if not fireTouch then return end
		for _, targetPlayer in ipairs(Players:GetPlayers()) do
			if targetPlayer ~= LocalPlayer and targetPlayer.Character then
				local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
				if targetHRP then
					local dist = (targetHRP.Position - playerHRP.Position).Magnitude
					if dist <= PVPState.ReachDist then
						for _, part in ipairs(targetPlayer.Character:GetChildren()) do
							if part:IsA("BasePart") then
								fireTouch(sword.Handle, part, 0)
								fireTouch(sword.Handle, part, 1)
								fireTouch(sword.Handle, part, 0)
							end
						end
					end
				end
			end
		end
	end)
end)

-- ============================================================
--  MINIMIZE / EXIT
-- ============================================================
local minimized = false
local storedH   = MainFrame.Size.Y.Offset

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		storedH = MainFrame.Size.Y.Offset
		TweenService:Create(MainFrame, TweenInfo.new(0.2), {
			Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 40)
		}):Play()
		task.wait(0.05)
		TabBar.Visible      = false
		ContentArea.Visible = false
	else
		TabBar.Visible      = true
		ContentArea.Visible = true
		TweenService:Create(MainFrame, TweenInfo.new(0.2), {
			Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, storedH)
		}):Play()
	end
end)

ExitBtn.MouseButton1Click:Connect(function()
	_stopFly()
	TweenService:Create(MainFrame, TweenInfo.new(0.2), {
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.22)
	ScreenGui:Destroy()
end)

-- ============================================================
--  SETTINGS  (RGB colour pickers)
-- ============================================================

local UI_ACTIVE = false
local UserInputService = game:GetService("UserInputService")

local SF = Instance.new("Frame")
SF.Size = UDim2.new(0,360,0,500)
SF.Position = UDim2.new(0.5,-180,0.5,-250)
SF.BackgroundColor3 = Theme.SettingsBG
SF.BorderSizePixel = 0
SF.Visible = false
SF.ZIndex = 20
SF.Parent = ScreenGui

Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 10)

local SFS = Instance.new("UIStroke", SF)
SFS.Color = Theme.Accent
SFS.Thickness = 2
SFS.Transparency = 0.3

reg(SF, "BackgroundColor3", "SettingsBG")
table.insert(themedObjects, {inst=SFS, prop="Color", key="Accent"})

local SFTitle = Instance.new("TextLabel", SF)
SFTitle.Size = UDim2.new(1,-50,0,40)
SFTitle.Position = UDim2.new(0,12,0,0)
SFTitle.BackgroundTransparency = 1
SFTitle.Text = "Settings - Theme Colors"
SFTitle.TextColor3 = Theme.Accent
SFTitle.Font = Enum.Font.GothamBold
SFTitle.TextSize = 15
SFTitle.TextXAlignment = Enum.TextXAlignment.Left
SFTitle.ZIndex = 21

reg(SFTitle, "TextColor3", "Accent")

local SFC = Instance.new("TextButton", SF)
SFC.Size = UDim2.new(0,32,0,26)
SFC.Position = UDim2.new(1,-38,0,7)
SFC.BackgroundColor3 = Theme.Accent
SFC.BackgroundTransparency = 0.2
SFC.BorderSizePixel = 0
SFC.Text = "X"
SFC.TextColor3 = Theme.BtnText
SFC.Font = Enum.Font.GothamBold
SFC.TextSize = 13
SFC.ZIndex = 21

Instance.new("UICorner", SFC).CornerRadius = UDim.new(1, 0)

SFC.MouseButton1Click:Connect(function()
	SF.Visible = false
	UI_ACTIVE = false
end)

reg(SFC, "BackgroundColor3", "Accent")
reg(SFC, "TextColor3", "BtnText")

local SFScroll = Instance.new("ScrollingFrame", SF)
SFScroll.Size = UDim2.new(1,-12,1,-50)
SFScroll.Position = UDim2.new(0,6,0,46)
SFScroll.BackgroundTransparency = 1
SFScroll.BorderSizePixel = 0
SFScroll.CanvasSize = UDim2.new(0,0,0,0)
SFScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SFScroll.ScrollBarThickness = 4
SFScroll.ScrollBarImageColor3 = Theme.Accent
SFScroll.ZIndex = 21

table.insert(themedObjects, {inst=SFScroll, prop="ScrollBarImageColor3", key="Accent"})

local SFL = Instance.new("UIListLayout", SFScroll)
SFL.Padding = UDim.new(0,10)
SFL.SortOrder = Enum.SortOrder.LayoutOrder

local SFP = Instance.new("UIPadding", SFScroll)
SFP.PaddingLeft = UDim.new(0,8)
SFP.PaddingRight = UDim.new(0,8)

-- ============================================================
-- SETTINGS DRAG (FIXED MOBILE + NO STICK)
-- ============================================================

do
	local sfDrag = false
	local sfDS, sfSP
	local activeInput = nil

	SF.InputBegan:Connect(function(i)
		if not UI_ACTIVE then return end

		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then

			sfDrag = true
			activeInput = i
			sfDS = i.Position
			sfSP = SF.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if not UI_ACTIVE then return end
		if not sfDrag then return end
		if i ~= activeInput then return end

		local d = i.Position - sfDS

		SF.Position = UDim2.new(
			sfSP.X.Scale, sfSP.X.Offset + d.X,
			sfSP.Y.Scale, sfSP.Y.Offset + d.Y
		)
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i == activeInput then
			sfDrag = false
			activeInput = nil
		end
	end)

	SF:GetPropertyChangedSignal("Visible"):Connect(function()
		if not SF.Visible then
			sfDrag = false
			activeInput = nil
		end
	end)
end

-- ============================================================
-- OPEN / CLOSE
-- ============================================================

SettingsBtn.MouseButton1Click:Connect(function()
	SF.Visible = not SF.Visible
	UI_ACTIVE = SF.Visible
end)

-- ============================================================
-- RGB PICKER + GUI TRANSPARENCY SLIDER (ADDED)
-- ============================================================

local chC = {
	R = Color3.fromRGB(255,80,80),
	G = Color3.fromRGB(80,210,80),
	B = Color3.fromRGB(80,140,255)
}

-- ============================================================
-- GUI TRANSPARENCY CONTROL (NEW)
-- ============================================================

local function addGuiTransparencySlider(parent)
	local row = Instance.new("Frame", parent)
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1,0,0,70)

	local lbl = Instance.new("TextLabel", row)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1,-10,0,18)
	lbl.Text = "GUI Transparency"
	lbl.TextColor3 = Theme.LabelText
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	reg(lbl, "TextColor3", "LabelText")

	local trk = Instance.new("Frame", row)
	trk.Size = UDim2.new(1,-20,0,8)
	trk.Position = UDim2.new(0,0,0,28)
	trk.BackgroundColor3 = Color3.fromRGB(40,60,80)
	trk.BorderSizePixel = 0
	Instance.new("UICorner", trk).CornerRadius = UDim.new(1,0)

	local fill = Instance.new("Frame", trk)
	fill.Size = UDim2.new(0.2,0,1,0)
	fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

	local kn = Instance.new("Frame", trk)
	kn.Size = UDim2.new(0,12,0,12)
	kn.Position = UDim2.new(0.2,-6,0.5,-6)
	kn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)

	local hit = Instance.new("TextButton", row)
	hit.Size = UDim2.new(1,-20,0,40)
	hit.Position = UDim2.new(0,0,0,20)
	hit.BackgroundTransparency = 1
	hit.Text = ""

	local dragging = false

	local function apply(v)
		v = math.clamp(v, 0, 1)

		fill.Size = UDim2.new(v,0,1,0)
		kn.Position = UDim2.new(v,-6,0.5,-6)

		MainFrame.BackgroundTransparency = v
		TabBar.BackgroundTransparency = v + 0.05
		ContentArea.BackgroundTransparency = v + 0.03
	end

	local function update(x)
		local abs = trk.AbsolutePosition.X
		local sz = trk.AbsoluteSize.X
		local rel = math.clamp((x - abs) / sz, 0, 1)
		apply(rel)
	end

	hit.InputBegan:Connect(function(i)
		if not UI_ACTIVE then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			update(i.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement
			or i.UserInputType == Enum.UserInputType.Touch then

			update(i.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	apply(0.2)
end

-- ============================================================
-- RGB PICKER
-- ============================================================

local function makeRGBRow(parent, rowLabel, themeKey)
	local Z = 22

	local row = Instance.new("Frame", parent)
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1,0,0,106)
	row.ZIndex = Z

	local hdr = Instance.new("TextLabel", row)
	hdr.BackgroundTransparency = 1
	hdr.Size = UDim2.new(1,-34,0,18)
	hdr.Text = rowLabel
	hdr.TextColor3 = Theme.LabelText
	hdr.Font = Enum.Font.GothamBold
	hdr.TextSize = 12
	hdr.TextXAlignment = Enum.TextXAlignment.Left
	hdr.ZIndex = Z

	reg(hdr, "TextColor3", "LabelText")

	local sw = Instance.new("Frame", row)
	sw.Size = UDim2.new(0,26,0,26)
	sw.Position = UDim2.new(1,-30,0,-4)
	sw.BackgroundColor3 = Theme[themeKey]
	sw.BorderSizePixel = 0
	sw.ZIndex = Z

	Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 4)

	local cur = {
		R = math.round(Theme[themeKey].R * 255),
		G = math.round(Theme[themeKey].G * 255),
		B = math.round(Theme[themeKey].B * 255),
	}

	for i, ch in ipairs({"R","G","B"}) do
		local y = 20 + (i-1)*28

		local cl = Instance.new("TextLabel", row)
		cl.BackgroundTransparency = 1
		cl.Size = UDim2.new(0,14,0,20)
		cl.Position = UDim2.new(0,0,0,y)
		cl.Text = ch
		cl.TextColor3 = chC[ch]
		cl.Font = Enum.Font.GothamBold
		cl.TextSize = 11
		cl.ZIndex = Z

		local trk = Instance.new("Frame", row)
		trk.Size = UDim2.new(1,-66,0,8)
		trk.Position = UDim2.new(0,18,0,y+6)
		trk.BackgroundColor3 = Color3.fromRGB(40,60,80)
		trk.BorderSizePixel = 0
		trk.ZIndex = Z

		Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

		local fl = Instance.new("Frame", trk)
		fl.Size = UDim2.new(cur[ch]/255,0,1,0)
		fl.BackgroundColor3 = chC[ch]
		fl.BorderSizePixel = 0
		fl.ZIndex = Z+1

		Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)

		local kn = Instance.new("Frame", trk)
		kn.Size = UDim2.new(0,12,0,12)
		kn.Position = UDim2.new(cur[ch]/255,-6,0.5,-6)
		kn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		kn.BorderSizePixel = 0
		kn.ZIndex = Z+2

		Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)

		local vl = Instance.new("TextLabel", row)
		vl.BackgroundTransparency = 1
		vl.Size = UDim2.new(0,34,0,18)
		vl.Position = UDim2.new(1,-48,0,y)
		vl.Text = tostring(cur[ch])
		vl.TextColor3 = Theme.LabelText
		vl.Font = Enum.Font.Gotham
		vl.TextSize = 11
		vl.ZIndex = Z

		reg(vl, "TextColor3", "LabelText")

		local hit = Instance.new("TextButton", row)
		hit.Size = UDim2.new(1,-66,0,20)
		hit.Position = UDim2.new(0,18,0,y)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = Z+3

		local dc = false

		local function upd(px)
			if not UI_ACTIVE then return end

			local abs = trk.AbsolutePosition.X
			local sz = trk.AbsoluteSize.X
			if sz == 0 then return end

			local rel = math.clamp((px - abs) / sz, 0, 1)
			local v = math.round(rel * 255)

			cur[ch] = v

			fl.Size = UDim2.new(rel, 0, 1, 0)
			kn.Position = UDim2.new(rel, -6, 0.5, -6)
			vl.Text = tostring(v)

			Theme[themeKey] = Color3.fromRGB(cur.R, cur.G, cur.B)
			sw.BackgroundColor3 = Theme[themeKey]

			applyTheme()
		end

		hit.InputBegan:Connect(function(i)
			if not UI_ACTIVE then return end

			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then

				dc = true
				upd(i.Position.X)
			end
		end)

		UserInputService.InputChanged:Connect(function(i)
			if not UI_ACTIVE then return end
			if not dc then return end

			if i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch then

				upd(i.Position.X)
			end
		end)

		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then

				dc = false
			end
		end)
	end
end

for _, r in ipairs({
	{"Main BG","MainBG"},{"Tab Bar BG","TabBG"},{"Title Color","TitleColor"},{"Section BG","SectionBG"},
	{"Accent / Buttons","Accent"},{"Button Text","BtnText"},{"Label Text","LabelText"},
	{"Toggle ON","ToggleON"},{"Toggle OFF","ToggleOFF"},
	{"Slider Fill","SliderFill"},{"Input BG","InputBG"},{"Settings BG","SettingsBG"},
	}) do
	makeRGBRow(SFScroll, r[1], r[2])
end

-- ADD TRANSPARENCY SLIDER
addGuiTransparencySlider(SFScroll)

applyTheme()
