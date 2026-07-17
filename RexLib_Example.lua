--[[
    RexLib Example Usage
    Load the library and build a full UI with all element types
]]

local RexLib = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))() -- replace with your raw paste URL
-- OR if testing locally:
-- local RexLib = loadfile("RexLib.lua")()

-- ===================== CREATE WINDOW =====================
local Window = RexLib:CreateWindow({
    Title = "Rex Hub v2.0",
    Size = UDim2.new(0, 540, 0, 400),
})

-- Startup notification
RexLib:Notify({
    Title = "Rex Hub",
    Message = "Loaded successfully — welcome back.",
    Duration = 3,
    Type = "Success"
})

-- ===================== COMBAT TAB =====================
local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "⚔"
})

CombatTab:CreateSection("Targeting")

local AimbotToggle = CombatTab:CreateToggle({
    Name = "Target Acquisition",
    Default = false,
    Flag = "Aimbot",
    Callback = function(state)
        print("[Combat] Target Acquisition:", state)
        if state then
            RexLib:Notify({Title = "Combat", Message = "Target acquisition enabled", Type = "Info"})
        end
    end
})

local FOVSlider = CombatTab:CreateSlider({
    Name = "Acquisition FOV",
    Min = 10,
    Max = 800,
    Default = 120,
    Increment = 5,
    Suffix = "px",
    Flag = "AimFOV",
    Callback = function(val)
        print("[Combat] FOV set to:", val)
    end
})

local SmoothSlider = CombatTab:CreateSlider({
    Name = "Smoothing Factor",
    Min = 0,
    Max = 1,
    Default = 0.3,
    Increment = 0.05,
    Flag = "AimSmooth",
    Callback = function(val)
        print("[Combat] Smoothing:", val)
    end
})

local TargetPartDrop = CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
    Default = "Head",
    Flag = "TargetPart",
    Callback = function(opt)
        print("[Combat] Targeting:", opt)
    end
})

CombatTab:CreateSection("Reach")

local ReachToggle = CombatTab:CreateToggle({
    Name = "Extended Reach",
    Default = false,
    Flag = "Reach",
    Callback = function(state)
        print("[Combat] Reach:", state)
    end
})

local ReachSlider = CombatTab:CreateSlider({
    Name = "Reach Distance",
    Min = 5,
    Max = 25,
    Default = 10,
    Increment = 0.5,
    Suffix = " studs",
    Flag = "ReachDist",
    Callback = function(val)
        print("[Combat] Reach distance:", val)
    end
})

-- ===================== VISUALS TAB =====================
local VisualsTab = Window:CreateTab({
    Name = "Visuals",
    Icon = "👁"
})

VisualsTab:CreateSection("Entity Overlay")

local ESPToggle = VisualsTab:CreateToggle({
    Name = "Entity State Panel",
    Default = false,
    Flag = "ESP",
    Callback = function(state)
        print("[Visuals] ESP:", state)
    end
})

local ESPColorPicker = VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(88, 101, 242),
    Flag = "ESPColor",
    Callback = function(color)
        print("[Visuals] ESP Color:", color)
    end
})

local BoxDrop = VisualsTab:CreateDropdown({
    Name = "Box Type",
    Options = {"2D", "3D", "Corners", "None"},
    Default = "2D",
    Flag = "BoxType",
    Callback = function(opt)
        print("[Visuals] Box type:", opt)
    end
})

VisualsTab:CreateSection("Occlusion")

local WallToggle = VisualsTab:CreateToggle({
    Name = "Occlusion Override",
    Default = false,
    Flag = "WallVis",
    Callback = function(state)
        print("[Visuals] Occlusion override:", state)
    end
})

local ChamsDrop = VisualsTab:CreateDropdown({
    Name = "Render Mode",
    Options = {"Highlight", "SurfaceAppearance", "Wireframe", "ForceField"},
    Default = "Highlight",
    Flag = "ChamsMode",
    Callback = function(opt)
        print("[Visuals] Render mode:", opt)
    end
})

local ChamsColor = VisualsTab:CreateColorPicker({
    Name = "Overlay Color",
    Default = Color3.fromRGB(255, 60, 80),
    Flag = "ChamsColor",
    Callback = function(color)
        print("[Visuals] Overlay color:", color)
    end
})

local TransSlider = VisualsTab:CreateSlider({
    Name = "Overlay Transparency",
    Min = 0,
    Max = 1,
    Default = 0.3,
    Increment = 0.05,
    Suffix = "",
    Flag = "ChamsTrans",
    Callback = function(val)
        print("[Visuals] Transparency:", val)
    end
})

-- ===================== MOVEMENT TAB =====================
local MoveTab = Window:CreateTab({
    Name = "Movement",
    Icon = "🏃"
})

MoveTab:CreateSection("Speed")

local SpeedToggle = MoveTab:CreateToggle({
    Name = "Speed Modifier",
    Default = false,
    Flag = "Speed",
    Callback = function(state)
        if state then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = RexLib.Flags.SpeedVal.Value
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

local SpeedSlider = MoveTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 32,
    Increment = 1,
    Flag = "SpeedVal",
    Callback = function(val)
        if RexLib.Flags and RexLib.Flags.Speed and RexLib.Flags.Speed.Value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

MoveTab:CreateSection("Aerial")

local FlyToggle = MoveTab:CreateToggle({
    Name = "Flight",
    Default = false,
    Flag = "Fly",
    Callback = function(state)
        print("[Movement] Flight:", state)
    end
})

local FlySpeedSlider = MoveTab:CreateSlider({
    Name = "Flight Speed",
    Min = 10,
    Max = 300,
    Default = 60,
    Increment = 5,
    Flag = "FlySpeed",
    Callback = function(val)
        print("[Movement] Flight speed:", val)
    end
})

local JumpSlider = MoveTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 10,
    Flag = "JumpPow",
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
    end
})

local NoClipToggle = MoveTab:CreateToggle({
    Name = "No Clip",
    Default = false,
    Flag = "Noclip",
    Callback = function(state)
        print("[Movement] Noclip:", state)
    end
})

-- ===================== MISC TAB =====================
local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "🔧"
})

MiscTab:CreateSection("Utilities")

MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        RexLib:Notify({Title = "Misc", Message = "Rejoining...", Duration = 2, Type = "Warning"})
        task.delay(1, function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end
})

MiscTab:CreateButton({
    Name = "Copy Server Link",
    Callback = function()
        local jobId = game.JobId
        setclipboard("roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. jobId)
        RexLib:Notify({Title = "Misc", Message = "Server link copied to clipboard", Duration = 2, Type = "Success"})
    end
})

MiscTab:CreateInput({
    Name = "Teleport PlaceID",
    Placeholder = "Enter PlaceID...",
    Flag = "TPPlaceId",
    Callback = function(text)
        local id = tonumber(text)
        if id then
            RexLib:Notify({Title = "Teleport", Message = "Teleporting to " .. text, Duration = 2, Type = "Info"})
            game:GetService("TeleportService"):Teleport(id, game.Players.LocalPlayer)
        else
            RexLib:Notify({Title = "Error", Message = "Invalid PlaceID", Duration = 2, Type = "Error"})
        end
    end
})

MiscTab:CreateSection("Binds")

MiscTab:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Flag = "UIToggle",
    OnPress = function()
        -- This would toggle the UI visibility
        print("[Misc] UI toggle pressed")
    end
})

MiscTab:CreateKeybind({
    Name = "Panic Key (Destroy)",
    Default = Enum.KeyCode.F9,
    Flag = "PanicKey",
    OnPress = function()
        Window:Destroy()
    end
})

MiscTab:CreateSection("Info")

MiscTab:CreateParagraph({
    Title = "Rex Hub v2.0",
    Content = "Built with RexLib. Minimal. Functional. No bullshit."
})

MiscTab:CreateLabel("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
MiscTab:CreateLabel("Player: " .. game.Players.LocalPlayer.Name)
