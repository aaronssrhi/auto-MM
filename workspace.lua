-- LocalScript: Duplicar Inventario
local a = game:GetService("Players")
local b = a.LocalPlayer
local c = b:WaitForChild("Backpack")

-- Función para duplicar un elemento del inventario
local function d(e)
	local f = e:Clone()
	f.Parent = c
	return f
end

-- Función para duplicar todos los elementos del inventario
local function g()
	for _, h in ipairs(c:GetChildren()) do
		if h:IsA("Tool") or h:IsA("LocalScript") or h:IsA("ModuleScript") then
			task.spawn(function()
				d(h)
				task.wait(math.random(0.1, 0.5)) -- Retraso aleatorio
			end)
		end
	end
end

-- Ejecutar la función para duplicar el inventario
g()

-- Mensaje de confirmación
print("Inventario duplicado con éxito.")
