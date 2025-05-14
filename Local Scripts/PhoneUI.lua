local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local screenGui = player:WaitForChild("PlayerGui"):WaitForChild("ScriptInterface")
local phoneButton = screenGui:WaitForChild("PhoneButton")
local phoneFrame = screenGui:WaitForChild("PhoneFrame")
local closeButton = phoneFrame:WaitForChild("CloseButton")
local eventLog = phoneFrame:WaitForChild("ScrollingFrame"):WaitForChild("EventLog")
local alertIcon = phoneButton:WaitForChild("AlertIcon")
local loreButton = phoneFrame:WaitForChild("LoreButton")
local tasksButton = phoneFrame:WaitForChild("TasksButton")

local phoneEvent = ReplicatedStorage:WaitForChild("PhoneEvent")
local robotsScanned = ReplicatedStorage:WaitForChild("RobotsScanned")

local blinkInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true)
local blinkTween = TweenService:Create(alertIcon, blinkInfo, {ImageTransparency = 0.3})
alertIcon.Visible = false

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local hiddenPosition = UDim2.new(0.5, -phoneFrame.Size.X.Offset / 2, 1.2, 0)
local visiblePosition = UDim2.new(0.5, -phoneFrame.Size.X.Offset / 2, 0.5, -phoneFrame.Size.Y.Offset / 2)
phoneFrame.Position = hiddenPosition
phoneFrame.Visible = false

-- Хранение данных
local loreEntries = {} -- Лор (сюжетные записи)
local taskEntries = {} -- Задачи (теория, задания)
local robotEntries = {
	[1] = nil,
	[2] = nil,
	[3] = nil
}
local totalRobotParts = 3

-- Таблица классификации телефонов (исправлен регистр: "lore" вместо "Lore")
local phoneClassification = {
	["Phone_1"] = "lore", -- Сюжет: проблема освещения
	["Phone_2"] = "tasks", -- Теория: арифметика
	["Phone_3"] = "tasks",
	["Phone_4"] = "lore",
	["Phone_5"] = "tasks",
	["Phone_6"] = "lore",
	["Phone_7"] = "lore",
	["Phone_8"] = "lore",
	["Phone_9"] = "lore",
	["Phone_10"] = "tasks",
	["Phone_11"] = "tasks",
	["Phone_12"] = "tasks",
	["Phone_13"] = "tasks",
	["Phone_14"] = "tasks",
	["Phone_15"] = "lore",
	["Phone_16"] = "tasks",
	["Phone_17"] = "tasks"
}

-- Функция для классификации записей
local function classifyEntry(part, title, content, tasks, phoneId)
	local safeTitle = title or "[Без заголовка]"
	local safeContent = content or "[Без содержания]"
	local safeTasks = tasks or ""
	local entry = "" .. safeTitle .. "\n" .. safeContent .. "\n" .. safeTasks

	-- Лекции (циклы, ООП) — всегда задачи
	if safeTitle == "🧩3. Циклы в Lua" or safeTitle == "📚 Основы ООП: Перезапуск ядра" then
		return "tasks", entry
	end

	-- Роботы — задачи (включают задания)
	if part and type(part) == "number" and part >= 1 and part <= totalRobotParts then
		return "robot", entry
	end

	-- Телефоны — классификация по идентификатору
	if phoneId or phoneClassification[phoneId] then
		return phoneClassification[phoneId], entry
	end

	-- Терминалы инженеров (без задач) — лор
	if safeTasks == "" and (safeTitle:match("🛠 Запись") or safeContent:match("Запись инженера")) then
		return "lore", entry
	end

	-- Остальное по умолчанию — задачи
	warn("No classification for phoneId: " .. tostring(phoneId) .. ", defaulting to tasks")
	return "tasks", entry
end

-- Функция обновления текста
local function updatePhoneText(mode)
	local fullText = mode == "lore" and "Лор:\n\n" or "Задачи:\n\n"

	if mode == "lore" then
		if #loreEntries > 0 then
			fullText = fullText .. table.concat(loreEntries, "\n\n") .. "\n"
		else
			fullText = fullText .. "[Нет записей]\n"
		end
	else -- mode == "tasks"
		if #taskEntries > 0 then
			fullText = fullText .. table.concat(taskEntries, "\n\n") .. "\n"
		end

		-- Данные роботов
		if robotsScanned.Value > 0 then
			fullText = fullText .. "Данные роботов (" .. robotsScanned.Value .. "/" .. totalRobotParts .. "):\n\n"
			for i = 1, totalRobotParts do
				if robotEntries[i] then
					fullText = fullText .. robotEntries[i] .. "\n\n"
				else
					fullText = fullText .. "Часть " .. i .. "\n\n[Данные не получены]\n\n"
				end
			end
		end

		if #taskEntries == 0 and robotsScanned.Value == 0 then
			fullText = fullText .. "[Нет записей]\n"
		end
	end

	eventLog.Text = fullText
end

-- Обработка новых данных
phoneEvent.OnClientEvent:Connect(function(part, title, content, tasks, phoneId)
	if not title and not content and not tasks then
		warn("Empty PhoneEvent data received!")
		return
	end

	print("Получены данные: part=" .. tostring(part) .. ", title=" .. tostring(title) .. ", content=" .. tostring(content) .. ", tasks=" .. tostring(tasks) .. ", phoneId=" .. tostring(phoneId))

	local entryType, newEntry = classifyEntry(part, title, content, tasks, phoneId)

	if entryType == "robot" then
		if part >= 1 and part <= totalRobotParts then
			print("Записываем данные робота в часть " .. part)
			robotEntries[part] = newEntry
		end
	elseif entryType == "lore" then
		print("Записываем лор")
		table.insert(loreEntries, newEntry)
	else -- tasks
		print("Записываем задачу")
		table.insert(taskEntries, newEntry)
	end

	updatePhoneText(loreButton.BackgroundColor3 == Color3.fromRGB(0, 255, 100) and "lore" or "tasks")

	alertIcon.Visible = true
	blinkTween:Play()
end)

robotsScanned.Changed:Connect(function(newValue)
	print("Прогресс роботов: " .. newValue .. "/" .. totalRobotParts)
	updatePhoneText(loreButton.BackgroundColor3 == Color3.fromRGB(0, 255, 100) and "lore" or "tasks")
end)

-- Анимация кнопок
local function animateButton(button, isActive)
	local targetColor = isActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(50, 50, 60)
	local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
	tween:Play()
end

-- Обработчики кнопок
loreButton.MouseButton1Click:Connect(function()
	updatePhoneText("lore")
	animateButton(loreButton, true)
	animateButton(tasksButton, false)
end)

tasksButton.MouseButton1Click:Connect(function()
	updatePhoneText("tasks")
	animateButton(tasksButton, true)
	animateButton(loreButton, false)
end)

-- Показ/скрытие телефона
local function showPhone()
	phoneFrame.Visible = true
	local tween = TweenService:Create(phoneFrame, tweenInfo, {Position = visiblePosition})
	tween:Play()

	alertIcon.Visible = false
	blinkTween:Cancel()

	-- По умолчанию показываем лор
	updatePhoneText("lore")
	animateButton(loreButton, true)
	animateButton(tasksButton, false)
end

local function hidePhone()
	local tween = TweenService:Create(phoneFrame, tweenInfo, {Position = hiddenPosition})
	tween:Play()
	tween.Completed:Wait()
	phoneFrame.Visible = false
end

local function togglePhone()
	if phoneFrame.Visible then
		hidePhone()
	else
		showPhone()
	end
end

phoneButton.MouseButton1Click:Connect(togglePhone)
closeButton.MouseButton1Click:Connect(togglePhone)
