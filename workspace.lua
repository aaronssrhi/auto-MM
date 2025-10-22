-- LocalScript: Buscar brainrot "torrtugini Dragonfrutini" en la información del usuario
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

-- Función para buscar el brainrot por nombre y categoría en la información del usuario
local function findBrainrotInUserData(name, category)
	local function searchInUserData(data)
		if typeof(data) == "table" then
			for key, value in pairs(data) do
				if key == name and value.Category == category then
					return value
				end
				local result = searchInUserData(value)
				if result then
					return result
				end
			end
		end
		return nil
	end

	-- Acceder a la información del usuario (esto puede variar dependiendo del juego)
	local userData = Player:FindFirstChild("PlayerData") or Player:FindFirstChild("Data") or Player:FindFirstChild("UserData")

	if userData then
		local brainrotData = searchInUserData(userData)
		if brainrotData then
			outputLabel.Text = "Brainrot encontrado:\n" .. name .. "\nCategoría: " .. category .. "\nDatos: " .. tostring(brainrotData)
		else
			outputLabel.Text = "Brainrot no encontrado en la información del usuario."
		end
	else
		outputLabel.Text = "No se encontró la información del usuario."
	end
end

-- Buscar el brainrot "torrtugini Dragonfrutini" en la información del usuario
findBrainrotInUserData("torrtugini Dragonfrutini", "Secret")

-- Ajustar el tamaño del ScrollingFrame al contenido
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 20)
