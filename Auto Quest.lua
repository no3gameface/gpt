if _G.AutoQuestToggle then
    local P = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")

    repeat wait() until P.LocalPlayer
    repeat wait() until P.LocalPlayer.Character
    repeat wait() until P.LocalPlayer.Character.HumanoidRootPart

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = game:GetService("Players").LocalPlayer
    local questsFolder = player.PlayerGui.MainGui.MainFrames.Quests.Content
    local GlobalInit = ReplicatedStorage.Modules.GlobalInit

    local function getQuestData()
        local questData = {}

        for _, quest in pairs(questsFolder:GetChildren()) do
            if quest:IsA("ImageLabel") then
                local titleLabel = quest:FindFirstChild("Title")
                local percentageLabel = quest:FindFirstChild("Percentage")
                local rewardLabel = quest:FindFirstChild("Reward")
                local descriptionLabel = quest:FindFirstChild("Description")

                if titleLabel and percentageLabel and rewardLabel and descriptionLabel then
                    local questTitle = titleLabel.Text
                    local questPercentage = tonumber(percentageLabel.Text:match("%d+"))
                    if questPercentage > 100 then
                        questPercentage = 100
                    end
                    local questReward = rewardLabel.Text
                    local questDescription = descriptionLabel.Text:match("%d+")

                    table.insert(questData, {id = quest.Name, title = questTitle, percentage = questPercentage, reward = questReward, description = questDescription})
                end
            end
        end

        return questData
    end

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QuestProgressUI"
    screenGui.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(1, -220, 0.5, -150)
    frame.BackgroundTransparency = 1  -- Make the background transparent
    frame.Parent = screenGui

    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 10, 1, 10)  -- Add some padding for the border
    border.Position = UDim2.new(0, -5, 0, -5)
    border.BackgroundColor3 = Color3.new(0.6, 0, 0.6)  -- Purple color for the border
    border.BorderSizePixel = 0
    border.Parent = frame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -40)  -- Adjust size to fit inside the border
    scrollFrame.Position = UDim2.new(0, 10, 0, 20)  -- Adjust position for padding
    scrollFrame.Parent = border

    local questData = getQuestData()
    local yOffset = 0  -- Track the vertical offset

    for _, quest in ipairs(questData) do
        local questLabel = Instance.new("TextLabel")
        questLabel.Size = UDim2.new(1, 0, 0, 60)
        questLabel.Position = UDim2.new(0, 0, 0, yOffset)
        questLabel.BackgroundTransparency = 1
        questLabel.Text = quest.title .. ": " .. quest.percentage .. "%\nReward: " .. quest.reward .. "\nDescription: " .. quest.description
        questLabel.TextWrapped = true
        questLabel.TextColor3 = Color3.new(0, 0, 0)
        questLabel.Parent = scrollFrame

        yOffset = yOffset + 70
    end
end
    createUI()

    local function autoClaimQuests(questData)
        for _, quest in ipairs(questData) do
            if quest.percentage == 100 then
                GlobalInit.RemoteEvents.PlayerClaimQuest:FireServer(quest.id)
            end
        end
    end

    local function isQuestsFolderEmpty()
        for _, child in ipairs(questsFolder:GetChildren()) do
            if not child:IsA("UIListLayout") then
                return false
            end
        end
        return true
    end

    local function refreshQuestsIfEmpty()
        if isQuestsFolderEmpty() then
            print("Refreshing quests")
            GlobalInit.RemoteEvents.PlayerRefreshQuests:FireServer()
        end
    end

    while true do
        local questData = getQuestData()
        autoClaimQuests(questData)
        refreshQuestsIfEmpty(questData)
        wait(5)
    end
end
