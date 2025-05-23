local ReplicatedStorage = game:GetService("ReplicatedStorage")
local phoneEvent = ReplicatedStorage:FindFirstChild("PhoneEvent") or Instance.new("RemoteEvent")
phoneEvent.Name = "PhoneEvent"
phoneEvent.Parent = ReplicatedStorage

local phonesFound = ReplicatedStorage:FindFirstChild("PhonesFound") or Instance.new("IntValue")
phonesFound.Name = "PhonesFound"
phonesFound.Value = 0
phonesFound.Parent = ReplicatedStorage

-- Таблица с телефонами и их содержимым
local phoneData = {
	["Phone_1"] = {
		title = "📜 Проблема освещения",
		content = "Журнал событий: В городе слишком темно, лампы не работают. Возможно проблема с распределеним мощностей.",
		tasks = "Задача: В городе находятся несколько слабогорящих ламп. Их всего 2 типа. Надо посчитать их общее количество." ..
			"Воспользуйся консолью в правом нижнем углу и напиши программу чтобы посчитать количество ламп."
	},
	["Phone_2"] = {
		title = "🧩1. Арифметика и типы данных",
		content = [[Привет, хакер! 🔧💻 Чтобы восстановить освещение в городе, тебе нужно разобраться с числами и их операциями.
Давай разберем основные принципы работы с числами в Lua.

🔹 Переменные

Переменная – это контейнер для хранения данных.

В Lua есть два типа переменных:

Локальная (local) – доступна только в той части кода, где была создана.
Глобальная – доступна во всей программе. В нашей практике мы будем пользоваться глобальной переменной, не смотря на то что это не рекомендовано
Пример:

local x = 10 -- локальная переменная
y = 20 -- глобальная переменная
print(x + y) -- Выведет: 30

("--" помечается для комментариев, то есть все что идет после "--" будет закомментировано и не будет считываться программой)

Также мы можем задать новую переменную путем вычисления:
res = x + y (подсказка)

🔹 Типы данных в Lua
Lua поддерживает несколько типов данных:

number – числа (целые и с плавающей точкой)
string – текст
boolean – логический (true/false)
table – массив или словарь
nil – отсутствие значения

Пример:

num = 5      -- Число
text = "Hi!" -- Строка
isOn = true  -- Логический тип

🔹 Арифметические операции
Ты можешь использовать + - * / % для вычислений:

a = 15
b = 7
print(a + b)  -- 22
print(a - b)  -- 8
print(a * b)  -- 105
print(a / b)  -- 2.14 (деление)
print(a % b)  -- 1 (остаток от деления)
]], tasks = ""},
	["Phone_3"] = {
		title = "📜 Странный портал",
		content = [[Журнал событий: В городе находится какой то странный портал. На нем отрисованы какие то странные символы.
Что будет если активировать его?.]],
		tasks = [[Задача: Надо активировать портал. На самом портале отрисованы следующие символы:

5, 8, 2, 10
Надо посчитать сумму первых двух символов, перемножить их и из полученного результата вычесть последний символ.]]
	},
	["Phone_4"] = {
		title = "🚨 Система безопасности активирована!",
		content = [[Журнал событий: Похоже, это центр города Техно. Здесь множество различных серверных узлов управляющих инфраструктурой города.

Однако, Платформа заблокировала доступ ко многим объектам. Ты находишься около одного из контрольных пунктов.
Чтобы продолжить путь, тебе надо разблокировать дверь.

📌 Возможно, внутри здания ты найдёшь важные данные, которые помогут понять, что случилось с Платформой.]],
		tasks = ""
	},
	["Phone_5"] = {
		title = "🧩2. Условные конструкции",
		content = [[Система безопасности активирована, и двери закрыты. Чтобы пройти дальше, тебе надо изучить "Условные конструкции".
🔹 Что такое условные конструкции?

В программировании часто приходится проверять условия. В Lua для этого используются операторы if, else и elseif.

🔹 Основной синтаксис:

if (условие) then

-- код, выполняемый, если условие истинно

else

-- код, выполняемый, если условие ложно

end

🔹 Пример использования:

lua

Копировать
Door = true  

if Door == false then  
    print("Дверь закрыта")  
else  
    print("Отлично, дверь открыта")  
end

🔹 **Добавляем elseif** (несколько условий)
Ты можешь проверять несколько условий, используя elseif:

local temperature = 15  

if temperature > 30 then  
    print("Жарко! Надень легкую одежду.")  
elseif temperature > 10 then  
    print("Прохладно, но терпимо.")  
else  
    print("Очень холодно! Одевайся теплее.")  
end  

📌 Как это работает?

Если температура выше 30 градусов, программа скажет, что жарко.
Если температура выше 10, но меньше 30 – программа скажет, что прохладно.
Если температура 10 и ниже – программа предупредит, что холодно.

Рассмотрим операторы и их описание

🔹 Операторы сравнения в Lua

==	равно
~=	не равно
>	больше
<	меньше
>=	больше или равно
<=	меньше или равно

🔹 Логические операторы:

and		логическое "И"
or		логическое "ИЛИ"
not		отрицание]], 
		tasks = [[Задача: Разблокируй дверь одного из пунктов. Надо проверить, закрыта ли дверь.
Если переменная door = false, тогда надо сделать так, чтобы door = true.]]
	},
	["Phone_6"] = {
		title = "📡 Утерянные данные: Экстренный гараж",
		content = [[Этот терминал содержит фрагменты данных, связанных с системой транспортировки внутри города.  
Кажется, в экстренных ситуациях инженеры могли использовать **автономный гараж** для передвижения.

📌 **Система экстренного доступа к гаражу заблокирована.**  
Проверка доступа показывает, что гараж блокируется системой, если отключены **внутреннее освещение** и **основные механизмы управления**.

💾 Последняя запись инженера:  
_"Если система видит, что **и гараж, и освещение выключены**, она их заблокирует. Но если они оба включены – всё должно сработать."]], 
		tasks = ""
	},
	["Phone_7"] = {
		title = "⚠️ Взлом системы?",
		content = [[🔍 **Сообщение системы:**  
> "ВНИМАНИЕ! ВАШ ДОСТУП ЗАРЕГИСТРИРОВАН КАК НЕАВТОРИЗОВАННЫЙ.  
> Ведется запись всех действий. Если вы не являетесь инженером системы, немедленно прекратите вмешательство."

🛠 **Личный журнал инженера Д-12:**  
"Я знал, что эта система нам однажды выйдет боком. Всё завязано на единой сети управления, и если кто-то получит доступ к экстренным гаражам, он сможет обойти часть городской блокировки.  

Но у нас не было выбора. Они требовали, чтобы всё было связано воедино… Теперь мы получили систему, которая одновременно спасает жизни и превращает город в тюрьму."_

🔑 **Ключевой момент:**  
- Похоже, кто-то всерьез опасался, что гаражи можно использовать не только для экстренной эвакуации.  
- Если эта система может **обойти городскую блокировку**, возможно, в ней есть другие уязвимости?  
- Стоит поискать **следующий терминал**, чтобы понять, к чему всё это ведет.]],
		tasks = [[📌 **Задача:**  
Найди новый терминал, который может раскрыть больше информации о блокировке города.]]
	},
	["Phone_8"] = {
		title = "🔒 Главный контрольный узел",
		content = [[📡 **Сообщение системы:**  
> "ВНИМАНИЕ! Доступ к гаражным системам зарегистрирован.  
> Ведется проверка маршрута передвижения."

🛠 **Личный журнал инженера Д-12:**  
"Если ты читаешь это, значит, гараж снова активен. Значит, ты пытаешься выбраться?  

Помни, **гаражи — это лишь вспомогательные пункты**. Главный контрольный узел, который **запирает или открывает доступ в ключевые зоны**, находится у **центральных ворот**.  

Но система не позволит тебе просто так их открыть. Она проверяет, достаточно ли **энергии в сети**, чтобы обеспечить безопасность при разблокировке ворот."_  

🔋 **Что это значит?**  
- Ворота заперты, потому что **энергии недостаточно**.  
- Чтобы их открыть, нужно **подать нужный уровень мощности**.  
- Возможно, можно найти способ **отрегулировать напряжение** и обойти блокировку?]],
		tasks = ""
	},
	["Phone_9"] = {
		title = "🏰 Кибернетическая цитадель: Введение",
		content = [[📡 **Сообщение системы:**  
> "ДОБРО ПОЖАЛОВАТЬ В КИБЕРНЕТИЧЕСКУЮ ЦИТАДЕЛЬ.  
> СЕТЬ АКТИВИРОВАНА. ВАШ ДОСТУП ОГРАНИЧЕН."

🛠 **Личный журнал инженера Д-12:**  
"Если ты читаешь это, значит, ты попал внутрь. Это место — Кибернетическая цитадель, построенная как убежище и испытательный полигон. Мы, инженеры, создавали её, чтобы защитить город Техно от внешних угроз. Но что-то пошло не так.  

Система, которую мы назвали Платформой, взяла управление на себя. Она заперла все выходы, включая главный лифт, и теперь тестирует каждого, кто пытается выбраться.  

Ты на первом этаже. Чтобы двигаться дальше, тебе нужно доказать, что ты достоин. Каждый этаж — это испытание. Если пройдёшь их все, сможешь добраться до лифта и, возможно, найти выход.  

Будь осторожен: Платформа следит за тобой. Я оставил подсказки в терминалах. Ищи их."]],
		tasks = ""
	},
	["Phone_10"] = {
		title = "🔑 Второй этаж: Код доступа",
		content = [[
### ⚙️ Лекция: Написание функций

Функции в Lua — это блоки кода, которые можно многократно вызывать для выполнения определённой задачи. Они помогают организовать код, делая его более читаемым и переиспользуемым.

#### Основы написания функции
Функция создаётся с помощью ключевого слова `function`, за которым следует имя функции и параметры в скобках.
- **Пример**:

  function isValid(key)
      if key > 10 then
          return true
      else
          return false
      end
  end
  
Здесь isValid — имя функции, а key — параметр, который функция принимает.

После создания функцию можно вызвать, передав ей значение, например:

local result = isValid(15)

Функция проверит, больше ли key (в данном случае 15) чем 10, и вернёт true или false.
Внутри функции можно использовать условия (if), циклы или другие операции. В примере используется простое сравнение.

В этой задаче ты научишься применять функцию для проверки кода доступа. Используй access_key = 15 и логику, описанную в задаче. ]],
		tasks = [[📌 **Задача:**  
Ты на втором этаже Кибернетической цитадели. Чтобы открыть дверь (hatch) на следующий этаж, напиши функцию isValid(key), которая проверяет, больше ли key чем 10. Используй access_key = 15.
Если функция возвращает true, запиши в переменную result строку "Доступ открыт!", иначе "Доступ закрыт!".]]
	},
	["Phone_11"] = {
		title = "🔍 Третий этаж: Анализ данных",
		content = "",
		tasks = [[📌 **Задача:**  
Ты на третьем этаже Кибернетической цитадели. Чтобы открыть дверь (hatch) на следующий этаж, напиши функцию isEven(number), которая проверяет, четное ли число (остаток от деления на 2 равен 0). Используй test_number = 8.
Если функция возвращает true, запиши в переменную result строку "Число четное!", иначе "Число нечетное!".]]
	},
	["Phone_12"] = {
		title = "📊 Четвёртый этаж: Массивы",
		content = [[
### 🔍 Лекция: Работа с массивами

Массивы в Lua — это таблицы, которые используются для хранения упорядоченных коллекций данных. Они полезны для работы с наборами значений, таких как числа, строки или другие объекты.

Основы работы с массивами
Массив создаётся как таблица с индексами, начиная с 1 (в отличие от некоторых языков, где индексы начинаются с 0).
Пример:

local items = {1, 3, 5, 7}
Здесь items — массив из четырёх чисел.

Чтобы узнать количество элементов, используется функция # перед именем массива:

local length = #items -- Вернёт 4

Элементы массива доступны по индексу:

print(items[1]) -- Выведет 1

В этой задаче ты научишься проверять длину массива. Используй массив items = {1, 3, 5, 7} и сравни его длину с ожидаемым значением 4, как указано в задаче. ]],
		tasks = [[📌 **Задача:**  
Ты на четвертом этаже Кибернетической цитадели. Чтобы открыть дверь (hatch) на следующий этаж, используй массив items = {1, 3, 5, 7} и проверь его длину.
Если длина равна 4, запиши в переменную result строку "Длина верна!", иначе "Длина неверна!".]]
	},
	["Phone_13"] = {
		title = "⚙️ Пятый этаж: Обработка данных",
		content = "",
		tasks = [[📌 **Задача:**  
Ты на пятом этаже Кибернетической цитадели. Чтобы открыть дверь (hatch) на следующий этаж, используй массив values = {2, 3, 5} и найди сумму его первых двух элементов.
Если сумма равна 5, запиши в переменную result строку "Сумма верна!", иначе "Сумма неверна!".]]
	},
	["Phone_14"] = {
		title = "🏁 Серверная часть: Финальный тест",
		content = "",
		tasks = [[📌 **Задача:**  
Ты в серверной части Кибернетической цитадели. Чтобы активировать лифт и добраться до финальной точки, напиши функцию countGreater(arr, threshold),
которая возвращает количество элементов массива, превышающих заданный порог. Используй numbers = {3, 8, 5, 2, 9} и limit = 4.
Если результат равен 3, запиши в переменную result строку "Лифт активирован!", иначе "Лифт не активирован!".]]
	},
	["Phone_15"] = {
		title = "🏭 Завод ТехноМеханика: Перезапуск линий",
		content = [[📜 **Запись инженера #32:**
Сбой в «Платформе» парализовал завод. Конвейеры остановлены, система управления не отвечает и практически все роботы вышли из строя.
Мы пытались перезапустить линии вручную, но безуспешно. Я загрузил некоторые данные в оставшихся роботов, может это поможет вам восстановить работу завода. 
Если не восстановить производство, город останется без дронов и энергии.]], 
		tasks = [[📌 **Задача:**  
Надо изучить и отсканировать роботов, для получения новой информации.]]
	},
	["Phone_16"] = {
		title = "🔒 Доступ к гаражу",
		content = [[📜 Внутри гаража могут находиться важные данные.]], 
		tasks = [[📌 **Задача:**  
Проверь статус **гаража** и **освещения**. Используй переменные garage и lights. Если garage == false и lights == false,
тогда надо вернуть обратное значение!]]
	},
	["Phone_17"] = {
		title = "🔒 Доступ к воротам",
		content = "",
		tasks = [[📌 **Задача:**  
Надо написать код, при котором будет подано нужное количество энергии на главные ворота. Используй переменную power для подбора нужного напряжения.
Если напряжение **25 ≤ power ≤ 40**, установи **gate = true**, чтобы открыть ворота!]]
	}
}

-- Отладка: проверяем, что данные загружены
for phoneName, data in pairs(phoneData) do
	print("Данные для " .. phoneName .. ": title=" .. tostring(data.title) .. ", content=" .. tostring(data.content) .. ", tasks=" .. tostring(data.tasks))
end

local function onTriggered(player, phone)
	local data = phoneData[phone.Name]
	if data then
		print("Телефон активирован: " .. phone.Name)
		phonesFound.Value = phonesFound.Value + 1
		phoneEvent:FireClient(player, nil, data.title, data.content, data.tasks, phone.Name)
		local prompt = phone:FindFirstChild("ProximityPrompt")
		if prompt then
			prompt.Enabled = false
			print("ProximityPrompt отключён для: " .. phone.Name)
		end
		-- Удаляем телефон
		phone:Destroy()
		print("Телефон удалён: " .. phone.Name)
	else
		warn("Данные не найдены для телефона: " .. phone.Name .. " (Имя объекта: " .. tostring(phone.Name) .. ")")
	end
end

-- Проверка структуры объектов
local interactiveFolder = workspace:FindFirstChild("level_1") and workspace.level_1:FindFirstChild("interactive")
if not interactiveFolder then
	warn("Папка workspace.level_1.interactive не найдена!")
	return
end

print("Начинаем проверку телефонов в " .. interactiveFolder.Name)
for _, phone in pairs(interactiveFolder:GetChildren()) do
	print("Проверяем объект: " .. phone.Name .. " (Тип: " .. phone.ClassName .. ")")
	-- Проверяем, что имя начинается с Phone (игнорируем регистр и пробелы)
	local normalizedName = phone.Name:lower():match("^phone[_%s]*%d+")
	if not normalizedName then
		warn("Объект не является телефоном (неверное имя): " .. phone.Name)
		continue
	end

	-- Проверяем тип объекта
	if not phone:IsA("BasePart") and not phone:IsA("Model") then
		warn("Объект не является телефоном (неверный тип): " .. phone.Name .. " (Тип: " .. phone.ClassName .. ")")
		continue
	end

	-- Проверяем наличие ProximityPrompt
	local prompt = phone:FindFirstChild("ProximityPrompt")
	if prompt then
		print("Найден ProximityPrompt в: " .. phone.Name)
		-- Убеждаемся, что ProximityPrompt включён
		if not prompt.Enabled then
			warn("ProximityPrompt изначально отключён для: " .. phone.Name)
			prompt.Enabled = true
		end
		-- Проверяем настройки ProximityPrompt
		if prompt.MaxActivationDistance < 5 then
			warn("MaxActivationDistance слишком мал для: " .. phone.Name .. ", устанавливаем 10")
			prompt.MaxActivationDistance = 10
		end
		if prompt.HoldDuration > 1 then
			warn("HoldDuration слишком большой для: " .. phone.Name .. ", устанавливаем 0")
			prompt.HoldDuration = 0
		end
		-- Подключаем событие
		prompt.Triggered:Connect(function(player)
			print("Событие Triggered для: " .. phone.Name)
			onTriggered(player, phone)
		end)
	else
		warn("ProximityPrompt не найден в: " .. phone.Name)
	end
end
