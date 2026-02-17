--[[
    ███████╗██╗     ██╗███╗   ██╗ ██████╗     ██████╗ ██╗   ██╗██╗
    ██╔════╝██║     ██║████╗  ██║██╔════╝     ██╔══██╗██║   ██║██║
    █████╗  ██║     ██║██╔██╗ ██║██║  ███╗    ██████╔╝██║   ██║██║
    ██╔══╝  ██║     ██║██║╚██╗██║██║   ██║    ██╔══██╗██║   ██║██║
    ██║     ███████╗██║██║ ╚████║╚██████╔╝    ██████╔╝╚██████╔╝██║
    ╚═╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝
    made by tensor0101
    UI: Kavo (стабильный)
]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Загрузка Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fling GUI | tensor0101", "DarkTheme")

-- Переменные
_G.AutoFling = false
_G.Selected = nil
_G.FlingPower = 9999
_G.FlingMethod = "Vector"

-- Поиск RemoteEvent
local RemoteEvents = {}
local function RefreshEvents()
    RemoteEvents = {}
    for _, child in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        if child:IsA("RemoteEvent") then
            table.insert(RemoteEvents, child)
        end
    end
end
RefreshEvents()
game:GetService("ReplicatedStorage").ChildAdded:Connect(function(c)
    if c:IsA("RemoteEvent") then table.insert(RemoteEvents, c) end
end)

-- Функция флинга
local function fling(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.Character.HumanoidRootPart
    local power = _G.FlingPower
    local args
    if _G.FlingMethod == "Vector" then
        args = {hrp, Vector3.new(power, power, power)}
    else
        args = {hrp, Vector3.new(power*100, power*100, power*100)}
    end
    for _, event in ipairs(RemoteEvents) do
        pcall(function()
            event:FireServer(unpack(args))
        end)
    end
end

-- Вкладки
local MainTab = Window:NewTab("Main")
local PlayersTab = Window:NewTab("Players")
local SettingsTab = Window:NewTab("Settings")

-- Секции
local MainSection = MainTab:NewSection("Основное")
local PlayersSection = PlayersTab:NewSection("Выбор цели")
local SettingsSection = SettingsTab:NewSection("Настройки флинга")

-- Main
MainSection:NewButton("Fling All", "Кинуть всех", function()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            fling(plr)
        end
    end
end)

MainSection:NewToggle("Auto Fling", "Автоматический флинг", function(val)
    _G.AutoFling = val
    if val then
        coroutine.wrap(function()
            while _G.AutoFling do
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= game.Players.LocalPlayer then
                        fling(plr)
                    end
                end
                task.wait(0.05)
            end
        end)()
    end
end)

MainSection:NewButton("Stop Fling", "Остановить автофлинг", function()
    _G.AutoFling = false
end)

-- Players
local playerDropdown = PlayersSection:NewDropdown("Выбери игрока", "Игрок для флинга", {}, function(val)
    _G.Selected = game.Players:FindFirstChild(val)
end)

local function updatePlayerList()
    local list = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    playerDropdown:Refresh(list)
end
updatePlayerList()

PlayersSection:NewButton("Fling Selected", "Кинуть выбранного", function()
    if _G.Selected then
        fling(_G.Selected)
    end
end)

PlayersSection:NewButton("Refresh List", "Обновить список", updatePlayerList)

-- Settings
SettingsSection:NewDropdown("Метод флинга", "Vector или Velocity", {"Vector", "Velocity"}, function(val)
    _G.FlingMethod = val
end)

SettingsSection:NewSlider("Мощность", "Сила флинга", 1000, 100000, function(val)
    _G.FlingPower = val
end)

SettingsSection:NewButton("Destroy GUI", "Уничтожить окно", function()
    Library:Destroy()
end)

-- Обновление списка при изменениях
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

print("Fling GUI by tensor0101 (Kavo) загружен. Наслаждайся.")
