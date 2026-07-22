-- Приглашение в Discord (один раз)
local function Discord()
    pcall(function()
        if isfile and writefile and not isfile('invited_tirvoxhub.txt') then
            writefile('invited_tirvoxhub.txt', 'true')
            local discordInvite = "https://discord.gg/fhBzjgp78r"

            local http_request = (syn and syn.request) or (http and http.request) or request
            if http_request then
                http_request({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = {
                            code = string.match(discordInvite, "discord%.com/invite/(%w+)")
                        },
                        nonce = game:GetService("HttpService"):GenerateGUID(false)
                    })
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Executor Not Supported",
                    Text = "Join manually: " .. discordInvite,
                    Duration = 5
                })
            end
        end
    end)
end

Discord()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Список поддерживаемых игр и ссылок на скрипты
local supportedGames = {
    [537413528] = "https://raw.githubusercontent.com/tirvox/babft/main/farm1.lua",
    [13924946576] = "https://raw.githubusercontent.com/tirvox/tirvoxdingus/main/tirvoxdingus.lua",
    [134362540404764] = "https://raw.githubusercontent.com/tirvox/gendertirvoxhub/main/gendertirvoxhub1.lua"
}

local scriptUrl = supportedGames[game.PlaceId]

-- Если игра поддерживается, показываем GUI с ключ-системой
if scriptUrl then
    local CoreGui = game:GetService("CoreGui")
    
    -- Удаляем старый GUI если он есть
    if CoreGui:FindFirstChild("TirvoxKeySystem") then
        CoreGui.TirvoxKeySystem:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TirvoxKeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "Tirvox Hub | Key System"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.9, 0, 0, 40)
    textBox.Position = UDim2.new(0.05, 0, 0, 60)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Enter Key Here..."
    textBox.Text = ""
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Parent = mainFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox

    local getBtn = Instance.new("TextButton")
    getBtn.Size = UDim2.new(0.44, 0, 0, 40)
    getBtn.Position = UDim2.new(0.05, 0, 0, 120)
    getBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    getBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getBtn.Text = "Get Key"
    getBtn.Font = Enum.Font.GothamBold
    getBtn.TextSize = 14
    getBtn.Parent = mainFrame
    
    local getCorner = Instance.new("UICorner")
    getCorner.CornerRadius = UDim.new(0, 6)
    getCorner.Parent = getBtn

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.44, 0, 0, 40)
    checkBtn.Position = UDim2.new(0.51, 0, 0, 120)
    checkBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkBtn.Text = "Check Key"
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    checkBtn.Parent = mainFrame
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 6)
    checkCorner.Parent = checkBtn

    local function notify(title, text)
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 5})
    end

    -- Кнопка Get Key
    getBtn.MouseButton1Click:Connect(function()
        local discordInvite = "https://discord.gg/hmjXGKruX6"
        local http_request = (syn and syn.request) or (http and http.request) or request
        if http_request then
            http_request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "hmjXGKruX6"
                    },
                    nonce = HttpService:GenerateGUID(false)
                })
            })
        else
            if setclipboard then setclipboard(discordInvite) end
            notify("Discord", "Link copied to clipboard: " .. discordInvite)
        end
    end)

    -- Кнопка Check Key
    checkBtn.MouseButton1Click:Connect(function()
        if textBox.Text == "2026tirvoxhubkey" then
            notify("Success", "Key accepted! Loading script...")
            gui:Destroy()
            
            -- Загрузка скрипта
            local success, result = pcall(function()
                local data = game:HttpGet(scriptUrl)
                local f = loadstring(data)
                if f then
                    f()
                else
                    error("Invalid script (nil loadstring)")
                end
            end)
            
            if not success then
                local errMsg = result or "Unknown error"
                notify("Error", errMsg)
                warn("Ошибка загрузки скрипта: " .. scriptUrl .. "\n" .. errMsg)
            end
        else
            notify("Error", "Invalid Key!")
        end
    end)
else
    StarterGui:SetCore("SendNotification", {
        Title = "Game Not Supported",
        Text = "This game is not supported by Tirvox Hub",
        Duration = 5
    })
end
