# ARIO HUB UI Library

A custom Roblox Lua UI library for ARIO SCRIPTS.

## Components

### Window
```lua
local Window = Ario:CreateWindow({
    Title = "ARIO HUB",
    Subtitle = "My UI",
    Theme = "Midnight",
    Size = UDim2.fromOffset(620, 480)
})
```

### Tab
```lua
local Main = Window:CreateTab({Name = "Main"})
```

### Section
```lua
Main:CreateSection("Combat")
```

### Label
```lua
Main:CreateLabel("Hello ARIO")
```

### Paragraph
```lua
Main:CreateParagraph("About", "This is my custom UI.")
```

### Button
```lua
Main:CreateButton({
    Name = "Execute",
    Tag = "NEW",
    Callback = function()
        print("clicked")
    end
})
```

### Toggle
```lua
local Toggle = Main:CreateToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(value)
        print(value)
    end
})

Toggle:Set(true)
print(Toggle:Get())
```

### Slider
```lua
local Slider = Main:CreateSlider({
    Name = "Speed",
    Min = 1,
    Max = 100,
    Default = 25,
    Callback = function(value)
        print(value)
    end
})

Slider:Set(50)
```

### Dropdown
```lua
local Dropdown = Main:CreateDropdown({
    Name = "Mode",
    Options = {"Normal", "Fast", "Extreme"},
    Default = "Normal",
    Callback = function(value)
        print(value)
    end
})
```

### Input
```lua
Main:CreateInput({
    Placeholder = "Username...",
    Callback = function(text, enterPressed)
        print(text)
    end
})
```

### Keybind
```lua
Main:CreateKeybind({
    Name = "Toggle",
    Default = Enum.KeyCode.RightShift,
    OnPressed = function()
        print("pressed")
    end
})
```

### Tags
```lua
Main:CreateTag("NEW", "NEW")
Main:CreateTag("VIP", "VIP")
Main:CreateTag("BETA", "BETA")
Main:CreateTag("FREE", "FREE")
```

## Built-in themes

- Midnight
- Obsidian
- Ocean

Use:
```lua
Theme = "Ocean"
```

## Custom themes

```lua
Ario:RegisterTheme("MyTheme", {
    Background = Color3.fromRGB(8, 12, 20),
    Surface = Color3.fromRGB(15, 22, 35),
    Surface2 = Color3.fromRGB(23, 34, 52),
    Border = Color3.fromRGB(45, 75, 110),
    Text = Color3.fromRGB(245, 250, 255),
    Muted = Color3.fromRGB(145, 165, 185),
    Accent = Color3.fromRGB(45, 135, 255),
    Success = Color3.fromRGB(70, 210, 135),
    Danger = Color3.fromRGB(240, 80, 90),
})

local Window = Ario:CreateWindow({
    Title = "ARIO HUB",
    Theme = "MyTheme"
})
```

## Notification

```lua
Window:Notify({
    Title = "Success",
    Content = "Loaded!",
    Duration = 3
})
```

## Loading

For testing inside Roblox Studio, use a ModuleScript and `require()`.

For a remote loader, host `ARIO.lua` somewhere that provides its raw text, then:

```lua
local Ario = loadstring(game:HttpGet("YOUR_RAW_URL"))()
```

Do not use a GitHub normal webpage URL. Use the raw file URL.

## Notes

This is version 1.0.0 and intentionally keeps the core library in one file so it is easy to host and load. The Components/Core/Themes folders are documentation and extension starting points.
