local A = _G.A
local Cam = workspace.CurrentCamera
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
_G.SpeedBtn.MouseButton1Click:Connect(function()
    local s = {0.5, 1, 2, 5, 10, 20}
    local i = table.find(s, A.Speed) or 2
    A.Speed = s[i % #s + 1]
    _G.SpeedBtn.Text = "SPEED: " .. A.Speed .. "x"
end)
_G.TPBtn.MouseButton1Click:Connect(function()
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
        A.Rot = A.Rot + Vector2.new(-io.Delta.X * 0.007, -io.Delta.Y * 0.007)
    end
end)
local function StopMove()
    A.StartPos, A.CurrentMovePos, A.CurrentMoveVec = nil, nil, Vector2.new(0, 0)
end
_G.MovePad.InputEnded:Connect(StopMove)
UIS.InputEnded:Connect(function(io)
    if io.UserInputType == Enum.UserInputType.Touch and not A.StartPos then
        StopMove()
    end
end)
