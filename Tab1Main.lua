local A = _G.A
local MainFrame = _G.MainFrame
local TopBar = _G.TopBar
local UIS = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local LP = game:GetService("Players").LocalPlayer
local MainPage = _G.MainPage
local TabContainer = _G.TabContainer

if not A then task.wait(0.1) A = _G.A end

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

MainPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MainPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end)

local function CreateBtn(name)
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
        isSliding = true UpdateFOV(i)
    end
end)
UIS.InputChanged:Connect(function(i)
    if isSliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        UpdateFOV(i)
    end
end)
UIS.InputEnded:Connect(function() isSliding = false end)

local ToggleBtn = CreateBtn("STATUS: OFF")
local SpeedBtn = CreateBtn("SPEED: 1x")
local TPBtn = CreateBtn("TELEPORT HERE")

local CreditsLabel = Instance.new("TextLabel", MainPage)
CreditsLabel.Size = UDim2.new(0.9, 0, 0, 20)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "made by AcelestuZ"
CreditsLabel.Font = Enum.Font.GothamMedium
CreditsLabel.TextSize = 10
CreditsLabel.TextColor3 = Color3.fromRGB(120, 120, 120)

local IsOpen = false
MinBtn.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen
    MinBtn.Text = IsOpen and "HIDE" or "OPEN"
    MainFrame:TweenSize(IsOpen and UDim2.new(0, 250, 0, 255) or UDim2.new(0, 250, 0, 35), "Out", "Back", 0.3, true)
    TabContainer.Visible = IsOpen
end)

CloseBtn.MouseButton1Click:Connect(function() 
    A.Reset(ToggleBtn)
    _G.ScreenGui:Destroy()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    A.Enabled = not A.Enabled
    ToggleBtn.Text = A.Enabled and "STATUS: ON" or "STATUS: OFF"
    ToggleBtn.BackgroundColor3 = A.Enabled and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
    _G.MovePad.Visible = A.Enabled
    if A.Enabled then
        local x, y, z = Cam.CFrame:ToEulerAnglesYXZ()
        A.Rot = Vector2.new(x, y)
        if LP.Character then
            A.TeleportToGround(LP.Character.HumanoidRootPart.Position)
            task.wait(0.05)
            LP.Character.HumanoidRootPart.Anchored = true
        end
    else
        A.Reset(ToggleBtn)
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    local s = {0.5, 1, 2, 5, 10, 20}
    local i = table.find(s, A.Speed) or 2
    A.Speed = s[i % #s + 1]
    SpeedBtn.Text = "SPEED: " .. A.Speed .. "x"
end)

TPBtn.MouseButton1Click:Connect(function()
    if LP.Character then A.TeleportToGround(Cam.CFrame.Position) end
end)

_G.MovePad.InputBegan:Connect(function(io)
    if io.UserInputType == Enum.UserInputType.Touch then
        A.StartPos = Vector2.new(io.Position.X, io.Position.Y)
        A.CurrentMovePos = A.StartPos
    end
end)
_G.MovePad.InputChanged:Connect(function(io)
    if A.StartPos and io.UserInputType == Enum.UserInputType.Touch then
        A.CurrentMovePos = Vector2.new(io.Position.X, io.Position.Y)
    end
end)
UIS.InputChanged:Connect(function(io, gpe)
    if not A.Enabled or gpe then return end
    if io.UserInputType == Enum.UserInputType.Touch and io.Position.X >= Cam.ViewportSize.X / 2 then
        A.Rot = A.Rot + Vector2.new(-io.Delta.Y * 0.005, -io.Delta.X * 0.005)
    end
end)
local function StopMove()
    A.StartPos, A.CurrentMovePos, A.CurrentMoveVec = nil, nil, Vector2.new(0,0)
end
_G.MovePad.InputEnded:Connect(StopMove)
UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.Touch and not A.StartPos then StopMove() end end)
