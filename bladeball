task.wait(5)
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local plr = game.Players.LocalPlayer
local iconId = "rbxassetid://104855869460943"

-- auto inject
queueonteleport([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/HTKyuu/GALIL/refs/heads/main/bladeball"))()
]])

local lastTeleportCheck = tick() 
local teleportDelay = 0.1
local i = 0
local realBall = nil
local lastPosition = nil
local lastTime = nil
local hasPressedF = false 
local autoBall = false
local teleport = false

-- notifyer
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = iconId,
        Duration = duration
    })
end

--print("Welcome", plr.Name, "\ndiscord.gg/95zRSYtFe4\n")
notify(plr.Name, "discord.gg/95zRSYtFe4", 5)

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

-- Toggle loop when K key is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end  -- Ignore if the game already processed this input (e.g., if it was used for something else)

    if input.KeyCode == Enum.KeyCode.K then
        autoBall = not autoBall  -- Toggle the flag on/off
                -- Show a notification at the bottom-right corner
        if autoBall then
            notify("GALIL", "AutoBall is enabled now.", 2)
        else
            notify("GALIL", "AutoBall is disabled now.", 2)
        end
    end
    if input.KeyCode == Enum.KeyCode.P then
        teleport = not teleport  -- Toggle the flag on/off
                -- Show a notification at the bottom-right corner
        if teleport then
            notify("GALIL", "Teleport is enabled now.", 2)
        else
            notify("GALIL", "Teleport is disabled now.", 2)
        end
    end
    if input.KeyCode == Enum.KeyCode.T then
        autoTrainingBall = not autoTrainingBall  -- Toggle the flag on/off
                -- Show a notification at the bottom-right corner
        if autoTrainingBall then
            notify("GALIL", "AutoTraining is enabled now.", 2)
        else
            notify("GALIL", "AutoTraining is disabled now.", 2)
        end
    end
end)

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
