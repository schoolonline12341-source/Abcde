local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

_G.MovePad = Instance.new("Frame", _G.ScreenGui)
_G.MovePad.Size = UDim2.new(0.45, 0, 1, 0)
_G.MovePad.BackgroundTransparency = 1
_G.MovePad.Visible = false

_G.MainFrame = Instance.new("Frame", _G.ScreenGui)
_G.MainFrame.Size = UDim2.new(0, 250, 0, 35)
_G.MainFrame.Position = UDim2.new(0.5, -125, 0.15, 0)
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
    while task.wait() do
        rot = rot + 2
        NeonGradient.Rotation = rot % 360
    end
end)

_G.TopBar = Instance.new("Frame", _G.MainFrame)
_G.TopBar.Size = UDim2.new(1, 0, 0, 35)
_G.TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", _G.TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "FREECAM"
Title.TextColor3 = Color3.new(1,1,1)
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
NavBar.Size = UDim2.new(1, 0, 0, 25)
NavBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

_G.MainPage = Instance.new("ScrollingFrame", TabContainer)
_G.MainPage.Size = UDim2.new(1, 0, 1, -25)
_G.MainPage.Position = UDim2.new(0, 0, 0, 25)
_G.MainPage.BackgroundTransparency = 1
_G.MainPage.ScrollBarThickness = 0

_G.SettingsPage = Instance.new("ScrollingFrame", TabContainer)
_G.SettingsPage.Size = UDim2.new(1, 0, 1, -25)
_G.SettingsPage.Position = UDim2.new(0, 0, 0, 25)
_G.SettingsPage.BackgroundTransparency = 1
_G.SettingsPage.ScrollBarThickness = 0
_G.SettingsPage.Visible = false

local MainTabBtn = Instance.new("TextButton", NavBar)
MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
MainTabBtn.Text = "MAIN"
MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainTabBtn.TextColor3 = Color3.new(1,1,1)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 10

local SettingsTabBtn = Instance.new("TextButton", NavBar)
SettingsTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
SettingsTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
SettingsTabBtn.Text = "SETTINGS"
SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SettingsTabBtn.Font = Enum.Font.GothamBold
SettingsTabBtn.TextSize = 10

MainTabBtn.MouseButton1Click:Connect(function()
    _G.MainPage.Visible = true
    _G.SettingsPage.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

SettingsTabBtn.MouseButton1Click:Connect(function()
    _G.MainPage.Visible = false
    _G.SettingsPage.Visible = true
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

local dragging, dragStart, startPos
_G.TopBar.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not _G.A.Enabled then
        dragging = true
        dragStart = input.Position
        startPos = _G.MainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        _G.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function() dragging = false end)

RS.RenderStepped:Connect(function(dt)
    if _G.A and _G.A.UpdateCamera then _G.A.UpdateCamera(dt) end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab1Main.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab2Setting.lua"))()
