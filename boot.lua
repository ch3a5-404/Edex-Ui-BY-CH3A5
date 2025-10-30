repeat task.wait() until game:IsLoaded()
wait(5)--[[
  🔧 Chea Cheat Blox Tool UI
  Author: ChatGPT
  V3 - Hacker Tech Style
  Features:
  - Moon toggle
  - Animated menu
  - Scrollable options
  - Glow outline
  - Draggable UI
]]--

local PLAYER_NAME = "bj5jhgg"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CheaCheatTechUI"
gui.ResetOnSpawn = false

-- 🎨 Colors
local COLORS = {
	bg = Color3.fromHex("#0A0A0A"),
	accent = Color3.fromHex("#00AEEF"),
	accent2 = Color3.fromHex("#FFAA00"),
	textMain = Color3.fromHex("#F5F5F5"),
	textSub = Color3.fromHex("#B0B0B0"),
	border = Color3.fromHex("#303030"),
	success = Color3.fromHex("#00FF88"),
	warning = Color3.fromHex("#FF4444"),
}

-- 🖱️ Make draggable
local function makeDraggable(obj, dragHandle)
	local dragging, dragInput, startPos, startInputPos
	dragHandle = dragHandle or obj
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInputPos = input.Position
			startPos = obj.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - startInputPos
			obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- 🌙 Moon Toggle Button
local moon = Instance.new("ImageButton")
moon.Size = UDim2.new(0, 50, 0, 50)
moon.Position = UDim2.new(0, 30, 0, 100)
moon.BackgroundTransparency = 1
moon.Image = "rbxassetid://6031075937"
moon.ImageColor3 = COLORS.accent
moon.Parent = gui
makeDraggable(moon)

-- 🪟 Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 400, 0, 320)
menu.Position = UDim2.new(0, 90, 0, 100)
menu.BackgroundColor3 = COLORS.bg
menu.Visible = true
menu.Parent = gui
makeDraggable(menu)

-- Corners + Glow
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local glow = Instance.new("UIStroke", menu)
glow.Color = COLORS.accent
glow.Thickness = 2
glow.Transparency = 0.3

-- Title
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.MontserratBold
title.Text = "Blox Tool Hub - Chea Cheat"
title.TextColor3 = COLORS.textMain
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- Scroll container
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper functions
local function createButton(text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = color or COLORS.accent
	btn.TextColor3 = COLORS.textMain
	btn.TextSize = 16
	btn.Font = Enum.Font.RobotoMedium
	btn.Text = text
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = COLORS.border
	stroke.Thickness = 1
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.accent2}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or COLORS.accent}):Play()
	end)
	return btn
end

local function createSection(name)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 24)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.MontserratSemiBold
	lbl.Text = "⚙️ " .. name
	lbl.TextSize = 16
	lbl.TextColor3 = COLORS.accent2
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	return lbl
end

-- 🧩 Sections + Tools
local sections = {
	{title="Auto Farm", buttons={"Auto Farm Level", "Auto Farm Boss", "Auto Collect Drops"}},
	{title="Teleport", buttons={"Teleport to Island", "Teleport to Sea 2", "Teleport to Player"}},
	{title="Server", buttons={"Rejoin", "Hop Server", "Low Ping Server"}},
	{title="Misc", buttons={"Infinite Energy", "No Clip", "Speed Boost", "ESP Player"}},
}

for _, sec in pairs(sections) do
	local secLbl = createSection(sec.title)
	secLbl.Parent = scroll
	for _, btnText in pairs(sec.buttons) do
		local btn = createButton(btnText)
		btn.Parent = scroll
		btn.MouseButton1Click:Connect(function()
			print("[CheaCheat UI] Clicked:", btnText)
		end)
	end
end

-- 🌙 Toggle Animation
local isOpen = true
local tweenTime = 0.4
moon.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	if isOpen then
		menu.Visible = true
		menu.Position = UDim2.new(0, 90, 0, 120)
		menu.BackgroundTransparency = 1
		TweenService:Create(menu, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
			Position = UDim2.new(0, 90, 0, 100)
		}):Play()
		moon.ImageColor3 = COLORS.accent
	else
		local tween = TweenService:Create(menu, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 90, 0, 130)
		})
		tween:Play()
		moon.ImageColor3 = COLORS.accent2
		task.delay(tweenTime, function()
			menu.Visible = false
		end)
	end
end)

print("[✅] Chea Cheat Blox Tool UI Loaded Successfully")
