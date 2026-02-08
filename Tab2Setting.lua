local A = _G.A
local MainFrame = _G.MainFrame
local SettingsPage = _G.SettingsPage
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local UIList = Instance.new("UIListLayout", SettingsPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- FUNZIONE PER I SOTTOTITOLI (ORDINE SEZIONI)
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

-- SEZIONE 1: VISUAL & RENDERING
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

-- SEZIONE 2: INTERFACE & STEALTH
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

local HideAllBtn = CreateSetBtn("STEALTH UI: OFF")
HideAllBtn.MouseButton1Click:Connect(function()
    A.HideEverything = not A.HideEverything
    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
                -- Utilizzo di Enabled per evitare il bug delle GUI che riappaiono a caso
                [span_4](start_span)gui.Enabled = not A.HideEverything[span_4](end_span)
            end
        end
    end
    pcall(function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, not A.HideEverything)
    end)
    HideAllBtn.Text = A.HideEverything and "STEALTH UI: ON" or "STEALTH UI: OFF"
    HideAllBtn.BackgroundColor3 = A.HideEverything and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

-- RESET TAP (Comando secco senza ON/OFF)
local ResetBtn = CreateSetBtn("FORCE RESET GUI (TAP)")
ResetBtn.MouseButton1Click:Connect(function()
    ResetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
    A.HideEverything = false
    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
                gui.Enabled = false
                [span_5](start_span)gui.Enabled = true[span_5](end_span)
            end
        end
    end
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Humanoid") then
            [span_6](start_span)v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer[span_6](end_span)
        end
    end
    pcall(function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    end)
    task.wait(0.2)
    ResetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

-- SEZIONE 3: SYSTEM SETTINGS
CreateTitle("SYSTEM SETTINGS")

local ToggleKeyBtn = CreateSetBtn("UI TOGGLE KEY: H")
ToggleKeyBtn.MouseButton1Click:Connect(function()
    ToggleKeyBtn.Text = "PRESS ANY KEY..."
    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            A.ToggleKey = input.KeyCode
            [span_7](start_span)ToggleKeyBtn.Text = "UI TOGGLE KEY: " .. input.KeyCode.Name[span_7](end_span)
            conn:Disconnect()
        end
    end)
end)
