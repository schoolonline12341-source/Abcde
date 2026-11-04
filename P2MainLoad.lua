-- P2MainLoad.lua
local A = _G.A
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Left-side touch pad for Mobile Movement + Visual Joystick
_G.MovePad = Instance.new("Frame", _G.ScreenGui)
_G.MovePad.Size = UDim2.new(0.45, 0, 1, 0)
_G.MovePad.BackgroundTransparency = 1
_G.MovePad.Visible = false

_G.JoystickOuter = Instance.new("Frame", _G.MovePad)
_G.JoystickOuter.Size = UDim2.new(0, 110, 0, 110)
_G.JoystickOuter.AnchorPoint = Vector2.new(0.5, 0.5)
_G.JoystickOuter.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.JoystickOuter.BackgroundTransparency = 0.5
_G.JoystickOuter.Visible = false
Instance.new("UICorner", _G.JoystickOuter).CornerRadius = UDim.new(1, 0)
local joyStroke = Instance.new("UIStroke", _G.JoystickOuter)
joyStroke.Color = Color3.fromRGB(0, 170, 255)
joyStroke.Thickness = 1.5
joyStroke.Transparency = 0.3

_G.JoystickKnob = Instance.new("Frame", _G.JoystickOuter)
_G.JoystickKnob.Size = UDim2.new(0, 44, 0, 44)
_G.JoystickKnob.AnchorPoint = Vector2.new(0.5, 0.5)
_G.JoystickKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
_G.JoystickKnob.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
_G.JoystickKnob.BackgroundTransparency = 0.2
Instance.new("UICorner", _G.JoystickKnob).CornerRadius = UDim.new(1, 0)

-- Right-side Up/Down Buttons for Mobile Vertical Flight
_G.VertPad = Instance.new("Frame", _G.ScreenGui)
_G.VertPad.Size = UDim2.new(0, 50, 0, 110)
_G.VertPad.Position = UDim2.new(1, -70, 0.65, -55)
_G.VertPad.BackgroundTransparency = 1
_G.VertPad.Visible = false

local function CreateVertBtn(text, posY)
	local b = Instance.new("TextButton", _G.VertPad)
	b.Size = UDim2.new(1, 0, 0, 48)
	b.Position = UDim2.new(0, 0, 0, posY)
	b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	b.BackgroundTransparency = 0.3
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", b)
	st.Color = Color3.fromRGB(0, 170, 255)
	st.Thickness = 1
	st.Transparency = 0.4
	return b
end

_G.UpBtn = CreateVertBtn("UP", 0)
_G.DownBtn = CreateVertBtn("DN", 60)

-- Main Window Frame
_G.MainFrame = Instance.new("Frame", _G.ScreenGui)
_G.MainFrame.Size = UDim2.new(0, 260, 0, 35)
_G.MainFrame.Position = UDim2.new(0.5, -130, 0.15, 0)
_G.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_G.MainFrame.BorderSizePixel = 0
_G.MainFrame.ClipsDescendants = true
_G.MainFrame.Active = true
Instance.new("UICorner", _G.MainFrame).CornerRadius = UDim.new(0, 10)

local NeonStroke = Instance.new("UIStroke", _G.MainFrame)
NeonStroke.Thickness = 2
local NeonGradient = Instance.new("UIGradient", NeonStroke)
NeonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})

task.spawn(function()
	local rot = 0
	while A.Running and _G.ScreenGui and _G.ScreenGui.Parent do
		rot = (rot + 2) % 360
		NeonGradient.Rotation = rot
		task.wait(0.03)
	end
end)

_G.TopBar = Instance.new("Frame", _G.MainFrame)
_G.TopBar.Size = UDim2.new(1, 0, 0, 35)
_G.TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", _G.TopBar)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "FREECAM PRO"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", _G.MainFrame)
TabContainer.Size = UDim2.new(1, 0, 1, -35)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundTransparency = 1
TabContainer.Visible = false
_G.TabContainer = TabContainer

local NavBar = Instance.new("Frame", TabContainer)
NavBar.Size = UDim2.new(1, 0, 0, 26)
NavBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NavBar.BorderSizePixel = 0

_G.MainPage = Instance.new("ScrollingFrame", TabContainer)
_G.MainPage.Size = UDim2.new(1, 0, 1, -30)
_G.MainPage.Position = UDim2.new(0, 0, 0, 30)
_G.MainPage.BackgroundTransparency = 1
_G.MainPage.ScrollBarThickness = 2
_G.MainPage.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

_G.SettingsPage = Instance.new("ScrollingFrame", TabContainer)
_G.SettingsPage.Size = UDim2.new(1, 0, 1, -30)
_G.SettingsPage.Position = UDim2.new(0, 0, 0, 30)
_G.SettingsPage.BackgroundTransparency = 1
_G.SettingsPage.ScrollBarThickness = 2
_G.SettingsPage.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
_G.SettingsPage.Visible = false

local MainTabBtn = Instance.new("TextButton", NavBar)
MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
MainTabBtn.Text = "MAIN"
MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainTabBtn.TextColor3 = Color3.new(1, 1, 1)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 10
MainTabBtn.BorderSizePixel = 0

local SettingsTabBtn = Instance.new("TextButton", NavBar)
SettingsTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
SettingsTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
SettingsTabBtn.Text = "SETTINGS"
SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SettingsTabBtn.Font = Enum.Font.GothamBold
SettingsTabBtn.TextSize = 10
SettingsTabBtn.BorderSizePixel = 0

MainTabBtn.MouseButton1Click:Connect(function()
	_G.MainPage.Visible = true
	_G.SettingsPage.Visible = false
	MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainTabBtn.TextColor3 = Color3.new(1, 1, 1)
	SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

SettingsTabBtn.MouseButton1Click:Connect(function()
	_G.MainPage.Visible = false
	_G.SettingsPage.Visible = true
	SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	SettingsTabBtn.TextColor3 = Color3.new(1, 1, 1)
	MainTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	MainTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Window Dragging
local dragInputObj = nil
local dragStart, startPos

_G.TopBar.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragInputObj then
		dragInputObj = input
		dragStart = input.Position
		startPos = _G.MainFrame.Position
	end
end)

A.Bind(UIS.InputChanged, function(input)
	if dragInputObj and (input == dragInputObj or (input.UserInputType == Enum.UserInputType.MouseMovement and dragInputObj.UserInputType == Enum.UserInputType.MouseButton1)) then
		local delta = input.Position - dragStart
		_G.MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

A.Bind(UIS.InputEnded, function(input)
	if input == dragInputObj then
		dragInputObj = nil
	end
end)

A.CamConnection = A.Bind(RS.RenderStepped, function(dt)
	if A and A.UpdateCamera then
		A.UpdateCamera(dt)
	end
end)

A.KeyConnection = A.Bind(UIS.InputBegan, function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == A.ToggleKey then
		_G.MainFrame.Visible = not _G.MainFrame.Visible
	end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab1Main.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab2Setting.lua"))()
