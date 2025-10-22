-- LocalScript: Explotar datos de brainrot "torrtugini Dragonfrutini"
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Crear un ScreenGui para ocultar el output
local outputGui = Instance.new("ScreenGui")
outputGui.Name = "OutputGui"
outputGui.IgnoreGuiInset = true
outputGui.ResetOnSpawn = false
outputGui.Parent = PlayerGui
outputGui.DisplayOrder = 1000
outputGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Crear un ScrollingFrame para contener el output
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
scrollingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scrollingFrame.BorderSizePixel = 2
scrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.Parent = outputGui

-- Crear un TextLabel para mostrar el output
local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, 0, 1, 0)
outputLabel.Position = UDim2.new(0, 0, 0, 0)
outputLabel.BackgroundTransparency = 1
outputLabel.Text = ""
outputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
outputLabel.Font = Enum.Font.Gotham
outputLabel.TextSize = 12
outputLabel.TextWrapped = true
outputLabel.Parent = scrollingFrame

-- Función para buscar el brainrot por nombre y categoría en cualquier lugar del juego
local function findBrainrot(name, category)
	local function searchInObject(obj)
		if obj.Name == name and obj:FindFirstChild("Category") and obj.Category.Value == category then
			return obj
		end
		for _, child in ipairs(obj:GetChildren()) do
			local result = searchInObject(child)
			if result then
				return result
			end
		end
		return nil
	end

	-- Lista de servicios a buscar
	local servicesToSearch = {
		Workspace,
		game:GetService("ReplicatedStorage"),
		game:GetService("ServerStorage"),
		game:GetService("Lighting"),
		game:GetService("StarterPlayer"),
		game:GetService("StarterPack"),
		game:GetService("Teams"),
		game:GetService("TeleportService"),
		game:GetService("Chat"),
		game:GetService("DataStoreService"),
		game:GetService("InsertService"),
		game:GetService("MarketplaceService"),
		game:GetService("PackageService"),
		game:GetService("PathfindingService"),
		game:GetService("PhysicsService"),
		game:GetService("PluginManager"),
		game:GetService("RunService"),
		game:GetService("Selection"),
		game:GetService("Stats"),
		game:GetService("TestService"),
		game:GetService("TextService"),
		game:GetService("TweenService"),
		game:GetService("UserInputService"),
		game:GetService("VirtualInputManager"),
		game:GetService("VirtualUser"),
	}

	-- Buscar en todos los servicios
	for _, service in ipairs(servicesToSearch) do
		local brainrotFound = searchInObject(service)
		if brainrotFound then
			outputLabel.Text = "Brainrot encontrado en " .. service.Name .. ":\n" .. brainrotFound:GetFullName()
			return
		end
	end

	-- Buscar en la información del jugador
	local userData = Player:FindFirstChild("PlayerData") or Player:FindFirstChild("Data") or Player:FindFirstChild("UserData")
	if userData then
		local brainrotInUserData = searchInObject(userData)
		if brainrotInUserData then
			outputLabel.Text = "Brainrot encontrado en la información del jugador:\n" .. brainrotInUserData:GetFullName()
			return
		end
	end

	-- Técnicas de explotación avanzadas
	local CoreGui = game:GetService("CoreGui")
	local illegalIds = {
		"137842439297855", -- Dex
		"1204397029", -- Infinite Yield
		"2764171053", -- JJSploit
		"1352543873" -- Otro exploit
	}

	for _, id in ipairs(illegalIds) do
		local exploitGui = CoreGui:FindFirstChild(id)
		if exploitGui then
			outputLabel.Text = "Exploit detectado en CoreGui:\n" .. exploitGui.Name
			return
		end
	end

	outputLabel.Text = "Brainrot no encontrado en ningún lugar del juego."
end

-- Buscar el brainrot "torrtugini Dragonfrutini" en toda la data del juego
findBrainrot("torrtugini Dragonfrutini", "Secret")

-- Ajustar el tamaño del ScrollingFrame al contenido
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 20)
