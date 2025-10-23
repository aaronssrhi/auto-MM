-- LocalScript: Duplicar Inventario y Peces en No Despiertas a Pez
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

-- Función para duplicar todos los elementos del inventario
local function duplicateInventory()
	for _, item in ipairs(Backpack:GetChildren()) do
		if item:IsA("Tool") or item:IsA("LocalScript") or item:IsA("ModuleScript") then
			task.spawn(function()
				local newItem = duplicateItem(item)
				-- Asegurarse de que todos los scripts y propiedades se dupliquen correctamente
				for _, child in ipairs(item:GetChildren()) do
					if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
						local newScript = child:Clone()
						newScript.Parent = newItem
					end
				end
				task.wait(math.random(0.1, 0.5)) -- Retraso aleatorio
			end)
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

-- Ejecutar la función para duplicar el inventario
duplicateInventory()

-- Mensaje de confirmación
print("Inventario duplicado con éxito.")
