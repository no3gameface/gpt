local P = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

repeat wait() until P.LocalPlayer
repeat wait() until P.LocalPlayer.Character
repeat wait() until P.LocalPlayer.Character.HumanoidRootPart
wait()

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
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local borderGradient = Instance.new("UIGradient")
    borderGradient.Rotation = 0
    borderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(89, 196, 255)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(155, 129, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(223, 157, 255)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(206, 182, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(188, 239, 255))
    }
    borderGradient.Parent = frame

    local squareCorner = Instance.new("UICorner")
    squareCorner.CornerRadius = UDim.new(0.1, 0)
    squareCorner.Parent = frame

    local innerFrame = Instance.new("Frame")
    innerFrame.Size = UDim2.new(0.98, 0, 0.98, 0)
    innerFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
    innerFrame.BackgroundTransparency = 0
    
    innerFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    innerFrame.Parent = frame

    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0.1, 0)
    innerCorner.Parent = innerFrame

    local currentRot = borderGradient.Rotation
    local tweenService = game:GetService("TweenService")
    local tweenInformation = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
    local goal = {Rotation = currentRot + 360}
    local tween = tweenService:Create(borderGradient, tweenInformation, goal)
    tween:Play()

    local questData = getQuestData()

    local yOffset = 0
    for _, quest in ipairs(questData) do
        local questLabel = Instance.new("TextLabel")
        questLabel.Size = UDim2.new(1, 0, 0, 60)
        questLabel.Position = UDim2.new(0, 0, 0, yOffset)
        questLabel.BackgroundTransparency = 1
        questLabel.Text = quest.title .. ": " .. quest.percentage .. "%\nReward: " .. quest.reward .. "\nDescription: " .. quest.description
        questLabel.TextWrapped = true
        questLabel.TextColor3 = Color3.new(1, 1, 1)
        questLabel.Parent = innerFrame

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

    -- Check for claimed quests and remove them from the GUI
    for _, quest in ipairs(questData) do
        if quest.percentage == 100 then
            local questLabel = innerFrame:FindFirstChild(quest.title)
            if questLabel then
                questLabel:Destroy()
            end
        end
    end

    autoClaimQuests(questData)
    refreshQuestsIfEmpty(questData)
    wait(5)
end
