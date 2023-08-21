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
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -30)
    scrollFrame.Position = UDim2.new(0, 0, 0, 30)
    scrollFrame.Parent = frame

    local questData = getQuestData()
    local yOffset = 0  -- Track the vertical offset

    for _, quest in ipairs(questData) do
        local questLabel = Instance.new("TextLabel")
        questLabel.Size = UDim2.new(1, 0, 0, 60)
        questLabel.Position = UDim2.new(0, 0, 0, yOffset)  -- Set the position based on yOffset
        questLabel.BackgroundTransparency = 1
        questLabel.Text = quest.title .. ": " .. quest.percentage .. "%\nReward: " .. quest.reward .. "\nDescription: " .. quest.description
        questLabel.TextWrapped = true
        questLabel.TextColor3 = Color3.new(0, 0, 0)
        questLabel.Parent = scrollFrame

        yOffset = yOffset + 70  -- Increment yOffset for the next label
    end

    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 10, 1, 10)
    border.Position = UDim2.new(0, -5, 0, -5)
    border.BackgroundTransparency = 1
    border.Parent = frame

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new(Color3.new(0.6, 0, 0.6))
    uiGradient.Parent = border

    local currentRotation = 0
    local TweenService = game:GetService("TweenService")
    local TweenInformation = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local Goal = {Rotation = currentRotation + 360}

    local function animateBorder()
        local rotationTween = TweenService:Create(uiGradient, TweenInformation, Goal)
        rotationTween:Play()
    end

    animateBorder()
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
