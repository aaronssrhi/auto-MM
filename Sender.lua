local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

-- Crear UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/share?code=XXXXXXXX"

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Parent = Frame
ErrorLabel.Size = UDim2.new(1, -20, 0, 30)
ErrorLabel.Position = UDim2.new(0, 10, 0, 110)
ErrorLabel.TextColor3 = Color3.new(1, 0, 0)
ErrorLabel.BackgroundTransparency = 1

local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Button.TextColor3 = Color3.new(1, 1, 1)

local MiniButton = Instance.new("TextButton")
MiniButton.Parent = ScreenGui
MiniButton.Size = UDim2.new(0, 100, 0, 30)
MiniButton.Position = UDim2.new(0, 20, 0, 20)
MiniButton.Text = "Abrir ventana"
MiniButton.Visible = false
MiniButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MiniButton.TextColor3 = Color3.new(1, 1, 1)

MiniButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    MiniButton.Visible = false
end)

-- Validación simple del link
local function isLinkValid(link)
    local code = string.match(link, "^https://www.roblox.com/share%?code=(%w+)$")
    return code ~= nil
end

-- Simular pausa solo para el jugador
local function simulateWorldPause()
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Playing = false
        end
    end
    for _, sound in pairs(SoundService:GetChildren()) do
        if sound:IsA("Sound") then
            sound.Playing = false
        end
    end
    local overlay = Instance.new("Frame")
    overlay.Name = "FreezeOverlay"
    overlay.Parent = Player:WaitForChild("PlayerGui")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    local tween = TweenService:Create(overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.7})
    tween:Play()
end

-- Botón principal
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isLinkValid(link) then
        local remoteEvent = ReplicatedStorage:WaitForChild("SendServerLink")
        remoteEvent:FireServer(link)
        simulateWorldPause()
        Frame.Visible = false
        MiniButton.Visible = true
        ErrorLabel.Text = ""
    else
        ErrorLabel.Text = "El link no tiene el formato correcto"
    end
end)

