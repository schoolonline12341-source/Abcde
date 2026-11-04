-- P1Tab2Setting.lua
_G.A = _G.A or {}
local A = _G.A
local SettingsPage = _G.SettingsPage
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

_G.SettingsUIList = Instance.new("UIListLayout", SettingsPage)
_G.SettingsUIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
_G.SettingsUIList.Padding = UDim.new(0, 8)
_G.SettingsUIList.SortOrder = Enum.SortOrder.LayoutOrder

local order = 0
local function NextOrder()
	order = order + 1
	return order
end
A.UI.NextSetOrder = NextOrder

function CreateTitle(text)
	local t = Instance.new("TextLabel", SettingsPage)
	t.LayoutOrder = NextOrder()
	t.Size = UDim2.new(0.9, 0, 0, 24)
	t.BackgroundTransparency = 1
	t.Text = "-- " .. text .. " --"
	t.TextColor3 = Color3.fromRGB(180, 180, 180)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 10
	return t
end
A.UI.CreateTitle = CreateTitle

function CreateSetBtn(name)
	local b = Instance.new("TextButton", SettingsPage)
	b.LayoutOrder = NextOrder()
	b.Size = UDim2.new(0.9, 0, 0, 30)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamSemibold
	b.Text = name
	b.TextSize = 10
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end
A.UI.CreateSetBtn = CreateSetBtn

CreateTitle("VISUAL & RENDERING")

local FullBrightBtn = CreateSetBtn("FULL BRIGHT: OFF")
FullBrightBtn.MouseButton1Click:Connect(function()
	A.FullBright = not A.FullBright
	if A.FullBright then
		Lighting.Brightness = 3
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(178, 178, 178)
		Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
	else
		Lighting.Brightness = A.OrigLighting.Brightness
		Lighting.GlobalShadows = A.OrigLighting.GlobalShadows
		Lighting.Ambient = A.OrigLighting.Ambient
		Lighting.OutdoorAmbient = A.OrigLighting.OutdoorAmbient
	end
	FullBrightBtn.Text = A.FullBright and "FULL BRIGHT: ON" or "FULL BRIGHT: OFF"
	FullBrightBtn.BackgroundColor3 = A.FullBright and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

local NoFogBtn = CreateSetBtn("NO FOG: OFF")
NoFogBtn.MouseButton1Click:Connect(function()
	A.NoFog = not A.NoFog
	Lighting.FogEnd = A.NoFog and 100000 or A.OrigLighting.FogEnd
	NoFogBtn.Text = A.NoFog and "NO FOG: ON" or "NO FOG: OFF"
	NoFogBtn.BackgroundColor3 = A.NoFog and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

CreateTitle("INTERFACE & STEALTH")

local NamesBtn = CreateSetBtn("HIDDEN NAMES: OFF")
NamesBtn.MouseButton1Click:Connect(function()
	A.HideNames = not A.HideNames
	for _, v in pairs(Players:GetPlayers()) do
		if v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
			v.Character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = A.HideNames
				and Enum.HumanoidDisplayDistanceType.None
				or Enum.HumanoidDisplayDistanceType.Viewer
		end
	end
	NamesBtn.Text = A.HideNames and "HIDDEN NAMES: ON" or "HIDDEN NAMES: OFF"
	NamesBtn.BackgroundColor3 = A.HideNames and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2Tab2Setting.lua"))()
