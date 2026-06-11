local A = _G.A
repeat task.wait() until _G.TopBar and _G.MainFrame and _G.MainPage
local TopBar = _G.TopBar
if not _G.MinBtn or not _G.MinBtn.Parent then
    _G.MinBtn = Instance.new("TextButton", TopBar)
    _G.MinBtn.Size = UDim2.new(0, 45, 0, 25)
    _G.MinBtn.Position = UDim2.new(1, -75, 0.5, -12)
    _G.MinBtn.BackgroundTransparency = 1
    _G.MinBtn.Text = "OPEN"
    _G.MinBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    _G.MinBtn.Font = Enum.Font.Gotham
    _G.MinBtn.TextSize = 10
end
if not _G.CloseBtn or not _G.CloseBtn.Parent then
    _G.CloseBtn = Instance.new("TextButton", TopBar)
    _G.CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    _G.CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
    _G.CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    _G.CloseBtn.Text = ""
    Instance.new("UICorner", _G.CloseBtn).CornerRadius = UDim.new(1, 0)
end
_G.ToggleBtn = CreateBtn("STATUS: OFF")
_G.SpeedBtn = CreateBtn("SPEED: 1x")
_G.TPBtn = CreateBtn("TELEPORT HERE")
local CreditsLabel = Instance.new("TextLabel", _G.MainPage)
CreditsLabel.Size = UDim2.new(0.9, 0, 0, 20)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "made by AcelestuZ"
CreditsLabel.Font = Enum.Font.GothamMedium
CreditsLabel.TextSize = 10
CreditsLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2Tab1Main2.lua"))()
end)
