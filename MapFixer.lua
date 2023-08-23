if _G.MapFixerToggle then
    if game.PlaceId == 5902977746 then
        -- Wait for the local character to exist
        local player = game:GetService("Players").LocalPlayer
        repeat wait() until player.Character
        print("Local character exists")

        local globalEnv = getrenv()._G
        if globalEnv.serverType == "Match" then
            print("Server type is Match, proceeding...")

            local mapPath = workspace:FindFirstChild("Map")
            if mapPath and mapPath:FindFirstChild("Path") then
                print("workspace.Map.Path exists, proceeding...")

                -- Clone both children under workspace.Map.Path
                local children = mapPath.Path:GetChildren()
                for _, child in pairs(children) do
                    local clone = child:Clone()
                    clone.Name = "ForceField" -- Change name
                    clone.Material = Enum.Material.ForceField -- Change material
                    clone.Parent = workspace -- Move clone to workspace
                end

                -- Delete the children under workspace.Map
                for _, child in pairs(workspace.Map.Path:GetChildren()) do
                    child:Destroy()
                end

                print("Children under workspace.Map.Path cloned and original children under workspace.Map deleted")
            else
                print("workspace.Map.Path does not exist, exiting...")
            end

            -- Enable auto skip
            local RS = game:GetService("ReplicatedStorage")
            RS.Modules.GlobalInit.RemoteEvents:WaitForChild("PlayerReadyForNextWave")
            while wait() do
                RS.Modules.GlobalInit.RemoteEvents.PlayerReadyForNextWave:FireServer()
                print("Firing PlayerReadyForNextWave event") -- Debugging print
            end
        else
            print("Server type is not Match, exiting...")
        end
    end
else
    print("PlaceId is not 5902977746, exiting...")
end
