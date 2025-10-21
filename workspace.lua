-- LocalScript: Imprimir estructura del Workspace de manera no detectable
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
outputLabel.Parent = outputGui

-- Función para imprimir la estructura del Workspace
local function printWorkspaceStructure(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local output = indentStr .. obj.Name .. " (" .. obj.ClassName .. ")\n"

	if obj:IsA("Model") then
		for _, child in ipairs(obj:GetChildren()) do
			output = output .. printWorkspaceStructure(child, indent + 1)
		end
	end

	outputLabel.Text = outputLabel.Text .. output
	return output
end

-- Imprimir la estructura del Workspace
printWorkspaceStructure(Workspace)

-- Ocultar el TextLabel después de un breve período para que no sea detectable
wait(1)
outputLabel.Visible = false
