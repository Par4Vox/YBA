if workspace:FindFirstChild("BarrierRoofKicks") then 
    workspace.BarrierRoofKicks:Destroy()
end

--// Variables
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local InfDash;
local InfTick = tick()
local Humanoid = Character.Humanoid
local DefaultSpeed = Humanoid.WalkSpeed
local DefaultJump = Humanoid.JumpPower
local Horse = workspace:FindFirstChild(Player.Name.."'s Horse") or nil

getgenv().settings = {
    ["HookedSpeed"] = 22,
    ["WalkSpeed"] = 22,
    ["ToggleWalk"] = false,
    ["FlySpeed"] = 1,
    ["InfDelay"] = 0.5,
    ["DP"] = 50
}

settings.sbr = {
    ["Stage1TPDelay"] = 1,
    ["Stage2TPDelay"] = 1,
    ["Stage3TPDelay"] = 1,
    ["Stage4TPDelay"] = 1,
    ["LastStageTPDelay"] = 1,
    ["AllStageHideDelay"] = 0,
    ["WinHideDelay"] = 3
}

settings.horse = {
    ["WalkSpeed"] = 0,
    ["FlySpeed"] = 1
}

settings.teleports = {
    ["Stage 1 Barrier"] = nil,
    ["Stage 2 Barrier"] = nil,
    ["Stage 3 Barrier"] = nil,
    ["Stage 4 Barrier"] = nil,
    ["Normal Hide"] = nil,
    ["Finish Hide"] = nil,
    ["Finish Line Barrier"] = nil
}

settings.stands = {
    ["StandAttachDistance"] = 0,
    ["PredictionStrength"] = 0,
    ["TargetPlayer"] = nil,
    ["Barrage"] = false,
    ["Finisher"] = false,
    ["Punch"] = false,
    ["HeavyPunch"] = false,
    ["Attached"] = false,
    ["AllPlayers"] = {},
    ["Stand"] = nil
}

--// Permanently force locations (this is done because the map is randomised and some objects get deleted)
pcall(function()
    settings.teleports["Stage 1 Barrier"] = workspace.Barriers:FindFirstChild("1").CFrame
    settings.teleports["Stage 2 Barrier"] = workspace.Barriers:FindFirstChild("2").CFrame
    settings.teleports["Stage 3 Barrier"] = workspace.Barriers:FindFirstChild("3").CFrame
    settings.teleports["Stage 4 Barrier"] = workspace.Map["NYC Bridge"].Start.CFrame
    settings.teleports["Normal Hide"] = workspace.Map["NYC Bridge"].NYCBridge.Bridge.Bridge.MeshPart.CFrame
    settings.teleports["Finish Hide"] = workspace.Map["NYC Bridge"].Start.CFrame - Vector3.new(0,30,0)
    settings.teleports["Finish Line Barrier"] = workspace.Map["NYC Bridge"]["End_Line"].CFrame + Vector3.new(0,100,0)
end)
    
--// Functions
local function SummonStand(args)
    if not Character:FindFirstChild("SummonedStand").Value and args == true then
        repeat task.wait() until Character:FindFirstChild("RemoteFunction")
        Character.RemoteFunction:InvokeServer("ToggleStand", "Toggle")
    elseif Character:FindFirstChild("SummonedStand").Value and args == false then
        repeat task.wait() until Character:FindFirstChild("RemoteFunction")
        Character.RemoteFunction:InvokeServer("ToggleStand", "Toggle")
    end
end

local function UpdateList()
    table.clear(settings.stands["AllPlayers"])
    
    for _, Player in Players:GetChildren() do
        table.insert(settings.stands["AllPlayers"], Player.Name)
    end
    
    return true
end

local function UseMove(Move)
    Move = Move

    if Move == string.lower("m1") or Move == string.lower("m2") then
        local Char = Character
        if Char and Char:FindFirstChild("RemoteFunction") then
            Char:FindFirstChild("RemoteFunction"):InvokeServer("Attack", Move)
        end
    end
    
    if typeof(Move) == "Enum" then
        local Char = Character
        if Char and Char:FindFirstChild("RemoteEvent") then
            Char:FindFirstChild("RemoteEvent"):FireServer("InputBegan", {
                ["Input"] = Move
            })
        end
    end
end

local function Get_Stroke()
    StrokeDir = 180
    local Anim = "6926086304"
        
    if (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A)) then
        StrokeDir = 90
        Anim = "6926086567"
    end
        
    if (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D)) and StrokeDir == 180 then
        StrokeDir = -90
        Anim = "6926086883"
    end
        
    if (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W)) and StrokeDir == 180 then
        StrokeDir = 0
        Anim = "6926086032"
    end
        
    return StrokeDir, Anim
end

print(TeleportBypassable)
_G.BypassExecuted = false
--// Bypasses
if not _G.BypassExecuted then
    _G.BypassExecuted = true
    print("Starting Hooks")
    local OldNamecallTP;
    OldNamecallTP = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
        local Arguments = {...}
        local Method =  getnamecallmethod()
        
        if Method == "InvokeServer" and Arguments[1] == "idklolbrah2de" then
            return "  ___XP DE KEY"
        end

        if (Method == "FireServer" or Method == "InvokeServer" or Method == "InvokeClient") and Arguments[1] == "Reset" and Arguments[3] ~= "vezrr" then
            return wait(9e9) 
        end

        return OldNamecallTP(self, ...)
    end))
    
    print("Hooked Teleport")
    print("Hooks Bypassed")
end

--// Fix SBR Chat 
Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Position = UDim2.new(0,0,0,-156)
Player.PlayerGui.Chat.Frame.Position = UDim2.new(0,0,1,95)

--// UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("yba is ass by vezrr - V3.01 - discord.gg/2DzNtgGP9K", colors)
local MainTab = Window:NewTab("Main")
local SBRTab = Window:NewTab("Auto SBR")
local TeleportsTab = Window:NewTab("Teleports")
local HorseTabs = Window:NewTab("Horse")
local StandsTab = Window:NewTab("Stand")
local OtherTab = Window:NewTab("Other")
local CreditsTab = Window:NewTab("Credits")

local Player = MainTab:NewSection("Player")
local SBR = SBRTab:NewSection("Auto SBR Settings")
local Teleports = TeleportsTab:NewSection("Teleports")
local HorseTab = HorseTabs:NewSection("Horse")
local Stands = StandsTab:NewSection("Stand Attach")
local Other = OtherTab:NewSection("Other")
local Credits = CreditsTab:NewSection("Discord Server: discord.gg/2DzNtgGP9K")

--[[Player:NewToggle("Toggle Speed", "Toggles Custom Speed", function(State)
    settings["ToggleWalk"] = State
    
    if settings["ToggleWalk"] then
        settings["HookedSpeed"] = settings["WalkSpeed"]
    else
        settings["HookedSpeed"] = 22
    end
end)

Player:NewSlider("Speed", "Adjust Speed", 100, 22, function(Value)
    if settings["ToggleWalk"] then
        settings["HookedSpeed"] = Value
        settings["WalkSpeed"] = Value
    end
end)

Player:NewToggle("Toggle Jump", "Toggles Custom Jump", function(State)
    settings["ToggleJump"] = State
    
    if settings["ToggleJump"] then
        settings["HookedJump"] = settings["JumpPower"]
    else
        settings["HookedJump"] = 50
    end
end)

Player:NewSlider("Jump", "Adjust Jump", 200, 50, function(Value)
    if settings["ToggleJump"] then
        settings["HookedJump"] = Value
        settings["JumpPower"] = Value
    end
end)]]

Player:NewToggle("Player Fly", "Move = WASD", function(State)
    if State then
        local Keys_Pressed = {
        	["W"] = 0;
        	["A"] = 0;
        	["S"] = 0;
        	["D"] = 0;
        }
        local Key_Info = {
        	["W"] = {
        		["Operator"] = "+";
        		["Direction"] = "LookVector";
        	};
        	["A"] = {
        		["Operator"] = "-";
        		["Direction"] = "RightVector";
        	};
        	["S"] = {
        		["Operator"] = "-";
        		["Direction"] = "LookVector";
        	};
        	["D"] = {
        		["Operator"] = "+";
        		["Direction"] = "RightVector";
        	};
        }
        
        --// Begin fly script
        
        --// Variables
        local UIS = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        
        --// Neat functions
        local function GetKeyFromEnum(enum)
        	return enum.KeyCode.Name
        end
        
        local function GetMass(Model)
        	local Mass = 0;
        	for i,v in pairs(Model:GetDescendants()) do
        		if v:IsA("BasePart") then Mass = Mass + v:GetMass() end
        	end
        	return Mass;
        end
        
        local function Math(Operator, A, B)
        	if Operator == "-" then return A-B elseif Operator == "+" then return A+B end
        end
        
        --// Key detection
        UIS.InputBegan:Connect(function(Key, Typing)
        	if Typing then return end
        	
        	local Key_String = GetKeyFromEnum(Key)
        	if Keys_Pressed[Key_String] then
        		Keys_Pressed[Key_String] = 1
        	end
        end)
        
        UIS.InputEnded:Connect(function(Key, Typing)
        	if Typing then return end
        	
        	local Key_String = GetKeyFromEnum(Key)
        	if Keys_Pressed[Key_String] then
        		Keys_Pressed[Key_String] = 0
        	end
        end)
        
        --// Fly loop
        
        _G.FlyLoop = RunService.RenderStepped:Connect(function()
        	if not Character then return end
        	Character.Humanoid.WalkSpeed = 0; Character.Humanoid.JumpPower = 0;
        	
        	Character.PrimaryPart.CFrame = CFrame.new(Character.PrimaryPart.Position, Character.PrimaryPart.Position + workspace.CurrentCamera.CFrame.LookVector)
        	local CharacterMass = GetMass(Character)
        	--// Calculate new velocity
        	
            local Velocity = Vector3.new(0, CharacterMass/workspace.Gravity, 0) --// Lets try not to decend
            for i,v in pairs(Keys_Pressed) do
                if v == 0 then else
                Velocity = Math(Key_Info[i].Operator, Velocity, Character.PrimaryPart.CFrame[Key_Info[i].Direction] * settings["FlySpeed"] * CharacterMass) end
            end
        	
        	Character.PrimaryPart.Velocity = Velocity
        end)
    else
        _G.FlyLoop:Disconnect()
        Player.Character.Humanoid.WalkSpeed = 22
    end
end)

Player:NewSlider("Fly Speed", "", 35,1, function(t)
    settings["FlySpeed"] = t
end)

Player:NewToggle("Anti Vampire Burn", "", function(State)
    local VampLoop = nil
    if State then
        workspace.Weather.Value = nil
        VampLoop = workspace.Weather:GetPropertyChangedSignal("Value"):Connect(function()
            workspace.Weather.Value = nil
        end)
    else
        if VampLoop then
            VampLoop:Disconnect()
        end
    end
end)

SBR:NewSlider("TP Stage 1 Delay", "", 35,0, function(Value)
    settings.sbr["Stage1TPDelay"] = Value
end)

SBR:NewSlider("TP Stage 2 Delay", "", 35,0, function(Value)
    settings.sbr["Stage2TPDelay"] = Value
end)

SBR:NewSlider("TP Stage 3 Delay", "", 35,0, function(Value)
    settings.sbr["Stage3TPDelay"] = Value
end)

SBR:NewSlider("TP Stage 4 Delay", "", 35,0, function(Value)
    settings.sbr["Stage4TPDelay"] = Value
end)

SBR:NewSlider("TP Finish Delay", "", 35,0, function(Value)
    settings.sbr["LastStageTPDelay"] = Value
end)

SBR:NewSlider("Hide Delay", "", 35,0, function(Value)
    settings.sbr["AllStageHideDelay"] = Value
end)

SBR:NewSlider("Win Hige Delay", "", 35,3, function(Value)
    settings.sbr["WinHideDelay"] = Value
end)

local AutoSBR = SBRTab:NewSection("Auto SBR")

AutoSBR:NewButton("Auto SBR V1 (Player)", "Auto Completes SBR", function()
    if Character then
        Character.HumanoidRootPart.CFrame = settings.teleports["Normal Hide"]
        
        repeat task.wait() until workspace.Barrier:FindFirstChild("StartBarrier") == nil
        task.wait(settings.sbr["Stage1TPDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Stage 1 Barrier"]
        
        task.wait(settings.sbr["AllStageHideDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Normal Hide"]
        
        repeat task.wait() until workspace.Barriers:FindFirstChild("1") == nil
        task.wait(settings.sbr["Stage2TPDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Stage 2 Barrier"]
        
        task.wait(settings.sbr["AllStageHideDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Normal Hide"]
        
        repeat task.wait() until workspace.Barriers:FindFirstChild("2") == nil
        task.wait(settings.sbr["Stage3TPDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Stage 3 Barrier"]
        
        task.wait(settings.sbr["AllStageHideDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Normal Hide"]
        
        repeat task.wait() until workspace.Barriers:FindFirstChild("3") == nil
        task.wait(settings.sbr["Stage4TPDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Stage 4 Barrier"]
        
        task.wait(settings.sbr["AllStageHideDelay"])
        repeat task.wait()
            Character.HumanoidRootPart.CFrame = settings.teleports["Finish Hide"]
        until workspace.Barriers:FindFirstChild("4") == nil
        task.wait(settings.sbr["LastStageTPDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Finish Line Barrier"]
        
        task.wait(settings.sbr["WinHideDelay"])
        Character.HumanoidRootPart.CFrame = settings.teleports["Finish Hide"]
    end
end)

AutoSBR:NewButton("Auto SBR V2 (Horse)", "use if noob", function()
    if Horse then
        repeat task.wait() until workspace:FindFirstChild("StartBarrier") == nil
        task.wait(settings["Stage1TPDelay"])
        Horse.HumanoidRootPart.CFrame = settings.teleports["Stage 1 Barrier"]
            
        repeat wait() until workspace.Barriers:FindFirstChild("1") == nil
        task.wait(settings["Stage2TPDelay"])
        Horse.HumanoidRootPart.CFrame = settings.teleports["Stage 2 Barrier"]
            
        repeat wait() until workspace.Barriers:FindFirstChild("2") == nil
        task.wait(settings["Stage3TPDelay"])
        Horse.HumanoidRootPart.CFrame = settings.teleports["Stage 3 Barrier"]
            
        repeat wait() until workspace.Barriers:FindFirstChild("3") == nil
        task.wait(settings["Stage4TPDelay"])
        Horse.HumanoidRootPart.CFrame = settings.teleports["Stage 4 Barrier"]
        
        repeat wait() until workspace.Barriers:FindFirstChild("4") == nil
        task.wait(settings["LastStageTPDelay"])
        
        Horse.HumanoidRootPart.CFrame = settings.teleports["Finish Line Barrier"]
    end
end)

for Name, CFrame in settings.teleports do
    Teleports:NewButton(Name, "Teleport to this place", function()
        Character.PrimaryPart.CFrame = CFrame
    end)
end

HorseTab:NewToggle("Horse Fly", "Move = WASD", function(State)
    if State then
        local Keys_Pressed = {
        	["W"] = 0;
        	["A"] = 0;
        	["S"] = 0;
        	["D"] = 0;
        }
        local Key_Info = {
        	["W"] = {
        		["Operator"] = "+";
        		["Direction"] = "LookVector";
        	};
        	["A"] = {
        		["Operator"] = "-";
        		["Direction"] = "RightVector";
        	};
        	["S"] = {
        		["Operator"] = "-";
        		["Direction"] = "LookVector";
        	};
        	["D"] = {
        		["Operator"] = "+";
        		["Direction"] = "RightVector";
        	};
        }
        
        
        --// Begin fly script
        
        --// Variables
        local UIS = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        
        --// Neat functions
        local function GetKeyFromEnum(enum)
        	return enum.KeyCode.Name
        end
        
        local function GetMass(Model)
        	local Mass = 0;
        	for i,v in pairs(Model:GetDescendants()) do
        		if v:IsA("BasePart") then Mass = Mass + v:GetMass() end
        	end
        	return Mass;
        end
        
        local function Math(Operator, A, B)
        	if Operator == "-" then return A-B elseif Operator == "+" then return A+B end
        end
        
        --// Key detection
        UIS.InputBegan:Connect(function(Key, Typing)
        	if Typing then return end
        	
        	local Key_String = GetKeyFromEnum(Key)
        	if Keys_Pressed[Key_String] then
        		Keys_Pressed[Key_String] = 1
        	end
        end)
        
        UIS.InputEnded:Connect(function(Key, Typing)
        	if Typing then return end
        	
        	local Key_String = GetKeyFromEnum(Key)
        	if Keys_Pressed[Key_String] then
        		Keys_Pressed[Key_String] = 0
        	end
        end)
        
        --// Fly loop
        
        _G.FlyLoop = RunService.RenderStepped:Connect(function()
        	if not Horse then return end
        	Horse.Humanoid.WalkSpeed = 0; Horse.Humanoid.JumpPower = 0;
        	
        	Horse.HumanoidRootPart.CFrame = CFrame.new(Horse.HumanoidRootPart.Position, Horse.HumanoidRootPart.Position + workspace.CurrentCamera.CFrame.LookVector)
        	local HorseMass = GetMass(Horse)
        	--// Calculate new velocity
        	
            local Velocity = Vector3.new(0, HorseMass/workspace.Gravity, 0) --// Lets try not to decend
            for i,v in pairs(Keys_Pressed) do
                if v == 0 then else
                Velocity = Math(Key_Info[i].Operator, Velocity, Horse.HumanoidRootPart.CFrame[Key_Info[i].Direction] * settings.horse["FlySpeed"] * HorseMass) end
            end
        	
        	Horse.HumanoidRootPart.Velocity = Velocity
        end)
    else
        _G.FlyLoop:Disconnect()
        HorseMass.Humanoid.WalkSpeed = settings.horse["WalkSpeed"]
    end
end)

HorseTab:NewSlider("Horse Fly Speed", "Adjust Fly Speed", 50, 0, function(Value) -- 500 (MaxValue) | 0 (MinValue)
    settings.horse["FlySpeed"] = Value
end)

HorseTeleports = HorseTabs:NewSection("Horse Teleports")

for Name, CFrame in settings.teleports do
    HorseTeleports:NewButton(Name, "Teleport Horse to this place", function()
        Horse.HumanoidRootPart.CFrame = CFrame
    end)
end

HorseTeleports:NewButton("Teleport to Horse", "Teleports you to Horse", function()
    Character.PrimaryPart.CFrame = Horse.HumanoidRootPart.CFrame
end)

HorseTeleports:NewButton("Teleport Horse to you", "Teleports Horse to you", function()
    Horse.HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end)

getgenv().AttachLoop = nil
Stands:NewToggle("Attach Yourself To Player", "the title the title", function(State)
    local suc, fail = pcall(function()
        local CameraValue;
        local OldPos;
        task.wait(1)
        
        if State then
            local EnemyChar = workspace.Living:FindFirstChild(settings.stands["TargetPlayer"])
            if not EnemyChar then return end
            
            OldPos = Character.PrimaryPart.CFrame
            CameraValue = Instance.new("ObjectValue", Character)
            CameraValue.Name = "FocusCam"
            CameraValue.Value = EnemyChar.Humanoid
            
            AttachLoop = game:GetService("RunService").RenderStepped:Connect(function()
                task.wait()
                local Prediction = EnemyChar.PrimaryPart.Velocity * (settings.stands["PredictionStrength"]/10)

                task.spawn(function()
                    SummonStand(true)
                end)
                
                task.spawn(function()
                    if Prediction == Vector3.new(0, 0, 0) then
                        Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        Character.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame - Vector3.new(0,40,0)
                        Character.StandMorph.HumanoidRootPart.StandAttach.AlignPosition.MaxForce = 9e9
                        Character.StandMorph.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame - EnemyChar.PrimaryPart.CFrame.lookVector * settings.stands["StandAttachDistance"]
                        Character.StandMorph.HumanoidRootPart.CFrame = CFrame.lookAt(Character.StandMorph.HumanoidRootPart.Position, EnemyChar.PrimaryPart.Position)
                    else
                        Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        Character.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame - Vector3.new(0,35,0)
                        Character.StandMorph.HumanoidRootPart.StandAttach.AlignPosition.MaxForce = 9e9
                        Character.StandMorph.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame + Prediction
                        Character.StandMorph.HumanoidRootPart.CFrame = CFrame.lookAt(Character.StandMorph.HumanoidRootPart.Position, EnemyChar.PrimaryPart.Position)
                    end
                end)
                
                if EnemyChar["Blocking_Capacity"].Value == 0 then
                    if settings.stands["Barrage"] then UseMove(Enum.KeyCode.E) end
                    if settings.stands["Punch"] then UseMove("m1") end
                else
                    if settings.stands["Finisher"] then UseMove(Enum.KeyCode.R) end
                    if settings.stands["HeavyPunch"] then UseMove("m2") end
                end
            end)
        else
            if AttachLoop then
                AttachLoop:Disconnect()

                if Character:FindFirstChild("FocusCam") then
                    Character.FocusCam:Destroy()
                end
                
                for i = 0, 2, 1 do
                    SummonStand(false)
                    
                    if settings.teleports["Normal Hide"] then
                        Character.PrimaryPart.CFrame = settings.teleports["Normal Hide"]
                    else
                        Character.PrimaryPart.CFrame = OldPos
                    end
                    
                    task.wait(1)
                end
            end
        end
    end)
    warn(suc,fail)
end)

Stands:NewButton("Teleport to Player", "TP to player", function()
    pcall(function()
        Character.PrimaryPart.CFrame = workspace.Living:FindFirstChild(settings.stands["TargetPlayer"]).PrimaryPart.CFrame
    end)
end)

local StandSettings = StandsTab:NewSection("Settings")

UpdateList()

local PlayerSelection = StandSettings:NewDropdown("Select Target", "Select Target", settings.stands["AllPlayers"], function(Select)
    settings.stands["TargetPlayer"] = Select
end)

StandSettings:NewToggle("Auto Barrage", "Auto Barrage", function(State)
    settings.stands["Barrage"] = State
end)

StandSettings:NewToggle("Auto Barrage Finisher", "Auto Carrage Finisher", function(State)
    settings.stands["Finisher"] = State
end)

StandSettings:NewToggle("Auto Punch", "Auto Punch", function(State)
    settings.stands["Punch"] = State
end)

StandSettings:NewToggle("Auto Heavy Punch", "Auto Heavy Punch", function(State)
    settings.stands["HeavyPunch"] = State
end)

StandSettings:NewSlider("Stand Distance", "Distance from player", 10, 0, function(Value)
    settings.stands["StandAttachDistance"] = Value
end)

StandSettings:NewSlider("Prediction Strength", "Predicts the player movement", 6, 0, function(Value)
    settings.stands["PredictionStrength"] = Value
end)

Players.PlayerAdded:Connect(function(player)
    repeat task.wait() until workspace.Living:FindFirstChild(player.Name) and UpdateList()

    PlayerSelection:Refresh(settings.stands["AllPlayers"])
end)

Players.PlayerRemoving:Connect(function(player)
    repeat task.wait() until UpdateList()
    
    PlayerSelection:Refresh(settings.stands["AllPlayers"])
end)

Other:NewButton("Delete Stage Barriers", "you can't use auto sbr with this", function(t)
    for i = 1, 4, 1 do
        workspace.Barriers[i]:Destroy()
    end
end)

Other:NewToggle("Infinite Dash", "Change Dash Power/Delay", function(State)
    if State then
        InfDash = game:GetService("UserInputService").InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed then return end
            
            if Input.KeyCode == Enum.KeyCode.LeftAlt and (tick()-InfTick) >= settings["InfDelay"] then
                InfTick = tick()
                if not Character then return end
                local Dir, Anim_ = Get_Stroke()
                local Anim = Instance.new("Animation", workspace) Anim.Name = "Dash_Xenon" Anim.AnimationId = "rbxassetid://"..Anim_
                local Anim2 = Character.Humanoid:LoadAnimation(Anim)
                Anim2:Play()
                GAYPENIS = Instance.new("BodyVelocity", Character.HumanoidRootPart)
                GAYPENIS.Name = "DashVelocity"
                GAYPENIS.Velocity = (Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Dir), 0)).lookVector * settings["DP"]
                GAYPENIS.MaxForce = Vector3.new(55555,1000,55555)
                game:GetService("Debris"):AddItem(GAYPENIS, 0.25)
            end
        end)
    else
        if InfDash then
            InfDash:Disconnect()
        end
    end
end)

Other:NewSlider("Dash Power", "", 1000, 50, function(Value)
    settings["DP"] = Value;
end)

Other:NewSlider("Dash Delay", "", 2, 0.1, function(Value)
    settings["InfDelay"] = Value;
end)

Credits:NewLabel("Owner & Developer: vezrr")
Credits:NewLabel("Fly & Bypasses: enxquity")
Credits:NewLabel("UI: Kavo (Kavo UI Library)")
    
Character.ChildAdded:Connect(function(Child)
    if Child:IsA("BodyPosition") or Child:IsA("BodyVelocity") then
        Child:Destroy()
    end
end)

game.CollectionService.TagAdded:Connect(function(Tag)
    if Tag == "AntiHeal" then
        Character.RemoteEvent:FireServer("StopPoison")
        Character.RemoteEvent:FireServer("StopBleed")
        Character.RemoteEvent:FireServer("StopFire")
    end
end)
