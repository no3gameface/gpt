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
                        clone.Name = "ASDUOJHASUODHUASIHDUOASHJDPOUHASUDh" -- Change name
                        clone.Material = Enum.Material.Neon
                        clone.Transparency = 0.5
                        clone.Color = Color3.new(0, 1, 0)
                        clone.Parent = workspace -- Move clone to workspace
                    end
                end

                -- Delete the children under workspace.Map
                for _, v in pairs(workspace.Map:GetDescendants()) do
                    if v:IsA("Part") and (v.Name == "Ground" or v.Name == "Floor" or v.Name == "Grass") then
                        if v:FindFirstChild("Texture") then
                            v.Texture:Destroy()
                        else
                            local originalSize = v.Size
                            -- Adding 1000 to the original X and Z dimensions
                            v.Size = Vector3.new(originalSize.X + 1000, originalSize.Y, originalSize.Z + 1000)
                        end
                    end
                end

                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Decoration" or v.Name == "Entrance" or v.Name == "Exit" or v.Name == "CheckpointLists" then
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

           
        else
            print("Server type is not Match, exiting...")
        end
    end
else
    print("PlaceId is not 5902977746, exiting...")
end
