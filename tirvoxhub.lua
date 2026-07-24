-- Приглашение в Discord (один раз)
local function Discord()
    pcall(function()
        if isfile and writefile and not isfile('invited_tirvoxhub.txt') then
            writefile('invited_tirvoxhub.txt', 'true')
            local discordInvite = "https://discord.gg/fhBzjgp78r"
            local http_request = (syn and syn.request) or (http and http.request) or request
            if http_request then
                pcall(function()
                    http_request({
                        Url = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com"
                        },
                        Body = game:GetService("HttpService"):JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = { code = "fhBzjgp78r" },
                            nonce = game:GetService("HttpService"):GenerateGUID(false)
                        })
                    })
                end)
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

-- Если игра поддерживается
if scriptUrl then
    local AequorUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/hnwiie/AequorUI/main/main.lua"))()

    if not AequorUI then
        StarterGui:SetCore("SendNotification", {
            Title = "Ошибка",
            Text = "Не удалось загрузить AequorUI! Проверь ссылку или интернет.",
            Duration = 10
        })
        return
    end

    local screenGui = AequorUI.GeneralUI:CreateMain(Enum.KeyCode.L, "Aqua")
    local mainFrame = screenGui:WaitForChild("MainFrame")
    local divider   = mainFrame:WaitForChild("Divider")

    local myTabs = AequorUI.TabManager:Init(mainFrame)
    local tab1, container1 = myTabs:CreateTab("Profile", "Human", 1)

    -- ══════════════════════════════════════════
    --  GITHUB AUTH SYSTEM (Nickname / Password)
    -- ══════════════════════════════════════════
    
    local function notify(title, text)
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 5})
    end

    -- Чтение сохранённых данных
    local savedNick = ""
    local savedPass = ""
    local authFile = "tirvox_auth.txt"
    if isfile and readfile and isfile(authFile) then
        local content = readfile(authFile)
        local n, p = content:match("^(.-)\n(.-)$")
        if n and p then
            savedNick = n
            savedPass = p
        end
    end

    AequorUI.ElementManager:CreateParagraph(container1, "Авторизация", "Войдите в аккаунт, чтобы загрузить скрипт.")

    -- Кастомная функция для красивых полей ввода
    local function CreateCustomInput(container, placeholder, defaultText)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(1, 0, 0, 45)
        holder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        holder.BorderSizePixel = 0
        holder.Parent = container
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
        
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -30, 1, 0)
        box.Position = UDim2.new(0, 15, 0, 0)
        box.BackgroundTransparency = 1
        box.Text = defaultText or ""
        box.PlaceholderText = placeholder
        box.Font = Enum.Font.Gotham
        box.TextSize = 15
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.Parent = holder
        
        return box
    end

    -- Создаём поля ввода и подставляем сохранённые данные
    local nickBox = CreateCustomInput(container1, "Введите Nickname...", savedNick)
    local passBox = CreateCustomInput(container1, "Введите Password...", savedPass)

    -- Кнопка Login
    AequorUI.ElementManager:CreateButton(container1, "Login", "Войти и загрузить скрипт", function()
        local nick = nickBox.Text
        local pass = passBox.Text
        if nick ~= "" and pass ~= "" then
            local GITHUB_RAW = "https://raw.githubusercontent.com/tirvox/tirvoxhub-base/main/profiles/%s.json"
            local url = string.format(GITHUB_RAW, nick)
            local success, response = pcall(function() return game:HttpGet(url) end)
            
            if success and response ~= "404: Not Found" then
                local data = HttpService:JSONDecode(response)
                if data.password == pass then
                    notify("Success", "Вход выполнен! Загрузка скрипта...")
                    
                    -- Сохраняем ник и пароль для следующего раза
                    if writefile then
                        writefile(authFile, nick .. "\n" .. pass)
                    end
                    
                    screenGui:Destroy()
                    
                    -- Загрузка основного скрипта
                    local loadSuccess, result = pcall(function()
                        local scriptData = game:HttpGet(scriptUrl)
                        local f = loadstring(scriptData)
                        if f then
                            f()
                        else
                            error("Invalid script (nil loadstring)")
                        end
                    end)
                    
                    if not loadSuccess then
                        local errMsg = result or "Unknown error"
                        notify("Error", errMsg)
                        warn("Ошибка загрузки скрипта: " .. scriptUrl .. "\n" .. errMsg)
                    end
                else
                    notify("Error", "Неверный пароль.")
                end
            else
                notify("Error", "Профиль не найден.")
            end
        else
            notify("Error", "Заполните все поля.")
        end
    end)

    -- Кнопка Discord (Открывает приглашение или копирует)
    AequorUI.ElementManager:CreateButton(container1, "Discord", "Присоединиться к серверу.", function()
        local discordInvite = "https://discord.gg/hmjXGKruX6"
        local inviteCode = "hmjXGKruX6"
        local http_request = (syn and syn.request) or (http and http.request) or request
        local opened = false
        
        if http_request then
            local success = pcall(function()
                http_request({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = HttpService:JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = { code = inviteCode },
                        nonce = HttpService:GenerateGUID(false)
                    })
                })
                opened = true
            end)
        end
        
        -- Если RPC не сработал (экзекутор блокирует localhost или нет приложения)
        if not opened then
            if setclipboard then 
                setclipboard(discordInvite) 
                notify("Discord", "Ссылка скопирована! Вставь её в браузер (Ctrl+V).")
            else
                notify("Discord", "Ссылка: " .. discordInvite)
            end
        end
    end)

    -- ══════════════════════════════════════════
    --  THEME & ICONS
    -- ══════════════════════════════════════════

    AequorUI.ThemeManager:SetTheme("Aqua", mainFrame)
    AequorUI.ThemeManager:SetTransparency(0.3, mainFrame)
    AequorUI.ThemeManager:SetAcrylic(false, screenGui)
    AequorUI.ThemeManager:SetComponentColor("Selection", Color3.fromRGB(255, 255, 255), { myTabs.SelectionBar })
    AequorUI.ThemeManager:SetComponentColor("Boundary", Color3.fromRGB(255, 255, 255), { myTabs.BoundaryLine, divider })
    AequorUI.ThemeManager:SetComponentColor("Glow", Color3.fromRGB(255, 255, 255), { tab1:WaitForChild("Glow") })
    AequorUI.ThemeManager:SetComponentTransparency("Boundary", 0.8, { myTabs.BoundaryLine, divider })
    AequorUI.IconManager:SetIconColor(Color3.fromRGB(255, 255, 255), { tab1:WaitForChild("Icon") })

    print("AequorUI Auth System loaded.")
else
    StarterGui:SetCore("SendNotification", {
        Title = "Game Not Supported",
        Text = "This game is not supported by Tirvox Hub",
        Duration = 5
    })
end
