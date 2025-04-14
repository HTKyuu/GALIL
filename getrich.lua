local RunService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "A1-02"
local autoRoll = false
local tpToCherrys = false
local tpToCoffee = false
local currentCherryIndex = 1
local currentCoffeeIndex = 1
local teleportCooldown = 1
local nextTeleportTime = 0
local isTeleporting = false
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local Window = Fluent:CreateWindow({
    Title = "GALIL " .. Version,
    SubTitle = "by kyuu",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,  
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

-- Erstelle Tabs
local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "" }),
    Main = Window:AddTab({ Title = "AutoRoll", Icon = "" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

local Options = Fluent.Options


do
    Fluent:Notify({
        Title = "Join our Discord",
        Content = "discord.gg/95zRSYtFe4",
        SubContent = "keyless scripts", 
        Duration = 8 
    })

    Tabs.Info:AddParagraph({
        Title = "Welcome " .. plr.Name,
        Content = "discord.gg/95zRSYtFe4"
    })


    -- Toggle-Schalter
    local Toggle = Tabs.Main:AddToggle("Auto Roll", {Title = "Auto Roll", Default = false })
    Toggle:OnChanged(function()
        autoRoll = not autoRoll
    end)
    local Toggle = Tabs.Teleport:AddToggle("Collect Cherrys", {Title = "Collect Cherrys", Default = false })
    Toggle:OnChanged(function()
        tpToCherrys = not tpToCherrys
    end)
    local Toggle = Tabs.Teleport:AddToggle("Collect Coffee", {Title = "Collect Coffee", Default = false })
    Toggle:OnChanged(function()
        tpToCoffee = not tpToCoffee
    end)

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

local function getCherryModels()
    local folder = workspace.BoostModels:FindFirstChild("CherryModels")
    if not folder then
        return {}
    end

    local result = {}
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "CherryModel" then
            table.insert(result, obj)
        end
    end
    return result
end

local function getCoffeeModels()
    local folder = workspace.BoostModels:FindFirstChild("CoffeeModels")
    if not folder then
        return {}
    end

    local result = {}
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "CoffeeModel" then
            table.insert(result, obj)
        end
    end
    return result
end


RunService.RenderStepped:Connect(function(dt)
    local now = tick()
    if not autoRoll then
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetRollCardID"):InvokeServer()
    end

    if not tpToCherrys and now >= nextTeleportTime then
        local models = getCherryModels()
        if #models > 0 then
            if currentCherryIndex > #models then
                currentCherryIndex = 1
            end

            local model = models[currentCherryIndex]
            local cf = model:GetPivot()
            if cf then
                hrp.CFrame = cf + Vector3.new(0, 1, 0)
                currentCherryIndex += 1
                nextTeleportTime = now + teleportCooldown
            end
        end
    end
    if not tpToCoffee and now >= nextTeleportTime then
        local models = getCoffeeModels()
        if #models > 0 then
            if currentCoffeeIndex > #models then
                currentCoffeeIndex = 1
            end

            local model = models[currentCoffeeIndex]
            local cf = model:GetPivot()
            if cf then
                hrp.CFrame = cf + Vector3.new(0, 1, 0)
                currentCoffeeIndex += 1
                nextTeleportTime = now + teleportCooldown
            end
        end
    end
end)
