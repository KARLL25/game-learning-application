local ReplicatedStorage = game:GetService("ReplicatedStorage")
local phoneEvent = ReplicatedStorage:FindFirstChild("PhoneEvent") or Instance.new("RemoteEvent")
phoneEvent.Name = "PhoneEvent"
phoneEvent.Parent = ReplicatedStorage

local robotsScanned = ReplicatedStorage:FindFirstChild("RobotsScanned") or Instance.new("IntValue")
robotsScanned.Name = "RobotsScanned"
robotsScanned.Value = 0
robotsScanned.Parent = ReplicatedStorage

-- Данные по роботам после сканирования
local robotData = {
	["Robot_1"] = {
		part = 1,
		title = "🤖 Робот-Разведчик",
		content = "Этот робот собирал данные о городе. Его память повреждена, но удалось восстановить часть информации.",
		tasks = "Задача: Проверь, какие данные сохранились. Возможно, среди них есть важные подсказки."
	},
	["Robot_2"] = {
		part = 2,
		title = "🔧 Сервисный дрон",
		content = "Этот дрон отвечал за ремонт городской инфраструктуры. В его логе есть записи о поломках.",
		tasks = "Задача: Используй данные, чтобы понять, какие объекты в городе вышли из строя."
	},
	["Robot_3"] = {
		part = 3,
		title = "⚙️ Технический ассистент",
		content = "Этот робот помогал инженерам. В его памяти зашифрованы инструкции для работы с электроникой.",
		tasks = "Задача: Разбери зашифрованные данные и найди инструкцию по восстановлению системы."
	}
}

-- Лекция после сканирования всех роботов
local cycleLecture = {
	title = "🧩3. Циклы в Lua",
	content = [[Привет, хакер! Ты собрал данные со всех роботов, и теперь пора изучить "Циклы" — мощный инструмент в программировании, который позволяет повторять действия.

🔹 **Что такое циклы?**
Циклы используются, когда нужно выполнить код несколько раз. В Lua есть три основных типа циклов:

1. **for** (числовой цикл)
   Используется, если ты знаешь, сколько раз нужно повторить действие.
   Синтаксис: for i = начало, конец, шаг do -- код end
   Пример:
   for i = 1, 5, 1 do
       print("Повторение #" .. i)
   end
   -- Выведет: Повторение #1, Повторение #2, ..., Повторение #5

2. **while** (цикл с условием)
   Выполняется, пока условие истинно.
   Синтаксис: while условие do -- код end
   Пример:
   local count = 0
   while count < 3 do
       print("Счет: " .. count)
       count = count + 1
   end
   -- Выведет: Счет: 0, Счет: 1, Счет: 2

3. **repeat-until** (цикл до условия)
   Выполняется хотя бы раз, пока условие не станет истинным.
   Синтаксис: repeat -- код until условие
   Пример:
   local num = 0
   repeat
       print("Число: " .. num)
       num = num + 1
   until num > 4
   -- Выведет: Число: 0, Число: 1, ..., Число: 4]],
	tasks = [[🔹 **Задача1: Подсчет роботов**
Роботов слишком мало для восстановления работы завода. Подсчитай количество роботов (от 1 до 3 включительно) с помощью цикла for. 
Результат должен быть записан в переменную sum. Если сумма равна 6, будет создано еще 3 робота для восстановления системы.

🔹 **Задача 2: Активация печи (for)**
Печь перерабатывает материалы для завода, но ей нужно 30 единиц энергии. 
У тебя 6 роботов. Каждая пара роботов генерирует 10 единиц энергии. 
Используй цикл for, чтобы подсчитать энергию от всех пар, и запиши результат в переменную energy.

🔹 **Задача 3: Запуск генератора (while)**
Генератор должен работать на частоте 50 единиц. У тебя есть 6 роботов (Robot_1–Robot_6), каждый добавляет 10 единиц частоты. 
Используй цикл while, чтобы увеличить частоту до 50, и запиши результат в переменную frequency.

🔹 **Задача 4: Настройка конвейера (repeat-until)**
Конвейер должен обработать 12 единиц материала. У тебя 6 роботов, каждый переносит 2 единицы. 
Используй цикл repeat-until, чтобы подсчитать материалы, и запиши результат в переменную materials.]]
}

local function onScanned(player, robot)
	local data = robotData[robot.Name]
	if data then
		print(player.Name .. " отсканировал " .. robot.Name .. ", часть: " .. data.part)
		phoneEvent:FireClient(player, data.part, data.title, data.content, data.tasks)
		robotsScanned.Value = robotsScanned.Value + 1
		print("Роботов отсканировано: " .. robotsScanned.Value)

		if robotsScanned.Value == 3 then
			print("Все роботы отсканированы, отправляем лекцию игроку " .. player.Name)
			phoneEvent:FireClient(player, cycleLecture.title, cycleLecture.content, cycleLecture.tasks)
		end

		local prompt = robot:FindFirstChild("HumanoidRootPart"):FindFirstChild("ProximityPrompt")
		if prompt then
			prompt.Enabled = false
		end
	end
end

for _, robot in pairs(workspace.level_3.interactive:GetChildren()) do
	print("Проверка объекта: " .. robot.Name .. " (" .. robot.ClassName .. ")")
	local rootPart = robot:FindFirstChild("HumanoidRootPart")
	local prompt = rootPart and rootPart:FindFirstChild("ProximityPrompt")

	if prompt then
		print("Найден ProximityPrompt в " .. robot.Name .. " (HumanoidRootPart)")
		prompt.Triggered:Connect(function(player)
			onScanned(player, robot)
		end)
	else
		warn("ProximityPrompt или HumanoidRootPart не найден в " .. robot.Name)
	end
end
