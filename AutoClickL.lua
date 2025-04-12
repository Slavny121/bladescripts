local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Создаем GUI для уведомления
local notification = Instance.new("ScreenGui")
notification.Name = "AutoClickerNotification"
notification.ResetOnSpawn = false
notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.08, 0)
frame.Position = UDim2.new(0.35, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.ClipsDescendants = true

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Успешно внедрен, активация автокликера - Z, деактивация аналогична! Приятной игры :D"
label.Font = Enum.Font.GothamBold
label.TextSize = 18
label.TextColor3 = Color3.new(1, 1, 1)
label.TextWrapped = true
label.Parent = frame

frame.Parent = notification
notification.Parent = PlayerGui

-- Анимация переливающегося текста
local function rainbowText()
    local t = 0
    while t < 10 do -- Длительность 10 секунд
        t += RunService.Heartbeat:Wait()
        local hue = (tick() * 0.5) % 1
        local color = Color3.fromHSV(hue, 0.8, 1)
        
        -- Черно-белый градиент (меняем только яркость)
        local brightness = (math.sin(tick() * 5) * 0.5 + 0.5)
        label.TextColor3 = Color3.new(brightness, brightness, brightness)
    end
    notification:Destroy()
end

coroutine.wrap(rainbowText)()

-- Автокликер
local autoclickerEnabled = false
local clickSpeed = 0.01
local connection = nil

local function rapidClick()
    if autoclickerEnabled then
        mouse1click()
        task.wait(clickSpeed)
    elseif connection then
        connection:Disconnect()
        connection = nil
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
        autoclickerEnabled = not autoclickerEnabled
        
        -- Создаем мини-уведомление при переключении
        local status = Instance.new("TextLabel")
        status.Text = autoclickerEnabled and "🟢 АВТОКЛИКЕР АКТИВИРОВАН" or "🔴 АВТОКЛИКЕР ВЫКЛЮЧЕН"
        status.Size = UDim2.new(0.2, 0, 0.05, 0)
        status.Position = UDim2.new(0.4, 0, 0.12, 0)
        status.BackgroundTransparency = 0.8
        status.TextColor3 = autoclickerEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        status.Parent = notification
        
        task.delay(2, function()
            status:Destroy()
        end)
        
        if autoclickerEnabled then
            connection = RunService.Heartbeat:Connect(rapidClick)
        end
    end
end)

print("✅ Автокликер готов! Активация - Z")