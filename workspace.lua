-- LocalScript: Buscar y extraer datos del brainrot "torrtugini Dragonfrutini"
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

-- Función para buscar el brainrot por nombre y extraer su ubicación
local function findBrainrot(name)
	local function searchObject(obj)
		if obj.Name == name then
			return obj
		end
		for _, child in ipairs(obj:GetChildren()) do
			local result = searchObject(child)
			if result then
				return result
			end
		end
		return nil
	end

	local brainrot = searchObject(Workspace)
	if brainrot then
		outputLabel.Text = "Brainrot encontrado:\n" .. brainrot.Name .. "\nUbicación: " .. brainrot:GetFullName()
	else
		outputLabel.Text = "Brainrot no encontrado."
	end
end

-- Buscar el brainrot "torrtugini Dragonfrutini"
findBrainrot("torrtugini Dragonfrutini")

-- Ajustar el tamaño del ScrollingFrame al contenido
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 20)
