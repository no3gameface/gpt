if _G.MapFixerToggle then
    if game.PlaceId == 5902977746 then
        -- Wait for the local character to exist
        local player = game:GetService("Players").LocalPlayer
        repeat
            wait()
        until player.Character
        print("Local character exists")

        local globalEnv = getrenv()._G
        if globalEnv.serverType == "Match" then
            print("Server type is Match, proceeding...")

            local mapPath = workspace:FindFirstChild("Map")
            if mapPath and mapPath:FindFirstChild("Path") then
                print("workspace.Map.Path exists, proceeding...")

                -- Clone parts under workspace.Map.Path
                local descendants = mapPath.Path:GetDescendants()
                for _, child in pairs(descendants) do
                    if child:IsA("Part") then
                        local clone = child:Clone()
                        clone.Name = "ForceField" -- Change name
                        clone.Material = Enum.Material.Neon
                        clone.Transparency = 0.5
                        clone.Color = Color3.new(0, 1, 0)
                        clone.Parent = workspace -- Move clone to workspace
                    end
                end

                -- Delete the children under workspace.Map
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Decoration" then
                        v:Destroy()
                    end
                end

                for _, child in pairs(workspace.Map.Path:GetDescendants()) do
                    if child:IsA("Part") then
                        child:Destroy()
                    end
                end

                print("Parts under workspace.Map.Path cloned and original parts under workspace.Map deleted")
            else
                print("workspace.Map.Path does not exist, exiting...")
            end

            while true do
                wait()
                local RS = game:GetService("ReplicatedStorage")
                RS.Modules.GlobalInit.RemoteEvents:WaitForChild("PlayerReadyForNextWave")
                RS.Modules.GlobalInit.RemoteEvents.PlayerReadyForNextWave:FireServer()
            end
        else
            print("Server type is not Match, exiting...")
        end
    end
else
    print("PlaceId is not 5902977746, exiting...")
end
