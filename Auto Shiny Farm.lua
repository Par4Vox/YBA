getgenv().standList =  {
    ["The World"] = true,
    ["Star Platinum"] = true,
    ["Star Platinum: The World"] = true,
    ["Crazy Diamond"] = true,
    ["King Crimson"] = true,
    ["King Crimson Requiem"] = true
}

getgenv().sortOrder = "Asc" --desc for less players, asc for more
getgenv().lessPing = false --turn this on if u want lower ping servers, cant guarantee you will see same people using script, and data error 1
getgenv().webhook = "" --change this if u want to use ur own webhook

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
repeat task.wait() until Character:FindFirstChild("RemoteEvent") and Character:FindFirstChild("RemoteFunction")
local RemoteFunction, RemoteEvent = Character.RemoteFunction, Character.RemoteEvent
local HRP = Character.PrimaryPart
local part

if not LocalPlayer.PlayerGui:FindFirstChild("HUD") then
    print("I FOUND IT")
    local HUD = game:GetService("ReplicatedStorage").Objects.HUD:Clone()
    HUD.Parent = LocalPlayer.PlayerGui
end

print("I DID FOUND IT, MAYBE IT WILL WORK?")
RemoteEvent:FireServer("PressedPlay")

if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1") then
    LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1"):Destroy()
end

if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen") then
    LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen"):Destroy()
end

local function SendWebhook(msg)
    local url = getgenv().webhook

    local data;
    data = {
        ["embeds"] = {
            {
                ["title"] = "sigma hub - stand ferm",
                ["description"] = msg,
                ["type"] = "rich",
                ["color"] = tonumber(0x7269ff),
            }
        }
    }

    repeat task.wait() until data
    local newdata = game:GetService("HttpService"):JSONEncode(data)


    local headers = {
        ["Content-Type"] = "application/json"
    }
    local request = http_request or request or HttpPost or syn.request or http.request
    local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    request(abcdef)
end

local itemHook;
itemHook = hookfunction(getrawmetatable(game.Players.LocalPlayer.Character.HumanoidRootPart.Position).__index, function(p,i)
    if getcallingscript().Name == "ItemSpawn" and i:lower() == "magnitude" then
        return 0
    end
    return itemHook(p,i)
end)

local Hook;
Hook = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
    local args = {...}
    local namecallmethod =  getnamecallmethod()

    if namecallmethod == "InvokeServer" then
        if args[1] == "idklolbrah2de" then
            return "  ___XP DE KEY"
        end
    end

    return Hook(self, ...)
end))

part = Instance.new("Part")
part.Parent = workspace
part.Anchored = true
part.Size = Vector3.new(25,1,25)
part.Position = Vector3.new(500, 2000, 500)

function ClickBTN(BTN)
    for _,connection in pairs(getconnections(BTN.MouseButton1Click)) do
        connection:Fire()
    end
end

local function useItem(aItem, amount)
    local item = LocalPlayer.Backpack:WaitForChild(aItem, 5)

    if amount then
        LocalPlayer.Character.Humanoid:EquipTool(item)
        LocalPlayer.Character:WaitForChild("RemoteFunction"):InvokeServer("LearnSkill",{["Skill"] = "Worthiness ".. amount,["SkillTreeType"] = "Character"})
        item:Activate()

        repeat task.wait() until LocalPlayer.PlayerGui:FindFirstChild("DialogueGui")
        firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
        task.wait()
        firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.Options:WaitForChild("Option1").TextButton.MouseButton1Click)
        task.wait()
        firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
        task.wait()
		repeat task.wait() until LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.DialogueFrame.Frame.Line001.Container.Group001.Text == "You"
		firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
        task.wait()
    end
end
local Main = LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("Main")
local Stands = Main.Frames:WaitForChild("Stands")
local ScrollingFrame = Stands:WaitForChild("ScrollingFrame")
local Equipped = ScrollingFrame:WaitForChild("Equipped")

--main function (entrypoint) of standfarm
local function attemptStandFarm()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(500, 2010, 500)
    
    if LocalPlayer.PlayerStats.Stand.Value == "None" then
        print("DEBUG CHECK, USING MYSTERIOUS ARROW")
        useItem("Mysterious Arrow", "II")
        repeat task.wait() until LocalPlayer.PlayerStats.Stand.Value ~= "None"

        if not Equipped:FindFirstChild("Shiny") then
            print("DEBUG CHECK, USING ROKAKAKA")
            useItem("Rokakaka", "II")
        elseif Equipped:FindFirstChild("Shiny") then
            SendWebhook("Got `".. LocalPlayer.PlayerStats.Stand.Value .. "` stand")
        end

    elseif not Equipped:FindFirstChild("Shiny") then
        print("DEBUG CHECK, USING ROKAKAKA TO CLEAR STAND")
        useItem("Rokakaka", "II")
    end
end

if not Equipped:FindFirstChild("Shiny") then
    attemptStandFarm()
end

game.Workspace.Living.ChildAdded:Connect(function(character)
    if character.Name == LocalPlayer.Name then
        if not Equipped:FindFirstChild("Shiny") then
            attemptStandFarm()
        end
    end
end)
