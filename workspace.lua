-- // Servicios principales
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")

-- // Crear ScreenGui principal
local outputGui = Instance.new("ScreenGui")
outputGui.Name = "OutputGui"
outputGui.IgnoreGuiInset = true
outputGui.ResetOnSpawn = false
outputGui.Parent = PlayerGui
outputGui.DisplayOrder = 1000
outputGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- // Fondo del panel
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.55, 0)
frame.Position = UDim2.new(0.25, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0)
frame.Parent = outputGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- // Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🔍 Buscador de Brainrots"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- // Scroll de resultados
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -70)
scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.Parent = frame

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 8)
uiCorner2.Parent = scrollingFrame

-- // Texto de salida
local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, -10, 0, 0)
outputLabel.BackgroundTransparency = 1
outputLabel.Text = ""
outputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
outputLabel.Font = Enum.Font.Code
outputLabel.TextSize = 14
outputLabel.TextWrapped = true
outputLabel.TextYAlignment = Enum.TextYAlignment.Top
outputLabel.AutomaticSize = Enum.AutomaticSize.Y
outputLabel.Parent = scrollingFrame

-- // Botón para repetir búsqueda
local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0.4, 0, 0, 30)
refreshButton.Position = UDim2.new(0.3, 0, 1, -35)
refreshButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
refreshButton.Text = "🔄 Rebuscar"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.TextSize = 14
refreshButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = refreshButton

-----------------------------------------------------------
-- // FUNCIÓN DE BÚSQUEDA
-----------------------------------------------------------
local function aggressiveBrainrotSearch()
	outputLabel.Text = "Buscando posibles brainrots...\n\n"

	local results = {}

	-- Función recursiva
	local function searchInObject(obj)
		if not obj or typeof(obj) ~= "Instance" then return end

		if obj:IsA("Model") or obj:IsA("Folder") then
			for _, child in ipairs(obj:GetChildren()) do
				if child.Name == "torrtugini Dragonfrutini" and child:FindFirstChild("Category") and child.Category.Value == "Secret" then
					table.insert(results, child:GetFullName())
				end
				searchInObject(child)
			end
		end
	end

	-- Buscar en posibles contenedores de datos del jugador
	local dataContainers = { "PlayerData", "Data", "UserData" }
	for _, name in ipairs(dataContainers) do
		local folder = Player:FindFirstChild(name)
		if folder then searchInObject(folder) end
	end

	-- Buscar en servicios comunes
	for _, serviceName in ipairs({ "ReplicatedStorage", "ServerStorage", "Workspace" }) do
		local service = game:GetService(serviceName)
		if service then searchInObject(service) end
	end

	-- Buscar exploits en CoreGui
	local CoreGui = game:GetService("CoreGui")
	local illegalIds = {
		["137842439297855"] = "Dex",
		["1204397029"] = "Infinite Yield",
		["2764171053"] = "JJSploit",
		["1352543873"] = "Otro exploit"
	}

	for id, name in pairs(illegalIds) do
		if CoreGui:FindFirstChild(id) then
			table.insert(results, "Exploit detectado en CoreGui: " .. name .. " (" .. id .. ")")
		end
	end

	-- Mostrar resultados
	if #results > 0 then
		outputLabel.Text = "✅ Resultados encontrados:\n\n"
		for i, r in ipairs(results) do
			outputLabel.Text = outputLabel.Text .. tostring(i) .. ". " .. r .. "\n"
		end
	else
		outputLabel.Text = "❌ No se encontraron brainrots ni exploits en el juego."
	end
end

-- // Ejecutar búsqueda inicial
aggressiveBrainrotSearch()

-- // Asignar acción al botón
refreshButton.MouseButton1Click:Connect(function()
	aggressiveBrainrotSearch()
end)
