-- // Chea Cheat Tech-Inspired UI 🌙 //
-- Works on Executors (Fluxus, Arceus X, Delta, Codex, etc.)

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CheaCheatMoonUI"
gui.ResetOnSpawn = false

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- 🎨 Color Theme
local COLORS = {
    bg = Color3.fromRGB(10, 10, 10),
    accent = Color3.fromRGB(0, 174, 239),
    accent2 = Color3.fromRGB(255, 170, 0),
    text = Color3.fromRGB(245, 245, 245),
    border = Color3.fromRGB(48, 48, 48)
}

-- 🖱️ Make Draggable
local function makeDraggable(obj)
    local dragging, dragInput, startPos, startMousePos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = obj.Position
            startMousePos = input.Position
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startMousePos
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 🌙 Moon Toggle Button
local moon = Instance.new("ImageButton", gui)
moon.Name = "MoonButton"
moon.Size = UDim2.new(0, 60, 0, 60)
moon.Position = UDim2.new(0, 20, 0, 120)
moon.BackgroundTransparency = 1
moon.Image = "rbxassetid://6031075937" -- moon icon
moon.ImageColor3 = COLORS.accent
makeDraggable(moon)

-- 🪟 Menu Frame
local menu = Instance.new("Frame", gui)
menu.Name = "MainMenu"
menu.Size = UDim2.new(0, 400, 0, 360)
menu.Position = UDim2.new(0, 100, 0, 120)
menu.BackgroundColor3 = COLORS.bg
menu.Visible = true
makeDraggable(menu)

local uicorner = Instance.new("UICorner", menu)
uicorner.CornerRadius = UDim.new(0, 10)
local border = Instance.new("UIStroke", menu)
border.Color = COLORS.accent
border.Thickness = 2
border.Transparency = 0.3

-- 🧠 Title
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.MontserratBold
title.Text = "🌙 Chea Cheat Menu"
title.TextColor3 = COLORS.text
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- 📜 Scrollable Menu
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper for Sections + Buttons
local function section(text)
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.MontserratSemiBold
    lbl.TextColor3 = COLORS.accent2
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "🔹 " .. text
end

local function addButton(name, func)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = COLORS.accent
    btn.TextColor3 = COLORS.text
    btn.TextSize = 16
    btn.Font = Enum.Font.Roboto
    btn.Text = name
    btn.AutoButtonColor = false
    local c = Instance.new("UICorner", btn)
    local st = Instance.new("UIStroke", btn)
    st.Color = COLORS.border
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.accent2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.accent}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if func then pcall(func) end
        print("[CheaCheat Menu] Clicked:", name)
    end)
end

-- Add Menu Options
section("🌾 Auto Farm")
addButton("Auto Farm Level")
addButton("Auto Farm Boss")

section("🌀 Teleport")
addButton("Teleport to Island")
addButton("Teleport to Player")

section("🌍 Server")
addButton("Hop Server")
addButton("Rejoin Server")

section("💡 Misc")
addButton("ESP Player")
addButton("Infinite Energy")
addButton("WalkSpeed x2")

-- 🌙 Toggle Open/Close
local open = true
moon.MouseButton1Click:Connect(function()
	open = not open
	TweenService:Create(moon, TweenInfo.new(0.25), {
		ImageColor3 = open and COLORS.accent or COLORS.accent2
	}):Play()
	menu.Visible = open
end)

print("✅ Chea Cheat Moon UI Loaded Successfully!")
