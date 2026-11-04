-- P2Tab1Main.lua
local A = _G.A
repeat task.wait() until _G.TopBar and _G.MainFrame and _G.MainPage and A.UI and A.UI.CreateBtn

local TopBar = _G.TopBar
local MainFrame = _G.MainFrame
local TabContainer = _G.TabContainer
local MainPage = _G.MainPage
local Cam = workspace.CurrentCamera
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

local Controls = nil
pcall(function()
	Controls = require(LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
end)

local MinBtn = _G.MinBtn
local CloseBtn = _G.CloseBtn
local CreateBtn = A.UI.CreateBtn

local ToggleBtn = CreateBtn("STATUS: OFF", 1)
local SpeedBtn = CreateBtn("SPEED: 1x", 2)
local TPBtn = CreateBtn("TELEPORT HERE", 3)

local ControlsHint = Instance.new("TextLabel", MainPage)
ControlsHint.LayoutOrder = 20
ControlsHint.Size = UDim2.new(0.9, 0, 0, 32)
ControlsHint.BackgroundTransparency = 1
ControlsHint.Text = "PC: WASD + E/Q + RightClick | Mobile: Dual Touch"
ControlsHint.Font = Enum.Font.Gotham
ControlsHint.TextSize = 9
ControlsHint.TextWrapped = true
ControlsHint.TextColor3 = Color3.fromRGB(140, 140, 140)

local CreditsLabel = Instance.new("TextLabel", MainPage)
CreditsLabel.LayoutOrder = 21
CreditsLabel.Size = UDim2.new(0.9, 0, 0, 20)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "made by AcelestuZ"
CreditsLabel.Font = Enum.Font.GothamMedium
CreditsLabel.TextSize = 10
CreditsLabel.TextColor3 = Color3.fromRGB(120, 120, 120)

local IsOpen = false

MinBtn.MouseButton1Click:Connect(function()
	IsOpen = not IsOpen
	MinBtn.Text = IsOpen and "HIDE" or "OPEN"
	MainFrame:TweenSize(
		IsOpen and UDim2.new(0, 260, 0, 290) or UDim2.new(0, 260, 0, 35),
		"Out", "Back", 0.3, true
	)
	TabContainer.Visible = IsOpen
end)

CloseBtn.MouseButton1Click:Connect(function()
	if Controls then pcall(function() Controls:Enable() end) end
	if A.CleanUp then A.CleanUp() end
end)

ToggleBtn.MouseButton1Click:Connect(function()
	A.Enabled = not A.Enabled
	ToggleBtn.Text = A.Enabled and "STATUS: ON" or "STATUS: OFF"
	ToggleBtn.BackgroundColor3 = A.Enabled and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)

	local isTouchDevice = UIS.TouchEnabled
	_G.MovePad.Visible = A.Enabled and isTouchDevice
	if _G.VertPad then _G.VertPad.Visible = A.Enabled and isTouchDevice end

	if A.Enabled then
		Cam = workspace.CurrentCamera
		A.DefaultFOV = Cam.FieldOfView
		local x, y, _ = Cam.CFrame:ToEulerAnglesYXZ()
		A.Rot = Vector2.new(x, y)
		if Controls then pcall(function() Controls:Disable() end) end

		if LP.Character then
			local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				local animator = humanoid:FindFirstChildOfClass("Animator")
				if animator then
					for _, track in pairs(animator:GetPlayingAnimationTracks()) do
						track:Stop()
					end
					local animate = LP.Character:FindFirstChild("Animate")
					if animate then
						animate.Enabled = false
						local idleTarget = animate:FindFirstChild("idle")
						local idleAnim = idleTarget and idleTarget:FindFirstChildOfClass("Animation")
						if idleAnim then
							A.IdleTrack = animator:LoadAnimation(idleAnim)
						end
					end
					if not A.IdleTrack then
						local fallbackIdle = Instance.new("Animation")
						fallbackIdle.AnimationId = humanoid.RigType == Enum.HumanoidRigType.R15
							and "rbxassetid://507766388" or "rbxassetid://180435571"
						A.IdleTrack = animator:LoadAnimation(fallbackIdle)
					end
					if A.IdleTrack then
						A.IdleTrack.Looped = true
						A.IdleTrack:Play()
					end
				end
			end

			task.spawn(function()
				local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
				local hum = LP.Character:FindFirstChildOfClass("Humanoid")
				if hrp and hum then
					hrp.Anchored = false
					if hum.FloorMaterial == Enum.FloorMaterial.Air and hum:GetState() ~= Enum.HumanoidStateType.Swimming then
						hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
						while hum.FloorMaterial == Enum.FloorMaterial.Air and A.Enabled and LP.Character and LP.Character:IsDescendantOf(workspace) do
							task.wait()
						end
					end
					if A.Enabled and LP.Character and LP.Character:IsDescendantOf(workspace) then
						A.TeleportToGround(hrp.Position)
						hrp.Anchored = true
					end
				end
			end)
		end
	else
		if A.IdleTrack then
			A.IdleTrack:Stop()
			A.IdleTrack = nil
		end
		if Controls then pcall(function() Controls:Enable() end) end
		A.Reset(ToggleBtn)
	end
end)

SpeedBtn.MouseButton1Click:Connect(function()
	local s = {0.25, 0.5, 1, 2, 5, 10, 20}
	local i = table.find(s, A.Speed) or 3
	A.Speed = s[i % #s + 1]
	SpeedBtn.Text = "SPEED: " .. A.Speed .. "x"
end)

TPBtn.MouseButton1Click:Connect(function()
	Cam = workspace.CurrentCamera
	if LP.Character and Cam then
		A.TeleportToGround(Cam.CFrame.Position)
	end
end)

-- Mobile Vertical UP / DOWN Buttons
if _G.UpBtn and _G.DownBtn then
	_G.UpBtn.InputBegan:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.Touch or io.UserInputType == Enum.UserInputType.MouseButton1 then
			A.VerticalMove = 1
		end
	end)
	_G.UpBtn.InputEnded:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.Touch or io.UserInputType == Enum.UserInputType.MouseButton1 then
			if A.VerticalMove > 0 then A.VerticalMove = 0 end
		end
	end)
	_G.DownBtn.InputBegan:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.Touch or io.UserInputType == Enum.UserInputType.MouseButton1 then
			A.VerticalMove = -1
		end
	end)
	_G.DownBtn.InputEnded:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.Touch or io.UserInputType == Enum.UserInputType.MouseButton1 then
			if A.VerticalMove < 0 then A.VerticalMove = 0 end
		end
	end)
end

-- Dedicated Multi-Touch & PC Mouse Camera/Movement Handling
local moveTouchObj = nil
local lookTouchObj = nil
local isRightMouseLooking = false

_G.MovePad.InputBegan:Connect(function(io)
	if io.UserInputType == Enum.UserInputType.Touch and not moveTouchObj then
		moveTouchObj = io
		A.StartPos = Vector2.new(io.Position.X, io.Position.Y)
		A.CurrentMovePos = A.StartPos

		if _G.JoystickOuter and _G.JoystickKnob then
			_G.JoystickOuter.Position = UDim2.new(0, io.Position.X, 0, io.Position.Y)
			_G.JoystickKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
			_G.JoystickOuter.Visible = true
		end
	end
end)

A.Bind(UIS.InputBegan, function(io, gpe)
	if not A.Enabled or gpe then return end
	if io.UserInputType == Enum.UserInputType.MouseButton2 then
		isRightMouseLooking = true
		UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
	elseif io.UserInputType == Enum.UserInputType.Touch and io ~= moveTouchObj and not lookTouchObj then
		Cam = workspace.CurrentCamera
		if Cam and io.Position.X >= Cam.ViewportSize.X * 0.45 then
			lookTouchObj = io
		end
	end
end)

A.Bind(UIS.InputChanged, function(io, gpe)
	if not A.Enabled then return end

	-- Mobile Left Thumbstick Drag
	if io == moveTouchObj then
		A.CurrentMovePos = Vector2.new(io.Position.X, io.Position.Y)
		if _G.JoystickKnob and A.StartPos then
			local diff = A.CurrentMovePos - A.StartPos
			local clamped = diff.Magnitude > 45 and (diff.Unit * 45) or diff
			_G.JoystickKnob.Position = UDim2.new(0.5, clamped.X, 0.5, clamped.Y)
		end
		return
	end

	-- Mobile Right Screen Camera Rotation
	if io == lookTouchObj then
		A.Rot = A.Rot + Vector2.new(-io.Delta.Y * 0.005, -io.Delta.X * 0.005)
		return
	end

	-- PC Right-Click Mouse Camera Rotation
	if isRightMouseLooking and io.UserInputType == Enum.UserInputType.MouseMovement then
		A.Rot = A.Rot + Vector2.new(-io.Delta.Y * 0.004, -io.Delta.X * 0.004)
	end
end)

A.Bind(UIS.InputEnded, function(io)
	if io == moveTouchObj then
		moveTouchObj = nil
		A.StartPos = nil
		A.CurrentMovePos = nil
		A.CurrentMoveVec = Vector2.new(0, 0)
		if _G.JoystickOuter then _G.JoystickOuter.Visible = false end
	elseif io == lookTouchObj then
		lookTouchObj = nil
	elseif io.UserInputType == Enum.UserInputType.MouseButton2 then
		isRightMouseLooking = false
		UIS.MouseBehavior = Enum.MouseBehavior.Default
	end
end)
