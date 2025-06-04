local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаём RemoteEvent для связи с клиентом
local teleportEvent = Instance.new("RemoteEvent")
teleportEvent.Name = "TeleportToLoc4Event"
teleportEvent.Parent = ReplicatedStorage

-- Таблица для отслеживания телепортированных игроков
local teleportedPlayers = {}

-- Функция для отправки сигнала клиенту
local function initiateTeleport(player)
	if teleportedPlayers[player] then return end -- Проверка, телепортирован ли игрок

	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end

	-- Отправляем сигнал клиенту
	teleportEvent:FireClient(player)
	teleportedPlayers[player] = true
end

-- Обработка пересечения триггера
local trigger = script.Parent

trigger.Touched:Connect(function(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
	if humanoid and humanoid.Parent then
		local player = Players:GetPlayerFromCharacter(humanoid.Parent)
		if player and not teleportedPlayers[player] then
			initiateTeleport(player)
		end
	end
end)
