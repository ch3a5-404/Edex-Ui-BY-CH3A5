repeat task.wait() until game:IsLoaded()
wait(5) -- extra load time

local Lighting = game.Lighting

-- Function to set nice lighting colors
local function setLighting()
    Lighting.Ambient = Color3.fromRGB(200, 220, 255) -- ស្រស់ស្រួច
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.ColorShift_Bottom = Color3.fromRGB(180, 200, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(220, 240, 255)
    Lighting.ExposureCompensation = 0.5
    Lighting.FogColor = Color3.fromRGB(200, 220, 255)
    Lighting.FogEnd = 100000
    Lighting.GeographicLatitude = 41.733
    Lighting.OutdoorAmbient = Color3.fromRGB(210, 230, 255)
    Lighting.GlobalShadows = true
end

-- Remove unwanted effects
for i,v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("BlurEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
        v:Destroy()
    end
end

setLighting()

Lighting.Changed:Connect(setLighting)
Lighting.DescendantAdded:Connect(function(obj)
    if obj:IsA("Sky") or obj:IsA("BlurEffect") or obj:IsA("BloomEffect") or obj:IsA("SunRaysEffect") then
        obj:Destroy()
    end
end)

-- ===== Add Simple UI =====
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LightingUI"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 100)
Frame.Position = UDim2.new(0.8, 0, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Frame.BackgroundTransparency = 0.3
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 230, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 30)
Button.Text = "Change Lighting Color"
Button.TextScaled = true
Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Parent = Frame

-- Change lighting color on button click
Button.MouseButton1Click:Connect(function()
    Lighting.Ambient = Color3.fromRGB(math.random(150,255), math.random(150,255), 255)
    Lighting.ColorShift_Bottom = Color3.fromRGB(math.random(150,255), math.random(150,255), 255)
    Lighting.ColorShift_Top = Color3.fromRGB(math.random(200,255), math.random(200,255), 255)
    Lighting.FogColor = Color3.fromRGB(math.random(150,255), math.random(150,255), 255)
end)
