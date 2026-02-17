--[[
    ███████╗██╗     ██╗███╗   ██╗ ██████╗     ██████╗ ██╗   ██╗██╗
    ██╔════╝██║     ██║████╗  ██║██╔════╝     ██╔══██╗██║   ██║██║
    █████╗  ██║     ██║██╔██╗ ██║██║  ███╗    ██████╔╝██║   ██║██║
    ██╔══╝  ██║     ██║██║╚██╗██║██║   ██║    ██╔══██╗██║   ██║██║
    ██║     ███████╗██║██║ ╚████║╚██████╔╝    ██████╔╝╚██████╔╝██║
    ╚═╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝
    made by tensor0101
]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Загрузка Linoria с кучей запасных ссылок (чтоб наверняка)
local Library
local links = {
    "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/library.lua",
    "https://raw.githubusercontent.com/realredz/BloxFruits/main/Source/LinoriaLib/library.lua",
    "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/library.lua",
    "https://raw.githubusercontent.com/ArriBRO/LinoriaLib/main/library.lua",
    "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" -- IY как запасной вариант
}

for _, link in ipairs(links) do
    local success, res = pcall(function()
        return loadstring(game:HttpGet(link))()
    end)
    if success and res then
        Library = res
        break
    end
end

if not Library then
    error("Не удалось загрузить библиотеку, мудак. Качай Solara.")
end

-- Создание окна с красивыми настройками
local Window = Library:CreateWindow({
    Title = "Fling GUI | tensor0101",
    Center = true,
    AutoShow = true,
    Resizable = false,
    ShowCustomCursor = true,
    Keybind = "RightControl",
    Size = UDim2.fromOffset(500, 400),
    Transparency = 0.1,  -- Лёгкая прозрачность для стиля
})

-- Плавное появление
Window.Frame.BackgroundTransparency = 1
Window.Frame:TweenPosition(UDim2.new(0.5, -250, 0.5, -200), "Out", "Quad", 0.4, true)
for i = 1, 10 do
    Window.Frame.BackgroundTransparency = 1 - i/10
    task.wait(0.02)
end

-- Переменные
_G.AutoFling = false
_G.Selected = nil
_G.FlingPower = 9999  -- базовая сила
_G.FlingMethod = "Vector" -- Vector или Velocity

-- Функция поиска событий (кешируем для скорости)
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

-- Функция флинга с выбором силы
local function fling(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.Character.HumanoidRootPart
    local power = _G.FlingPower
    local args
    if _G.FlingMethod == "Vector" then
        args = {hrp, Vector3.new(power, power, power)}
    else
        -- Velocity метод: задаём бешеную скорость
        args = {hrp, Vector3.new(power*100, power*100, power*100)}
    end
    for _, event in ipairs(RemoteEvents) do
        pcall(function()
            event:FireServer(unpack(args))
        end)
    end
end

-- Вкладки
local MainTab = Window:AddTab("Main")
local PlayersTab = Window:AddTab("Players")
local SettingsTab = Window:AddTab("Settings")

-- ===== Main вкладка =====
local MainSection = MainTab:AddLeftGroupbox("Основное")

MainSection:AddButton({
    Text = "Fling All",
    Func = function()
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                fling(plr)
            end
        end
    end
})

MainSection:AddToggle({
    Text = "Auto Fling",
    Default = false,
    Callback = function(val)
        _G.AutoFling = val
        if val then
            coroutine.wrap(function()
                while _G.AutoFling do
                    for _, plr in ipairs(game.Players:GetPlayers()) do
                        if plr ~= game.Players.LocalPlayer then
                            fling(plr)
                        end
                    end
                    task.wait(0.05)  -- чаще спамим = сильнее эффект
                end
            end)()
        end
    end
})

MainSection:AddButton({
    Text = "Stop Fling",
    Func = function()
        _G.AutoFling = false
    end
})

-- ===== Players вкладка =====
local PlayersSection = PlayersTab:AddLeftGroupbox("Выбор цели")

local playerDropdown
local function updatePlayerList()
    local list = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    if playerDropdown then
        playerDropdown:SetValues(list)
    end
end

playerDropdown = PlayersSection:AddDropdown({
    Text = "Игрок",
    Values = {},
    Default = 1,
    Callback = function(value)
        _G.Selected = game.Players:FindFirstChild(value)
    end
})

PlayersSection:AddButton({
    Text = "Fling Selected",
    Func = function()
        if _G.Selected then
            fling(_G.Selected)
        end
    end
})

PlayersSection:AddButton({
    Text = "Refresh List",
    Func = updatePlayerList
})

-- ===== Settings вкладка =====
local SettingsSection = SettingsTab:AddLeftGroupbox("Настройки флинга")

SettingsSection:AddDropdown({
    Text = "Метод",
    Values = {"Vector", "Velocity"},
    Default = 1,
    Callback = function(val)
        _G.FlingMethod = val
    end
})

SettingsSection:AddSlider({
    Text = "Мощность",
    Min = 1000,
    Max = 100000,
    Default = 9999,
    Rounding = 0,
    Compact = false,
    Callback = function(val)
        _G.FlingPower = val
    end
})

SettingsSection:AddButton({
    Text = "Уничтожить гуй",
    Func = function()
        Window:Destroy()
    end
})

-- ===== Добавляем визуальные плюшки =====
-- Подпись tensor0101 жирным шрифтом
local credit = Instance.new("TextLabel")
credit.Parent = Window.Frame
credit.BackgroundTransparency = 1
credit.Position = UDim2.new(0, 10, 1, -30)
credit.Size = UDim2.new(1, -20, 0, 25)
credit.Text = "сделано tensor0101"
credit.TextColor3 = Color3.fromRGB(255, 255, 255)
credit.TextTransparency = 0.4
credit.TextXAlignment = "Right"
credit.Font = "GothamBlack"
credit.TextSize = 14
credit.TextStrokeTransparency = 0.8
credit.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Анимации для всех кнопок (плавное увеличение и подсветка)
for _, btn in ipairs(Window.Frame:DescendantInstances()) do
    if btn:IsA("TextButton") then
        btn.MouseEnter:Connect(function()
            btn:TweenSize(UDim2.new(1, 0, 0, 38), "Out", "Quad", 0.15)
            btn:TweenPosition(UDim2.new(0, 0, 0, -4), "Out", "Quad", 0.15)
            btn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        end)
        btn.MouseLeave:Connect(function()
            btn:TweenSize(UDim2.new(1, 0, 0, 30), "Out", "Quad", 0.15)
            btn:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end

-- Обновление списка игроков при старте и изменениях
updatePlayerList()
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Обновление событий при добавлении новых
game:GetService("ReplicatedStorage").ChildAdded:Connect(function(c)
    if c:IsA("RemoteEvent") then
        table.insert(RemoteEvents, c)
    end
end)

print("Fling GUI by tensor0101 загружен. Должно флингать, если нет — иди нахуй.")
