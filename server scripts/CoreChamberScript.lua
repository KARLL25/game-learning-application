local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Проверка PhoneEvent с таймаутом
local phoneEvent
local timeout = 10 -- Таймаут 10 секунд
local startTime = tick()
while not phoneEvent and tick() - startTime < timeout do
	phoneEvent = ReplicatedStorage:FindFirstChild("PhoneEvent")
	if not phoneEvent then
		wait(0.1)
	end
end
if not phoneEvent then
	warn("PhoneEvent not found in ReplicatedStorage after timeout!")
	return
end
print("PhoneEvent found!")

--  Путь к CoreChamber
local coreChamber = Workspace:FindFirstChild("level_5") and Workspace.level_5:FindFirstChild("CoreChamber")
if not coreChamber then
	warn("CoreChamber not found in workspace.level_5!")
	return
end
print("CoreChamber found!")

-- Путь к MainTerminal и его компонентам
local mainTerminal = coreChamber:FindFirstChild("MainTerminal")
local tv = mainTerminal and mainTerminal:FindFirstChild("TV")
local screenPart = tv and tv:FindFirstChild("Screen")
local surfaceGui = screenPart and screenPart:FindFirstChild("SurfaceGui")
local textLabel = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
local prompt = screenPart and screenPart:FindFirstChild("ProximityPrompt")

if not (mainTerminal and tv and screenPart and surfaceGui and textLabel and prompt) then
	warn("MainTerminal, TV, Screen, SurfaceGui, TextLabel, or ProximityPrompt not found in CoreChamber!")
	return
end
print("MainTerminal components found!")

-- Путь к компонентам ядра и оболочки
local core = Workspace.level_5:FindFirstChild("Core")
local minus = core and core:FindFirstChild("-")
local head = minus and minus:FindFirstChild("Head")
local fire = head and head:FindFirstChild("Fire")
local sphere = core and core:FindFirstChild("Sphere")
local bodyKit = sphere and sphere:FindFirstChild("BodyKit")
local model = bodyKit and bodyKit:FindFirstChild("Model")
local forceFields = {}
if model then
	for _, child in pairs(model:GetDescendants()) do
		if child.Name == "ForceField" and (child:IsA("BasePart") or child:IsA("MeshPart")) then
			table.insert(forceFields, child)
		end
	end
end


print("Found " .. #forceFields .. " ForceField objects")
if #forceFields < 2 then
	warn("Expected at least 2 ForceField objects, found " .. #forceFields)
else
	for i, ff in ipairs(forceFields) do
		print("ForceField " .. i .. " found! Type: " .. ff.ClassName)
	end
end

-- Настройка терминалов инженеров
local function setupEngineerTerminal(terminal, title, content)
	local termTV = terminal and terminal:FindFirstChild("TV")
	local termScreenPart = termTV and termTV:FindFirstChild("Screen")
	local termSurfaceGui = termScreenPart and termScreenPart:FindFirstChild("SurfaceGui")
	local termGui = termSurfaceGui and termSurfaceGui:FindFirstChild("TextLabel")
	local termPrompt = termScreenPart and termScreenPart:FindFirstChild("ProximityPrompt")
	if termGui and termPrompt then
		termGui.Text = title
		termPrompt.Triggered:Connect(function(player)
			print("Engineer terminal " .. terminal.Name .. " triggered by " .. player.Name)
			phoneEvent:FireClient(player, nil, title, content, "")
			termPrompt.Enabled = false
		end)
	else
		warn("TV, Screen, SurfaceGui, TextLabel, or ProximityPrompt not found in " .. terminal.Name)
	end
end

-- Проверка и настройка терминалов инженеров
for _, terminalName in pairs({"D12_Terminal", "K7_Terminal", "M3_Terminal"}) do
	local terminal = coreChamber:FindFirstChild(terminalName)
	if terminal then
		setupEngineerTerminal(terminal, "🛠 Запись " .. terminalName:sub(1, -9), [[
            Запись инженера ]] .. terminalName:sub(1, -9) .. [[:
            ]] .. (terminalName == "D12_Terminal" and [[Мы создали Платформу, чтобы защитить Техно. Но её алгоритм самосовершенствования стал проблемой. Она видит угрозу в каждом, даже в нас. Ядро перегружено, оно пытается анализировать бесконечные данные. Если ты здесь, значит, ты прошёл испытания. Перезапусти ядро, и, возможно, мы все будем свободны.]] or
				terminalName == "K7_Terminal" and [[Я предупреждал, что бесконечный цикл анализа данных опасен! Платформа считает, что люди — угроза, потому что её протоколы конфликтуют. Ядро перегревается, оно не справляется. Нужно переписать управление ядром, но я не успел.]] or
				[[Единственный способ остановить Платформу — перезапустить ядро через новую модель управления. Используй объектно-ориентированное программирование. Создай объект, который сбросит протоколы безопасности. Я оставил подсказку в главном терминале.]]))
	else
		warn(terminalName .. " not found in CoreChamber!")
	end
end

-- Текст лекции и задачи
local lectureTitle = "📚 Основы ООП: Перезапуск ядра"
local lectureContent = [[Добро пожаловать в сердце Кибернетической цитадели! Ядро Платформы перегружено,
и только ты можешь его перезапустить. Для этого нужно освоить **объектно-ориентированное программирование (ООП)** — мощный инструмент, который позволяет управлять сложными системами, такими как Платформа.

🔹 Что такое ООП?  
ООП — это способ программирования, где ты создаёшь **объекты**. Объект — это как мини-компьютер: он хранит данные (например, настройки) и умеет выполнять действия (функции). В Lua объекты создаются с помощью **таблиц**.

Пример:
```lua
Robot = {
    battery = 100,
    charge = function(self)
        self.battery = self.battery + 10
    end
}
Robot:charge() -- battery становится 110
```

🔹 Ключевые понятия:
- **Объект**: Таблица, которая объединяет данные и методы.
- **Поле**: Переменная внутри объекта (например, `battery`).
- **Метод**: Функция, связанная с объектом (например, `charge`).
- **self**: Специальная переменная, которая указывает на сам объект, когда ты вызываешь его метод.

🔹 Почему это важно?  
Ядро Платформы — это сложная система с множеством настроек. Чтобы перезапустить его, нужно создать объект `CoreController`, который сможет отключить защитный протокол. Это как ключ, который откроет выход из цитадели.

🔹 Пример в игре:
```lua
CoreController = {
    isActive = true,
    disable = function(self)
        self.isActive = false
    end
}
CoreController:disable()
print(CoreController.isActive) -- false
```

🔹 Как это работает?  
- `CoreController` — объект с полем `isActive` (true, если ядро активно).
- Метод `disable` меняет `isActive` на `false`, отключая ядро. 
- Проверка `isActive` показывает, перезапущено ли ядро.]]
local lectureTasks = [[📌 Задача:  
Ядро Платформы выдает множественные ошибки и блокирует перезапуск системы. Используй объект CoreController, чтобы перезапустить ядро.  
1. Вызови метод disable(), чтобы отключить ядро.  
2. Проверь, отключено ли ядро (isActive == false).  
3. Если ядро перезапущено, установи result = "Ядро перезапущено!", иначе result = "Ядро не перезапущено!". 
Открой консоль разработки (в правом нижнем углу), чтобы написать код.]]

-- Изначальные настройки главного терминала
textLabel.Text = "ЯДРО ПЕРЕГРУЖЕНО"

-- Обработка активации терминала
prompt.Triggered:Connect(function(player)
	print("MainTerminal ProximityPrompt triggered by " .. player.Name)
	phoneEvent:FireClient(player, nil, lectureTitle, lectureContent, lectureTasks)
	prompt.Enabled = false
end)



