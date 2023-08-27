if _G.MapFixerToggle and game.PlaceId == 5902977746 then
    local player = game:GetService("Players").LocalPlayer
    while not player.Character do
        wait()
    end
    print("Local character exists")

    local globalEnv = getrenv()._G
    if globalEnv.serverType == "Match" then
        print("Server type is Match, proceeding...")

        local mapPath = workspace:FindFirstChild("Map")
        if mapPath and mapPath:FindFirstChild("Path") then
            print("workspace.Map.Path exists, proceeding...")

            -- Clone and modify parts under workspace.Map.Path
            for _, child in pairs(mapPath.Path:GetDescendants()) do
                if child:IsA("Part") then
                    local clone = child:Clone()
                    clone.Name = "ModifiedPart"
                    clone.Material = Enum.Material.Neon
                    clone.Transparency = 0.5
                    clone.Color = Color3.new(0, 1, 0)
                    clone.Parent = workspace
                    child:Destroy()
                end
            end

            -- Modify specific parts under workspace.Map
            for _, v in pairs(workspace.Map:GetDescendants()) do
                if v.Name == "Ground" or v.Name == "Grass" then
                    v.Size = Vector3.new(v.Size.X * 100, v.Size.Y, v.Size.Z * 100)
                end
            end

            -- Remove unnecessary parts from workspace
            local partsToRemove = {
                "Decoration",
                "Entrance",
                "Exit"
            }
            for _, v in pairs(partsToRemove) do
                for _, child in pairs(workspace:GetDescendants()) do
                    if child.Name == v then
                        child:Destroy()
                    end
                end
            end

            print("Parts modified and unnecessary parts removed")
        else
            print("workspace.Map.Path does not exist, exiting...")
        end

        local RS = game:GetService("ReplicatedStorage")
        local readyEvent = RS.Modules.GlobalInit.RemoteEvents:WaitForChild("PlayerReadyForNextWave")

        while true do
            wait()
            readyEvent:FireServer()
        end
    else
        print("Server type is not Match, exiting...")
    end
else
    print("PlaceId is not 5902977746, exiting...")
end
