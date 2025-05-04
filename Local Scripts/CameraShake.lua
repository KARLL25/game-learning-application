local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

print("CameraShake script loaded for " .. player.Name)

local shakeEvent = ReplicatedStorage:WaitForChild("ShakeEvent", 10)
if not shakeEvent then
	warn("ShakeEvent not found in ReplicatedStorage!")
	return
end

-- Функция для тряски камеры
local function shakeCamera()
	local shakeDuration = 3 -- Длительность тряски (секунды)
	local shakeMagnitude = 1 -- Сила тряски
	local startTime = tick()

	local connection
	connection = RunService.RenderStepped:Connect(function()
		if tick() - startTime >= shakeDuration then
			connection:Disconnect()
			return
		end

		-- Случайное смещение камеры
		local offset = Vector3.new(
			(math.random() - 0.5) * shakeMagnitude,
			(math.random() - 0.5) * shakeMagnitude,
			0
		)
		camera.CFrame = camera.CFrame * CFrame.new(offset)
	end)
end

-- Обработка события тряски
shakeEvent.OnClientEvent:Connect(function()
	print("Camera shake triggered for " .. player.Name)
	shakeCamera()
end)
