-- Fling Gui для любых исполнителей
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zzerexx/scripts/main/loader.lua"))()

local Window = Library:CreateWindow("Fling Gui V2")
local Main = Window:CreateFolder("Main")

Main:Button("Fling All", function()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            pcall(function()
                local args = {
                    [1] = v.Character.HumanoidRootPart,
                    [2] = Vector3.new(9999,9999,9999)
                }
                for _,e in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                    if e:IsA("RemoteEvent") then
                        pcall(function()
                            e:FireServer(unpack(args))
                        end)
                    end
                end
            end)
        end
    end
end)

Main:Toggle("Auto Fling", false, function(val)
    _G.AutoFling = val
    coroutine.wrap(function()
        while _G.AutoFling do
            for i,v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer then
                    pcall(function()
                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local args = {
                                [1] = v.Character.HumanoidRootPart,
                                [2] = Vector3.new(9999,9999,9999)
                            }
                            for _,e in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                                if e:IsA("RemoteEvent") then
                                    pcall(function()
                                        e:FireServer(unpack(args))
                                    end)
                                end
                            end
                        end
                    end)
                end
            end
            wait(0.1)
        end
    end)()
end)

local PlayersFolder = Window:CreateFolder("Players")

local function UpdatePlayerList()
    local list = {}
    for i,v in pairs(game.Players:GetPlayers()) do
        table.insert(list, v.Name)
    end
    return list
end

PlayersFolder:Dropdown("Select Player", UpdatePlayerList(), function(name)
    _G.Selected = game.Players:FindFirstChild(name)
end)

PlayersFolder:Button("Fling Selected", function()
    if _G.Selected and _G.Selected.Character then
        pcall(function()
            local args = {
                [1] = _G.Selected.Character.HumanoidRootPart,
                [2] = Vector3.new(9999,9999,9999)
            }
            for _,e in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if e:IsA("RemoteEvent") then
                    pcall(function()
                        e:FireServer(unpack(args))
                    end)
                end
            end
        end)
    end
end)

PlayersFolder:Button("Refresh", function()
    PlayersFolder:Dropdown("Select Player", UpdatePlayerList(), function(name)
        _G.Selected = game.Players:FindFirstChild(name)
    end)
end)
