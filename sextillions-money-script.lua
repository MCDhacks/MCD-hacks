-- ============================================================================
-- 🌌 SCRIPT DE SERVIDOR: FORMATO SEXTILLONES (9,999,999,999 SX)
-- ============================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("DarDineroEvent")

-- 1. Crear el marcador de dinero al entrar al juego
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local dinero = Instance.new("NumberValue")
	dinero.Name = "Dinero"
	dinero.Value = 0
	dinero.Parent = leaderstats
end)

-- 2. Escuchar el clic y otorgar los 9,999,999,999 Sx
RemoteEvent.OnServerEvent:Connect(function(player)
	local stats = player:FindFirstChild("leaderstats")
	if stats then
		local dineroContador = stats:FindFirstChild("Dinero")
		if dineroContador then
			-- Definimos la cantidad exacta en Sextillones de forma limpia
			local cantidadSx = 9999999999000000000000000000000
			dineroContador.Value = dineroContador.Value + cantidadSx
		end
	end
end)
