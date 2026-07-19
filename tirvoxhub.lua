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

-- Загрузка скриптов под конкретные игры
if game.PlaceId == 537413528 then -- Build A Boat For Treasure 🌊
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tirvox/babft/main/farm1.lua'))()
elseif game.PlaceId == 13924946576 then -- Dingus 🔧
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tirvox/tirvoxdingus/main/tirvoxdingus.lua'))()
end
