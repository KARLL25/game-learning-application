local tweenService = game:GetService("TweenService")

local openButton = script.Parent:WaitForChild("OpenScriptButton")
local scriptFrame = script.Parent:WaitForChild("ScriptFrame")
local runButton = scriptFrame:WaitForChild("RunButton")
local closeButton = scriptFrame:WaitForChild("CloseButton")
local codeInput = scriptFrame:WaitForChild("CodeInput")
local debugOutput = scriptFrame:WaitForChild("DebugOutput")

local initialPosition = UDim2.new(0.026, 0, 0.023, 0)
local hiddenPosition = UDim2.new(0.026, 0, 1.2, 0)

scriptFrame.Position = hiddenPosition
scriptFrame.Visible = false  

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

openButton.MouseButton1Click:Connect(function()
	scriptFrame.Visible = true  
	local tween = tweenService:Create(scriptFrame, tweenInfo, {Position = initialPosition})  
	tween:Play()
end)

closeButton.MouseButton1Click:Connect(function()
	local tween = tweenService:Create(scriptFrame, tweenInfo, {Position = hiddenPosition})  
	tween:Play()
	tween.Completed:Wait()  
	scriptFrame.Visible = false  
end)

local function animateText(textLabel, fullText, speed)
	textLabel.Text = ""  
	for i = 1, #fullText do
		textLabel.Text = string.sub(fullText, 1, i)
		wait(speed)
	end
end

local function flashFrame(color, duration)
	local originalColor = scriptFrame.BackgroundColor3
	scriptFrame.BackgroundColor3 = color
	wait(0.2)
	tweenService:Create(scriptFrame, TweenInfo.new(duration), {BackgroundColor3 = originalColor}):Play()
end

runButton.MouseButton1Click:Connect(function()
	local code = codeInput.Text
	print("📤 Отправляем код на сервер:", code)
	game.ReplicatedStorage:WaitForChild("EvaluateCode"):FireServer(code)
end)

game.ReplicatedStorage:WaitForChild("EvaluateCodeResponse").OnClientEvent:Connect(function(result)
	print("📩 Клиент получил ответ:", result)

	local message = "🖥 Результат: " .. tostring(result)
	local successSound = game.ReplicatedStorage:WaitForChild("SuccessSound")
	local errorSound = game.ReplicatedStorage:WaitForChild("ErrorSound")
	wait(0.5)

	if result == "garage_unlocked" then
		message = "✅ Гараж открыт! Теперь можно пройти."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		game.ReplicatedStorage:WaitForChild("GarageUnlockEvent"):FireServer()
	elseif result == "power_check" then
		message = "⚡ Проверка мощности... ⏳"  
		wait(1)  
		local power = game.ReplicatedStorage:WaitForChild("PowerValue").Value  
		if power >= 25 and power <= 40 then
			message = "✅ Правильно! Мощность в норме (" .. tostring(power) .. "). Ворота открываются!"
			flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
			if successSound then successSound:Play() end
			game.ReplicatedStorage:WaitForChild("DoorEvent"):FireServer()
		elseif power < 25 then
			message = "⚠️ Ошибка! Слишком низкое значение мощности (" .. tostring(power) .. "). Увеличьте подачу энергии!"
			flashFrame(Color3.fromRGB(255, 0, 0), 0.3)
			if errorSound then errorSound:Play() end
		else
			message = "🚨 Ошибка! Перегрузка системы (" .. tostring(power) .. "). Уменьшите потребление!"
			flashFrame(Color3.fromRGB(255, 0, 0), 0.3)
			if errorSound then errorSound:Play() end
		end
		
	elseif result == "code_granted" then
		message = "🔢 ✅ Поздравляю! Получен код: 9701. Введите его в NumPad."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == 15 then
		message = "✅ Правильный ответ! ".. tostring(result) .. " ламп включено."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		game.ReplicatedStorage:WaitForChild("LightEvent"):FireServer()
		
	elseif result == 16 then
		message = "🚀 Портал активирован! Ответ " .. tostring(result) .. " верный. Теперь можно перемещаться."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		game.ReplicatedStorage:WaitForChild("PortalActivateEvent"):FireServer()
		
	elseif result == "door_open" then
		message = "🚪 Дверь открыта! Теперь можно пройти."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		game.ReplicatedStorage:WaitForChild("DoorEvent"):FireServer()
		
	elseif result == 6 then
		message = "✅ Правильно! Сумма роботов: " .. tostring(result) .. ". Создано 3 дополнительных робота для восстановления завода!"
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		game.ReplicatedStorage:WaitForChild("SpawnRobotsEvent"):FireServer()
		
	elseif result == "furnace_activated" then
		message = "✅ Печь активирована! Завод восстановлен!"
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "generator_activated" then
		message = "✅ Генератор запущен! Энергия подается на завод."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "conveyor_activated" then
		message = "✅ Конвейер запущен! Теперь материалы можно подавать в печь."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "floor3_activated" then
		message = "✅ Доступ ко 3-му этажу открыт! Дверь активирована."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "floor4_activated" then
		message = "✅ Доступ к 4-му этажу открыт! Дверь активирована."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "floor5_activated" then
		message = "✅ Доступ к 5-му этажу открыт! Дверь активирована."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "floor6_activated" then
		message = "✅ Доступ к 6-му этажу открыт! Дверь активирована."
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
		
	elseif result == "elevator_activated" then
		message = "✅ Лифт активирован! Доступ к финальной точке открыт!"
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
	elseif result == "core_reset" then
		message = "✅ Ядро перезапущено! Доступ к выходу открыт!"
		flashFrame(Color3.fromRGB(0, 255, 0), 0.5)
		if successSound then successSound:Play() end
	else
		message = "❌ Ошибка! Ваш результат: " .. tostring(result) .. ". Попробуйте снова."
		flashFrame(Color3.fromRGB(255, 0, 0), 0.3)
		if errorSound then errorSound:Play() end
	end

	animateText(debugOutput, message, 0.05)
end)
