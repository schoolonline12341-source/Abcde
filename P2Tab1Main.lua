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
