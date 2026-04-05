-- AYARLAR
local mesafeSınırı = 50 -- Ne kadar yakındakilere saldırsın?
local vurusHizi = 0.2 -- Saldırı hızı (Saniye)

-- Saldırı Fonksiyonu
local function saldır(hedef)
    local karakter = game.Players.LocalPlayer.Character
    local root = karakter:FindFirstChild("HumanoidRootPart")
    
    if hedef and hedef:FindFirstChild("HumanoidRootPart") then
        -- Hedefe çok kısa süreliğine ışınlanma veya yaklaşma mantığı
        root.CFrame = hedef.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        
        -- OYUNA ÖZEL VURUŞ EVENTI (Bu kısım her oyunda farklıdır)
        -- Muscle Masters'ta genellikle 'Punch' veya 'Attack' isimli bir RemoteEvent tetiklenir.
        -- Örnek: game:GetService("ReplicatedStorage").Events.Punch:FireServer()
    end
end

-- Ana Döngü
task.spawn(function()
    while task.wait(vurusHizi) do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local hedefChar = player.Character
                local hum = hedefChar:FindFirstChild("Humanoid")
                
                if hum and hum.Health > 0 then
                    local mesafe = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - hedefChar.HumanoidRootPart.Position).Magnitude
                    
                    if mesafe <= mesafeSınırı then
                        saldır(hedefChar)
                    end
                end
            end
        end
    end
end)
