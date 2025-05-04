local player = game.Players.LocalPlayer
local screenGui = player:WaitForChild("PlayerGui"):WaitForChild("ScriptInterface") 

local phoneButton = screenGui:WaitForChild("PhoneButton") 
local phoneFrame = screenGui:WaitForChild("PhoneFrame") 
local closeButton = phoneFrame:WaitForChild("CloseButton") 
local eventLog = phoneFrame:WaitForChild("ScrollingFrame"):WaitForChild("EventLog")
local alertIcon = phoneButton:WaitForChild("AlertIcon") 

local phoneEvent = game.ReplicatedStorage:WaitForChild("PhoneEvent")
local robotsScanned = game.ReplicatedStorage:WaitForChild("RobotsScanned")
local tweenService = game:GetService("TweenService")

local blinkInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true) 
local blinkTween = tweenService:Create(alertIcon, blinkInfo, {ImageTransparency = 0.3}) 

alertIcon.Visible = false 

local logEntries = {}
local robotEntries = {
	[1] = nil,
	[2] = nil,
	[3] = nil
}
local totalRobotParts = 3

local hiddenPosition = UDim2.new(0.5, -phoneFrame.Size.X.Offset / 2, 1.2, 0) 
local visiblePosition = UDim2.new(0.5, -phoneFrame.Size.X.Offset / 2, 0.5, -phoneFrame.Size.Y.Offset / 2) 

phoneFrame.Position = hiddenPosition
phoneFrame.Visible = false 

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function updatePhoneText()
	local fullText = "Журнал событий:\n\n"

	-- Добавляем записи от телефонов
	if #logEntries > 0 then
		fullText = fullText .. table.concat(logEntries, "\n") .. "\n"
	end

	-- Добавляем данные роботов только если уже был отсканирован хотя бы один робот
	if robotsScanned.Value > 0 then
		fullText = fullText .. "Данные роботов (" .. robotsScanned.Value .. "/" .. totalRobotParts .. "):\n\n"
		for i = 1, totalRobotParts do
			if robotEntries[i] then
				fullText = fullText .. robotEntries[i] .. "\n\n"
			else
				fullText = fullText .. "**Часть " .. i .. "**\n\n[Данные не получены]\n\n"
			end
		end

		--if robotsScanned.Value == totalRobotParts then
			--fullText = fullText .. "**Все роботы отсканированы!**\n\nТеперь используй данные для восстановления системы."
		--end
	end

	eventLog.Text = fullText
end

phoneEvent.OnClientEvent:Connect(function(part, title, content, tasks)
	print("Получены данные: part=" .. tostring(part) .. ", title=" .. tostring(title) .. ", content=" .. tostring(content) .. ", tasks=" .. tostring(tasks))

	local safeTitle = title or "[Без заголовка]"
	local safeContent = content or "[Без содержания]"
	local safeTasks = tasks or ""

	local newEntry = "**" .. safeTitle .. "**\n" .. safeContent .. "\n" .. safeTasks

	if type(part) == "number" and part >= 1 and part <= totalRobotParts then
		print("Записываем данные робота в часть " .. part)
		robotEntries[part] = newEntry
	else
		print("Записываем данные телефона")
		table.insert(logEntries, newEntry)
	end

	updatePhoneText()

	alertIcon.Visible = true
	blinkTween:Play()
end)

robotsScanned.Changed:Connect(function(newValue)
	print("Прогресс роботов: " .. newValue .. "/" .. totalRobotParts)
	updatePhoneText()
end)

local function showPhone()
	phoneFrame.Visible = true
	local tween = tweenService:Create(phoneFrame, tweenInfo, {Position = visiblePosition})
	tween:Play()

	alertIcon.Visible = false
	blinkTween:Cancel()
end

local function hidePhone()
	local tween = tweenService:Create(phoneFrame, tweenInfo, {Position = hiddenPosition})
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
