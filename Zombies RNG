local RunService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "B1-01"
local autoRoll = false
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



RunService.RenderStepped:Connect(function(dt)
    local now = tick()
    if not autoRoll then
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetRollCardID"):InvokeServer()
    end
end)
