-- Получаем локального игрока
local player = game.Players.LocalPlayer


local playerGui = player:WaitForChild("PlayerGui")


local infoGUI = playerGui:WaitForChild("Starter_infoGUI")

-- Игнорируем системные отступы (чтобы перекрыть верхнюю часть)
infoGUI.IgnoreGuiInset = true

-- Получаем доступ к Frame и TextLabel
local frame = infoGUI:WaitForChild("Frame")
local text1 = frame:WaitForChild("info1")
local text2 = frame:WaitForChild("info2")
local text3 = frame:WaitForChild("info3")

-- Получаем интерфейсы иконок
local scriptInterface = playerGui:WaitForChild("ScriptInterface")
local phoneButton = scriptInterface:WaitForChild("PhoneButton")
local openScriptButton = scriptInterface:WaitForChild("OpenScriptButton")

-- Настраиваем Frame для заполнения всего экрана
frame.Size = UDim2.new(1, 0, 1, 0) 
frame.Position = UDim2.new(0, 0, 0, 0) 
frame.BackgroundTransparency = 0 
frame.Visible = true

-- Настраиваем TextLabel для центрирования и увеличения текста
text1.Size = UDim2.new(0.9, 0, 0.3, 0) 
text1.Position = UDim2.new(0.05, 0, 0.35, 0) 
text1.TextScaled = true 
text1.TextWrapped = true 
text1.AnchorPoint = Vector2.new(0.5, 0.5)
text1.Position = UDim2.new(0.5, 0, 0.35, 0) 

text2.Size = UDim2.new(0.9, 0, 0.3, 0)
text2.Position = UDim2.new(0.5, 0, 0.35, 0)
text2.TextScaled = true
text2.TextWrapped = true
text2.AnchorPoint = Vector2.new(0.5, 0.5)

text3.Size = UDim2.new(0.9, 0, 0.3, 0)
text3.Position = UDim2.new(0.5, 0, 0.35, 0)
text3.TextScaled = true
text3.TextWrapped = true
text3.AnchorPoint = Vector2.new(0.5, 0.5)

text1.TextTransparency = 1 -- Текст начинает с невидимости
text2.TextTransparency = 1
text3.TextTransparency = 1

-- Скрываем иконки во время заставки
phoneButton.Visible = false
openScriptButton.Visible = false
phoneButton.ImageTransparency = 1
openScriptButton.ImageTransparency = 1

-- Анимация для плавного появления текста
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local tweenHideInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

-- Функция для анимации текста
local function fadeInText(textLabel)
	local goal = {TextTransparency = 0} 
	local tween = tweenService:Create(textLabel, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait() -- Ждём завершения анимации
end

local function fadeOutText(textLabel)
	local goal = {TextTransparency = 1} 
	local tween = tweenService:Create(textLabel, tweenHideInfo, goal)
	tween:Play()
	tween.Completed:Wait() -- Ждём завершения анимации
end

-- Анимация для изменения прозрачности Frame
local function fadeInFrame()
	local goal = {BackgroundTransparency = 0} 
	local tween = tweenService:Create(frame, tweenInfo, goal)
	tween:Play()
end

local function fadeOutFrame()
	local goal = {BackgroundTransparency = 1} 
	local tween = tweenService:Create(frame, tweenHideInfo, goal)
	tween:Play()
	tween.Completed:Wait()
end

-- Анимация плавного появления иконок
local function fadeInIcons()
	phoneButton.Visible = true
	openScriptButton.Visible = true

	local iconTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local phoneTween = tweenService:Create(phoneButton, iconTweenInfo, {ImageTransparency = 0})
	local consoleTween = tweenService:Create(openScriptButton, iconTweenInfo, {ImageTransparency = 0})

	phoneTween:Play()
	consoleTween:Play()
end

-- Начинаем анимацию
fadeInFrame() -- Показываем фрейм

-- Последовательно показываем и скрываем тексты
fadeInText(text1)  
wait(5)  

fadeOutText(text1)  
wait(1)  

fadeInText(text2)  
wait(5)  

fadeOutText(text2)  
wait(1)  

fadeInText(text3)  
wait(5)  

fadeOutText(text3)  
wait(1)

-- После того как все тексты исчезли, скрываем фрейм
fadeOutFrame()

-- Плавно показываем иконки
fadeInIcons()
