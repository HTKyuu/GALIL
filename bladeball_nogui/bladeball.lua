task.wait(3)
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local plr = game.Players.LocalPlayer
local iconId = "rbxassetid://104855869460943"
local plr = game.Players.LocalPlayer
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "A1-02"
local i = 0
local realBall = nil
local lastPosition = nil
local lastTime = nil
local hasPressedF = false 
local autoBall = true
local teleport = true
local autoTrainingBall = true

-- Erstelle das Fenster
local Window = Fluent:CreateWindow({
    Title = "GALIL " .. Version,
    SubTitle = "by kyuu",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,  -- Blur kann deaktiviert werden, falls es Probleme gibt
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl  -- Verwendet Minimize-Taste
})

-- Erstelle Tabs
local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "" }),
    Main = Window:AddTab({ Title = "AutoBall", Icon = "" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

local Options = Fluent.Options

-- Füge Benachrichtigungen und UI-Komponenten hinzu
do
    Fluent:Notify({
        Title = "Join our Discord",
        Content = "discord.gg/95zRSYtFe4",
        SubContent = "keyless scripts",  -- Optional
        Duration = 8  -- Benachrichtigung verschwindet nach 5 Sekunden
    })

    Tabs.Info:AddParagraph({
        Title = "Welcome " .. plr.Name,
        Content = "discord.gg/95zRSYtFe4"
    })


    -- Toggle-Schalter
    local Toggle = Tabs.Main:AddToggle("AutoBall", {Title = "Enable AutoBall", Default = false })
    Toggle:OnChanged(function()
        autoBall = not autoBall
    end)
    local Toggle = Tabs.Main:AddToggle("AutoTraining", {Title = "Enable Training", Default = false })
    Toggle:OnChanged(function()
        autoTrainingBall = not autoTrainingBall
    end)
    local Toggle = Tabs.Teleport:AddToggle("Teleport", {Title = "Enable Teleport", Default = false })
    Toggle:OnChanged(function()
        teleport = not teleport
    end)


    -- Schieberegler
    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Increase Range",
        Description = "[WARNING] Only on\nhigh ping recommended",
        Default = 0.095,
        Min = 0,
        Max = 0.2,
        Rounding = 3,
        Callback = function(Value)
        end
    })
        local Slider = Tabs.Teleport:AddSlider("Slider", {
        Title = "Teleport height",
        Description = "",
        Default = -10,
        Min = -20,
        Max = 20,
        Rounding = 0,
        Callback = function(Value)
        end
    })
    Tabs.Info:AddButton({
        Title = "Join Discord",
        Description = "",
        Callback = function()
    end
    })
end
-- Füge die Manager zu Fluent hinzu
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Setze das Folder für die Manager
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

-- Baue die UI
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "GALIL",
    Content = "The script has been loaded.",
    Duration = 5
})

-- auto inject
queueonteleport([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/HTKyuu/GALIL/refs/heads/main/bladeball"))()
]])

--print("Welcome", plr.Name, "\ndiscord.gg/95zRSYtFe4\n")
-- notify(plr.Name, "discord.gg/95zRSYtFe4", 5)

-- find ball function (needed later)
local function findRealBall()
    for _, ball in ipairs(workspace.Balls:GetChildren()) do
        if ball:GetAttribute("realBall") == true then
            return ball
        end
    end
    return nil
end

local function findRealTrainingBall()
    for _, trainingBall in ipairs(workspace.TrainingBalls:GetChildren()) do
        if trainingBall:GetAttribute("realBall") == true then
            return trainingBall
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function(dt)
    if autoBall then
        -- find ball
        if not realBall or not realBall:IsDescendantOf(workspace.Balls) then
            realBall = findRealBall()
            lastPosition = nil
            lastTime = nil
        end
        
        -- check if targetted
        if realBall and realBall:GetAttribute("target") == plr.Name then
            local currentPosition = realBall.CFrame.Position
            local currentTime = tick()

            -- speed calculation towards the player
            local speedTowardsPlayer = 0
            if lastPosition and lastTime then
                local deltaTime = currentTime - lastTime
                local distance = (currentPosition - lastPosition).Magnitude
                local velocity = (currentPosition - lastPosition) / deltaTime  -- velocity vector

                -- Vector pointing from the ball to the player
                local playerPosition = plr.Character and plr.Character.PrimaryPart and plr.Character.PrimaryPart.CFrame.Position
                if playerPosition then
                    local directionToPlayer = (playerPosition - currentPosition).unit  -- normalized direction vector
                    speedTowardsPlayer = velocity:Dot(directionToPlayer)
                end
            end

            -- distance calculation
            local playerPosition = plr.Character and plr.Character.PrimaryPart and plr.Character.PrimaryPart.CFrame.Position
            if playerPosition then
                local distanceToPlayer = (currentPosition - playerPosition).Magnitude
                local dynamicDistance = 15 + (speedTowardsPlayer * 0.095) 
                if distanceToPlayer < dynamicDistance and not hasPressedF then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) -- F key press
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game) -- F key release
                    -- print(string.format("Success distance: %.2f studs, Speed Towards Player: %.2f studs/sec", distanceToPlayer, speedTowardsPlayer))
                    hasPressedF = true  
                end
            end

            -- save current state
            lastPosition = currentPosition
            lastTime = currentTime
        -- check if targetting different player
        else
            if realBall and realBall:GetAttribute("target") ~= plr.Name then
                hasPressedF = false
            end
            lastPosition = nil
            lastTime = nil
        end
    end
    if teleport then 
        local currentTime = tick()  -- Get the current time
        
        -- Only proceed if enough time has passed since the last teleport check
        if lastTeleportCheck and currentTime - lastTeleportCheck >= teleportDelay then
            lastTeleportCheck = currentTime  -- Update the last teleport check time

            -- find ball
            if not realBall or not realBall:IsDescendantOf(workspace.Balls) then
                realBall = findRealBall()
            end

            -- get player and ball position
            if realBall then
                local ballPosition = realBall.CFrame
                local playerCharacter = workspace.Alive:FindFirstChild(plr.Name)

                -- teleport logic
                if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                    local radius = 8
                    local steps = 12

                    i += 1
                    local angle = math.rad((i % steps) / steps * 360)
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    local y = -12

                    local newPos = ballPosition.Position + Vector3.new(x, y, z)
                    playerCharacter.HumanoidRootPart.CFrame = CFrame.new(newPos, ballPosition.Position)
                end
            else
                return
            end
        end
    end


    -- TRAINING

    if autoTrainingBall then
        -- find ball
        if not realBall or not realBall:IsDescendantOf(workspace.TrainingBalls) then
            realBall = findRealTrainingBall()
            lastPosition = nil
            lastTime = nil
        end
        
        -- check if targetted
        if realBall and realBall:GetAttribute("target") == plr.Name then
            local currentPosition = realBall.CFrame.Position
            local currentTime = tick()

            -- speed calculation towards the player
            local speedTowardsPlayer = 0
            if lastPosition and lastTime then
                local deltaTime = currentTime - lastTime
                local distance = (currentPosition - lastPosition).Magnitude
                local velocity = (currentPosition - lastPosition) / deltaTime  -- velocity vector

                -- Vector pointing from the ball to the player
                local playerPosition = plr.Character and plr.Character.PrimaryPart and plr.Character.PrimaryPart.CFrame.Position
                if playerPosition then
                    local directionToPlayer = (playerPosition - currentPosition).unit  -- normalized direction vector
                    speedTowardsPlayer = velocity:Dot(directionToPlayer)
                end
            end

            -- distance calculation
            local playerPosition = plr.Character and plr.Character.PrimaryPart and plr.Character.PrimaryPart.CFrame.Position
            if playerPosition then
                local distanceToPlayer = (currentPosition - playerPosition).Magnitude
                local dynamicDistance = 15 + (speedTowardsPlayer * 0.095) 
                if distanceToPlayer < dynamicDistance and not hasPressedF then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) -- F key press
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game) -- F key release
                    -- print(string.format("Success distance: %.2f studs, Speed Towards Player: %.2f studs/sec", distanceToPlayer, speedTowardsPlayer))
                    hasPressedF = true  
                end
            end

            -- save current state
            lastPosition = currentPosition
            lastTime = currentTime
        -- check if targetting different player
        else
            if realBall and realBall:GetAttribute("target") ~= plr.Name then
                hasPressedF = false
            end
            lastPosition = nil
            lastTime = nil
        end
    end

end)
