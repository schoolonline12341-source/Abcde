-- P1MainLoad.lua
_G.A = _G.A or {}
local A = _G.A

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Clean up previous execution before re-initializing
if A.CleanUp then
	pcall(A.CleanUp)
end

A.Connections = {}
A.UI = {}
A.Enabled = false
A.Speed = 1
A.Smoothness = 12
A.Rot = Vector2.new(0, 0)
A.Velocity = Vector3.new(0, 0, 0)
A.StartPos = nil
A.CurrentMovePos = nil
A.CurrentMoveVec = Vector2.new(0, 0)
A.VerticalMove = 0
A.TargetFOV = 70
A.DefaultFOV = Cam and Cam.FieldOfView or 70
A.ToggleKey = A.ToggleKey or Enum.KeyCode.H
A.Running = true

-- Save original Lighting properties once so toggles restore accurately
if not A.OrigLighting then
	A.OrigLighting = {
		Brightness = Lighting.Brightness,
		GlobalShadows = Lighting.GlobalShadows,
		FogEnd = Lighting.FogEnd,
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient
	}
end

function A.Bind(signal, callback)
	local conn = signal:Connect(callback)
	table.insert(A.Connections, conn)
	return conn
end

function A.TeleportToGround(targetPos)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char, Cam}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		local res = workspace:Raycast(targetPos, Vector3.new(0, -500, 0), rayParams)
		local rot = hrp.CFrame - hrp.CFrame.Position
		if res then
			hrp.CFrame = CFrame.new(res.Position + Vector3.new(0, 3.5, 0)) * rot
		else
			hrp.CFrame = CFrame.new(targetPos) * rot
		end
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end
end

function A.Reset(toggleBtn)
	A.Enabled = false
	A.StartPos = nil
	A.CurrentMovePos = nil
	A.CurrentMoveVec = Vector2.new(0, 0)
	A.VerticalMove = 0
	A.Velocity = Vector3.new(0, 0, 0)

	if UIS.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition then
		UIS.MouseBehavior = Enum.MouseBehavior.Default
	end

	if toggleBtn then
		toggleBtn.Text = "STATUS: OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end

	if _G.MovePad then _G.MovePad.Visible = false end
	if _G.VertPad then _G.VertPad.Visible = false end

	Cam = workspace.CurrentCamera
	if Cam then
		Cam.CameraType = Enum.CameraType.Custom
		Cam.FieldOfView = A.DefaultFOV or 70
	end

	if LP.Character then
		local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.Anchored = false end
		local animate = LP.Character:FindFirstChild("Animate")
		if animate then animate.Enabled = true end
	end
end

local function GetPCMoveVector()
	if UIS:GetFocusedTextBox() then
		return Vector3.new(0, 0, 0), 1
	end
	local x, y, z = 0, 0, 0
	if UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.Right) then x = x + 1 end
	if UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.Left) then x = x - 1 end
	if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up) then z = z + 1 end
	if UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.Down) then z = z - 1 end
	if UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space) then y = y + 1 end
	if UIS:IsKeyDown(Enum.KeyCode.Q) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then y = y - 1 end

	local boost = (UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)) and 2.5 or 1
	return Vector3.new(x, y, z), boost
end

function A.UpdateCamera(dt)
	if not A.Enabled then return end
	Cam = workspace.CurrentCamera
	if not Cam then return end

	Cam.CameraType = Enum.CameraType.Scriptable

	-- Mobile thumbstick calculation
	if A.StartPos and A.CurrentMovePos then
		local diff = A.CurrentMovePos - A.StartPos
		if diff.Magnitude > 2 then
			A.CurrentMoveVec = diff.Unit * (math.min(diff.Magnitude, 60) / 60)
		else
			A.CurrentMoveVec = Vector2.new(0, 0)
		end
	else
		A.CurrentMoveVec = Vector2.new(0, 0)
	end

	-- Combine PC Keyboard and Mobile Touch inputs
	local pcVec, boost = GetPCMoveVector()
	local moveX = math.clamp(pcVec.X + A.CurrentMoveVec.X, -1, 1)
	local moveZ = math.clamp(pcVec.Z - A.CurrentMoveVec.Y, -1, 1)
	local moveY = math.clamp(pcVec.Y + A.VerticalMove, -1, 1)

	local targetInput = Vector3.new(moveX, moveY, moveZ)
	if targetInput.Magnitude > 1 then
		targetInput = targetInput.Unit
	end

	-- Smooth velocity interpolation
	local alpha = math.clamp(dt * (A.Smoothness or 12), 0, 1)
	A.Velocity = A.Velocity:Lerp(targetInput * boost, alpha)

	-- Clamp vertical pitch so camera never flips upside down
	local pitch = math.clamp(A.Rot.X, -math.rad(89), math.rad(89))
	A.Rot = Vector2.new(pitch, A.Rot.Y)

	local rotCFrame = CFrame.fromEulerAnglesYXZ(A.Rot.X, A.Rot.Y, 0)
	local cf = Cam.CFrame
	local moveDir = (rotCFrame.LookVector * A.Velocity.Z)
		+ (rotCFrame.RightVector * A.Velocity.X)
		+ (Vector3.new(0, 1, 0) * A.Velocity.Y)

	local newPos = cf.Position + (moveDir * (A.Speed * dt * 60))
	Cam.CFrame = CFrame.new(newPos) * rotCFrame
	Cam.FieldOfView = A.TargetFOV
end

local Parent = (game:GetService("CoreGui"):FindFirstChild("RobloxGui")) or LP:WaitForChild("PlayerGui")

function A.CleanUp()
	A.Running = false
	for _, conn in ipairs(A.Connections or {}) do
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
	A.Connections = {}

	if A.IdleTrack then
		pcall(function() A.IdleTrack:Stop() end)
		A.IdleTrack = nil
	end

	A.Reset()

	local old = Parent:FindFirstChild("Freecam_AcelestuZ_V0.5")
	if old then old:Destroy() end
end

_G.ScreenGui = Instance.new("ScreenGui", Parent)
_G.ScreenGui.Name = "Freecam_AcelestuZ_V0.5"
_G.ScreenGui.IgnoreGuiInset = true
_G.ScreenGui.ResetOnSpawn = false

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2MainLoad.lua"))()
