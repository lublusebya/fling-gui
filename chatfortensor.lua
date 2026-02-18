-- Universal Chat GUI Script (No Censorship)
-- Creator: tensor0101 (Discord: tensor0101)

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ChatGUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Основное окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 330) -- чуть выше, чтобы поместилась надпись
frame.Position = UDim2.new(0.5, -200, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Заголовок с именем автора
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.BackgroundTransparency = 0.3
title.BorderSizePixel = 0
title.Text = "  Чат (RAGE mode) — by tensor0101 💖"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Область чата
local chatList = Instance.new("ScrollingFrame")
chatList.Size = UDim2.new(1, -20, 1, -110) -- поднял, чтобы освободить место для надписи
chatList.Position = UDim2.new(0, 10, 0, 40)
chatList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
chatList.BackgroundTransparency = 0.2
chatList.BorderSizePixel = 0
chatList.CanvasSize = UDim2.new(0, 0, 0, 0)
chatList.ScrollBarThickness = 8
chatList.AutomaticCanvasSize = Enum.AutomaticSize.Y
chatList.Parent = frame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = chatList

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = chatList

-- Поле ввода
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -90, 0, 30)
inputBox.Position = UDim2.new(0, 10, 1, -70)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.BackgroundTransparency = 0.2
inputBox.BorderSizePixel = 0
inputBox.PlaceholderText = "Введите сообщение (без ограничений)..."
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- Кнопка отправки
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 70, 0, 30)
sendBtn.Position = UDim2.new(1, -80, 1, -70)
sendBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
sendBtn.BackgroundTransparency = 0.2
sendBtn.BorderSizePixel = 0
sendBtn.Text = "Отправить"
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.TextSize = 14
sendBtn.Font = Enum.Font.GothamSemibold
sendBtn.Parent = frame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendBtn

-- Надпись с автором и дискордом внизу
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, -20, 0, 20)
creditLabel.Position = UDim2.new(0, 10, 1, -30)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Создатель: tensor0101 (Discord: tensor0101) 💖"
creditLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditLabel.TextSize = 12
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextXAlignment = Enum.TextXAlignment.Center
creditLabel.Parent = frame

local function addMessage(text)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -10, 0, 20)
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.TextColor3 = Color3.fromRGB(255, 255, 255)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.Parent = chatList
end

local function sendMessage()
    local text = inputBox.Text
    if text ~= "" then
        addMessage(player.Name .. ": " .. text)
        inputBox.Text = ""
    end
end

sendBtn.MouseButton1Click:Connect(sendMessage)
inputBox.FocusLost:Connect(function(enter)
    if enter then
        sendMessage()
    end
end)

addMessage("Добро пожаловать. Чат без цензуры от tensor0101.")
