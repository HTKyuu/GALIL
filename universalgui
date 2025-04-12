-- Xeno Roblox GUI mit Tabs & Funktionen (Teleport, Fly, Speed)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "XenoFlyGui"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 360, 0, 300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Tab Buttons
local tabMain = Instance.new("TextButton", mainFrame)
tabMain.Text = "Main"
tabMain.Size = UDim2.new(0, 180, 0, 30)
tabMain.Position = UDim2.new(0, 0, 0, 0)
tabMain.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabMain.TextColor3 = Color3.new(1,1,1)
tabMain.BorderSizePixel = 0

local tabTeleport = Instance.new("TextButton", mainFrame)
tabTeleport.Text = "Teleport"
tabTeleport.Size = UDim2.new(0, 180, 0, 30)
tabTeleport.Position = UDim2.new(0, 180, 0, 0)
tabTeleport.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabTeleport.TextColor3 = Color3.new(1,1,1)
tabTeleport.BorderSizePixel = 0

-- Tab Frames
local mainTab = Instance.new("Frame", mainFrame)
mainTab.Position = UDim2.new(0, 0, 0, 30)
mainTab.Size = UDim2.new(1, 0, 1, -30)
mainTab.BackgroundTransparency = 1

local teleportTab = Instance.new("Frame", mainFrame)
teleportTab.Position = UDim2.new(0, 0, 0, 30)
teleportTab.Size = UDim2.new(1, 0, 1, -30)
teleportTab.BackgroundTransparency = 1
teleportTab.Visible = false

local function switchTab(tab)
	if tab == "main" then
		mainTab.Visible = true
		teleportTab.Visible = false
		tabMain.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		tabTeleport.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	else
		mainTab.Visible = false
		teleportTab.Visible = true
		tabMain.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		tabTeleport.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
end

tabMain.MouseButton1Click:Connect(function() switchTab("main") end)
tabTeleport.MouseButton1Click:Connect(function() switchTab("teleport") end)

-- Elements – MAIN TAB
local posLabel = Instance.new("TextLabel", mainTab)
posLabel.Size = UDim2.new(1, 0, 0, 30)
posLabel.Position = UDim2.new(0, 0, 0, 0)
posLabel.TextColor3 = Color3.new(1, 1, 1)
posLabel.BackgroundTransparency = 1
posLabel.Text = "Position:"

game:GetService("RunService").RenderStepped:Connect(function()
	posLabel.Text = "Position: " .. math.floor(hrp.Position.X) .. ", " .. math.floor(hrp.Position.Y) .. ", " .. math.floor(hrp.Position.Z)
end)

-- Key Spam
local spamBtn = Instance.new("TextButton", mainTab)
spamBtn.Text = "☐ Spam Key"
spamBtn.Size = UDim2.new(0, 120, 0, 30)
spamBtn.Position = UDim2.new(0, 140, 0, 80)
spamBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
spamBtn.TextColor3 = Color3.new(1,1,1)
spamBtn.BorderSizePixel = 0

local keyBox = Instance.new("TextBox", mainTab)
keyBox.PlaceholderText = "Key (e.g. E)"
keyBox.Size = UDim2.new(0, 100, 0, 30)
keyBox.Position = UDim2.new(0, 140, 0, 120)
keyBox.Text = ""
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyBox.BorderSizePixel = 0

local spamEnabled = false
local spamThread

spamBtn.MouseButton1Click:Connect(function()
	spamEnabled = not spamEnabled
	spamBtn.Text = spamEnabled and "☑ Spam Key" or "☐ Spam Key"

	if spamEnabled then
		local keyToPress = keyBox.Text:upper()
		if keyToPress == "" then
			spamEnabled = false
			spamBtn.Text = "☐ Spam Key"
			warn("No key selected to spam.")
			return
		end

		spamThread = task.spawn(function()
			while spamEnabled do
				-- Simuliere Tastendruck (nur für Server- oder Client-RemoteEvents nutzbar, z. B. wenn E z. B. Interaktion triggert)
				-- In Roblox können Tastendrücke nicht clientseitig simuliert werden, aber wir können z. B. den InputContext aktivieren:
				local vim = game:GetService("VirtualInputManager")
				pcall(function()
					vim:SendKeyEvent(true, Enum.KeyCode[keyToPress], false, game)
					wait(0.05)
					vim:SendKeyEvent(false, Enum.KeyCode[keyToPress], false, game)
				end)
				wait(0.2) -- Intervall zwischen den Tasten
			end
		end)
	else
		if spamThread then
			task.cancel(spamThread)
			spamThread = nil
		end
	end
end)

-- Speed
local speedBox = Instance.new("TextBox", mainTab)
speedBox.PlaceholderText = "Speed"
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 40)
speedBox.Text = ""
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.BorderSizePixel = 0

speedBox.FocusLost:Connect(function()
	local n = tonumber(speedBox.Text)
	if n then humanoid.WalkSpeed = n end
end)

-- Auto Walk + Return Checkbox
local autoWalkBackBtn = Instance.new("TextButton", mainTab)
autoWalkBackBtn.Text = "☐ Auto Walk + Return (5s)"
autoWalkBackBtn.Size = UDim2.new(0, 180, 0, 30)
autoWalkBackBtn.Position = UDim2.new(0, 10, 0, 160)
autoWalkBackBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoWalkBackBtn.TextColor3 = Color3.new(1, 1, 1)
autoWalkBackBtn.BorderSizePixel = 0

local autoReturnEnabled = false
local autoReturnThread

autoWalkBackBtn.MouseButton1Click:Connect(function()
	autoReturnEnabled = not autoReturnEnabled
	autoWalkBackBtn.Text = autoReturnEnabled and "☑ Auto Walk + Return (5s)" or "☐ Auto Walk + Return (5s)"
	
	if autoReturnEnabled then
		autoReturnThread = task.spawn(function()
			while autoReturnEnabled do
				local oldPos = hrp.Position
				
				-- Lauf nach vorne für 5 Sekunden
				local moveVector = hrp.CFrame.LookVector
				local runTime = 5
				local start = tick()
				
				while tick() - start < runTime and autoReturnEnabled do
					-- Bewege dich nach vorne
					hrp.Velocity = moveVector * 16
					RunService.Stepped:Wait()
				end
				
				-- Stoppe Bewegung
				hrp.Velocity = Vector3.zero
				wait(0.1)
				
				-- Zurück teleportieren
				if autoReturnEnabled then
					hrp.CFrame = CFrame.new(oldPos)
				end
				
				wait(0.5) -- Pause zwischen Wiederholungen
			end
		end)
	else
		if autoReturnThread then
			task.cancel(autoReturnThread)
			autoReturnThread = nil
		end
		hrp.Velocity = Vector3.zero
	end
end)


-- Fly-Modus
local flyBtn = Instance.new("TextButton", mainTab)
flyBtn.Text = "☐ Fly Mode"
flyBtn.Size = UDim2.new(0, 120, 0, 30)
flyBtn.Position = UDim2.new(0, 10, 0, 80)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.BorderSizePixel = 0

-- Fly-System
local gravityOff = false
local bodyVelocity, flyConn
local moveDir = Vector3.zero
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local flySpeed = 50

local function getMove()
	local cam = workspace.CurrentCamera
	local dir = Vector3.zero
	if uis:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
	if uis:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
	if uis:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
	if uis:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
	dir = Vector3.new(dir.X, 0, dir.Z).Unit
	if tostring(dir) == "nan, nan, nan" then dir = Vector3.zero end
	return dir
end

flyBtn.MouseButton1Click:Connect(function()
	gravityOff = not gravityOff
	if gravityOff then
		flyBtn.Text = "☑ Fly Mode"
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Name = "FlyVelocity"
		bodyVelocity.Parent = hrp
		flyConn = rs.RenderStepped:Connect(function()
			bodyVelocity.Velocity = getMove() * flySpeed
		end)
	else
		flyBtn.Text = "☐ Fly Mode"
		if flyConn then flyConn:Disconnect() flyConn = nil end
		if bodyVelocity then bodyVelocity:Destroy() end
	end
end)

-- Copy Coords
local copyBtn = Instance.new("TextButton", mainTab)
copyBtn.Text = "Copy Coords"
copyBtn.Size = UDim2.new(0, 120, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 120)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
copyBtn.TextColor3 = Color3.new(1,1,1)
copyBtn.BorderSizePixel = 0

copyBtn.MouseButton1Click:Connect(function()
	setclipboard(math.floor(hrp.Position.X) .. ", " .. math.floor(hrp.Position.Y) .. ", " .. math.floor(hrp.Position.Z))
end)

-- X to close
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Elements – TELEPORT TAB
local locations = {
	{"Playground", Vector3.new(-356, 30, -1730)},
	{"Beach", Vector3.new(-556, 30, -1514)},
	{"Camp", Vector3.new(-15, 30, -1055)},
	{"School", Vector3.new(-11999, 6956, -3041)},
	{"Pizza", Vector3.new(0, 6972, -5949)},
	{"Hostpital", Vector3.new(54, 6877, -12138)},
	{"Firehydrant", Vector3.new(-363, 30, -1221)}
}

for i, loc in pairs(locations) do
	local btn = Instance.new("TextButton", teleportTab)
	btn.Size = UDim2.new(0, 320, 0, 30)
	btn.Position = UDim2.new(0, 20, 0, 10 + (i-1)*40)
	btn.Text = loc[1]
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.BorderSizePixel = 0

	btn.MouseButton1Click:Connect(function()
		hrp.CFrame = CFrame.new(loc[2])
	end)
end
