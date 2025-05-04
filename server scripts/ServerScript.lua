local replicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local evaluateEvent = replicatedStorage:WaitForChild("EvaluateCode")
local responseEvent = replicatedStorage:WaitForChild("EvaluateCodeResponse")
local lightEvent = replicatedStorage:WaitForChild("LightEvent")
local portalEvent = replicatedStorage:WaitForChild("PortalActivateEvent")
local doorEvent = replicatedStorage:WaitForChild("DoorEvent")
local garageEvent = replicatedStorage:WaitForChild("GarageUnlockEvent")
local spawnRobotsEvent = Instance.new("RemoteEvent")
spawnRobotsEvent.Name = "SpawnRobotsEvent"
spawnRobotsEvent.Parent = replicatedStorage

local shakeEvent = Instance.new("RemoteEvent")
shakeEvent.Name = "ShakeEvent"
shakeEvent.Parent = replicatedStorage

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

local function animateCoreAndShell()
	print("Starting animateCoreAndShell")
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	if head then
		print("Animating Head (" .. head.ClassName .. ")")
		local tween = TweenService:Create(head, tweenInfo, {Color = Color3.fromRGB(0, 255, 0)})
		tween:Play()
	else
		warn("Cannot animate Head: not found")
	end
	if fire then
		print("Animating Fire (" .. fire.ClassName .. ")")
		if fire:IsA("Fire") then
			local tween = TweenService:Create(fire, tweenInfo, {Color = Color3.fromRGB(0, 255, 0)})
			tween:Play()
		else
			warn("Fire is not a supported type for color animation: " .. fire.ClassName)
		end
	else
		warn("Cannot animate Fire: not found")
	end
	for i, forceField in ipairs(forceFields) do
		if forceField then
			print("Animating ForceField " .. i .. " (" .. forceField.ClassName .. ")")
			forceField.Transparency = 0.5 -- Полупрозрачность
			local mesh = forceField:FindFirstChildOfClass("SpecialMesh") or forceField:FindFirstChildOfClass("MeshPart")
			if mesh then
				print("Mesh found in ForceField " .. i .. ": " .. mesh.ClassName .. ", VertexColor: " .. tostring(mesh.VertexColor))
				local tween = TweenService:Create(mesh, tweenInfo, {VertexColor = Vector3.new(0, 255, 0)})
				tween:Play()
			else
				warn("Mesh not found in ForceField " .. i)
				local tween = TweenService:Create(forceField, tweenInfo, {Transparency = 0.3})
				tween:Play()
			end
		else
			warn("Cannot animate ForceField " .. i .. ": not found")
		end
	end
	if #forceFields == 0 then
		warn("No ForceField objects to animate")
	end
end

local garageModel = workspace.level_2:WaitForChild("GarageBuilding")
local taskCompletedValue = garageModel:WaitForChild("TaskCompleted")

local powerValue = Instance.new("IntValue")
powerValue.Name = "PowerValue"
powerValue.Parent = replicatedStorage
powerValue.Value = 0 

local elevatorButton = workspace.level_4.location.Elevator.Shaft["5"]:FindFirstChild("Call")
if elevatorButton then
	for _, part in pairs(elevatorButton:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
		elseif part:IsA("ProximityPrompt") then
			part.Enabled = false
		elseif part:IsA("ClickDetector") then
			part.MaxActivationDistance = 0
		elseif part:IsA("SurfaceGui") then
			part.Enabled = false
		end
	end
	print("Кнопка вызова лифта и её текст отключены до решения задачи!")
else
	warn("Кнопка Call не найдена в level_4 -> location -> Elevator -> Shaft -> 5!")
end

local holoGramTV = workspace.level_4.location.DoomSpire:FindFirstChild("HoloGramTV")
local tvSignLabel
if holoGramTV then
	local sign = holoGramTV:FindFirstChild("Sign")
	if sign then
		local surfaceGui = sign:FindFirstChild("SurfaceGui")
		if surfaceGui then
			tvSignLabel = surfaceGui:FindFirstChild("SIGN")
			if tvSignLabel and tvSignLabel:IsA("TextLabel") then
				tvSignLabel.Text = "ERROR"
				print("Телевизор настроен с надписью 'ERROR'.")
			else
				warn("TextLabel SIGN не найден в SurfaceGui телевизора!")
			end
		else
			warn("SurfaceGui не найден в sign телевизора!")
		end
	else
		warn("sign не найден в HoloGramTV!")
	end
else
	warn("HoloGramTV не найден в DoomSpire!")
end

local completedFloors = {}

local function spawnRobot(name, position)
	local templateRobot = workspace.level_3.interactive:FindFirstChild("Robot_1")
	if not templateRobot then
		warn("Шаблон робота Robot_1 не найден!")
		return
	end

	local newRobot = templateRobot:Clone()
	newRobot.Name = name
	local rootPart = newRobot:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.Position = position
		rootPart.Anchored = false

		local prompt = rootPart:FindFirstChild("ProximityPrompt")
		if prompt then
			prompt:Destroy()
		end
	end

	for _, script in pairs(newRobot:GetDescendants()) do
		if script:IsA("Script") and script.Disabled == false then
			local newScript = script:Clone()
			newScript.Parent = script.Parent
			newScript.Disabled = false
			script:Destroy()
			print("Активирован скрипт " .. newScript.Name .. " в " .. name)
		end
	end

	newRobot.Parent = workspace.level_3.interactive
	print("Создан робот " .. name .. " на позиции " .. tostring(position) .. " без возможности сканирования")
	return newRobot
end

local function activateFurnace(player)
	local furnace = workspace.level_3:FindFirstChild("Furnace")
	if not furnace then
		warn("Печь Furnace не найдена в workspace.level_3!")
		return
	end
	print("Печь Furnace найдена в workspace.level_3")

	local main = furnace:FindFirstChild("main")
	if not main then
		warn("main не найден в Furnace!")
	else
		print("main найден")
		local gear = main:FindFirstChild("Gear")
		if not gear then
			warn("gear не найден в main!")
		else
			print("gear найден")
			local spinScript = gear:FindFirstChild("Spin")
			if spinScript and spinScript:IsA("Script") then
				spinScript.Disabled = false
				print("Активирован Spin script в Furnace")
			else
				warn("Скрипт Spin не найден в gear или не является Script!")
			end
		end
	end

	local extra = furnace:FindFirstChild("extra")
	if not extra then
		warn("extra не найден в Furnace!")
	else
		print("extra найден")
		local firePart = extra:FindFirstChild("FirePart")
		if not firePart then
			warn("firepart не найден в extra!")
		else
			print("firepart найден")
			local fire = firePart:FindFirstChild("Fire")
			if fire then 
				fire.Enabled = true 
				print("Огонь в печи включен") 
			else
				warn("Fire не найден в firepart!")
			end
			local smoke = firePart:FindFirstChild("Smoke")
			if smoke then 
				smoke.Enabled = true 
				print("Дым в печи включен") 
			else
				warn("smoke не найден в firepart!")
			end
			local pointLight = firePart:FindFirstChild("PointLight")
			if pointLight then 
				pointLight.Enabled = true 
				print("Свет в печи включен") 
			else
				warn("PointLight не найден в firepart!")
			end
		end
	end

	print("Печь активирована!")
end

local function activateGenerator(player)
	local generator = workspace.level_3:FindFirstChild("Generator")
	if not generator then
		warn("Генератор Generator не найден в workspace!")
		return
	end

	local keySwitch = generator:FindFirstChild("Panel"):FindFirstChild("KeySwitch")
	if keySwitch then
		local key = keySwitch:FindFirstChild("Key")
		if key then
			local keyInner = key:FindFirstChild("Key")
			if keyInner then
				keyInner:FindFirstChild("KeyTurn"):Play()
			end
			TweenService:Create(key.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = key.PrimaryPart.CFrame * CFrame.Angles(math.rad(-90), 0, 0)}):Play()
			wait(1)

			local panelBase = generator:FindFirstChild("Panel"):FindFirstChild("PanelBase")
			if panelBase then
				local genSound2 = panelBase:FindFirstChild("GeneratorSound2")
				if genSound2 then
					genSound2:Play()
					TweenService:Create(genSound2, TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Volume = 0.2, PlaybackSpeed = 1}):Play()
				end
			end
			wait(10)
			generator:FindFirstChild("Panel"):FindFirstChild("Screen"):FindFirstChild("Screen"):FindFirstChild("SurfaceGui"):FindFirstChild("Text").Visible = true
		end
	end

	local panel = generator:FindFirstChild("Panel")
	if panel then
		local panelBase = panel:FindFirstChild("PanelBase")
		if panelBase then
			local genSound = panelBase:FindFirstChild("GeneratorSound")
			if genSound then
				genSound.PlaybackSpeed = 0
				genSound:Play()
				TweenService:Create(genSound, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {PlaybackSpeed = 1}):Play()
			end
		end

		local dials = panel:FindFirstChild("Dials")
		if dials then
			TweenService:Create(dials:FindFirstChild("Dial1").PrimaryPart, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {CFrame = dials.Dial1.PrimaryPart.CFrame * CFrame.Angles(math.rad(-120), 0, 0)}):Play()
			wait(2)
			TweenService:Create(dials:FindFirstChild("Dial2").PrimaryPart, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = dials.Dial2.PrimaryPart.CFrame * CFrame.Angles(math.rad(-150), 0, 0)}):Play()
			TweenService:Create(dials:FindFirstChild("Dial3").PrimaryPart, TweenInfo.new(3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {CFrame = dials.Dial3.PrimaryPart.CFrame * CFrame.Angles(math.rad(-60), 0, 0)}):Play()
			wait(3)
		end

		local smokePipe = generator:FindFirstChild("SmokePipe")
		if smokePipe then
			local particleEmitter = smokePipe:FindFirstChild("ParticleEmitter")
			if particleEmitter then
				particleEmitter.Enabled = true
				print("Дым из ParticleEmitter включен")
			end
			local smoke = smokePipe:FindFirstChild("Smoke")
			if smoke then
				local innerParticleEmitter = smoke:FindFirstChild("ParticleEmitter")
				if innerParticleEmitter then
					innerParticleEmitter.Enabled = true
					print("Дым из Smoke.ParticleEmitter включен")
				end
				local innerSmoke = smoke:FindFirstChild("Smoke")
				if innerSmoke then
					innerSmoke.Enabled = true
					print("Дым из Smoke.Smoke включен")
				end
			end
		end

		generator.Powered.Value = true
		panel:FindFirstChild("Screen"):FindFirstChild("Screen"):FindFirstChild("SurfaceGui"):FindFirstChild("Text").Text = "Powered"
	end

	print("Генератор активирован!")
end

local function activateConveyor(player)
	local conveyorBelt = workspace.level_3:FindFirstChild("conveyor_belt")
	if not conveyorBelt then
		warn("Модель conveyor_belt не найдена в workspace.level_3!")
		return
	end

	local activatedCount = 0

	for _, conveyor in ipairs(conveyorBelt:GetChildren()) do
		if conveyor.Name == "Conveyor" then
			local beam = conveyor:FindFirstChild("Beam")
			if beam and beam:IsA("Beam") then
				beam.Enabled = true
				print("Анимация конвейера через Beam включена для " .. conveyor.Name)
			end

			local conveyorScript = conveyor:FindFirstChild("Script")
			if conveyorScript and conveyorScript:IsA("Script") then
				conveyorScript.Disabled = false
				print("Скрипт движения конвейера активирован для " .. conveyor.Name)
			end

			activatedCount = activatedCount + 1
		end
	end

	if activatedCount > 0 then
		print("Конвейер активирован! Активировано конвейеров: " .. activatedCount)
	else
		warn("Не найдено ни одного Conveyor внутри conveyor_belt!")
	end
end

local function openHatch(floorNumber)
	local citadel = workspace.level_4.location:FindFirstChild("DoomSpire")
	if not citadel then
		warn("DoomSpire не найден в workspace.level_4!")
		return
	end

	local floor = citadel:FindFirstChild("Floor" .. floorNumber)
	if not floor then
		warn("Floor" .. floorNumber .. " не найден в DoomSpire!")
		return
	end

	local hatch = floor:FindFirstChild("hatch")
	if not hatch then
		warn("hatch не найден на Floor" .. floorNumber .. "!")
		return
	end

	local door1 = hatch:FindFirstChild("Door1")
	local door2 = hatch:FindFirstChild("Door2")
	if not door1 or not door2 then
		warn("Door1 или Door2 не найдены в hatch!")
		return
	end

	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
	local Door1Open = {CFrame = door1.CFrame + door1.CFrame.lookVector * 4}
	local Door2Open = {CFrame = door2.CFrame + door2.CFrame.lookVector * 4}

	local Open1 = TweenService:Create(door1, tweenInfo, Door1Open)
	local Open2 = TweenService:Create(door2, tweenInfo, Door2Open)

	Open1:Play()
	Open2:Play()
	local openSound = hatch:FindFirstChild("open")
	if openSound then
		openSound.Playing = true
	end
	print("Дверь на Floor" .. floorNumber .. " открыта!")
end

local function activateFloor(player, floorNumber)
	completedFloors[player.Name] = completedFloors[player.Name] or {}
	if not completedFloors[player.Name][floorNumber] then
		openHatch(floorNumber)
		completedFloors[player.Name][floorNumber] = true
	end
end

local function parseCode(player, code)
	print("🔍 Получен код от " .. player.Name .. ": " .. code)

	local env = { 
		res = nil, 
		gate = false, 
		power = nil, 
		garage = false, 
		lights = false, 
		door = false, 
		sum = nil, 
		energy = nil, 
		frequency = nil, 
		materials = nil,
		result = nil
	}
	setmetatable(env, { __index = _G })

	completedFloors[player.Name] = completedFloors[player.Name] or {}

	local initialGarageState = taskCompletedValue.Value
	local initialPower = powerValue.Value

	local success, errorMessage = pcall(function()
		local func = loadstring(code)
		if func then
			setfenv(func, env)
			func()
		else
			error("Ошибка компиляции кода")
		end
	end)

	if not success then
		responseEvent:FireClient(player, "❌ Ошибка выполнения кода: " .. tostring(errorMessage))
		return
	end

	print("📩 Отправляем результат клиенту:", env.res or env.sum or env.energy or env.frequency or env.materials or env.result or "Нет результата")

	local solvedTask = nil

	if env.garage == true and env.lights == true and not initialGarageState then
		print("✅ Гараж разблокирован!")
		taskCompletedValue.Value = true
		responseEvent:FireClient(player, "garage_unlocked")
		garageEvent:FireClient(player)
		solvedTask = "garage"
	end

	if env.gate == true then
		if env.power and env.power >= 25 and env.power <= 40 then
			print("✅ Доступ к воротам получен. Код: 9701")
			responseEvent:FireClient(player, "code_granted")
		else
			print("🚨 Недостаточно мощности для ворот!")
			responseEvent:FireClient(player, "⚠️ Недостаточно мощности для ворот!")
		end
		solvedTask = "gate"
	end

	if env.res == 15 then
		print("💡 Включаем лампы!")
		responseEvent:FireClient(player, env.res)
		lightEvent:FireClient(player)
		solvedTask = "lights"
	elseif env.res == 16 then
		print("🚀 Активируем портал!")
		responseEvent:FireClient(player, env.res)
		portalEvent:FireClient(player)
		solvedTask = "portal"
	end

	if env.door == true then
		print("🚪 Открываем дверь!")
		responseEvent:FireClient(player, "door_open")
		doorEvent:FireClient(player)
		solvedTask = "door"
	end

	if env.power and env.power ~= initialPower then
		powerValue.Value = env.power
		if env.power < 25 then
			print("⚠️ Слишком низкое напряжение!")
			responseEvent:FireClient(player, "⚠️ Слишком низкое напряжение!")
		elseif env.power > 40 then
			print("🚨 Перегрузка системы!")
			responseEvent:FireClient(player, "🚨 Перегрузка системы!")
		end
		solvedTask = "power"
	end

	if env.sum == 6 then
		print("✅ Сумма роботов верна! Создаем дополнительных роботов.")
		responseEvent:FireClient(player, 6)
		solvedTask = "robots"
	end

	if env.energy == 30 then
		print("✅ Печь активирована! Завод восстановлен.")
		responseEvent:FireClient(player, "furnace_activated")
		activateFurnace(player)
		solvedTask = "furnace"
	end

	if env.frequency == 50 then
		print("✅ Генератор запущен!")
		responseEvent:FireClient(player, "generator_activated")
		activateGenerator(player)
		solvedTask = "generator"
	end

	if env.materials == 12 then
		print("✅ Конвейер запущен!")
		responseEvent:FireClient(player, "conveyor_activated")
		activateConveyor(player)
		solvedTask = "conveyor"
	end

	if env.result == "Доступ открыт!" and not completedFloors[player.Name][3] then
		print("✅ Доступ к 3-му этажу открыт!")
		responseEvent:FireClient(player, "floor3_activated")
		activateFloor(player, 3)
		solvedTask = "floor3"
	end

	if env.result == "Число четное!" and not completedFloors[player.Name][4] then
		print("✅ Доступ к 4-му этажу открыт!")
		responseEvent:FireClient(player, "floor4_activated")
		activateFloor(player, 4)
		solvedTask = "floor4"
	end

	if env.result == "Длина верна!" and not completedFloors[player.Name][5] then
		print("✅ Доступ к 5-му этажу открыт!")
		responseEvent:FireClient(player, "floor5_activated")
		activateFloor(player, 5)
		solvedTask = "floor5"
	end

	if env.result == "Сумма верна!" and not completedFloors[player.Name][6] then
		print("✅ Доступ к 6-му этажу открыт!")
		responseEvent:FireClient(player, "floor6_activated")
		activateFloor(player, 6)
		solvedTask = "floor6"
	end

	if env.result == "Лифт активирован!" and not completedFloors[player.Name][7] then
		print("✅ Лифт активирован! Доступ к финальной точке открыт!")
		responseEvent:FireClient(player, "elevator_activated")
		if elevatorButton then
			for _, part in pairs(elevatorButton:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Transparency = 0
					part.CanCollide = true
				elseif part:IsA("ProximityPrompt") then
					part.Enabled = true
				elseif part:IsA("ClickDetector") then
					part.MaxActivationDistance = 10
				elseif part:IsA("SurfaceGui") then
					part.Enabled = true
				end
			end
			print("Кнопка вызова лифта и её текст активированы!")
		end
		if tvSignLabel then
			tvSignLabel.Text = "Working"
			print("Надпись на телевизоре изменена на 'Working'!")
		end
		completedFloors[player.Name][7] = true
		solvedTask = "elevator"
	end

	if env.result == "Ядро перезапущено!" then
		print("✅ Ядро перезапущено! Доступ к выходу открыт!")
		local coreChamber = Workspace.level_5:FindFirstChild("CoreChamber")
		local mainTerminal = coreChamber and coreChamber:FindFirstChild("MainTerminal")
		local tv = mainTerminal and mainTerminal:FindFirstChild("TV")
		local screenPart = tv and tv:FindFirstChild("Screen")
		local surfaceGui = screenPart and screenPart:FindFirstChild("SurfaceGui")
		local textLabel = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
		if textLabel then
			textLabel.Text = "ЯДРО ПЕРЕЗАПУЩЕНО"
			textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
			print("TextLabel updated to ЯДРО ПЕРЕЗАПУЩЕНО")
		else
			warn("TextLabel not found in MainTerminal!")
		end
		responseEvent:FireClient(player, "core_reset")
		completedFloors[player.Name][5] = true
		solvedTask = "core"
		print("Firing ShakeEvent for " .. player.Name)
		shakeEvent:FireClient(player)
		animateCoreAndShell()
	end

	if not solvedTask then
		responseEvent:FireClient(player, "❌ Ошибка: Нет решенной задачи.")
	end
end

spawnRobotsEvent.OnServerEvent:Connect(function(player)
	print("Создаем 3 дополнительных робота для " .. player.Name)
	spawnRobot("Robot_4", Vector3.new(-399.317, 91.592, 1460.724))
	spawnRobot("Robot_5", Vector3.new(-405.317, 91.592, 1460.724))
	spawnRobot("Robot_6", Vector3.new(-411.317, 91.592, 1460.724))
end)

evaluateEvent.OnServerEvent:Connect(parseCode)
