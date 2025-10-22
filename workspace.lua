-- LocalScript: Manipular datos del jugador para encontrar brainrot de manera agresiva
local Players = game:GetService("Players")
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

-- Función para manipular datos del jugador y buscar brainrot de manera agresiva
local function aggressiveBrainrotSearch()
	local function searchInObject(obj)
		if obj:IsA("Model") or obj:IsA("Folder") then
			for _, child in ipairs(obj:GetChildren()) do
				if child.Name == "torrtugini Dragonfrutini" and child:FindFirstChild("Category") and child.Category.Value == "Secret" then
					return child
				end
				local result = searchInObject(child)
				if result then
					return result
				end
			end
		end
		return nil
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

	-- Buscar en ReplicatedStorage
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local brainrotInReplicatedStorage = searchInObject(replicatedStorage)
	if brainrotInReplicatedStorage then
		outputLabel.Text = "Brainrot encontrado en ReplicatedStorage:\n" .. brainrotInReplicatedStorage:GetFullName()
		return
	end

	-- Buscar en ServerStorage
	local serverStorage = game:GetService("ServerStorage")
	local brainrotInServerStorage = searchInObject(serverStorage)
	if brainrotInServerStorage then
		outputLabel.Text = "Brainrot encontrado en ServerStorage:\n" .. brainrotInServerStorage:GetFullName()
		return
	end

	-- Buscar en el Workspace
	local workspace = game:GetService("Workspace")
	local brainrotInWorkspace = searchInObject(workspace)
	if brainrotInWorkspace then
		outputLabel.Text = "Brainrot encontrado en Workspace:\n" .. brainrotInWorkspace:GetFullName()
		return
	end

	-- Acceder a datos remotos de manera forzada
	local http = game:GetService("HttpService")
	local remoteData = http:GetAsync("https://example.com/remote/data") -- Reemplaza con la URL real
	local remoteTable = http:JSONDecode(remoteData)
	local brainrotInRemoteData = searchInObject(remoteTable)
	if brainrotInRemoteData then
		outputLabel.Text = "Brainrot encontrado en datos remotos:\n" .. brainrotInRemoteData:GetFullName()
		return
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

-- Manipular datos del jugador y buscar brainrot de manera agresiva
aggressiveBrainrotSearch()

-- Ajustar el tamaño del ScrollingFrame al contenido
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 20)
