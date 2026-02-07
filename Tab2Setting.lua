local A = _G.A
local SettingsPage = _G.SettingsPage

local UIList = Instance.new("UIListLayout", SettingsPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

local function CreateBtn(name)
	local b = Instance.new("TextButton", SettingsPage)
	b.Size = UDim2.new(0.88, 0, 0, 30)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamSemibold
	b.Text = name
	b.TextSize = 10
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

-- 1) info mode button
local InfoBtn = CreateBtn("INFO MODE: OFF")

-- 1) info mode logic
InfoBtn.MouseButton1Click:Connect(function()
    A.InfoMode = not A.InfoMode
    InfoBtn.Text = A.InfoMode and "INFO MODE: ON" or "INFO MODE: OFF"
    InfoBtn.BackgroundColor3 = A.InfoMode and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
    
    -- Cerca tutte le icone info e le attiva/disattiva
    for _, v in pairs(_G.ScreenGui:GetDescendants()) do
        if v.Name == "InfoIcon" then
            v.Visible = A.InfoMode
        end
    end
end)

-- 2) reset button
local ResetBtn = CreateBtn("RESET GUI POSITION")
ResetBtn.MouseButton1Click:Connect(function()
    _G.MainFrame.Position = UDim2.new(0.5, -80, 0.15, 0)
end)

