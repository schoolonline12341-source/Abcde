--hello
local A = _G.A
local MainFrame = _G.MainFrame
local SettingsPage = _G.SettingsPage
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local UIList = Instance.new("UIListLayout", SettingsPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

local function CreateSetBtn(name)
    local b = Instance.new("TextButton", SettingsPage)
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.Text = name
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

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
                -- Non usiamo GetDescendants! Cambiamo solo la proprietà Enabled.
                -- Questo è l'unico modo sicuro per non far apparire GUI morte.
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


-- RESET ALL GUI (TAP)
local ResetBtn = CreateSetBtn("FORCE RESET GUI (TAP)")
ResetBtn.MouseButton1Click:Connect(function()
    ResetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70) -- Lampeggia verde
    
    A.HideEverything = false
    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    
    if pGui then
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
                -- Spegniamo e riaccendiamo per forzare il refresh originale
                gui.Enabled = false
                gui.Enabled = true
            end
        end
    end
    
    -- Ripristina i nomi (Hidden Names Reset)
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Humanoid") then
            v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
    
    -- Ripristina Roblox Core
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
