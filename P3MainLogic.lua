repeat task.wait() until _G.MainFrame and _G.TopBar and _G.MainPage and _G.SettingsPage and _G.MainTabBtn and _G.SettingsTabBtn
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
task.spawn(function()
    local rot = 0
    while _G.MainFrame and _G.MainFrame.Parent do
        task.wait()
        rot = rot + 2
        if _G.NeonGradient then _G.NeonGradient.Rotation = rot % 360 end
    end
end)
_G.MainTabBtn.MouseButton1Click:Connect(function()
    _G.MainPage.Visible = true
    _G.SettingsPage.Visible = false
    _G.MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    _G.SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)
_G.SettingsTabBtn.MouseButton1Click:Connect(function()
    _G.MainPage.Visible = false
    _G.SettingsPage.Visible = true
    _G.SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    _G.MainTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)
local dragging, dragStart, startPos
_G.TopBar.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and (_G.A and not _G.A.Enabled) then
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
_G.A = _G.A or {}
_G.A.CamConnection = RS.RenderStepped:Connect(function(dt)
    if _G.A and _G.A.UpdateCamera then _G.A.UpdateCamera(dt) end
end)
_G.A.ToggleKey = _G.A.ToggleKey or Enum.KeyCode.H
_G.A.KeyConnection = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == _G.A.ToggleKey then
        _G.MainFrame.Visible = not _G.MainFrame.Visible
    end
end)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab1Main.lua"))()
end)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P1Tab2Setting.lua"))()
end)
