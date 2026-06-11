_G.A = _G.A or {}
repeat task.wait() until _G.TopBar and _G.MainFrame and _G.MainPage
_G.MinBtn = Instance.new("TextButton", _G.TopBar)
_G.MinBtn.Size = UDim2.new(0, 45, 0, 25)
_G.MinBtn.Position = UDim2.new(1, -75, 0.5, -12)
_G.MinBtn.BackgroundTransparency = 1
_G.MinBtn.Text = "OPEN"
_G.MinBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
_G.MinBtn.Font = Enum.Font.Gotham
_G.MinBtn.TextSize = 10
_G.CloseBtn = Instance.new("TextButton", _G.TopBar)
_G.CloseBtn.Size = UDim2.new(0, 22, 0, 22)
_G.CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
_G.CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
_G.CloseBtn.Text = ""
Instance.new("UICorner", _G.CloseBtn).CornerRadius = UDim.new(1, 0)
_G.MainUIList = Instance.new("UIListLayout", _G.MainPage)
_G.MainUIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
_G.MainUIList.Padding = UDim.new(0, 8)
function _G.CreateBtn(name)
    local b = Instance.new("TextButton", _G.MainPage)
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.Text = name
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end
local SliderContainer = Instance.new("Frame", _G.MainPage)
SliderContainer.Size = UDim2.new(0.9, 0, 0, 40)
SliderContainer.BackgroundTransparency = 1
_G.SliderLabel = Instance.new("TextLabel", SliderContainer)
_G.SliderLabel.Size = UDim2.new(1, 0, 0, 15)
_G.SliderLabel.Text = "FOV: 70"
_G.SliderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
_G.SliderLabel.Font = Enum.Font.Gotham
_G.SliderLabel.TextSize = 9
_G.SliderLabel.BackgroundTransparency = 1
_G.SliderBack = Instance.new("Frame", SliderContainer)
_G.SliderBack.Size = UDim2.new(1, 0, 0, 14)
_G.SliderBack.Position = UDim2.new(0, 0, 0, 20)
_G.SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
_G.SliderBack.BackgroundTransparency = 0.6
_G.SliderBack.Active = true
Instance.new("UICorner", _G.SliderBack)
local SliderVisual = Instance.new("Frame", _G.SliderBack)
SliderVisual.Size = UDim2.new(1, 0, 0, 4)
SliderVisual.Position = UDim2.new(0, 0, 0.5, -2)
SliderVisual.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderVisual.ZIndex = 2
Instance.new("UICorner", SliderVisual)
_G.SliderFill = Instance.new("Frame", SliderVisual)
_G.SliderFill.Size = UDim2.new(0.44, 0, 1, 0)
_G.SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
_G.SliderFill.ZIndex = 3
Instance.new("UICorner", _G.SliderFill)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab1Main2.lua"))()
end)
