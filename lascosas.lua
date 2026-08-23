ocal Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "pPAPAPA",
    LoadingTitle = "A",
    LoadingSubtitle = "BY PAPAS",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local StatsTab = Window:CreateTab("Auto Stats", 4483362458)
StatsTab:CreateSection("Upgrade Settings")

local selectedstat = "vitality"
local autoStatsList = {
    "vitality", "healing", "strength", "energy", "flight", "speed",
    "climbing", "swinging", "fireball", "frost", "lightning", "power",
    "telekinesis", "shield", "laserVision", "metalSkin"
}

StatsTab:CreateDropdown({
    Name = "Select Stat",
    Options = autoStatsList,
    CurrentOption = "vitality",
    MultipleOptions = false,
    Flag = "SelectedStatFlag",
    Callback = function(Option)
        selectedstat = type(Option) == "table" and Option[1] or Option
        Rayfield:Notify({
            Title = "Stat Seleccionada",
            Content = "Has elegido: " .. tostring(selectedstat),
            Duration = 1.5
        })
    end,
})

local upgradeAmounts = {50, 100, 150, 300, 450, 600, 800, 1000, 1500, 2000, 3000, 6000, 8000, 10000, 15000, 20000, 30000, 40000}

-- Asignación segura del RemoteFunction
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventsFolder = ReplicatedStorage:WaitForChild("Events", 5)
local remote = eventsFolder and eventsFolder:WaitForChild("UpgradeAbility", 5)

if not remote then
    warn("No se encontró el RemoteFunction 'UpgradeAbility'")
end

for _, amount in ipairs(upgradeAmounts) do
    StatsTab:CreateButton({
        Name = "Upgrade " .. amount .. "x",
        Callback = function()
            if not selectedstat or not remote then return end

            task.spawn(function()
                for i = 1, amount do
                    task.spawn(function()
                        remote:InvokeServer(selectedstat)
                    end)
                    
                   
                    if i % 500 == 0 then
                        task.wait()
                    end
                end
            end)

            Rayfield:Notify({
                Title = "Ejecutando",
                Content = "Enviando " .. amount .. " peticiones...",
                Duration = 1.5
            })
        end,
    })
end
