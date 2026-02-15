_G.A = _G.A or {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

_G.A.Enabled = false
_G.A.Speed = 1
_G.A.Rot = Vector2.new(0, 0)
_G.A.StartPos = nil
_G.A.CurrentMovePos = nil
_G.A.CurrentMoveVec = Vector2.new(0, 0)
_G.A.TargetFOV = 70

function _G.A.TeleportToGround(targetPos)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char, Cam}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		local res = workspace:Raycast(targetPos, Vector3.new(0, -500, 0), rayParams)
		if res then
			hrp.CFrame = CFrame.new(res.Position + Vector3.new(0, 3.5, 0))
		else
			hrp.CFrame = CFrame.new(targetPos)
		end
	end
end

function _G.A.Reset(toggleBtn)
	_G.A.Enabled = false
	if toggleBtn then
		toggleBtn.Text = "STATUS: OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
	Cam.CameraType = Enum.CameraType.Custom
	Cam.FieldOfView = 70
	if LP.Character then
		local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.Anchored = false end
	end
end

function _G.A.UpdateCamera(dt)
	if not _G.A.Enabled then return end
	Cam.CameraType = Enum.CameraType.Scriptable
	if _G.A.StartPos and _G.A.CurrentMovePos then
		local diff = _G.A.CurrentMovePos - _G.A.StartPos
		if diff.Magnitude > 2 then
			_G.A.CurrentMoveVec = diff.Unit * (math.min(diff.Magnitude, 60) / 60)
		end
	end
	local cf = Cam.CFrame
	local dir = (cf.LookVector * -_G.A.CurrentMoveVec.Y) + (cf.RightVector * _G.A.CurrentMoveVec.X)
	Cam.CFrame = CFrame.new(cf.Position + (dir * (_G.A.Speed * dt * 60))) * CFrame.fromEulerAnglesYXZ(_G.A.Rot.X, _G.A.Rot.Y, 0)
	Cam.FieldOfView = _G.A.TargetFOV
end

local Parent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LP:WaitForChild("PlayerGui")
local function CleanUp()
	local old = Parent:FindFirstChild("Freecam_AcelestuZ_V0.5")
	if old then old:Destroy() end
end
CleanUp()

_G.ScreenGui = Instance.new("ScreenGui", Parent)
_G.ScreenGui.Name = "Freecam_AcelestuZ_V0.5"
_G.ScreenGui.IgnoreGuiInset = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2MainLoad.lua"))()
