local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Находим FadeScreen
local fadeScreen = playerGui:FindFirstChild("FadeScreen")
if not fadeScreen then
	fadeScreen = Instance.new("ScreenGui")
	fadeScreen.Name = "FadeScreen"
	fadeScreen.IgnoreGuiInset = true
	fadeScreen.Parent = playerGui
	print("FadeScreen создан в PlayerGui")
else
	fadeScreen.IgnoreGuiInset = true
	print("FadeScreen найден в PlayerGui, IgnoreGuiInset = " .. tostring(fadeScreen.IgnoreGuiInset))
end

local fadeFrame = fadeScreen:FindFirstChild("FadeFrame")
if not fadeFrame then
	fadeFrame = Instance.new("Frame")
	fadeFrame.Name = "FadeFrame"
	fadeFrame.Size = UDim2.new(1, 0, 1, 0)
	fadeFrame.Position = UDim2.new(0, 0, 0, 0)
	fadeFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	fadeFrame.BackgroundTransparency = 1
	fadeFrame.BorderSizePixel = 0
	fadeFrame.Parent = fadeScreen
	print("FadeFrame создан с размером: " .. tostring(fadeFrame.Size) .. ", позицией: " .. tostring(fadeFrame.Position))
else
	print("FadeFrame найден с размером: " .. tostring(fadeFrame.Size) .. ", позицией: " .. tostring(fadeFrame.Position))
end

-- Получаем RemoteEvent
local teleportEvent = ReplicatedStorage:WaitForChild("TeleportToLoc4Event")

-- Функция для анимации и телепортации
local function handleTeleport()
	local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Затемнение
	local fadeInTween = TweenService:Create(fadeFrame, tweenInfo, {BackgroundTransparency = 0})
	fadeInTween:Play()
	fadeInTween.Completed:Wait()
	print("Анимация затемнения завершена, прозрачность: " .. tostring(fadeFrame.BackgroundTransparency))

	-- Задержка после полного затемнения
	wait(0.5)

	-- Телепортация (проверяем SpawnLocation)
	local spawnLocation = game.Workspace.level_4:WaitForChild("SpawnLocation_Loc4", 5)
	if spawnLocation then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character:FindFirstChild("HumanoidRootPart").CFrame = spawnLocation.CFrame + Vector3.new(0, 3, 0)
			print(player.Name .. " телепортирован на 4-ю локацию (клиент)")
		end
	else
		warn("SpawnLocation_Loc4 не найден в Workspace!")
	end

	-- Осветление
	local fadeOutTween = TweenService:Create(fadeFrame, tweenInfo, {BackgroundTransparency = 1})
	fadeOutTween:Play()
	fadeOutTween.Completed:Wait()
end

-- Подключаемся к RemoteEvent
teleportEvent.OnClientEvent:Connect(handleTeleport)
