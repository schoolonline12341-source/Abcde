repeat task.wait() until _G.SliderBack and _G.SliderLabel and _G.SliderFill and _G.MainUIList and _G.MainPage
local A = _G.A
local UIS = game:GetService("UserInputService")
local function UpdateFOV(input)
    local percent = math.clamp((input.Position.X - _G.SliderBack.AbsolutePosition.X) / _G.SliderBack.AbsoluteSize.X, 0, 1)
    _G.SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    A.TargetFOV = math.floor(30 + (percent * 90))
    _G.SliderLabel.Text = "FOV: " .. A.TargetFOV
end
local isSliding = false
_G.SliderBack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
        UpdateFOV(i)
    end
end)
UIS.InputChanged:Connect(function(i)
    if isSliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        UpdateFOV(i)
    end
end)
UIS.InputEnded:Connect(function() isSliding = false end)
task.defer(function()
    _G.MainPage.CanvasSize = UDim2.new(0, 0, 0, _G.MainUIList.AbsoluteContentSize.Y)
    _G.MainUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        _G.MainPage.CanvasSize = UDim2.new(0, 0, 0, _G.MainUIList.AbsoluteContentSize.Y)
    end)
end)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/schoolonline12341-source/Abcde/main/P2Tab1Main.lua"))()
end)
