local A = _G.A
local MainFrame = _G.MainFrame
local SettingsPage = _G.SettingsPage
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local UIList = Instance.new("UIListLayout", SettingsPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

local function CreateTitle(text)
    local t = Instance.new("TextLabel", SettingsPage)
    t.Size = UDim2.new(0.9, 0, 0, 25)
    t.BackgroundTransparency = 1
    t.Text = "-- " .. text .. " --"
    t.TextColor3 = Color3.fromRGB(180, 180, 180)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 10
    return t
end

CreateTitle("VISUAL & RENDERING")

local FullBrightBtn = CreateSetBtn("FULL BRIGHT: OFF")
FullBrightBtn.MouseButton1Click:Connect(function()
    A.FullBright = not A.FullBright
    Lighting.Brightness = A.FullBright and 4 or 2
    Lighting.GlobalShadows = not A.FullBright
    FullBrightBtn.Text = A.FullBright and "FULL BRIGHT: ON" or "FULL BRIGHT: OFF"
    FullBrightBtn.BackgroundColor3 = A.FullBright and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

local NoFogBtn = CreateSetBtn("NO FOG: OFF")
NoFogBtn.MouseButton1Click:Connect(function()
    A.NoFog = not A.NoFog
    Lighting.FogEnd = A.NoFog and 100000 or 1000
    NoFogBtn.Text = A.NoFog and "NO FOG: ON" or "NO FOG: OFF"
    NoFogBtn.BackgroundColor3 = A.NoFog and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

local DOFBtn = CreateSetBtn("DEPTH OF FIELD: OFF")
DOFBtn.MouseButton1Click:Connect(function()
    local dof = Lighting:FindFirstChild("FreecamDOF") or Instance.new("DepthOfFieldEffect", Lighting)
    dof.Name = "FreecamDOF"
    dof.Enabled = not dof.Enabled
    DOFBtn.Text = dof.Enabled and "DEPTH OF FIELD: ON" or "DEPTH OF FIELD: OFF"
    DOFBtn.BackgroundColor3 = dof.Enabled and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

CreateTitle("INTERFACE & STEALTH")

local NamesBtn = CreateSetBtn("HIDDEN NAMES: OFF")
NamesBtn.MouseButton1Click:Connect(function()
    A.HideNames = not A.HideNames
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Humanoid") then
            v.Character.Humanoid.DisplayDistanceType = A.HideNames and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
    NamesBtn.Text = A.HideNames and "HIDDEN NAMES: ON" or "HIDDEN NAMES: OFF"
    NamesBtn.BackgroundColor3 = A.HideNames and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

local HideAllBtn = CreateSetBtn("STEALTH UI (CLICKABLE): OFF")
HideAllBtn.MouseButton1Click:Connect(function()
    A.HideEverything = not A.HideEverything
    local targetAlpha = A.HideEverything and 1 or 0
    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
                for _, obj in pairs(gui:GetDescendants()) do
                    if obj:IsA("GuiObject") then
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            obj.TextTransparency = targetAlpha
                            obj.BackgroundTransparency = targetAlpha
                        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                            obj.ImageTransparency = targetAlpha
                            obj.BackgroundTransparency = targetAlpha
                        elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                            obj.BackgroundTransparency = targetAlpha
                        end
                    elseif obj:IsA("UIStroke") then
                        obj.Transparency = targetAlpha
                    end
                end
            end
        end
    end
    pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not A.HideEverything) end)
    HideAllBtn.Text = A.HideEverything and "STEALTH UI: ON" or "STEALTH UI: OFF"
    HideAllBtn.BackgroundColor3 = A.HideEverything and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

CreateTitle("SYSTEM SETTINGS")

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

local ResetFOV = CreateSetBtn("RESET FOV (70)")
ResetFOV.MouseButton1Click:Connect(function()
    A.TargetFOV = 70
end)
