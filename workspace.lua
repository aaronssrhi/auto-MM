-- LocalScript: Duplicar Peces en No Despiertas a Pez
local a = game:GetService("Players")
local b = a.LocalPlayer
local c = b:WaitForChild("Backpack")
local d = b.Character or b.CharacterAdded:Wait()

-- Función para duplicar un elemento del inventario
local function e(f)
	local g = f:Clone()
	g.Parent = c
	return g
end

-- Función para buscar y duplicar peces
local function h()
	local i = {"Pez1", "Pez2", "Pez3"} -- Ajusta esto según los nombres reales de los peces en el juego

	for _, j in ipairs(i) do
		local k = c:FindFirstChild(j) or d:FindFirstChild(j)
		if k and k:IsA("Tool") then -- Asegurarse de que es un Tool
			task.spawn(function()
				e(k)
				task.wait(math.random(0.1, 0.5)) -- Retraso aleatorio
			end)
		end
	end
end

-- Ejecutar la función para duplicar los peces
h()

-- Mensaje de confirmación
print("Peces duplicados con éxito.")
