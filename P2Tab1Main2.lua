repeat task.wait() until _G.ToggleBtn and _G.SpeedBtn and _G.TPBtn
local A = _G.A
local LP = game:GetService("Players").LocalPlayer
local Controls = require(LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
local IsOpen = false
_G.MinBtn.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen
    _G.MinBtn.Text = IsOpen and "HIDE" or "OPEN"
    _G.MainFrame:TweenSize(IsOpen and UDim2.new(0, 250, 0, 255) or UDim2.new(0, 250, 0, 35), "Out", "Back", 0.3, true)
    _G.TabContainer.Visible = IsOpen
end)
_G.CloseBtn.MouseButton1Click:Connect(function() 
    if _G.A.IdleTrack then
        _G.A.IdleTrack:Stop()
        _G.A.IdleTrack = nil
    end
    if LP.Character then
        local animate = LP.Character:FindFirstChild("Animate")
        if animate then animate.Enabled = true end
    end
    A.Reset(_G.ToggleBtn)
    _G.MovePad.Visible = false
    Controls:Enable()
    if _G.ScreenGui then _G.ScreenGui:Destroy() _G.ScreenGui = nil end
    if _G.A.CamConnection then _G.A.CamConnection:Disconnect() _G.A.CamConnection = nil end
    if _G.A.KeyConnection then _G.A.KeyConnection:Disconnect() _G.A.KeyConnection = nil end
end)
_G.ToggleBtn.MouseButton1Click:Connect(function()
    A.Enabled = not A.Enabled
    if A.Enabled then
        _G.ToggleBtn.Text = "STATUS: ON"
        _G.ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
        _G.MovePad.Visible = true
        Controls:Disable()
        if LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                _G.A.TeleportToGround(hrp.Position)
                task.wait(0.05)
                hrp.Anchored = true
            end
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then animate.Enabled = false end
        end
    else
        _G.MovePad.Visible = false
        Controls:Enable()
        if LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then animate.Enabled = true end
        end
        A.Reset(_G.ToggleBtn)
    end
end)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2Tab1Main3.lua"))()
end)
