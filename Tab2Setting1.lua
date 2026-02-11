local A = _G.A
local MainFrame = _G.MainFrame
local SettingsPage = _G.SettingsPage
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local UIList = Instance.new("UIListLayout", SettingsPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local order = 0
local function NextOrder()
    order = order + 1
    return order
end

local function CreateTitle(text)
    local t = Instance.new("TextLabel", SettingsPage)
    t.LayoutOrder = NextOrder()
    t.Size = UDim2.new(0.9, 0, 0, 25)
    t.BackgroundTransparency = 1
    t.Text = "-- " .. text .. " --"
    t.TextColor3 = Color3.fromRGB(180, 180, 180)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 10
    return t
end

local function CreateSetBtn(name)
    local b = Instance.new("TextButton", SettingsPage)
    b.LayoutOrder = NextOrder()
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.Text = name
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function GetDOF()
    local dof = Lighting:FindFirstChild("FreecamDOF")
    if not dof then
        dof = Instance.new("DepthOfFieldEffect")
        dof.Name = "FreecamDOF"
        dof.Parent = Lighting
        dof.Enabled = false
        dof.FocusDistance = 10
        dof.InFocusRadius = 10
        dof.NearIntensity = 0.3
        dof.FarIntensity = 0.5
    end
    return dof
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
    local dof = GetDOF()
    dof.Enabled = not dof.Enabled

    DOFBtn.Text = dof.Enabled and "DEPTH OF FIELD: ON" or "DEPTH OF FIELD: OFF"
    DOFBtn.BackgroundColor3 = dof.Enabled and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

local DOFSliderContainer = Instance.new("Frame", SettingsPage)
DOFSliderContainer.LayoutOrder = NextOrder()
DOFSliderContainer.Size = UDim2.new(0.9, 0, 0, 40)
DOFSliderContainer.BackgroundTransparency = 1

local DOFLabel = Instance.new("TextLabel", DOFSliderContainer)
DOFLabel.Size = UDim2.new(1, 0, 0, 15)
DOFLabel.Text = "DOF FOCUS DISTANCE: 10"
DOFLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
DOFLabel.Font = Enum.Font.Gotham
DOFLabel.TextSize = 9
DOFLabel.BackgroundTransparency = 1

local DOFBack = Instance.new("Frame", DOFSliderContainer)
DOFBack.Size = UDim2.new(1, 0, 0, 14)
DOFBack.Position = UDim2.new(0, 0, 0, 20)
DOFBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DOFBack.BackgroundTransparency = 0.6
DOFBack.Active = true
Instance.new("UICorner", DOFBack)

local DOFVisual = Instance.new("Frame", DOFBack)
DOFVisual.Size = UDim2.new(1, 0, 0, 4)
DOFVisual.Position = UDim2.new(0, 0, 0.5, -2)
DOFVisual.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DOFVisual.ZIndex = 2
Instance.new("UICorner", DOFVisual)

local DOFFill = Instance.new("Frame", DOFVisual)
DOFFill.Size = UDim2.new(0.1, 0, 1, 0)
DOFFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
DOFFill.ZIndex = 3
Instance.new("UICorner", DOFFill)

local function UpdateDOF(input)
    local dof = GetDOF()
    dof.Enabled = true

    local percent = math.clamp((input.Position.X - DOFBack.AbsolutePosition.X) / DOFBack.AbsoluteSize.X, 0, 1)
    DOFFill.Size = UDim2.new(percent, 0, 1, 0)

    local focus = math.floor(5 + (percent * 195)) -- 5 → 200
    dof.FocusDistance = focus

    DOFLabel.Text = "DOF FOCUS DISTANCE: " .. focus
end

local slidingDOF = false
DOFBack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        slidingDOF = true
        UpdateDOF(i)
    end
end)

UIS.InputChanged:Connect(function(i)
    if slidingDOF and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        UpdateDOF(i)
    end
end)

UIS.InputEnded:Connect(function()
    slidingDOF = false
end)

CreateTitle("INTERFACE & STEALTH")

local NamesBtn = CreateSetBtn("HIDDEN NAMES: OFF")
NamesBtn.MouseButton1Click:Connect(function()
    A.HideNames = not A.HideNames
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Humanoid") then
            v.Character.Humanoid.DisplayDistanceType =
                A.HideNames and Enum.HumanoidDisplayDistanceType.None
                or Enum.HumanoidDisplayDistanceType.Viewer
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

SettingsPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end)
