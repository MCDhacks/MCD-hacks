-- ============================================================================
-- 🎯 YEET A FRIEND - SCRIPT COMPLETO
-- ============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ⚡ CONFIGURACIÓN
local THROW_POWER = 100  -- Fuerza de lanzamiento
local AUTO_YEET = false
local SPEED_BOOST = false

print("🎯 YEET A FRIEND Script Cargado!")

-- 1. FUNCIÓN PARA LANZAR JUGADORES
local function yeeterPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        -- Aplicar velocidad para lanzar
        local throwVelocity = (targetRoot.Position - rootPart.Position).Unit * THROW_POWER
        
        -- Si es de Roblox 0.18+, usar AssemblyLinearVelocity
        if targetRoot:FindFirstChild("BodyVelocity") then
            targetRoot.BodyVelocity.Velocity = throwVelocity * 2
        else
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = throwVelocity * 2
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = targetRoot
            game:GetService("Debris"):AddItem(bv, 0.1)
        end
        
        print("🎯 ¡Lanzado: " .. targetPlayer.Name .. "!")
    end
end

-- 2. SPEED BOOST (opcional)
function applySpeedBoost()
    if SPEED_BOOST then
        humanoid.WalkSpeed = 25  -- Velocidad normal es 16
    else
        humanoid.WalkSpeed = 16
    end
end

-- 3. AUTO-YEET (lanzar automáticamente a todos cerca)
RunService.Heartbeat:Connect(function()
    if AUTO_YEET then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot and (targetRoot.Position - rootPart.Position).Magnitude < 50 then
                    yeeterPlayer(p)
                end
            end
        end
    end
    applySpeedBoost()
end)

-- 4. CONTROLES DE TECLADO
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- E = Lanzar al jugador más cercano
    if input.KeyCode == Enum.KeyCode.E then
        local closest = nil
        local closestDist = 100
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local dist = (p.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if dist < closestDist then
                    closest = p
                    closestDist = dist
                end
            end
        end
        
        if closest then
            yeeterPlayer(closest)
        end
    end
    
    -- R = Toggle Auto-Yeet
    if input.KeyCode == Enum.KeyCode.R then
        AUTO_YEET = not AUTO_YEET
        print(AUTO_YEET and "✅ Auto-Yeet ACTIVADO" or "❌ Auto-Yeet DESACTIVADO")
    end
    
    -- T = Toggle Speed Boost
    if input.KeyCode == Enum.KeyCode.T then
        SPEED_BOOST = not SPEED_BOOST
        print(SPEED_BOOST and "⚡ Speed Boost ACTIVADO" or "❌ Speed Boost DESACTIVADO")
    end
    
    -- F = Aumentar fuerza de lanzamiento
    if input.KeyCode == Enum.KeyCode.F then
        THROW_POWER = THROW_POWER + 10
        print("💪 Fuerza de lanzamiento: " .. THROW_POWER)
    end
    
    -- G = Disminuir fuerza de lanzamiento
    if input.KeyCode == Enum.KeyCode.G then
        THROW_POWER = math.max(10, THROW_POWER - 10)
        print("💪 Fuerza de lanzamiento: " .. THROW_POWER)
    end
end)

-- 5. Recargar stats al respawnear
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    print("🔄 Script reactivado después del respawn!")
end)

-- 6. GUI DE CONTROLES
print("🎮 CONTROLES:")
print("E = Lanzar jugador más cercano")
print("R = Toggle Auto-Yeet")
print("T = Toggle Speed Boost")
print("F = Aumentar fuerza (+10)")
print("G = Disminuir fuerza (-10)")
print("═══════════════════════════════════════")
