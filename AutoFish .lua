
if _G.AutoFishToggle then

if game.PlaceId == 5902977746 then
    local P = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")

    local player = game:GetService("Players").LocalPlayer
    local targetText = "100/100"
    local targetCount = tonumber(targetText:match("(%d+)/%d+"))

    local function checkText()
        local hud = player.PlayerGui.MainGui.HUD
        local catchText = hud["CatchesToday"].Text.Text
        local currentCount = tonumber(catchText:match("(%d+)/%d+"))

        local difference = targetCount - currentCount

        if currentCount and targetCount then
            if catchText:find(targetText, 1, true) then
                print("Text contains", targetText)
            else
                print("Text does not contain", targetText)
            end
        else
            print("Unable to extract counts from text")
        end

        return difference
    end

    local calculatedDifference = checkText()

    repeat wait() until P.LocalPlayer
    repeat wait() until P.LocalPlayer.Character
    repeat wait() until P.LocalPlayer.Character.HumanoidRootPart

    -- variable
    local stuff = getrenv()._G.FireNetwork
    local id = game.Players.LocalPlayer.UserId

    -- hacker stuff
for i = calculatedDifference, 1, -1 do
    print(i)
    stuff("PlayerCatchFish", id)
    wait(10.1)
end
end
end
