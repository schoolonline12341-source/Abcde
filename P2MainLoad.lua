local A = _G.A
local MainFrame = _G.MainFrame
local TabContainer = _G.TabContainer
local MainPage = _G.MainPage
local MinBtn = _G.MinBtn
local CloseBtn = _G.CloseBtn
local Cam = workspace.CurrentCamera
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local Controls = require(LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
local function CreateBtn(name)
    local b = Instance.new("TextButton", MainPage)
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = name
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end
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
    if _G.A.IdleTrack then
        _G.A.IdleTrack:Stop()
        _G.A.IdleTrack = nil
    end
    pcall(function() Controls:Enable() end)
    if LP.Character then
        local animate = LP.Character:FindFirstChild("Animate")
        if animate then animate.Enabled = true end
    end
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
        pcall(function() Controls:Disable() end)
        if LP.Character then
            local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                    local animate = LP.Character:FindFirstChild("Animate")
                    if animate then
                        animate.Enabled = false
                        local idleTarget = animate:FindFirstChild("idle")
                        local idleAnim = idleTarget and idleTarget:FindFirstChildOfClass("Animation")
                        if idleAnim then
                            _G.A.IdleTrack = animator:LoadAnimation(idleAnim)
                        end
                    end
                    if not _G.A.IdleTrack then
                        local fallbackIdle = Instance.new("Animation")
                        fallbackIdle.AnimationId = humanoid.RigType == Enum.HumanoidRigType.R15 and "rbxassetid://507766388" or "rbxassetid://180435571"
                        _G.A.IdleTrack = animator:LoadAnimation(fallbackIdle)
                    end
                    if _G.A.IdleTrack then
                        _G.A.IdleTrack.Looped = true
                        _G.A.IdleTrack:Play()
                    end
                end
            end
            task.spawn(function()
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    hrp.Anchored = false
                    if hum.FloorMaterial == Enum.FloorMaterial.Air and hum:GetState() ~= Enum.HumanoidStateType.Swimming then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                        while hum.FloorMaterial == Enum.FloorMaterial.Air and _G.A.Enabled and LP.Character and LP.Character:IsDescendantOf(workspace) do
                            task.wait()
                        end
                    end
                    if _G.A.Enabled and LP.Character and LP.Character:IsDescendantOf(workspace) then
                        A.TeleportToGround(hrp.Position)
                        hrp.Anchored = true
                    end
                end
            end)
        end
    else
        if _G.A.IdleTrack then
            _G.A.IdleTrack:Stop()
            _G.A.IdleTrack = nil
        end
        pcall(function() Controls:Enable() end)
        if LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then animate.Enabled = true end
        end
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
