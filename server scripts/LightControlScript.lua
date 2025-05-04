local lightEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
lightEvent.Name = "LightEvent"

lightEvent.OnServerEvent:Connect(function(player)
	-- Включаем все SpotLight в Level_1 (уличные лампы)
	for _, lamp in ipairs(workspace.level_1:GetDescendants()) do
		if lamp:IsA("SpotLight") then
			lamp.Enabled = true
		end
	end

	-- Включаем все SurfaceLight в здании
	for _, light in ipairs(workspace.level_1:GetDescendants()) do
		if light:IsA("SurfaceLight") then
			light.Enabled = true
		end
	end
	
	for _, WindowLight_Fake in ipairs(workspace.level_1.City:GetDescendants()) do
		if WindowLight_Fake:IsA("Beam") then
			WindowLight_Fake.Enabled = true
		end
	end
	
	print("Свет включен у ламп и здания!")
end)
