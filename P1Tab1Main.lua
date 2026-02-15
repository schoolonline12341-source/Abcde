_G.A = _G.A or {}
local A = _G.A

repeat task.wait() until _G.TopBar and _G.MainFrame and _G.MainPage

local TopBar = _G.TopBar
local MainFrame = _G.MainFrame
local MainPage = _G.MainPage
local TabContainer = _G.TabContainer

local UIS = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local LP = game:GetService("Players").LocalPlayer

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 45, 0, 25)
MinBtn.Position = UDim2.new(1, -75, 0.5, -12)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "OPEN"
MinBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
MinBtn.Font = Enum.Font.Gotham
MinBtn.TextSize = 10

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = ""
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local UIList = Instance.new("UIListLayout", MainPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

function CreateBtn(name)
    local b = Instance.new("TextButton", MainPage)
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.Text = name
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local SliderContainer = Instance.new("Frame", MainPage)
SliderContainer.Size = UDim2.new(0.9, 0, 0, 40)
SliderContainer.BackgroundTransparency = 1

local SliderLabel = Instance.new("TextLabel", SliderContainer)
SliderLabel.Size = UDim2.new(1, 0, 0, 15)
SliderLabel.Text = "FOV: 70"
SliderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 9
SliderLabel.BackgroundTransparency = 1

local SliderBack = Instance.new("Frame", SliderContainer)
SliderBack.Size = UDim2.new(1, 0, 0, 14)
SliderBack.Position = UDim2.new(0, 0, 0, 20)
SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SliderBack.BackgroundTransparency = 0.6
SliderBack.Active = true
Instance.new("UICorner", SliderBack)

local SliderVisual = Instance.new("Frame", SliderBack)
SliderVisual.Size = UDim2.new(1, 0, 0, 4)
SliderVisual.Position = UDim2.new(0, 0, 0.5, -2)
SliderVisual.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderVisual.ZIndex = 2
Instance.new("UICorner", SliderVisual)

local SliderFill = Instance.new("Frame", SliderVisual)
SliderFill.Size = UDim2.new(0.44, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.ZIndex = 3
Instance.new("UICorner", SliderFill)

local function UpdateFOV(input)
    local percent = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    A.TargetFOV = math.floor(30 + (percent * 90))
    SliderLabel.Text = "FOV: " .. A.TargetFOV
end

local isSliding = false
SliderBack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
        UpdateFOV(i)
    end
end)
UIS.InputChanged:Connect(function(i)
    if isSliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        UpdateFOV(i)
    end
end)
UIS.InputEnded:Connect(function() isSliding = false end)

task.defer(function()
    MainPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        MainPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    end)
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2Tab1Main.lua"))()
