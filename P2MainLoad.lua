local LP = game:GetService("Players").LocalPlayer
_G.ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LP:WaitForChild("PlayerGui"))
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
_G.NeonStroke = Instance.new("UIStroke", _G.MainFrame)
_G.NeonStroke.Thickness = 2
_G.NeonGradient = Instance.new("UIGradient", _G.NeonStroke)
_G.NeonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
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
_G.TabContainer = Instance.new("Frame", _G.MainFrame)
_G.TabContainer.Size = UDim2.new(1, 0, 1, -35)
_G.TabContainer.Position = UDim2.new(0, 0, 0, 35)
_G.TabContainer.BackgroundTransparency = 1
_G.TabContainer.Visible = false
local NavBar = Instance.new("Frame", _G.TabContainer)
NavBar.Size = UDim2.new(1, 0, 0, 25)
NavBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.MainPage = Instance.new("ScrollingFrame", _G.TabContainer)
_G.MainPage.Size = UDim2.new(1, 0, 1, -25)
_G.MainPage.Position = UDim2.new(0, 0, 0, 25)
_G.MainPage.BackgroundTransparency = 1
_G.MainPage.ScrollBarThickness = 0
_G.SettingsPage = Instance.new("ScrollingFrame", _G.TabContainer)
_G.SettingsPage.Size = UDim2.new(1, 0, 1, -25)
_G.SettingsPage.Position = UDim2.new(0, 0, 0, 25)
_G.SettingsPage.BackgroundTransparency = 1
_G.SettingsPage.ScrollBarThickness = 0
_G.SettingsPage.Visible = false
_G.MainTabBtn = Instance.new("TextButton", NavBar)
_G.MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
_G.MainTabBtn.Text = "MAIN"
_G.MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_G.MainTabBtn.TextColor3 = Color3.new(1,1,1)
_G.MainTabBtn.Font = Enum.Font.GothamBold
_G.MainTabBtn.TextSize = 10
_G.SettingsTabBtn = Instance.new("TextButton", NavBar)
_G.SettingsTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
_G.SettingsTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
_G.SettingsTabBtn.Text = "SETTINGS"
_G.SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
_G.SettingsTabBtn.Font = Enum.Font.GothamBold
_G.SettingsTabBtn.TextSize = 10
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P3MainLogic.lua"))()
end)
