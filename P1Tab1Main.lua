-- P1Tab1Main.lua
_G.A = _G.A or {}
local A = _G.A

local TopBar = _G.TopBar
local MainFrame = _G.MainFrame
local MainPage = _G.MainPage
local UIS = game:GetService("UserInputService")

_G.MinBtn = Instance.new("TextButton", TopBar)
local MinBtn = _G.MinBtn
MinBtn.Size = UDim2.new(0, 45, 0, 25)
MinBtn.Position = UDim2.new(1, -75, 0.5, -12)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "OPEN"
MinBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 10

_G.CloseBtn = Instance.new("TextButton", TopBar)
local CloseBtn = _G.CloseBtn
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local UIList = Instance.new("UIListLayout", MainPage)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
_G.MainUIList = UIList

local mainOrder = 0
local function NextMainOrder()
	mainOrder = mainOrder + 1
	return mainOrder
end
A.UI.NextMainOrder = NextMainOrder

function CreateBtn(name, orderOverride)
	local b = Instance.new("TextButton", MainPage)
	b.LayoutOrder = orderOverride or NextMainOrder()
	b.Size = UDim2.new(0.9, 0, 0, 32)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.Text = name
	b.TextSize = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end
A.UI.CreateBtn = CreateBtn

local function CreateSlider(titlePrefix, minVal, maxVal, defaultVal, layoutOrder, onChanged)
	local container = Instance.new("Frame", MainPage)
	container.LayoutOrder = layoutOrder or NextMainOrder()
	container.Size = UDim2.new(0.9, 0, 0, 42)
	container.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, 0, 0, 15)
	label.Text = titlePrefix .. ": " .. tostring(defaultVal)
	label.TextColor3 = Color3.fromRGB(170, 170, 170)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 10
	label.BackgroundTransparency = 1

	local sliderBack = Instance.new("Frame", container)
	sliderBack.Size = UDim2.new(1, 0, 0, 16)
	sliderBack.Position = UDim2.new(0, 0, 0, 20)
	sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	sliderBack.BackgroundTransparency = 0.4
	sliderBack.Active = true
	Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1, 0)

	local sliderVisual = Instance.new("Frame", sliderBack)
	sliderVisual.Size = UDim2.new(1, -8, 0, 6)
	sliderVisual.Position = UDim2.new(0, 4, 0.5, -3)
	sliderVisual.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sliderVisual.ZIndex = 2
	Instance.new("UICorner", sliderVisual).CornerRadius = UDim.new(1, 0)

	local initPercent = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
	local sliderFill = Instance.new("Frame", sliderVisual)
	sliderFill.Size = UDim2.new(initPercent, 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	sliderFill.ZIndex = 3
	Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

	local activeSliderInput = nil

	local function UpdateFromInput(input)
		local percent = math.clamp((input.Position.X - sliderVisual.AbsolutePosition.X) / sliderVisual.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(percent, 0, 1, 0)
		local val = math.floor(minVal + (percent * (maxVal - minVal)))
		label.Text = titlePrefix .. ": " .. tostring(val)
		onChanged(val)
	end

	sliderBack.InputBegan:Connect(function(i)
		if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not activeSliderInput then
			activeSliderInput = i
			UpdateFromInput(i)
		end
	end)

	A.Bind(UIS.InputChanged, function(i)
		if activeSliderInput and (i == activeSliderInput or (i.UserInputType == Enum.UserInputType.MouseMovement and activeSliderInput.UserInputType == Enum.UserInputType.MouseButton1)) then
			UpdateFromInput(i)
		end
	end)

	A.Bind(UIS.InputEnded, function(i)
		if i == activeSliderInput then
			activeSliderInput = nil
		end
	end)
end

CreateSlider("FOV", 20, 120, 70, 10, function(val)
	A.TargetFOV = val
end)

CreateSlider("SMOOTHNESS", 2, 25, 12, 11, function(val)
	A.Smoothness = val
end)

task.defer(function()
	MainPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 12)
	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		MainPage.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 12)
	end)
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2Tab1Main.lua"))()
