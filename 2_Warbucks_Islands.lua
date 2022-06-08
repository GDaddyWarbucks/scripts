-- Kavo UI help library https://xheptcofficial.gitbook.io/kavo-library/

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Toggle UI window
Section:NewKeybind("KeybindText", "KebindInfo", Enum.KeyCode.LeftAlt, function()
    --Library:ToggleUI()
    print("You just clicked the bind")
end)

local Window = Library.CreateLib("Midnight Hub", "Ocean")

local Tab = Window:NewTab("Machinery")

local Section = Tab:NewSection("Smelting")

Section:NewToggle("Smelt Ore with Chests", "ToggleInfo", function(state)
    if state then

        _G.AutoSmeltEnabled = true

        spawn(function()
            
            while wait(0.5) and _G.AutoSmeltEnabled do

                    -- change the 20 to increase or decrease the distance from you
                    for _, v in pairs(findNearSmelters(20)) do
                        local smelter = v
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = smelter.CFrame + Vector3.new(0, 10, 0)
                        
                        for _, v in pairs(smelter.WorkerContents:GetChildren()) do
                            local item = v
                            if item.Name ~= "copperOre" then
                                game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({
                                ["tool"] = item
                                    })
                            end
                        end
                        
                        -- deposit copper Ore
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "copperOre"
                        })
                        -- add some coal
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "coal"
                        })
                    end
            end
        end)

    else
        _G.AutoSmeltEnabled = true
    end
end)

local Tab = Window:NewTab("Grind")

Section:NewToggle("Smelt Ore Pickup Drops", "ToggleInfo", function(state)
    if state then

        _G.AutoSmeltDropsEnabled = true

        spawn(function()

            while wait(0.5) and _G.AutoSmeltDropsEnabled do
                    -- change the 20 to increase or decrease the distance from you
                    for _, v in pairs(findNearSmelters(20)) do
                        local smelter = v
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = smelter.CFrame + Vector3.new(0, 10, 0)
                        
                        for _, v in pairs(smelter.WorkerContents:GetChildren()) do
                            local item = v
                            if item.Name ~= "copperOre" then
                                game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({
                                ["tool"] = item
                                    })
                            end
                        end
                        
                        -- deposit copper Ore
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "copperOre"
                        })
                        -- add some coal
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "coal"
                        })
                        -- remove anything inside the smelter thats not copper ore

                        spawn(function()
                                -- pickup the copper bars as drops
                                for _, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Drops:GetChildren()) do
                                if v:IsA('Tool') and v.Name == "copperIngot" then
                                    local tool = {
                                        ["tool"] = v
                                    }
                                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(tool)
                                end
                            end
                        end)
                    end

            end
        end)

    else
        _G.AutoSmeltDropsEnabled = true
    end
end)

local Section = Tab:NewSection("Barn")



Section:NewToggle("Farm Truffles", "ToggleInfo", function(state)
    if state then
        _G.TruffleEnabled = true
        
        -- Gets truffles
        spawn(function()
            
            while game.RunService.Heartbeat:wait() and _G.TruffleEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "barrelTruffle" then
                        --grab all truffles until empty
                        if #v:FindFirstChild('Contents'):GetChildren() > 0 then
                        
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            local truffletable = {
                            ["chest"] = v,
                            ["player_tracking_category"] = "join_from_web",
                            ["amount"] = 1,
                            ["tool"] = v:FindFirstChild('Contents'):FindFirstChildWhichIsA("Tool"),
                            ["action"] = "withdraw"
                            }
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_CHEST_TRANSACTION:InvokeServer(truffletable)
                        end

                    end
                end

                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    --if v.Name == "dirtPile" and v:FindFirstChild('MeshPart') then
                    if v.Name == "dirtPile" then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(getBest("Pickaxe"))
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            -- Fix htis area...still mining grass from dirtpile instead of truffles
                            game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer({
                                ["player_tracking_category"] = "join_from_web",
                                ["part"] = v:FindFirstChild('MeshPart'),
                                ["block"] = v,
                                ["norm"] = nil,
                                ["pos"] = nil 
                            })
                    end
                end
            end
        end)

    else
        _G.TruffleEnabled = false
    end
end)


Section:NewToggle("Farm Eggs", "ToggleInfo", function(state)
    if state then
        _G.EggEnabled = true

        --// 
        -- Gets island Duck and Chicken Eggs
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.EggEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "nest" and #v:FindFirstChild('Contents'):GetChildren() > 0 then

                            --grab all eggs in nest until empty                      
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            local eggtable = {
                            ["chest"] = v,
                            ["player_tracking_category"] = "join_from_web",
                            ["amount"] = 1,
                            ["tool"] = v:FindFirstChild('Contents'):FindFirstChildWhichIsA("Tool"),
                            ["action"] = "withdraw"
                            }
                        game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_CHEST_TRANSACTION:InvokeServer(eggtable)
                    end
                end

                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "itemPort" and v:FindFirstChildWhichIsA("Tool") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({["tool"] = v:FindFirstChildWhichIsA("Tool")})
                    end
                end
            end
        end)

    else
        _G.EggEnabled = false
    end
end)

Section:NewToggle("Deposit Eggs; Pickup Mayo", "ToggleInfo", function(state)
    if state then
        _G.SwitchEnabled = true

        -- Deposit eggs and pickup mayo
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.SwitchEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "churner" then
                        if v.WorkerOutputContents:FindFirstChild("jarMayonnaise") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 10, 0)
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({["tool"] = v.WorkerOutputContents:FindFirstChild("jarMayonnaise")})
                        else
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 10, 0)
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({["block"]=v,["amount"]=1,["toolName"]="egg"})
                        end
                    end
                end
            end
        end)

    else
        _G.SwitchEnabled = false
    end
end)


local Section = Tab:NewSection("Garden")

Section:NewToggle("Farm non-Fertile Flowers", "ToggleInfo", function(state)
    if state then
        _G.FlowersEnabled = true
        local FlowerBag = {}

        for i, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
            if _G.FlowersEnabled and v.Name:lower():match("flower") and not(v.Name:lower():match("fertile"))  then
                local flower = v
                -- rconsoleprint(i .. " " .. v.Name ..  "putting flower into table\n")
                    local flowName, flowPos = flower.Name, flower.CFrame
                    table.insert(FlowerBag, v)
            end
        end

        for j,k in ipairs(FlowerBag) do
            local flower = k
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = flower.CFramec+ Vector3.new(0, 5, 0)
            game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.client_request_1:InvokeServer({["flower"] = flower})
        end
    else
        _G.FlowersEnabled = false
    end
end)

Section:NewToggle("Harvest Spirit Crystals", "ToggleInfo", function(state)
    if state then
        _G.CrystalEnabled = true
        spawn(function()

            while game.RunService.Heartbeat:wait() and _G.CrystalEnabled do
                local CrystalBag = {}
                for _, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if _G.CrystalEnabled and v.Name == "spiritCrop" then
                            table.insert(CrystalBag, v)
                    end
                end
        
                for _, v in pairs(CrystalBag) do
                    -- teleport to crystal
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        
                    -- harvest crystal
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_HARVEST_CROP_REQUEST:InvokeServer({["player"] = game:GetService("Players").LocalPlayer,["player_tracking_category"] = "join_from_web",["model"] = v})
                              
                    -- plant spirit seed
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer({["upperBlock"] = false,["cframe"] = v.CFrame,["player_tracking_category"] = "join_from_web",["blockType"] = "spiritCrop"})
                end
            end
        end)
    else
        _G.CrystalEnabled = false
    end
end)

Section:NewToggle("Gather Leaves", "ToggleInfo", function(state)
    if state then
        _G.LeavesEnabled = true
        --Equip Leaf Clipper
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("clippers"))
        -- Kavo UI help library https://xheptcofficial.gitbook.io/kavo-library/

local Library = loadstring(game:HttpGet(
                               "https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Midnight Hub", "Ocean")

local Tab = Window:NewTab("Machinery")

local Section = Tab:NewSection("Smelting")

Section:NewToggle("Smelt Ore with Chests", "ToggleInfo", function(state)
    if state then

        _G.AutoSmeltEnabled = true

        spawn(function()
            
            while wait(0.5) and _G.AutoSmeltEnabled do

                    -- change the 20 to increase or decrease the distance from you
                    for _, v in pairs(findNearSmelters(20)) do
                        local smelter = v
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = smelter.CFrame + Vector3.new(0, 10, 0)
                        
                        for _, v in pairs(smelter.WorkerContents:GetChildren()) do
                            local item = v
                            if item.Name ~= "copperOre" then
                                game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({
                                ["tool"] = item
                                    })
                            end
                        end
                        
                        -- deposit copper Ore
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "copperOre"
                        })
                        -- add some coal
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "coal"
                        })
                    end
            end
        end)

    else
        _G.AutoSmeltEnabled = true
    end
end)


local Tab = Window:NewTab("Grind")

Section:NewToggle("Smelt Ore Pickup Drops", "ToggleInfo", function(state)
    if state then

        _G.AutoSmeltDropsEnabled = true

        spawn(function()

            while wait(0.5) and _G.AutoSmeltDropsEnabled do
                    -- change the 20 to increase or decrease the distance from you
                    for _, v in pairs(findNearSmelters(20)) do
                        local smelter = v
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = smelter.CFrame + Vector3.new(0, 10, 0)
                        
                        for _, v in pairs(smelter.WorkerContents:GetChildren()) do
                            local item = v
                            if item.Name ~= "copperOre" then
                                game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({
                                ["tool"] = item
                                    })
                            end
                        end
                        
                        -- deposit copper Ore
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "copperOre"
                        })
                        -- add some coal
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({
                            ["block"] = smelter,
                            ["amount"] = 1,
                            ["toolName"] = "coal"
                        })
                        -- remove anything inside the smelter thats not copper ore

                        spawn(function()
                                -- pickup the copper bars as drops
                                for _, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Drops:GetChildren()) do
                                if v:IsA('Tool') and v.Name == "copperIngot" then
                                    local tool = {
                                        ["tool"] = v
                                    }
                                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(tool)
                                end
                            end
                        end)
                    end

            end
        end)

    else
        _G.AutoSmeltDropsEnabled = true
    end
end)

local Section = Tab:NewSection("Barn")



Section:NewToggle("Farm Truffles", "ToggleInfo", function(state)
    if state then
        _G.TruffleEnabled = true

        weapon = game.Players.LocalPlayer.Backpack.opalPickaxe or game.Players.LocalPlayer.Characte.opalPickaxe
        
        -- Gets truffles
        spawn(function()
            
            while game.RunService.Heartbeat:wait() and _G.TruffleEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "barrelTruffle" then
                        --grab all truffles until empty
                        if #v:FindFirstChild('Contents'):GetChildren() > 0 then
                        
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            local truffletable = {
                            ["chest"] = v,
                            ["player_tracking_category"] = "join_from_web",
                            ["amount"] = 1,
                            ["tool"] = v:FindFirstChild('Contents'):FindFirstChildWhichIsA("Tool"),
                            ["action"] = "withdraw"
                            }
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_CHEST_TRANSACTION:InvokeServer(truffletable)
                        end

                    end
                end

                

                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "dirtPile" and v:FindFirstChild('MeshPart') then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon) 
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer({
                                ["player_tracking_category"] = "join_from_web",
                                ["part"] = v:FindFirstChild('MeshPart'),
                                ["block"] = v
                            })
                    end
                end
            end
        end)

    else
        _G.TruffleEnabled = false
    end
end)


Section:NewToggle("Farm Eggs", "ToggleInfo", function(state)
    if state then
        _G.EggEnabled = true

        --// 
        -- Gets island Duck and Chicken Eggs
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.EggEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "nest" and #v:FindFirstChild('Contents'):GetChildren() > 0 then

                            --grab all eggs in nest until empty                      
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            local eggtable = {
                            ["chest"] = v,
                            ["player_tracking_category"] = "join_from_web",
                            ["amount"] = 1,
                            ["tool"] = v:FindFirstChild('Contents'):FindFirstChildWhichIsA("Tool"),
                            ["action"] = "withdraw"
                            }
                        game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_CHEST_TRANSACTION:InvokeServer(eggtable)
                    end
                end

                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "itemPort" and v:FindFirstChildWhichIsA("Tool") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({["tool"] = v:FindFirstChildWhichIsA("Tool")})
                    end
                end
            end
        end)

    else
        _G.EggEnabled = false
    end
end)

Section:NewToggle("Deposit Eggs; Pickup Mayo", "ToggleInfo", function(state)
    if state then
        _G.SwitchEnabled = true

        -- Deposit eggs and pickup mayo
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.SwitchEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name == "churner" then
                        if v.WorkerOutputContents:FindFirstChild("jarMayonnaise") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 10, 0)
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer({["tool"] = v.WorkerOutputContents:FindFirstChild("jarMayonnaise")})
                        else
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 10, 0)
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_WORKER_DEPOSIT_TOOL_REQUEST:InvokeServer({["block"]=v,["amount"]=1,["toolName"]="egg"})
                        end
                    end
                end
            end
        end)

    else
        _G.SwitchEnabled = false
    end
end)


local Section = Tab:NewSection("Garden")

Section:NewToggle("Farm non-Fertile Flowers", "ToggleInfo", function(state)
    if state then
        _G.FlowersEnabled = true
        local FlowerBag = {}

        for i, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
            if _G.FlowersEnabled and v.Name:lower():match("flower") and not(v.Name:lower():match("fertile"))  then
                local flower = v
                -- rconsoleprint(i .. " " .. v.Name ..  "putting flower into table\n")
                    local flowName, flowPos = flower.Name, flower.CFrame
                    table.insert(FlowerBag, v)
            end
        end

        for j,k in ipairs(FlowerBag) do
            local flower = k
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = flower.CFramec+ Vector3.new(0, 5, 0)
            game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.client_request_1:InvokeServer({["flower"] = flower})
        end
    else
        _G.FlowersEnabled = false
    end
end)

Section:NewToggle("Harvest Spirit Crystals", "ToggleInfo", function(state)
    if state then
        _G.CrystalEnabled = true
        spawn(function()

            while game.RunService.Heartbeat:wait() and _G.CrystalEnabled do
                local CrystalBag = {}
                for _, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if _G.CrystalEnabled and v.Name == "spiritCrop" then
                            table.insert(CrystalBag, v)
                    end
                end
        
                for _, v in pairs(CrystalBag) do
                    -- teleport to crystal
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        
                    -- harvest crystal
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_HARVEST_CROP_REQUEST:InvokeServer({["player"] = game:GetService("Players").LocalPlayer,["player_tracking_category"] = "join_from_web",["model"] = v})
                              
                    -- plant spirit seed
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer({["upperBlock"] = false,["cframe"] = v.CFrame,["player_tracking_category"] = "join_from_web",["blockType"] = "spiritCrop"})
                end
            end
        end)
    else
        _G.CrystalEnabled = false
    end
end)

Section:NewToggle("Gather Leaves", "ToggleInfo", function(state)
    if state then
        _G.LeavesEnabled = true
        --Equip Leaf Clipper
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("clippers"))

        --// Shear Trees
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.LeavesEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name:match("tree") then
                        --local ltexists = v:FindFirstChild("LastTrimmed")
                        --if ltexists and (os.time() - v:FindFirstChild("LastTrimmed").Value > 180) then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_TRIM_TREE_REQUEST:InvokeServer({["tree"] = v})
                        --end
                    end
                end
            end
        end)
    else
        _G.LeavesEnabled = false
        -- we are done; remove leaf clippers
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    end
end)

Section:NewToggle("Pick Grapevines", "ToggleInfo", function(state)
    if state then
        _G.GrapevineEnabled = true
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.GrapevineEnabled do
                local GrapevineBag = {}
                for _, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if _G.GrapevineEnabled and v.Name == "grapeVine" then
                            table.insert(GrapevineBag, v)
                    end
                end
        
                for _, v in pairs(GrapevineBag) do
                    -- teleport 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        
                    -- harvest
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_HARVEST_CROP_REQUEST:InvokeServer({["player"] = game:GetService("Players").LocalPlayer,["player_tracking_category"] = "join_from_web",["model"] = v})
                              
                    -- plant seed
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer({["upperBlock"] = false,["cframe"] = v.CFrame,["player_tracking_category"] = "join_from_web",["blockType"] = "grapeVine"})
                end
            end
        end)
    else
        _G.GrapevineEnabled = false
    end
end)

-- Shared Functions
function findNearSmelters(rad)
    local smelters = {}
    local region = Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(rad, rad, rad), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(rad, rad, rad))
    for i, v in pairs(workspace:FindPartsInRegion3(region, game.Players.LocalPlayer.Character, math.huge)) do
        if v.Name == "soil" then
            table.insert(soils, v)
        end
    end
    return soils
end

        --// Shear Trees
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.LeavesEnabled do
                for i,v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if v.Name:match("tree") then
                        --local ltexists = v:FindFirstChild("LastTrimmed")
                        --if ltexists and (os.time() - v:FindFirstChild("LastTrimmed").Value > 180) then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.CLIENT_TRIM_TREE_REQUEST:InvokeServer({["tree"] = v})
                        --end
                    end
                end
            end
        end)
    else
        _G.LeavesEnabled = false
        -- we are done; remove leaf clippers
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    end
end)

Section:NewToggle("Pick Grapevines", "ToggleInfo", function(state)
    if state then
        _G.GrapevineEnabled = true
        spawn(function()
            while game.RunService.Heartbeat:wait() and _G.GrapevineEnabled do
                local GrapevineBag = {}
                for _, v in pairs(game:GetService("Workspace").Islands:FindFirstChildOfClass("Model").Blocks:GetChildren()) do
                    if _G.GrapevineEnabled and v.Name == "grapeVine" then
                            table.insert(GrapevineBag, v)
                    end
                end
        
                for _, v in pairs(GrapevineBag) do
                    -- teleport 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        
                    -- harvest
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_HARVEST_CROP_REQUEST:InvokeServer({["player"] = game:GetService("Players").LocalPlayer,["player_tracking_category"] = "join_from_web",["model"] = v})
                              
                    -- plant seed
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer({["upperBlock"] = false,["cframe"] = v.CFrame,["player_tracking_category"] = "join_from_web",["blockType"] = "grapeVine"})
                end
            end
        end)
    else
        _G.GrapevineEnabled = false
    end
end)

-- Shared Functions

local pickaxes = {
    "opalPickaxe",
    "diamondPickaxe",
    "gildedSteelPickaxe",
    "ironPickaxe",
    "stonePickaxe",
    "woodPickaxe"
}
local axes = {
    "diamondAxe",
    "opalAxe",
    "gildedSteelAxe",
    "ironAxe",
    "stoneAxe",
    "woodAxe"
}
local weapons = {
    "rageblade",
    "gildedSteelHammer",
    "ironWarAxe",
    "swordWood"
}
function getBest(typ)
    if typ == "Pickaxe" then
        for i, v in pairs(pickaxes) do
            if game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v) then
                return game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v)
            end
        end
    elseif typ == "Axe" then
        for i, v in pairs(axes) do
            if game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v) then
                return game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v)
            end
        end
    elseif typ == "Weapon" then
        for i, v in pairs(weapons) do
            if game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v) then
                return game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v)
            end
        end
    end
end
function findNearSmelters(rad)
    local smelters = {}
    local region = Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(rad, rad, rad), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(rad, rad, rad))
    for i, v in pairs(workspace:FindPartsInRegion3(region, game.Players.LocalPlayer.Character, math.huge)) do
        if v.Name == "soil" then
            table.insert(soils, v)
        end
    end
    return soils
end