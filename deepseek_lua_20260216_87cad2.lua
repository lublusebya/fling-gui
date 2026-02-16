-- Fling Gui with Players List
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-backups-for-games/main/backup_loader"))()

local Window = Library:CreateWindow("Fling Gui V2")
local Main = Window:CreateFolder("Main")

Main:Button("Fling All", function()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            local args = {
                [1] = v.Character.HumanoidRootPart,
                [2] = Vector3.new(9999,9999,9999)
            }
            game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
        end
    end
end)

Main:Toggle("Auto Fling", false, function(val)
    _G.AutoFling = val
    while _G.AutoFling do
        for i,v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                local args = {
                    [1] = v.Character.HumanoidRootPart,
                    [2] = Vector3.new(9999,9999,9999)
                }
                game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
            end
        end
        wait(0.1)
    end
end)

local PlayersFolder = Window:CreateFolder("Players")

PlayersFolder:Dropdown("Select Player", game.Players:GetPlayers(), function(plr)
    _G.Selected = plr
end)

PlayersFolder:Button("Fling Selected", function()
    if _G.Selected and _G.Selected.Character then
        local args = {
            [1] = _G.Selected.Character.HumanoidRootPart,
            [2] = Vector3.new(9999,9999,9999)
        }
        game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
    end
end)