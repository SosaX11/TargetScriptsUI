# Project TX | UI Library

A high-performance, modern UI library designed for Roblox script developers. Built for **Tha Bronx 3** and similar environments, featuring a sleek dark aesthetic, 2-column layouts, and a draggable/resizable interface.

## Installation
-- named to project tx cuz yes men :joy:
```lua
local ProjectTX = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/ProjectTX/main/ProjectTXUI.lua"))()
```

## API Documentation

### Initializing the Window
```lua
local Window = ProjectTX:Window({
    Title = "Project TX | Premium",
    Footer = "Project TX | Tha Bronx 3",
    Size = UDim2.new(0, 550, 0, 350)
})
```

### Creating Tabs
Tabs automatically handle navigation and feature a 2-column scrolling layout (`Tab.Left` and `Tab.Right`).
```lua
local MainTab = Window:Tab({
    Name = "Combat"
})
```

### Adding Sections
Sections group elements together and can be placed in either the left or right column.
```lua
local AimbotSection = MainTab:Section({
    Name = "Aimbot Settings",
    Parent = MainTab.Left -- Optional: MainTab.Left (default) or MainTab.Right
})
```

### UI Elements

#### Toggle
```lua
AimbotSection:Toggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(Value)
        print("Aimbot is now:", Value)
    end
})
```

#### Slider
```lua
AimbotSection:Slider({
    Name = "Fov Radius",
    Min = 0,
    Max = 500,
    Default = 100,
    Callback = function(Value)
        print("FOV set to:", Value)
    end
})
```

#### Button
```lua
AimbotSection:Button({
    Name = "Reset Settings",
    Callback = function()
        print("Settings reset!")
    end
})
```

#### Dropdown
```lua
AimbotSection:Dropdown({
    Name = "Target Priority",
    Options = {"Distance", "Health", "FOV"},
    Default = "Distance",
    Callback = function(Option)
        print("Targeting by:", Option)
    end
})
```

#### Label
```lua
AimbotSection:Label({
    Name = "Current Status: Active"
})
```

### Overlays (Mini Menu)
Useful for persistent status or quick toggles outside the main menu.
```lua
local Overlay = ProjectTX:Overlay({
    Title = "VALLEY.GG"
})

Overlay:Button({
    Name = "Kill All",
    Callback = function()
        print("Executing Kill All...")
    end
})
```

## Theme Configuration
You can customize the colors by modifying the `ProjectTX.Themes` table before initializing the window.

```lua
ProjectTX.Themes.Accent = Color3.fromRGB(0, 255, 255) -- Cyan theme
```

---
*Developed for Project TX*
