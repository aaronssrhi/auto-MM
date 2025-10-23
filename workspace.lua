-- LocalScript: Duplicar Peces en No Despiertas a Pez
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Función para duplicar un elemento del inventario
local function duplicateItem(item)
	local newItem = item:Clone()
	newItem.Parent = Backpack
	return newItem
end

-- Función para buscar y duplicar peces
local function duplicateFish()
	local fishNames = {"Pez1", "Pez2", "Pez3"} -- Ajusta esto según los nombres reales de los peces en el juego

	for _, fishName in ipairs(fishNames) do
		local fish = Backpack:FindFirstChild(fishName) or Character:FindFirstChild(fishName)
		if fish and fish:IsA("Tool") then -- Asegurarse de que es un Tool
			duplicateItem(fish)
		end
	end
end

-- Función para imprimir la estructura del inventario
local function printInventoryStructure(obj, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	print(indentStr .. obj.Name .. " (" .. obj.ClassName .. ")")

	for _, child in ipairs(obj:GetChildren()) do
		printInventoryStructure(child, indent + 1)
	end
end

-- Imprimir la estructura del inventario al inicio
print("Estructura del Backpack:")
printInventoryStructure(Backpack)

print("Estructura del Character:")
printInventoryStructure(Character)

-- Ejecutar la función para duplicar los peces
duplicateFish()

-- Mensaje de confirmación
print("Peces duplicados con éxito.")
