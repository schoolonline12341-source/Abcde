local A = _G.A
local SettingsPage = _G.SettingsPage
local UIS = game:GetService("UserInputService")

local HideAllBtn = CreateSetBtn("STEALTH UI: OFF")
HideAllBtn.MouseButton1Click:Connect(function()
    A.HideEverything = not A.HideEverything

    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
                gui.Enabled = not A.HideEverything
            end
        end
    end

    pcall(function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, not A.HideEverything)
    end)

    HideAllBtn.Text = A.HideEverything and "STEALTH UI: ON" or "STEALTH UI: OFF"
    HideAllBtn.BackgroundColor3 = A.HideEverything and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

CreateTitle("SYSTEM SETTINGS")

local ResetBtn = CreateSetBtn("FORCE RESET GUI (TAP)")
ResetBtn.MouseButton1Click:Connect(function()
    ResetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
    A.HideEverything = false

    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
                gui.Enabled = false
                gui.Enabled = true
            end
        end
    end

    pcall(function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    end)

    task.wait(0.2)
    ResetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

local ToggleKeyBtn = CreateSetBtn("UI TOGGLE KEY: H")
ToggleKeyBtn.MouseButton1Click:Connect(function()
    ToggleKeyBtn.Text = "PRESS ANY KEY..."
    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            A.ToggleKey = input.KeyCode
            ToggleKeyBtn.Text = "UI TOGGLE KEY: " .. input.KeyCode.Name
            conn:Disconnect()
        end
    end)
end)

-- FIXED: use global UIList
SettingsPage.CanvasSize = UDim2.new(0, 0, 0, _G.SettingsUIList.AbsoluteContentSize.Y)
_G.SettingsUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsPage.CanvasSize = UDim2.new(0, 0, 0, _G.SettingsUIList.AbsoluteContentSize.Y)
end)
