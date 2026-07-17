local Segoe = loadstring(game:HttpGet("https://raw.githubusercontent.com/millicas/Segoe/refs/heads/main/Segoe.lua"))()
local Window = Segoe:CreateWindow({
    Title = "Segoe Demo",
    Size = UDim2.new(0, 780, 0, 520),
})
Segoe:Notify({
    Title = "Welcome!",
    Message = "Segoe UI Demo loaded successfully",
    Type = "Success",
    Duration = 3
})
local Tab1 = Window:CreateTab({Name = "Basic"})
Tab1:CreateSection("Buttons & Labels")
Tab1:CreateLabel("This is a simple label element")
Tab1:CreateButton({
    Name = "Click Me!",
    Callback = function()
        Segoe:Notify({
            Title = "Button Clicked",
            Message = "You clicked the button!",
            Type = "Success"
        })
    end
})
Tab1:CreateParagraph({
    Title = "What is Segoe?",
    Content = "A modern, minimalist UI library with smooth animations and a clean design aesthetic."
})
local Tab2 = Window:CreateTab({Name = "Toggles"})
Tab2:CreateSection("Toggle Controls")
local toggle1 = Tab2:CreateToggle({
    Name = "Enable Feature",
    Default = false,
    Flag = "FeatureToggle",
    Callback = function(value)
        print("Feature toggle:", value)
        Segoe:Notify({
            Message = "Feature " .. (value and "enabled" or "disabled"),
            Duration = 2
        })
    end
})
local toggle2 = Tab2:CreateToggle({
    Name = "Auto Save",
    Default = true,
    Flag = "AutoSave",
    Callback = function(value)
        print("Auto save:", value)
    end
})
Tab2:CreateButton({
    Name = "Toggle First Switch",
    Callback = function()
        toggle1:Set(not toggle1.Value)
    end
})
local Tab3 = Window:CreateTab({Name = "Sliders"})
Tab3:CreateSection("Numeric Inputs")
local speedSlider = Tab3:CreateSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Suffix = "%",
    Flag = "SpeedSlider",
    Callback = function(value)
        print("Speed:", value)
    end
})
local distanceSlider = Tab3:CreateSlider({
    Name = "Distance",
    Min = 0,
    Max = 500,
    Default = 100,
    Increment = 10,
    Suffix = "m",
    Flag = "DistanceSlider",
    Callback = function(value)
        print("Distance:", value)
    end
})
Tab3:CreateSlider({
    Name = "Precision Slider",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Increment = 0.01,
    Suffix = "",
    Callback = function(value)
        print("Precision value:", value)
    end
})
Tab3:CreateButton({
    Name = "Set Speed to 75%",
    Callback = function()
        speedSlider:Set(75)
    end
})
local Tab4 = Window:CreateTab({Name = "Dropdowns"})
Tab4:CreateSection("Selection Controls")
local weaponDropdown = Tab4:CreateDropdown({
    Name = "Weapon",
    Options = {"Sword", "Bow", "Staff", "Axe", "Dagger"},
    Default = "Sword",
    Flag = "WeaponSelect",
    Callback = function(value)
        print("Selected weapon:", value)
        Segoe:Notify({
            Message = "Weapon changed to " .. value,
            Duration = 2
        })
    end
})
local difficultyDropdown = Tab4:CreateDropdown({
    Name = "Difficulty",
    Options = {"Easy", "Normal", "Hard", "Expert"},
    Default = "Normal",
    Callback = function(value)
        print("Difficulty:", value)
    end
})
Tab4:CreateButton({
    Name = "Add New Weapon",
    Callback = function()
        weaponDropdown:Refresh({"Sword", "Bow", "Staff", "Axe", "Dagger", "Spear", "Mace"})
        Segoe:Notify({Message = "Weapon list updated!", Duration = 2})
    end
})
Tab4:CreateButton({
    Name = "Select Staff",
    Callback = function()
        weaponDropdown:Set("Staff")
    end
})
local Tab5 = Window:CreateTab({Name = "Inputs"})
Tab5:CreateSection("Text & Keyboard")
local nameInput = Tab5:CreateInput({
    Name = "Username",
    Placeholder = "Enter name...",
    Default = "",
    Flag = "UsernameInput",
    Callback = function(text)
        print("Username entered:", text)
        Segoe:Notify({
            Message = "Username set to: " .. text,
            Duration = 2
        })
    end
})
Tab5:CreateInput({
    Name = "Code",
    Placeholder = "Enter code...",
    ClearOnFocus = true,
    Callback = function(text)
        if text == "1234" then
            Segoe:Notify({
                Title = "Success!",
                Message = "Code accepted",
                Type = "Success"
            })
        end
    end
})
Tab5:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Flag = "ToggleKey",
    Callback = function(key)
        print("Keybind changed to:", key.Name)
    end,
    OnPress = function()
        print("Toggle key pressed!")
        Segoe:Notify({Message = "UI toggle key pressed!", Duration = 1})
    end
})
Tab5:CreateButton({
    Name = "Set Name to 'Player'",
    Callback = function()
        nameInput:Set("Player")
    end
})
local Tab6 = Window:CreateTab({Name = "Colors"})
Tab6:CreateSection("Color Selection")
local primaryColor = Tab6:CreateColorPicker({
    Name = "Primary Color",
    Default = Color3.fromRGB(88, 101, 242),
    Flag = "PrimaryColor",
    Callback = function(color)
        print("Primary color:", color)
    end
})
Tab6:CreateColorPicker({
    Name = "Secondary Color",
    Default = Color3.fromRGB(240, 70, 80),
    Callback = function(color)
        print("Secondary color:", color)
    end
})
Tab6:CreateColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(60, 200, 120),
    Callback = function(color)
        print("Accent color:", color)
    end
})
Tab6:CreateButton({
    Name = "Set Red Primary",
    Callback = function()
        primaryColor:Set(Color3.fromRGB(255, 0, 0))
    end
})
Tab6:CreateButton({
    Name = "Change Theme Accent",
    Callback = function()
        local newColor = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
        Segoe:SetAccent(newColor)
        Segoe:Notify({
            Message = "Theme accent updated!",
            Type = "Success",
            Duration = 2
        })
    end
})
local Tab7 = Window:CreateTab({Name = "Advanced"})
Tab7:CreateSection("Combined Features")
Tab7:CreateParagraph({
    Title = "Flag System",
    Content = "Components with flags can be accessed globally through Segoe.Flags"
})
Tab7:CreateButton({
    Name = "Print All Flags",
    Callback = function()
        print("=== Current Flag Values ===")
        for flag, component in pairs(Segoe.Flags) do
            print(flag .. ":", component.Value)
        end
        Segoe:Notify({
            Message = "Flags printed to console",
            Duration = 2
        })
    end
})
Tab7:CreateButton({
    Name = "Random Configuration",
    Callback = function()
        if Segoe.Flags.SpeedSlider then
            Segoe.Flags.SpeedSlider:Set(math.random(0, 100))
        end
        if Segoe.Flags.FeatureToggle then
            Segoe.Flags.FeatureToggle:Set(math.random() > 0.5)
        end
        Segoe:Notify({
            Title = "Randomized!",
            Message = "Settings randomized",
            Type = "Warning"
        })
    end
})
Tab7:CreateSection("Notifications")
Tab7:CreateButton({
    Name = "Success Notification",
    Callback = function()
        Segoe:Notify({
            Title = "Success",
            Message = "Operation completed successfully!",
            Type = "Success",
            Duration = 3
        })
    end
})
Tab7:CreateButton({
    Name = "Error Notification",
    Callback = function()
        Segoe:Notify({
            Title = "Error",
            Message = "Something went wrong!",
            Type = "Error",
            Duration = 3
        })
    end
})
Tab7:CreateButton({
    Name = "Warning Notification",
    Callback = function()
        Segoe:Notify({
            Title = "Warning",
            Message = "Please review your settings",
            Type = "Warning",
            Duration = 3
        })
    end
})
Tab7:CreateButton({
    Name = "Simple Notification",
    Callback = function()
        Segoe:Notify({
            Message = "This is a simple notification",
            Duration = 2
        })
    end
})
local Tab8 = Window:CreateTab({Name = "Sections"})
Tab8:CreateSection("First Section")
Tab8:CreateLabel("Content in the first section")
Tab8:CreateToggle({
    Name = "Option A",
    Default = true,
    Callback = function(v) print("Option A:", v) end
})
Tab8:CreateSection("Second Section")
Tab8:CreateLabel("Content in the second section")
Tab8:CreateToggle({
    Name = "Option B",
    Default = false,
    Callback = function(v) print("Option B:", v) end
})
Tab8:CreateSection("Third Section")
Tab8:CreateLabel("Content in the third section")
Tab8:CreateSlider({
    Name = "Value",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(v) print("Value:", v) end
})
