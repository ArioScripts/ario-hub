-- ARIO HUB COMPLETE EXAMPLE
-- If ARIO.lua is hosted online:
-- local Ario = loadstring(game:HttpGet("YOUR_RAW_ARIO_URL"))()

local Ario = require(script.Parent.Parent.ARIO)

local Window = Ario:CreateWindow({
    Title = "ARIO HUB",
    Subtitle = "My custom Lua UI",
    Theme = "Midnight",
    Size = UDim2.fromOffset(620, 480)
})

local Main = Window:CreateTab({Name = "Main"})
local Settings = Window:CreateTab({Name = "Settings"})
local Info = Window:CreateTab({Name = "Info"})

Main:CreateSection("Controls")

Main:CreateButton({
    Name = "Execute",
    Tag = "NEW",
    Callback = function()
        Window:Notify({
            Title = "ARIO HUB",
            Content = "Button executed!",
            Duration = 3
        })
    end
})

Main:CreateToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(value)
        print("Enabled:", value)
    end
})

Main:CreateSlider({
    Name = "Power",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Power:", value)
    end
})

Main:CreateDropdown({
    Name = "Mode",
    Options = {"Normal", "Fast", "Extreme"},
    Default = "Normal",
    Callback = function(value)
        print("Mode:", value)
    end
})

Main:CreateInput({
    Placeholder = "Enter text...",
    Callback = function(text)
        print("Input:", text)
    end
})

Settings:CreateSection("Settings")

Settings:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    OnPressed = function()
        Window.Window.Visible = not Window.Window.Visible
    end
})

Settings:CreateTag("VIP", "VIP")
Settings:CreateTag("BETA", "BETA")
Settings:CreateTag("FREE", "FREE")

Info:CreateParagraph(
    "ARIO HUB",
    "A custom UI library made for ARIO SCRIPTS."
)
