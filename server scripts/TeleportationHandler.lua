local portal_1 = workspace.level_1.interactive:FindFirstChild("portal_1")
local portal_2 = workspace.level_2.interactive:FindFirstChild("portal_2")

local portalActivated = false -- Флаг, активирован ли портал

if portal_1 and portal_2 then
	local spawnLocation1 = portal_1:FindFirstChildWhichIsA("SpawnLocation")
	local spawnLocation2 = portal_2:FindFirstChildWhichIsA("SpawnLocation")

	if spawnLocation1 and spawnLocation2 then
		local function onPortalTouched(otherPart)
			local character = otherPart.Parent
			local player = game.Players:GetPlayerFromCharacter(character)

			if player then  -- ✅ Проверяем, существует ли игрок
				if portalActivated then  -- ✅ Проверяем, активирован ли портал
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					if humanoidRootPart then
						local newPosition = spawnLocation2.Position + Vector3.new(0, 5, 0) -- ✅ Телепортируем чуть выше
						humanoidRootPart.CFrame = CFrame.new(newPosition)
						print(player.Name .. " был телепортирован на level_2!")
					end
				else
					print(player.Name .. " не может телепортироваться, пока портал не активирован!")
				end
			end
		end

		-- Подключаем обработчик к `SpawnLocation` в первом портале
		spawnLocation1.Touched:Connect(onPortalTouched)

		-- Обработчик события активации портала
		game.ReplicatedStorage:WaitForChild("PortalActivateEvent").OnServerEvent:Connect(function()
			portalActivated = true
		end)

		print("✅ Телепортация настроена через SpawnLocation!")
	else
		warn("❌ Не найден SpawnLocation в portal_1 или portal_2!")
	end
else
	warn("❌ portal_1 или portal_2 не найдены!")
end
local function teleportPlayer(player, targetLocation, level)
	if player and player.Character then
		player.Character:SetPrimaryPartCFrame(targetLocation.CFrame)
		player:SetAttribute("CurrentLevel", level) -- Устанавливаем новый уровень
		print(player.Name .. " теперь в локации " .. level)
	end
end
