-- AYARLAR
local mesafeSiniri = 50 -- Ne kadar yakındaki oyunculara gitsin?
local vurusHizi = 0.1 -- Vuruş hızı (Daha düşük = Daha hızlı)

-- Servisler
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer

-- Vuruş Sinyalini Bulma (Muscle Masters için yaygın eventler)
local punchEvent = replicatedStorage:FindFirstChild("PunchEvent") or replicatedStorage:FindFirstChild("Attack") or replicatedStorage:FindFirstChild("Punch")

local function enYakinOyuncuyuBul()
    local enYakinMesafe = mesafeSiniri
    local hedef = nil
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local mesafe = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if mesafe < enYakinMesafe then
                    enYakinMesafe = mesafe
                    hedef = player.Character
                end
            end
        end
    end
    return hedef
end

-- Ana Döngü
task.spawn(function()
    while task.wait(vurusHizi) do
        local hedefKarakter = enYakinOyuncuyuBul()
        
        if hedefKarakter and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Hedefin arkasına ışınlan (3 stud arkası)
            localPlayer.Character.HumanoidRootPart.CFrame = hedefKarakter.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            
            -- Vuruş Sinyali Gönder
            if punchEvent then
                punchEvent:FireServer()
            end
        end
    end
end)

print("Auto-Kill Sistemi Aktif!")
