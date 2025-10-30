repeat task.wait() until game:IsLoaded()
wait(5)

local Lighting = game.Lighting

-- Function to set clean bright lighting
local function setLighting()
    Lighting.Ambient = Color3.fromRGB(200, 200, 255)
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.ColorShift_Bottom = Color3.fromRGB(220, 220, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.ExposureCompensation = 0
    Lighting.FogColor = Color3.fromRGB(240, 240, 255)
    Lighting.FogEnd = 999999999
    Lighting.GeographicLatitude = 41.733
    Lighting.OutdoorAmbient = Color3.fromRGB(240, 240, 255)
    Lighting.GlobalShadows = true
end

-- Remove unwanted effects
for i, v in pairs(Lighting:GetChildren()) do
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

-- UI Creation
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonMenuGUI"
screenGui.Parent = PlayerGui

-- Create Moon Button
local moonButton = Instance.new("TextButton")
moonButton.Name = "MoonButton"
moonButton.Size = UDim2.new(0, 60, 0, 60)
moonButton.Position = UDim2.new(0, 20, 0, 20)
moonButton.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
moonButton.Text = "☾"
moonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
moonButton.Font = Enum.Font.GothamBold
moonButton.TextScaled = true
moonButton.Parent = screenGui
moonButton.Active = true
moonButton.Draggable = true -- Allow drag

-- Create Menu Frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 400)
menuFrame.Position = UDim2.new(0, 100, 0, 100)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Example function button inside menu
local exampleBtn = Instance.new("TextButton")
exampleBtn.Size = UDim2.new(0, 200, 0, 50)
exampleBtn.Position = UDim2.new(0, 25, 0, 25)
exampleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 150)
exampleBtn.Text = "Example Function"
exampleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exampleBtn.Font = Enum.Font.GothamBold
exampleBtn.TextScaled = true
exampleBtn.Parent = menuFrame

exampleBtn.MouseButton1Click:Connect(function()
    print("Function triggered!")
    -- You can add more features here
end)

-- Toggle menu visibility on moon button click
moonButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
