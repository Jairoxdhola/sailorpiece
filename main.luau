-- Cancel old loops and connections
if getgenv().SailorHub_Cancel then
    getgenv().SailorHub_Cancel = true
end
if getgenv().SailorHub_Connection then
    getgenv().SailorHub_Connection:Disconnect()
end
if getgenv().SailorHub_FPS then
    getgenv().SailorHub_FPS:Disconnect()
end
getgenv().SailorHub_Cancel = false
getgenv().Config = nil -- Clear global config if any

-- Destroy old GUI if re-executing
if game:GetService("CoreGui"):FindFirstChild("SailorHub") then
    game:GetService("CoreGui"):FindFirstChild("SailorHub"):Destroy()
end

local Library = loadstring([[
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Library = {}
Library.Colors = {
    BG = Color3.fromRGB(18,18,28), Sidebar = Color3.fromRGB(22,22,35),
    Content = Color3.fromRGB(28,28,42), TopBar = Color3.fromRGB(25,25,38),
    Accent = Color3.fromRGB(110,90,255), Text = Color3.fromRGB(225,225,235),
    Sub = Color3.fromRGB(140,140,165), Elem = Color3.fromRGB(35,35,52),
    TogOff = Color3.fromRGB(45,45,65), TogOn = Color3.fromRGB(100,80,255),
}
local C = Library.Colors
Library.Version = "v1.2.6 (FPS Fix)"

function Library:CreateWindow(title, toggleKey)
    -- Loading Screen
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local load = Instance.new("Frame", sg)
    load.Size = UDim2.new(0,300,0,100)
    load.Position = UDim2.new(0.5,-150,0.5,-50)
    load.BackgroundColor3 = C.BG
    load.BorderSizePixel = 0
    Instance.new("UICorner", load).CornerRadius = UDim.new(0,10)
    local ll = Instance.new("TextLabel", load)
    ll.Size = UDim2.new(1,0,0,40)
    ll.BackgroundTransparency = 1
    ll.Text = "Sailor Hub Loading..."
    ll.TextColor3 = C.Text
    ll.Font = Enum.Font.GothamBold
    ll.TextSize = 15
    local bar = Instance.new("Frame", load)
    bar.Size = UDim2.new(0.8,0,0,4)
    bar.Position = UDim2.new(0.1,0,0.7,0)
    bar.BackgroundColor3 = C.Elem
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = C.Accent
    
    TweenService:Create(fill, TweenInfo.new(1.5), {Size = UDim2.new(1,0,1,0)}):Play()
    task.wait(1.6)
    sg:Destroy()

    print("Sailor UI Loaded: " .. Library.Version)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SailorHub"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game:GetService("CoreGui")

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,720,0,460)
    main.Position = UDim2.new(0.5,-360,0.5,-230)
    main.BackgroundColor3 = C.BG
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

    -- TopBar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundColor3 = C.TopBar
    top.BorderSizePixel = 0
    Instance.new("UICorner", top).CornerRadius = UDim.new(0,10)
    local fix = Instance.new("Frame", top)
    fix.Size = UDim2.new(1,0,0,10)
    fix.Position = UDim2.new(0,0,1,-10)
    fix.BackgroundColor3 = C.TopBar
    fix.BorderSizePixel = 0

    local tl = Instance.new("TextLabel", top)
    tl.Size = UDim2.new(0,300,1,0)
    tl.Position = UDim2.new(0,15,0,0)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = C.Text
    tl.TextSize = 16
    tl.Font = Enum.Font.GothamBold
    tl.TextXAlignment = Enum.TextXAlignment.Left

    local cls = Instance.new("TextButton", top)
    cls.Size = UDim2.new(0,40,0,40)
    cls.Position = UDim2.new(1,-40,0,0)
    cls.BackgroundTransparency = 1
    cls.Text = "X"
    cls.TextColor3 = C.Sub
    cls.TextSize = 16
    cls.Font = Enum.Font.GothamBold
    cls.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    -- Drag
    local drag,dI,dS,sP
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dS = i.Position
            sP = main.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    top.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then dI = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == dI and drag then
            local d = i.Position - dS
            main.Position = UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y)
        end
    end)

    -- Toggle key
    UIS.InputBegan:Connect(function(i, gpe)
        if not gpe and i.KeyCode == (toggleKey or Enum.KeyCode.K) then
            main.Visible = not main.Visible
        end
    end)

    -- Sidebar
    local side = Instance.new("Frame", main)
    side.Size = UDim2.new(0,150,1,-40)
    side.Position = UDim2.new(0,0,0,40)
    side.BackgroundColor3 = C.Sidebar
    side.BorderSizePixel = 0
    local sl = Instance.new("UIListLayout", side)
    sl.Padding = UDim.new(0,4)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    local sp = Instance.new("UIPadding", side)
    sp.PaddingTop = UDim.new(0,8)
    sp.PaddingLeft = UDim.new(0,6)
    sp.PaddingRight = UDim.new(0,6)

    -- Content
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1,-150,1,-40)
    content.Position = UDim2.new(0,150,0,40)
    content.BackgroundColor3 = C.Content
    content.BorderSizePixel = 0

    local window = {gui = gui, main = main, content = content, side = side, tabs = {}, activeTab = nil}

    function window:CreateTab(name)
        local page = Instance.new("ScrollingFrame", content)
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = C.Accent
        page.BorderSizePixel = 0
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0,6)
        pl.SortOrder = Enum.SortOrder.LayoutOrder
        local pp = Instance.new("UIPadding", page)
        pp.PaddingTop = UDim.new(0,10)
        pp.PaddingLeft = UDim.new(0,10)
        pp.PaddingRight = UDim.new(0,10)
        pp.PaddingBottom = UDim.new(0,180) -- Increased padding to prevent clipping of long dropdowns

        local btn = Instance.new("TextButton", side)
        btn.Size = UDim2.new(1,0,0,34)
        btn.BackgroundTransparency = 1
        btn.BackgroundColor3 = C.Accent
        btn.Text = name
        btn.TextColor3 = C.Sub
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)

        btn.MouseButton1Click:Connect(function()
            for _,t in pairs(self.tabs) do
                t.page.Visible = false
                t.btn.BackgroundTransparency = 1
                t.btn.TextColor3 = C.Sub
                if t.obj and t.obj.CloseAllDropdowns then
                    t.obj:CloseAllDropdowns()
                end
            end
            page.Visible = true
            btn.BackgroundTransparency = 0.85
            btn.TextColor3 = C.Text
        end)

        local tab = {page = page, btn = btn}
        table.insert(self.tabs, tab)
        if #self.tabs == 1 then
            page.Visible = true
            btn.BackgroundTransparency = 0.85
            btn.TextColor3 = C.Text
        end

        local tabObj = {page = page, dropdowns = {}}
        tab.obj = tabObj

        function tabObj:CloseAllDropdowns()
            if tabObj.dropdowns then
                for _, d in pairs(tabObj.dropdowns) do
                    if d.lf then d.lf.Visible = false end
                    if d.h then d.h.ZIndex = 5 end
                end
            end
        end

        function tabObj:CreateToggle(name, default, callback)
            local h = Instance.new("Frame", page)
            h.Size = UDim2.new(1,0,0,38)
            h.BackgroundColor3 = C.Elem
            h.BorderSizePixel = 0
            Instance.new("UICorner", h).CornerRadius = UDim.new(0,7)
            local l = Instance.new("TextLabel", h)
            l.Size = UDim2.new(1,-65,1,0)
            l.Position = UDim2.new(0,10,0,0)
            l.BackgroundTransparency = 1
            l.Text = name
            l.TextColor3 = C.Text
            l.TextSize = 12
            l.Font = Enum.Font.GothamMedium
            l.TextXAlignment = Enum.TextXAlignment.Left
            local tf = Instance.new("Frame", h)
            tf.Size = UDim2.new(0,40,0,20)
            tf.Position = UDim2.new(1,-50,0.5,-10)
            tf.BackgroundColor3 = default and C.TogOn or C.TogOff
            tf.BorderSizePixel = 0
            Instance.new("UICorner", tf).CornerRadius = UDim.new(1,0)
            local ci = Instance.new("Frame", tf)
            ci.Size = UDim2.new(0,16,0,16)
            ci.Position = default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
            ci.BackgroundColor3 = Color3.new(1,1,1)
            ci.BorderSizePixel = 0
            Instance.new("UICorner", ci).CornerRadius = UDim.new(1,0)
            local on = default
            local b = Instance.new("TextButton", h)
            b.Size = UDim2.new(1,0,1,0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.MouseButton1Click:Connect(function()
                on = not on
                TweenService:Create(tf, TweenInfo.new(0.15), {BackgroundColor3 = on and C.TogOn or C.TogOff}):Play()
                TweenService:Create(ci, TweenInfo.new(0.15), {Position = on and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
                if callback then callback(on) end
            end)
            return h
        end

        function tabObj:CreateDropdown(name, options, default, multi, callback)
            local h = Instance.new("Frame", page)
            h.Size = UDim2.new(1,0,0,38)
            h.BackgroundColor3 = C.Elem
            h.BorderSizePixel = 0
            h.ClipsDescendants = false
            h.ZIndex = 5
            Instance.new("UICorner", h).CornerRadius = UDim.new(0,7)
            local l = Instance.new("TextLabel", h)
            l.Size = UDim2.new(0.4,0,1,0)
            l.Position = UDim2.new(0,10,0,0)
            l.BackgroundTransparency = 1
            l.Text = name
            l.TextColor3 = C.Text
            l.TextSize = 12
            l.Font = Enum.Font.GothamMedium
            l.TextXAlignment = Enum.TextXAlignment.Left
            local sel = multi and (default or {}) or (default or options[1])
            local db = Instance.new("TextButton", h)
            db.Size = UDim2.new(0.55,0,0,28)
            db.Position = UDim2.new(0.42,0,0.5,-14)
            db.BackgroundColor3 = C.TogOff
            db.BorderSizePixel = 0
            db.TextColor3 = C.Text
            db.TextSize = 11
            db.Font = Enum.Font.GothamMedium
            db.TextTruncate = Enum.TextTruncate.AtEnd
            db.Text = multi and (#sel > 0 and table.concat(sel,", ") or "Select...") or tostring(sel)
            db.ZIndex = 5
            Instance.new("UICorner", db).CornerRadius = UDim.new(0,5)
            local lf = Instance.new("ScrollingFrame", h)
            lf.Size = UDim2.new(0.55,0,0,math.min(#options*28,150))
            lf.Position = UDim2.new(0.42,0,1,3)
            lf.BackgroundColor3 = C.Elem
            lf.BorderSizePixel = 0
            lf.Visible = false
            lf.ScrollBarThickness = 4
            lf.ScrollBarImageColor3 = C.Accent
            lf.ZIndex = 50
            lf.CanvasSize = UDim2.new(0,0,0,#options*28)
            lf.AutomaticCanvasSize = Enum.AutomaticSize.None
            Instance.new("UICorner", lf).CornerRadius = UDim.new(0,5)
            Instance.new("UIListLayout", lf).SortOrder = Enum.SortOrder.LayoutOrder

            local function populate(opts)
                for _,c in pairs(lf:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                lf.CanvasSize = UDim2.new(0,0,0,#opts*28)
                lf.Size = UDim2.new(0.55,0,0,math.min(#opts*28,150))
                for _,o in ipairs(opts) do
                    local ob = Instance.new("TextButton", lf)
                    ob.Size = UDim2.new(1,0,0,28)
                    ob.BackgroundTransparency = 0.5
                    ob.BackgroundColor3 = C.Elem
                    ob.BorderSizePixel = 0
                    ob.Text = "  "..o
                    ob.TextColor3 = C.Sub
                    ob.TextSize = 11
                    ob.Font = Enum.Font.GothamMedium
                    ob.TextXAlignment = Enum.TextXAlignment.Left
                    ob.ZIndex = 50
                    ob.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(sel, o)
                            if idx then table.remove(sel, idx) else table.insert(sel, o) end
                            db.Text = #sel > 0 and table.concat(sel,", ") or "Select..."
                            ob.TextColor3 = table.find(sel, o) and C.Accent or C.Sub
                        else
                            sel = o
                            db.Text = o
                            lf.Visible = false
                        end
                        if callback then callback(multi and sel or sel) end
                    end)
                end
            end
            populate(options)
            table.insert(tabObj.dropdowns, {h = h, lf = lf})

            db.MouseButton1Click:Connect(function() 
                local wasVisible = lf.Visible
                tabObj:CloseAllDropdowns()
                lf.Visible = not wasVisible
                h.ZIndex = lf.Visible and 1000 or 5
            end)
            local dropObj = {refresh = function(_, newOpts)
                options = newOpts
                populate(newOpts)
            end}
            return h, dropObj
        end

        function tabObj:CreateSlider(name, min, max, default, suffix, callback)
            local h = Instance.new("Frame", page)
            h.Size = UDim2.new(1,0,0,50)
            h.BackgroundColor3 = C.Elem
            h.BorderSizePixel = 0
            Instance.new("UICorner", h).CornerRadius = UDim.new(0,7)
            local l = Instance.new("TextLabel", h)
            l.Size = UDim2.new(1,-10,0,20)
            l.Position = UDim2.new(0,10,0,4)
            l.BackgroundTransparency = 1
            l.Text = name..": "..default..(suffix or "")
            l.TextColor3 = C.Text
            l.TextSize = 12
            l.Font = Enum.Font.GothamMedium
            l.TextXAlignment = Enum.TextXAlignment.Left
            local bar = Instance.new("Frame", h)
            bar.Size = UDim2.new(1,-20,0,6)
            bar.Position = UDim2.new(0,10,0,34)
            bar.BackgroundColor3 = C.TogOff
            bar.BorderSizePixel = 0
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
            fill.BackgroundColor3 = C.Accent
            fill.BorderSizePixel = 0
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
            local knob = Instance.new("Frame", bar)
            knob.Size = UDim2.new(0,14,0,14)
            knob.Position = UDim2.new((default-min)/(max-min),-7,0.5,-7)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.BorderSizePixel = 0
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
            local sliding = false
            local ib = Instance.new("TextButton", bar)
            ib.Size = UDim2.new(1,0,0,20)
            ib.Position = UDim2.new(0,0,-1,0)
            ib.BackgroundTransparency = 1
            ib.Text = ""
            ib.MouseButton1Down:Connect(function() sliding = true end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
            end)
            UIS.InputChanged:Connect(function(i)
                if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    local abs = bar.AbsolutePosition.X
                    local sz = bar.AbsoluteSize.X
                    local pct = math.clamp((i.Position.X - abs) / sz, 0, 1)
                    local val = math.floor(min + (max-min)*pct)
                    fill.Size = UDim2.new(pct,0,1,0)
                    knob.Position = UDim2.new(pct,-7,0.5,-7)
                    l.Text = name..": "..val..(suffix or "")
                    if callback then callback(val) end
                end
            end)
            return h
        end

        function tabObj:CreateButton(name, callback)
            local b = Instance.new("TextButton", page)
            b.Size = UDim2.new(1,0,0,36)
            b.BackgroundColor3 = C.Accent
            b.BorderSizePixel = 0
            b.Text = name
            b.TextColor3 = C.Text
            b.TextSize = 13
            b.Font = Enum.Font.GothamBold
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
            b.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            return b
        end

        function tabObj:CreateLabel(text)
            local l = Instance.new("TextLabel", page)
            l.Size = UDim2.new(1,0,0,22)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Sub
            l.TextSize = 11
            l.Font = Enum.Font.GothamMedium
            l.TextXAlignment = Enum.TextXAlignment.Left
            return l
        end

        return tabObj
    end

    function window:Notify(title, text)
        local n = Instance.new("Frame", gui)
        n.Size = UDim2.new(0,280,0,60)
        n.Position = UDim2.new(1,300,1,-80)
        n.BackgroundColor3 = C.TopBar
        n.BorderSizePixel = 0
        Instance.new("UICorner", n).CornerRadius = UDim.new(0,8)
        local nt = Instance.new("TextLabel", n)
        nt.Size = UDim2.new(1,-16,0,22)
        nt.Position = UDim2.new(0,8,0,6)
        nt.BackgroundTransparency = 1
        nt.Text = title
        nt.TextColor3 = C.Accent
        nt.TextSize = 13
        nt.Font = Enum.Font.GothamBold
        nt.TextXAlignment = Enum.TextXAlignment.Left
        local nc = Instance.new("TextLabel", n)
        nc.Size = UDim2.new(1,-16,0,20)
        nc.Position = UDim2.new(0,8,0,30)
        nc.BackgroundTransparency = 1
        nc.Text = text
        nc.TextColor3 = C.Sub
        nc.TextSize = 11
        nc.Font = Enum.Font.GothamMedium
        nc.TextXAlignment = Enum.TextXAlignment.Left
        TweenService:Create(n, TweenInfo.new(0.4), {Position = UDim2.new(1,-300,1,-80)}):Play()
        task.delay(4, function()
            TweenService:Create(n, TweenInfo.new(0.4), {Position = UDim2.new(1,300,1,-80)}):Play()
            task.wait(0.5)
            n:Destroy()
        end)
    end

    return window
end

return Library
]])()
local Window = Library:CreateWindow("Sailor Piece Hub", Enum.KeyCode.K)

local player = game.Players.LocalPlayer
local Config = {
    SelectedWeapon = "None",
    AutoEquip = false,
    SelectedDungeon = "CidDungeon",
    SelectedDifficulty = "Easy",
    AutoKillDungeon = false,
    AutoVoteDifficulty = false,
    AutoReplayDungeon = false,
    AntiAFK = true
}

-- UI Setup
local MainTab = Window:CreateTab("Combat")
local FarmTab = Window:CreateTab("Farm")
local TeleportTab = Window:CreateTab("Teleport")
local DungeonTab = Window:CreateTab("Dungeon")

-- Config Update
Config.SelectedQuestNPC = "QuestNPC1"
Config.AutoAcceptQuest = false
Config.AutoFarm = false
Config.AutoFarmQuest = false
Config.SelectedMob = "None"
Config.AttackDistance = 5
Config.AttackPosition = "Above"

-- Quest Data Mapping
local QuestsData = {
    ["QuestNPC1"] = {Island="Starter", Mobs={"Thief1","Thief2","Thief3","Thief5"}},
    ["QuestNPC2"] = {Island="Starter", Mobs={"ThiefBoss"}},
    ["QuestNPC3"] = {Island="Jungle", Mobs={"Monkey1","Monkey2","Monkey3","Monkey4","Monkey5"}},
    ["QuestNPC4"] = {Island="Jungle", Mobs={"MonkeyBoss"}},
    ["QuestNPC5"] = {Island="Desert", Mobs={"DesertBandit1","DesertBandit2","DesertBandit3","DesertBandit4","DesertBandit5"}},
    ["QuestNPC6"] = {Island="Desert", Mobs={"DesertBoss"}},
    ["QuestNPC7"] = {Island="Snow", Mobs={"FrostRogue1"}},
    ["QuestNPC8"] = {Island="Snow", Mobs={"SnowBoss"}},
    ["QuestNPC9"] = {Island="Shibuya", Mobs={"Sorcerer1"}},
    ["QuestNPC10"] = {Island="Shibuya", Mobs={"PandaMiniBoss"}},
    ["QuestNPC11"] = {Island="HollowIsland", Mobs={"Hollow1"}},
    ["QuestNPC12"] = {Island="Shinjuku", Mobs={"StrongSorcerer1"}},
    ["QuestNPC13"] = {Island="Shinjuku", Mobs={"Curse1"}},
    ["QuestNPC14"] = {Island="Slime", Mobs={"Slime1"}},
    ["QuestNPC15"] = {Island="Academy", Mobs={"AcademyTeacher1"}},
    ["QuestNPC16"] = {Island="Judgement", Mobs={"Swordsman1"}},
    ["QuestNPC17"] = {Island="Judgement", Mobs={"Quincy1"}},
    ["QuestNPC18"] = {Island="Judgement", Mobs={"Ninja1"}},
    ["QuestNPC19"] = {Island="Lawless", Mobs={"ArenaFighter1"}},
    ["Auto Farm Bunny"] = {Island="EasterIsland", Mobs={"Bunny1","Bunny2","Bunny3","Bunny4","Bunny5"}}
}

-- Remote Helper
local function GetRemote(folderName, remoteName)
    local rs = game:GetService("ReplicatedStorage")
    local folder = rs:FindFirstChild(folderName) or rs:FindFirstChild("Remotes") or rs:FindFirstChild("RemoteEvents")
    if folder then
        return folder:FindFirstChild(remoteName)
    end
    return nil
end

local function AbandonQuest()
    local r = GetRemote("RemoteEvents", "QuestAbandon")
    if r then r:FireServer("repeatable") end
end

local function TeleportToIsland(island)
    local r = GetRemote("Remotes", "TeleportToPortal")
    if r then r:FireServer(island) end
end

local function AcceptQuest(npc)
    local r = GetRemote("RemoteEvents", "QuestAccept")
    if r then r:FireServer(npc) end
end

-- Combat Tab (Weapons & Attack)
local _, weaponDropdownObj = MainTab:CreateDropdown("Select Weapon", {"None"}, "None", false, function(v)
    Config.SelectedWeapon = v
end)

MainTab:CreateToggle("Auto Equip", false, function(v)
    Config.AutoEquip = v
end)

MainTab:CreateDropdown("Attack Position", {"Above", "Below", "Behind"}, "Above", false, function(v)
    Config.AttackPosition = v
end)

MainTab:CreateSlider("Attack Distance", 1, 15, 5, " m", function(v)
    Config.AttackDistance = v
end)

-- Farm Tab (Quests & Farming)
local questNPCs = {}
for i = 1, 19 do table.insert(questNPCs, "Quest NPC "..i) end
table.insert(questNPCs, "Auto Farm Bunny")

FarmTab:CreateDropdown("Select Quest NPC", questNPCs, "Quest NPC 1", false, function(v)
    local npcName = v
    if v:find("Quest NPC ") then
        npcName = v:gsub("Quest NPC ", "QuestNPC")
    end
    Config.SelectedQuestNPC = npcName
    
    -- Auto Logic: Abandon -> Teleport -> Accept
    task.spawn(function()
        AbandonQuest()
        local qd = QuestsData[npcName]
        if qd then
            TeleportToIsland(qd.Island)
            task.wait(1.5)
            if npcName ~= "Auto Farm Bunny" then
                AcceptQuest(npcName)
            end
        end
    end)
end)

FarmTab:CreateToggle("Auto Farm Selected Quest", false, function(v)
    Config.AutoFarmQuest = v
end)

-- Teleport Selection
local islands = {
    "Starter", "Jungle", "Desert", "Snow", "Sailor", "Shibuya", "HollowIsland", 
    "Boss", "Dungeon", "Shinjuku", "Slime", "Academy", "Judgement", "Ninja", 
    "Lawless", "Tower", "Easter", "World"
}

TeleportTab:CreateDropdown("Select Island", islands, "Starter", false, function(v)
    TeleportToIsland(v)
end)

-- Dungeon Tab
DungeonTab:CreateDropdown("Select Dungeon", {"CidDungeon", "RuneDungeon", "DoubleDungeon"}, "CidDungeon", false, function(v)
    Config.SelectedDungeon = v
end)

DungeonTab:CreateButton("Start Dungeon", function()
    local args = {
        Config.SelectedDungeon
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestDungeonPortal"):FireServer(unpack(args))
    Window:Notify("Dungeon", "Requested portal for: " .. Config.SelectedDungeon)
end)

DungeonTab:CreateDropdown("Select Difficulty", {"Easy", "Medium", "Hard", "Extreme"}, "Easy", false, function(v)
    Config.SelectedDifficulty = v
end)

DungeonTab:CreateButton("Vote Difficulty", function()
    local args = {
        Config.SelectedDifficulty
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonWaveVote"):FireServer(unpack(args))
    Window:Notify("Dungeon", "Voted for: " .. Config.SelectedDifficulty)
end)

DungeonTab:CreateToggle("Auto Kill Dungeon", false, function(v)
    Config.AutoKillDungeon = v
end)

DungeonTab:CreateToggle("Auto Vote Difficulty", false, function(v)
    Config.AutoVoteDifficulty = v
end)

DungeonTab:CreateToggle("Auto Replay Dungeon", false, function(v)
    Config.AutoReplayDungeon = v
end)

local LastBossTeleport = 0
local CurrentIsland = "None"

-- Update CurrentIsland when teleporting
local oldTeleport = TeleportToIsland
TeleportToIsland = function(island)
    CurrentIsland = island
    oldTeleport(island)
end

-- Anti-AFK Implementation
player.Idled:Connect(function()
    if Config.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- ===== FUNCTIONS =====

local function GetTarget()
    local npcs = workspace:FindFirstChild("NPCs")
    if not npcs then return nil end
    
    -- Auto Kill Dungeon (Priority)
    if Config.AutoKillDungeon then
        for _, v in ipairs(npcs:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                return v
            end
        end
    end

    -- If Farming Quest, use QuestsData
    if Config.AutoFarmQuest then
        local qd = QuestsData[Config.SelectedQuestNPC]
        if qd then
            for _, v in ipairs(npcs:GetChildren()) do
                if table.find(qd.Mobs, v.Name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                    return v
                end
            end
        end
    end
    
    -- If Manual Farm, use SelectedMob
    if Config.AutoFarm then
        for _, v in ipairs(npcs:GetChildren()) do
            if v.Name == Config.SelectedMob and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                return v
            end
        end
    end
    
    return nil
end

local function GetAttackCFrame(target)
    local cf = target.HumanoidRootPart.CFrame
    local d = Config.AttackDistance
    if Config.AttackPosition == "Above" then
        return cf * CFrame.new(0, d, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    elseif Config.AttackPosition == "Below" then
        return cf * CFrame.new(0, -d, 0) * CFrame.Angles(math.rad(90), 0, 0)
    elseif Config.AttackPosition == "Behind" then
        return cf * CFrame.new(0, 0, d)
    end
    return cf * CFrame.new(0, d, 0)
end

-- ===== LOOPS =====

-- Target Cache
local currentTarget = nil
task.spawn(function()
    while task.wait(0.25) do -- Search targets 4 times per second, NOT 60!
        if getgenv().SailorHub_Cancel then break end
        if Config.AutoFarm or Config.AutoFarmQuest or Config.AutoKillDungeon or Config.AutoGlobalBoss then
            currentTarget = GetTarget()
        else
            currentTarget = nil
        end
    end
end)

-- Auto Farm & Movement Loop
getgenv().SailorHub_Connection = game:GetService("RunService").Heartbeat:Connect(function()
    if currentTarget then
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                char.HumanoidRootPart.CFrame = GetAttackCFrame(currentTarget)
            end
        end)
    end
end)

-- Fast Attack Loop
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().SailorHub_Cancel then break end
        if currentTarget then
            pcall(function()
                local r = game:GetService("ReplicatedStorage"):FindFirstChild("CombatSystem") and game:GetService("ReplicatedStorage").CombatSystem:FindFirstChild("Remotes")
                if r then
                    local hit = r:FindFirstChild("RequestHit")
                    if hit then hit:FireServer() end
                end
            end)
        end
    end
end)

-- Auto Quest Loop (Keep quest active)
task.spawn(function()
    while task.wait(5) do
        if getgenv().SailorHub_Cancel then break end
        if Config.AutoFarmQuest and Config.SelectedQuestNPC ~= "" then
            AcceptQuest(Config.SelectedQuestNPC)
        end
    end
end)

-- Refresh Loop (Backpack)
task.spawn(function()
    while task.wait(5) do
        if getgenv().SailorHub_Cancel then break end
        pcall(function()
            -- Weapons
            local items = {"None"}
            local seenW = {}
            for _, tool in ipairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and not seenW[tool.Name] then
                    table.insert(items, tool.Name)
                    seenW[tool.Name] = true
                end
            end
            if player.Character then
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") and not seenW[tool.Name] then
                        table.insert(items, tool.Name)
                        seenW[tool.Name] = true
                    end
                end
            end
            if weaponDropdownObj then weaponDropdownObj:refresh(items) end
        end)
    end
end)

-- Auto Dungeon Loop (Vote & Replay)
task.spawn(function()
    while task.wait(2) do
        if getgenv().SailorHub_Cancel then break end
        if Config.AutoVoteDifficulty then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonWaveVote"):FireServer(Config.SelectedDifficulty)
            end)
        end
        if Config.AutoReplayDungeon then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonWaveReplayVote"):FireServer("sponsor")
            end)
        end
    end
end)

-- Auto Equip Loop
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().SailorHub_Cancel then break end
        if Config.AutoEquip and Config.SelectedWeapon ~= "None" and Config.SelectedWeapon ~= "" then
            pcall(function()
                local char = player.Character
                if char and not char:FindFirstChild(Config.SelectedWeapon) then
                    local tool = player.Backpack:FindFirstChild(Config.SelectedWeapon)
                    if tool then
                        char.Humanoid:EquipTool(tool)
                    end
                end
            end)
        end
    end
end)

Window:Notify("Script Started", "Version: " .. (Library.Version or "Unknown"))

Window:Notify("Script Started", "Weapon system ready. Version: " .. (Library.Version or "Unknown"))
