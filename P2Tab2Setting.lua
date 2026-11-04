-- P2Tab2Setting.lua
local A = _G.A
local SettingsPage = _G.SettingsPage
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local CreateSetBtn = A.UI.CreateSetBtn
local CreateTitle = A.UI.CreateTitle

-- Floating Mini Button for Mobile Users when UI is hidden
local FloatBtn = Instance.new("TextButton", _G.ScreenGui)
FloatBtn.Size = UDim2.new(0, 42, 0, 42)
FloatBtn.Position = UDim2.new(0, 15, 0.5, -21)
FloatBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatBtn.BackgroundTransparency = 0.25
FloatBtn.Text = "FC"
FloatBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 12
FloatBtn.Visible = UIS.TouchEnabled
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
local floatStroke = Instance.new("UIStroke", FloatBtn)
floatStroke.Color = Color3.fromRGB(0, 170, 255)
floatStroke.Thickness = 1.5

FloatBtn.MouseButton1Click:Connect(function()
	_G.MainFrame.Visible = not _G.MainFrame.Visible
end)

local HideAllBtn = CreateSetBtn("HIDE GAME UI: OFF")
HideAllBtn.MouseButton1Click:Connect(function()
	A.HideEverything = not A.HideEverything
	local pGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
	if pGui then
		for _, gui in pairs(pGui:GetChildren()) do
			if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
				gui.Enabled = not A.HideEverything
			end
		end
	end
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, not A.HideEverything)
	end)
	HideAllBtn.Text = A.HideEverything and "HIDE GAME UI: ON" or "HIDE GAME UI: OFF"
	HideAllBtn.BackgroundColor3 = A.HideEverything and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

CreateTitle("SYSTEM SETTINGS")

local FloatToggleBtn = CreateSetBtn("FLOATING BUTTON: " .. (FloatBtn.Visible and "ON" or "OFF"))
FloatToggleBtn.BackgroundColor3 = FloatBtn.Visible and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
FloatToggleBtn.MouseButton1Click:Connect(function()
	FloatBtn.Visible = not FloatBtn.Visible
	FloatToggleBtn.Text = FloatBtn.Visible and "FLOATING BUTTON: ON" or "FLOATING BUTTON: OFF"
	FloatToggleBtn.BackgroundColor3 = FloatBtn.Visible and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

local ResetBtn = CreateSetBtn("FORCE RESET GUI (TAP)")
ResetBtn.MouseButton1Click:Connect(function()
	ResetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
	A.HideEverything = false
	HideAllBtn.Text = "HIDE GAME UI: OFF"
	HideAllBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	local pGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
	if pGui then
		for _, gui in pairs(pGui:GetChildren()) do
			if gui:IsA("ScreenGui") and gui ~= _G.ScreenGui then
				gui.Enabled = false
				gui.Enabled = true
			end
		end
	end
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
	end)
	task.wait(0.2)
	ResetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

local ToggleKeyBtn = CreateSetBtn("UI TOGGLE KEY: " .. A.ToggleKey.Name)
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

task.defer(function()
	SettingsPage.CanvasSize = UDim2.new(0, 0, 0, _G.SettingsUIList.AbsoluteContentSize.Y + 12)
	_G.SettingsUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SettingsPage.CanvasSize = UDim2.new(0, 0, 0, _G.SettingsUIList.AbsoluteContentSize.Y + 12)
	end)
end)
