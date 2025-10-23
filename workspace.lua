-- LocalScript: Duplicar Peces en No Despiertas a Pez
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local Character = Player.Character or Player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Función para duplicar un elemento del inventario
local function duplicateItem(item)
	local newItem = item:Clone()
	newItem.Parent = Backpack
	return newItem
end

-- Función para manejar la interacción del pez con la base
local function handleFishInteraction(fish)
	local function onTouch(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local player = Players:GetPlayerFromCharacter(character)
			if player then
				-- Lógica para colocar el pez en la base y dar dinero
				local base = player:FindFirstChild("Base") -- Ajusta esto según la estructura real de tu juego
				if base then
					fish.Parent = base
					print(player.Name .. " ha colocado " .. fish.Name .. " en su base.")
					-- Lógica para dar dinero al jugador
					local money = Instance.new("IntValue")
					money.Name = "Money"
					money.Value = 100 -- Ajusta la cantidad de dinero según sea necesario
					money.Parent = player
					print(player.Name .. " ha recibido " .. money.Value .. " de dinero.")
				end
			end
		end
	end

	fish.Touched:Connect(onTouch)
end

-- Función para duplicar el pez y manejar su interacción
local function duplicateFish()
	local fishName = "Imperium Whale" -- Nombre del pez que quieres duplicar

	local fish = Backpack:FindFirstChild(fishName) or Character:FindFirstChild(fishName)
	if fish and fish:IsA("Tool") then
		task.spawn(function()
			local newFish = duplicateItem(fish)
			-- Manejar la interacción del pez duplicado con la base
			handleFishInteraction(newFish)
			task.wait(math.random(0.1, 0.5)) -- Retraso aleatorio
		end)
	else
		print("Pez no encontrado en el inventario.")
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

-- Ejecutar la función para duplicar el pez
duplicateFish()

-- Mensaje de confirmación
print("Pez duplicado con éxito.")
