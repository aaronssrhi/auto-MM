-- LocalScript: Imprimir estructura de archivos específicos en el Workspace
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

-- Función para imprimir la estructura de un objeto y sus hijos
local function printObjectStructure(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local output = indentStr .. obj.Name .. " (" .. obj.ClassName .. ")\n"

	for _, child in ipairs(obj:GetChildren()) do
		output = output .. printObjectStructure(child, indent + 1)
	end

	outputLabel.Text = outputLabel.Text .. output
	return output
end

-- Función para buscar y imprimir los objetos específicos
local function printSpecificObjects()
	local specificObjects = {
		"Plots",
		"Road",
		"Events",
		"Pad",
		"Part"
	}

	for _, objName in ipairs(specificObjects) do
		local obj = Workspace:FindFirstChild(objName)
		if obj then
			printObjectStructure(obj)
		end
	end
end

-- Imprimir la estructura de los objetos específicos
printSpecificObjects()

-- Ajustar el tamaño del ScrollingFrame al contenido
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 20)
