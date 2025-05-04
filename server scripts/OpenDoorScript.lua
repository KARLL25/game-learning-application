local replicatedStorage = game:GetService("ReplicatedStorage")

-- Создаём удалённое событие для двери (если его ещё нет)
local doorEvent = replicatedStorage:FindFirstChild("DoorEvent") or Instance.new("RemoteEvent", replicatedStorage)
doorEvent.Name = "DoorEvent"

-- Находим двери в level_2
local door1 = workspace.level_2.city.Town_Hall.ButtonDoor:FindFirstChild("Door1")
local door2 = workspace.level_2.city.Town_Hall.ButtonDoor:FindFirstChild("Door2")

-- Проверяем, что двери существуют
if not door1 or not door2 then
	warn("🚪 Двери не найдены в level_2! Проверь названия объектов.")
	return
end

-- Настраиваем анимацию дверей
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)

local Door1Open = {CFrame = door1.CFrame + door1.CFrame.lookVector * 4}
local Door2Open = {CFrame = door2.CFrame + door2.CFrame.lookVector * 4}

local Open1 = TweenService:Create(door1, tweenInfo, Door1Open)
local Open2 = TweenService:Create(door2, tweenInfo, Door2Open)

-- Обработчик события
doorEvent.OnServerEvent:Connect(function(player)
	print("🔑 Игрок " .. player.Name .. " открыл дверь!")
	Open1:Play()
	Open2:Play()
end)
