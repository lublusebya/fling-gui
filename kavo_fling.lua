--[[
    ███████╗██╗     ██╗███╗   ██╗ ██████╗     ██████╗ ██╗   ██╗██╗
    ██╔════╝██║     ██║████╗  ██║██╔════╝     ██╔══██╗██║   ██║██║
    █████╗  ██║     ██║██╔██╗ ██║██║  ███╗    ██████╔╝██║   ██║██║
    ██╔══╝  ██║     ██║██║╚██╗██║██║   ██║    ██╔══██╗██║   ██║██║
    ██║     ███████╗██║██║ ╚████║╚██████╔╝    ██████╔╝╚██████╔╝██║
    ╚═╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝
    made by tensor0101
    UI: Fluent (красивый и плавный)
]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Загрузка Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fling GUI | tensor0101",
    SubTitle = "by tensor0101",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 400),
    Acrylic = true, -- Плавное размытие
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Переменные
_G.AutoFling = false
_G.Selected = nil
_G.FlingPower = 9999
_G.FlingMethod = "Vector"
_G.CustomEventName = ""

-- Поиск всех RemoteEvent и RemoteFunction (во всех сервисах)
local AllRemotes = {}
local function RefreshRemotes()
    AllRemotes = {}
    local services = {
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        game:GetService("Players"),
        game:GetService("Lighting"),
        game:GetService("ServerScriptService"),
        game:GetService("ServerStorage")
    }
    for _, service in ipairs(services) do
        for _, child in ipairs(service:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(AllRemotes, child)
            end
        end
    end
end
RefreshRemotes()

-- Автообновление ремоутов
game:GetService("ReplicatedStorage").ChildAdded:Connect(function(c)
    if c:IsA("RemoteEvent") or c:IsA("RemoteFunction") then table.insert(AllRemotes, c) end
end)

-- Функция флинга (мультиметод)
local function fling(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.Character.HumanoidRootPart
    local power = _G.FlingPower

    -- Генерация аргументов в зависимости от метода
    local args_list = {}
    if _G.FlingMethod == "Vector" then
        args_list = {
            {hrp, Vector3.new(power, power, power)},
            {hrp, CFrame.new(hrp.Position + Vector3.new(power, power, power))},
            {hrp, power}
        }
    elseif _G.FlingMethod == "Velocity" then
        args_list = {
            {hrp, Vector3.new(power*100, power*100, power*100)},
            {hrp, Vector3.new(power*50, power*1000, power*50)},
            {hrp, hrp.Velocity + Vector3.new(power*100, power*100, power*100)}
        }
    elseif _G.FlingMethod == "BodyVelocity" then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(power*100, power*100, power*100)
        args_list = {{hrp, bv}}
    else -- Custom
        args_list = {{hrp, Vector3.new(power, power, power)}}
    end

    -- Отправка во все ремоты всеми возможными аргументами
    for _, event in ipairs(AllRemotes) do
        for _, args in ipairs(args_list) do
            pcall(function()
                if event:IsA("RemoteEvent") then
                    event:FireServer(unpack(args))
                else
                    event:InvokeServer(unpack(args))
                end
            end)
        end
    end

    -- Если указано кастомное событие
    if _G.CustomEventName ~= "" then
        local customEvent = game:GetService("ReplicatedStorage"):FindFirstChild(_G.CustomEventName)
        if customEvent and (customEvent:IsA("RemoteEvent") or customEvent:IsA("RemoteFunction")) then
            for _, args in ipairs(args_list) do
                pcall(function()
                    if customEvent:IsA("RemoteEvent") then
                        customEvent:FireServer(unpack(args))
                    else
                        customEvent:InvokeServer(unpack(args))
                    end
                end)
            end
        end
    end
end

-- Вкладки
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local PlayersTab = Window:AddTab({ Title = "Players", Icon = "users" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- Параграф с информацией
MainTab:AddParagraph({
    Title = "Fling GUI",
    Content = "Сделано tensor0101\nФлинг во все ремоты всеми способами"
})

-- Main
MainTab:AddButton({
    Title = "Fling All",
    Description = "Кинуть всех игроков",
    Callback = function()
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                fling(plr)
            end
        end
    end
})

MainTab:AddToggle("AutoFling", {
    Title = "Auto Fling",
    Description = "Автоматический флинг",
    Default = false,
    Callback = function(val)
        _G.AutoFling = val
        if val then
            task.spawn(function()
                while _G.AutoFling do
                    for _, plr in ipairs(game.Players:GetPlayers()) do
                        if plr ~= game.Players.LocalPlayer then
                            fling(plr)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})

MainTab:AddButton({
    Title = "Stop Auto Fling",
    Description = "Остановить автоматический флинг",
    Callback = function()
        _G.AutoFling = false
    end
})

-- Players
local PlayersSection = PlayersTab:AddSection("Выбор цели")

local playerDropdown = PlayersSection:AddDropdown("PlayerDropdown", {
    Title = "Выбери игрока",
    Values = {},
    Multi = false,
    Default = "",
    Description = "Игрок для флинга",
    Callback = function(val)
        _G.Selected = game.Players:FindFirstChild(val)
    end
})

local function updatePlayerList()
    local list = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    playerDropdown:SetValues(list)
end
updatePlayerList()

PlayersSection:AddButton({
    Title = "Fling Selected",
    Description = "Кинуть выбранного игрока",
    Callback = function()
        if _G.Selected then
            fling(_G.Selected)
        end
    end
})

PlayersSection:AddButton({
    Title = "Refresh List",
    Description = "Обновить список игроков",
    Callback = updatePlayerList
})

-- Settings
local SettingsSection = SettingsTab:AddSection("Настройки флинга")

SettingsSection:AddDropdown("FlingMethod", {
    Title = "Метод",
    Values = { "Vector", "Velocity", "BodyVelocity", "Custom" },
    Default = "Vector",
    Description = "Способ флинга",
    Callback = function(val)
        _G.FlingMethod = val
    end
})

SettingsSection:AddSlider("FlingPower", {
    Title = "Мощность",
    Description = "Сила флинга",
    Default = 9999,
    Min = 1000,
    Max = 100000,
    Rounding = 0,
    Callback = function(val)
        _G.FlingPower = val
    end
})

SettingsSection:AddInput("CustomEvent", {
    Title = "Кастомное событие",
    Description = "Название RemoteEvent (если не находит автоматически)",
    Default = "",
    Placeholder = "Например: MainEvent",
    Numeric = false,
    Finished = false,
    Callback = function(val)
        _G.CustomEventName = val
    end
})

SettingsSection:AddButton({
    Title = "Refresh Remotes",
    Description = "Пересканировать все удалённые события",
    Callback = RefreshRemotes
})

SettingsSection:AddButton({
    Title = "Destroy GUI",
    Description = "Уничтожить окно",
    Callback = function()
        Window:Destroy()
    end
})

-- Обновление списка игроков при изменениях
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Настройки сохранения (опционально)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FlingGUI")
SaveManager:SetFolder("FlingGUI/specific")
InterfaceManager:BuildInterfaceSection(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)

Window:SelectTab(1)

print("Fling GUI by tensor0101 (Fluent) загружен. Если не флингует — иди в другие игры.")
