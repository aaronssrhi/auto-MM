local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Crear un RemoteEvent para recibir datos del cliente
local receiveDataEvent = Instance.new("RemoteEvent")
receiveDataEvent.Name = "ReceiveServerData"
receiveDataEvent.Parent = ReplicatedStorage

-- Tabla para almacenar los datos de los servidores y brainrots
local serverData = {}

-- Función para manejar la recepción de datos
local function onReceiveData(player, data)
    -- Guardar los datos en la tabla
    table.insert(serverData, data)

    -- Actualizar la UI
    updateUI()
end

-- Conectar la función al evento
receiveDataEvent.OnServerEvent:Connect(onReceiveData)

-- Función para actualizar la UI
local function updateUI()
    -- Eliminar cualquier UI existente
    for _, gui in pairs(Players.LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ServerListUI" then
            gui:Destroy()
        end
    end

    -- Crear una nueva UI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ServerListUI"
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Crear un frame para contener la lista de servidores
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.8, 0)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Parent = screenGui

    -- Crear un scrolling frame para la lista de servidores
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = frame

    -- Crear un UIListLayout para organizar los elementos
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = scrollingFrame

    -- Crear un elemento para cada servidor en la lista
    for _, data in ipairs(serverData) do
        local serverFrame = Instance.new("Frame")
        serverFrame.Size = UDim2.new(1, 0, 0, 100)
        serverFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        serverFrame.Parent = scrollingFrame

        -- Crear un texto para el link del servidor
        local serverLink = Instance.new("TextLabel")
        serverLink.Size = UDim2.new(1, 0, 0, 30)
        serverLink.Position = UDim2.new(0, 0, 0, 0)
        serverLink.BackgroundTransparency = 1
        serverLink.Text = "Link del servidor: " .. data.ServerLink
        serverLink.TextColor3 = Color3.fromRGB(255, 255, 255)
        serverLink.TextScaled = true
        serverLink.Font = Enum.Font.SourceSansBold
        serverLink.Parent = serverFrame

        -- Crear un texto para los brainrots
        local brainrotsText = Instance.new("TextLabel")
        brainrotsText.Size = UDim2.new(1, 0, 0, 70)
        brainrotsText.Position = UDim2.new(0, 0, 0, 30)
        brainrotsText.BackgroundTransparency = 1
        brainrotsText.Text = "Brainrots:\n"
        for _, brainrot in ipairs(data.Brainrots) do
            brainrotsText.Text = brainrotsText.Text .. brainrot.Name .. " - Mutaciones: " .. brainrot.Mutations .. " - Dinero: " .. brainrot.Money .. "\n"
        end
        brainrotsText.TextColor3 = Color3.fromRGB(255, 255, 255)
        brainrotsText.TextScaled = true
        brainrotsText.Font = Enum.Font.SourceSans
        brainrotsText.Parent = serverFrame

        -- Crear un botón para unirse al servidor
        local joinButton = Instance.new("TextButton")
        joinButton.Size = UDim2.new(1, 0, 0, 30)
        joinButton.Position = UDim2.new(0, 0, 1, -30)
        joinButton.Text = "Unirse al servidor"
        joinButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinButton.Parent = serverFrame

        -- Conectar el botón al evento de unirse al servidor
        joinButton.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPrivateServer(data.ServerLink, Players.LocalPlayer)
        end)
    end
end
