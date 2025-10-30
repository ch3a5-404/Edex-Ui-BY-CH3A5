repeat task.wait() until game:IsLoaded()
wait(5)
-- UI Menu with Moon Toggle | Author: ChatGPT
-- Theme: Professional, Sleek, Tech-inspired
-- User: Chea Cheat

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TechMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Colors
local COLORS = {
    background = Color3.fromHex("#0A0A0A"),
    accent = Color3.fromHex("#00AEEF"),
    secondaryAccent = Color3.fromHex("#FFAA00"),
    textMain = Color3.fromHex("#F5F5F5"),
    textSub = Color3.fromHex("#B0B0B0"),
    success = Color3.fromHex("#00FF88"),
    warning = Color3.fromHex("#FF4444"),
    border = Color3.fromHex("#303030"),
}

-- Function to make draggable UI
local function makeDraggable(obj, dragHandle)
	local dragging, dragInput, startPos, startInputPos
	local UIS = game:GetService("UserInputService")
	
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

-- Moon Button (toggle)
local moon = Instance.new("ImageButton")
moon.Name = "MoonToggle"
moon.Size = UDim2.new(0, 48, 0, 48)
moon.Position = UDim2.new(0, 40, 0, 80)
moon.BackgroundTransparency = 1
moon.Image = "rbxassetid://6031075937" -- Moon icon
moon.ImageColor3 = COLORS.accent
moon.Parent = gui

makeDraggable(moon)

-- Menu Frame
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 340, 0, 250)
menu.Position = UDim2.new(0, 100, 0, 100)
menu.BackgroundColor3 = COLORS.background
menu.BorderSizePixel = 0
menu.Visible = true
menu.Parent = gui
makeDraggable(menu)

-- Shadow
local shadow = Instance.new("UIStroke")
shadow.Color = COLORS.border
shadow.Thickness = 1
shadow.Parent = menu

-- Corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = menu

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.MontserratBold
title.Text = "Tech Control Menu"
title.TextSize = 20
title.TextColor3 = COLORS.textMain
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = menu

-- Subtitle (username)
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 20)
subtitle.Position = UDim2.new(0, 10, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Roboto
subtitle.Text = "Logged as: " .. PLAYER_NAME
subtitle.TextSize = 14
subtitle.TextColor3 = COLORS.textSub
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = menu

-- Button creation helper
local function createButton(text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -40, 0, 38)
	btn.BackgroundColor3 = color or COLORS.accent
	btn.TextColor3 = COLORS.textMain
	btn.TextSize = 16
	btn.Font = Enum.Font.RobotoMedium
	btn.Text = text
	btn.BorderSizePixel = 0
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = COLORS.border
	stroke.Thickness = 1
	stroke.Parent = btn
	
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = color == COLORS.accent and COLORS.secondaryAccent or COLORS.accent
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = color or COLORS.accent
	end)
	
	return btn
end

-- Buttons
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = menu
layout.SortOrder = Enum.SortOrder.LayoutOrder

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -80)
container.Position = UDim2.new(0, 0, 0, 80)
container.BackgroundTransparency = 1
container.Parent = menu

layout.Parent = container

local startBtn = createButton("Start HopServer", COLORS.accent)
startBtn.Parent = container
local stopBtn = createButton("Stop HopServer", COLORS.warning)
stopBtn.Parent = container
local showBtn = createButton("Show Decoded Constants", COLORS.secondaryAccent)
showBtn.Parent = container

startBtn.MouseButton1Click:Connect(function()
	print("[TechMenu] HopServer Started")
end)
stopBtn.MouseButton1Click:Connect(function()
	print("[TechMenu] HopServer Stopped")
end)
showBtn.MouseButton1Click:Connect(function()
	print("[TechMenu] Showing Decoded Constants...")
end)

-- Moon Toggle behavior
local open = true
moon.MouseButton1Click:Connect(function()
	open = not open
	menu.Visible = open
	if open then
		moon.ImageColor3 = COLORS.accent
	else
		moon.ImageColor3 = COLORS.secondaryAccent
	end
end)

print("[✅] Tech UI loaded for", PLAYER_NAME)
