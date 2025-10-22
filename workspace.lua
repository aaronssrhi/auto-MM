-- LocalScript: Buscar y extraer datos del brainrot "torrtugini Dragonfrutini"
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Crear un ScreenGui para mostrar el output
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

-- Función para buscar recursivamente en un objeto y sus hijos
local function searchInObject(obj, targetName)
	if obj:IsA("Model") or obj:IsA("Folder") then
		for _, child in ipairs(obj:GetChildren()) do
			if child.Name == targetName then
				return child
			end
			local result = searchInObject(child, targetName)
			if result then
				return result
			end
		end
	end
	return nil
end

-- Función principal para buscar el brainrot
local function findBrainrot()
	local targetName = "torrtugini Dragonfrutini"
	local brainrotFound = false

	-- Buscar en ReplicatedStorage
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local brainrotInReplicatedStorage = searchInObject(replicatedStorage, targetName)
	if brainrotInReplicatedStorage then
		outputLabel.Text = "Brainrot encontrado en ReplicatedStorage:\n" .. brainrotInReplicatedStorage:GetFullName()
		brainrotFound = true
	end

	-- Buscar en ServerStorage
	local serverStorage = game:GetService("ServerStorage")
	local brainrotInServerStorage = searchInObject(serverStorage, targetName)
	if brainrotInServerStorage then
		outputLabel.Text = "Brainrot encontrado en ServerStorage:\n" .. brainrotInServerStorage:GetFullName()
		brainrotFound = true
	end

	-- Buscar en Workspace
	local workspace = game:GetService("Workspace")
	local brainrotInWorkspace = searchInObject(workspace, targetName)
	if brainrotInWorkspace then
		outputLabel.Text = "Brainrot encontrado en Workspace:\n" .. brainrotInWorkspace:GetFullName()
		brainrotFound = true
	end

	-- Buscar en la información del jugador
	local userData = Player:FindFirstChild("PlayerData") or Player:FindFirstChild("Data") or Player:FindFirstChild("UserData")
	if userData then
		local brainrotInUserData = searchInObject(userData, targetName)
		if brainrotInUserData then
			outputLabel.Text = "Brainrot encontrado en la información del jugador:\n" .. brainrotInUserData:GetFullName()
			brainrotFound = true
		end
	end

	-- Si no se encuentra el brainrot, mostrar mensaje de error
	if not brainrotFound then
		outputLabel.Text = "Brainrot no encontrado en ningún lugar del juego."
	end

	-- Ajustar el tamaño del ScrollingFrame al contenido
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 20)
end

-- Ejecutar la función para buscar el brainrot
findBrainrot()
