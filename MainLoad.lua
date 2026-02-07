_G.A = {}
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

_G.MovePad = Instance.new("Frame", _G.ScreenGui)
_G.MovePad.Size = UDim2.new(0.45, 0, 1, 0)
_G.MovePad.BackgroundTransparency = 1
_G.MovePad.Visible = false

_G.MainFrame = Instance.new("Frame", _G.ScreenGui)
_G.MainFrame.Size = UDim2.new(0, 160, 0, 35)
_G.MainFrame.Position = UDim2.new(0.5, -80, 0.15, 0)
_G.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_G.MainFrame.BorderSizePixel = 0
_G.MainFrame.ClipsDescendants = true
_G.MainFrame.Active = true
Instance.new("UICorner", _G.MainFrame).CornerRadius = UDim.new(0, 10)

local NeonStroke = Instance.new("UIStroke", _G.MainFrame)
NeonStroke.Thickness = 2
local NeonGradient = Instance.new("UIGradient", NeonStroke)
NeonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})

task.spawn(function()
	local rot = 0
	while task.wait() do rot = rot + 2 NeonGradient.Rotation = rot % 360 end
end)

_G.TopBar = Instance.new("Frame", _G.MainFrame)
_G.TopBar.Size = UDim2.new(1, 0, 0, 35)
_G.TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", _G.TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "FREECAM"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Logica Drag migliorata (Solo sulla TopBar)
local dragging, dragStart, startPos
_G.TopBar.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not _G.A.Enabled then
        dragging = true
        dragStart = input.Position
        startPos = _G.MainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        _G.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function() dragging = false end)

-- ATTIVAZIONE TELECAMERA (Metti questa come ultima riga)
game:GetService("RunService").RenderStepped:Connect(function(dt)
    if _G.A and _G.A.UpdateCamera then
        _G.A.UpdateCamera(dt)
    end
end)


loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/Tab1Main.lua"))()
