local InputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local ProjectTX = {
    Flags = {},
    Themes = {
        Main = Color3.fromRGB(15, 15, 15),
        Header = Color3.fromRGB(20, 20, 20),
        Section = Color3.fromRGB(22, 22, 22),
        Element = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Stroke = Color3.fromRGB(40, 40, 40)
    }
}
ProjectTX.__index = ProjectTX

-- Utility Functions
function ProjectTX:Tween(obj, props, info)
    local tween = TweenService:Create(obj, info or TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

function ProjectTX:Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do inst[i] = v end
    return inst
end

function ProjectTX:Window(props)
    local Cfg = {
        Title = props.Title or "Project TX",
        Footer = props.Footer or "Project TX | Tha Bronx 3",
        Size = props.Size or UDim2.new(0, 700, 0, 450),
        Tabs = {}
    }
    
    local Screen = self:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ProjectTX",
        IgnoreGuiInset = true
    })
    
    local Main = self:Create("Frame", {
        Parent = Screen,
        Size = Cfg.Size,
        Position = UDim2.new(0.5, -Cfg.Size.X.Offset/2, 0.5, -Cfg.Size.Y.Offset/2),
        BackgroundColor3 = self.Themes.Main,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 4)})
    self:Create("UIStroke", {Parent = Main, Color = self.Themes.Stroke, Thickness = 1})

    -- Header (Title)
    local Header = self:Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = self.Themes.Header,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 4)})
    
    local Title = self:Create("TextLabel", {
        Parent = Header,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = Cfg.Title,
        TextColor3 = self.Themes.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Navigation (Tabs)
    local Nav = self:Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0
    })
    
    local TabHolder = self:Create("Frame", {
        Parent = Nav,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    self:Create("UIListLayout", {
        Parent = TabHolder,
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    -- Container
    local Container = self:Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, -20, 1, -95),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    -- Dragging
    local Dragging, DragStart, StartPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
        end
    end)
    InputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    InputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)

    -- Resizer
    local ResizeBtn = self:Create("ImageLabel", {
        Parent = Main,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -2, 1, -2),
        AnchorPoint = Vector2.new(1, 1),
        Image = "rbxassetid://6031094678",
        ImageColor3 = self.Themes.SubText,
        BackgroundTransparency = 1,
        ZIndex = 10
    })

    local Resizing = false
    local ResizeStartSize, ResizeStartPos
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = true
            ResizeStartSize = Main.Size
            ResizeStartPos = input.Position
        end
    end)
    InputService.InputChanged:Connect(function(input)
        if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - ResizeStartPos
            Main.Size = UDim2.new(0, math.max(ResizeStartSize.X.Offset + Delta.X, 400), 0, math.max(ResizeStartSize.Y.Offset + Delta.Y, 300))
        end
    end)
    InputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Resizing = false end
    end)

    local Window = setmetatable({
        Main = Main,
        TabHolder = TabHolder,
        Container = Container,
        Tabs = {},
        CurrentTab = nil
    }, ProjectTX)

    return Window
end

function ProjectTX:Tab(props)
    local Name = props.Name or "Tab"
    
    local TabButton = self:Create("TextButton", {
        Parent = self.TabHolder,
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundTransparency = 1,
        Text = Name,
        TextColor3 = self.Themes.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0
    })
    
    local Indicator = self:Create("Frame", {
        Parent = TabButton,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = self.Themes.Accent,
        BorderSizePixel = 0,
        Visible = false
    })

    local Page = self:Create("ScrollingFrame", {
        Parent = self.Container,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    -- 2-Column Layout
    local LeftCol = self:Create("Frame", {
        Parent = Page,
        Size = UDim2.new(0.5, -5, 1, 0),
        BackgroundTransparency = 1
    })
    local RightCol = self:Create("Frame", {
        Parent = Page,
        Size = UDim2.new(0.5, -5, 1, 0),
        Position = UDim2.new(0.5, 5, 0, 0),
        BackgroundTransparency = 1
    })
    
    for _, col in pairs({LeftCol, RightCol}) do
        self:Create("UIListLayout", {Parent = col, Padding = UDim.new(0, 10)})
    end

    local Tab = {
        Button = TabButton,
        Indicator = Indicator,
        Page = Page,
        Left = LeftCol,
        Right = RightCol
    }

    TabButton.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Page.Visible = false
            self.CurrentTab.Indicator.Visible = false
            self.CurrentTab.Button.TextColor3 = self.Themes.SubText
            self.CurrentTab.Button.BackgroundTransparency = 1
        end
        Page.Visible = true
        Indicator.Visible = true
        TabButton.TextColor3 = self.Themes.Text
        TabButton.BackgroundTransparency = 0.9 -- Subtle highlight
        self.CurrentTab = Tab
    end)

    if not self.CurrentTab then
        Page.Visible = true
        Indicator.Visible = true
        TabButton.TextColor3 = self.Themes.Text
        TabButton.BackgroundTransparency = 0.9
        self.CurrentTab = Tab
    end

    return setmetatable(Tab, {__index = ProjectTX})
end

function ProjectTX:Section(props)
    local Name = props.Name or "Section"
    local Parent = props.Parent or self.Left
    
    local Section = self:Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.Themes.Section,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Section, CornerRadius = UDim.new(0, 4)})
    self:Create("UIStroke", {Parent = Section, Color = self.Themes.Stroke, Thickness = 1})
    
    local Title = self:Create("TextLabel", {
        Parent = Section,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 0),
        Text = Name,
        TextColor3 = self.Themes.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Content = self:Create("Frame", {
        Parent = Section,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 30),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1
    })
    self:Create("UIListLayout", {Parent = Content, Padding = UDim.new(0, 8)})
    self:Create("UIPadding", {Parent = Content, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})

    return setmetatable({Content = Content}, {__index = ProjectTX})
end

function ProjectTX:Toggle(props)
    local Name = props.Name or "Toggle"
    local Default = props.Default or false
    local Callback = props.Callback or function() end
    
    local Frame = self:Create("Frame", {
        Parent = self.Content,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1
    })
    
    local Label = self:Create("TextLabel", {
        Parent = Frame,
        Size = UDim2.new(1, -40, 1, 0),
        Text = Name,
        TextColor3 = self.Themes.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Switch = self:Create("TextButton", {
        Parent = Frame,
        Size = UDim2.new(0, 30, 0, 16),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Default and self.Themes.Accent or self.Themes.Element,
        Text = "",
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
    
    local Knob = self:Create("Frame", {
        Parent = Switch,
        Size = UDim2.new(0, 12, 0, 12),
        Position = Default and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

    local Toggled = Default
    Switch.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        self:Tween(Switch, {BackgroundColor3 = Toggled and self.Themes.Accent or self.Themes.Element})
        self:Tween(Knob, {Position = Toggled and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
        Callback(Toggled)
    end)
end

function ProjectTX:Slider(props)
    local Name = props.Name or "Slider"
    local Min = props.Min or 0
    local Max = props.Max or 100
    local Default = props.Default or 50
    local Callback = props.Callback or function() end
    
    local Frame = self:Create("Frame", {
        Parent = self.Content,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1
    })
    
    local Label = self:Create("TextLabel", {
        Parent = Frame,
        Size = UDim2.new(1, 0, 0, 15),
        Text = Name,
        TextColor3 = self.Themes.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Track = self:Create("Frame", {
        Parent = Frame,
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = self.Themes.Element,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Track, CornerRadius = UDim.new(1, 0)})
    
    local Fill = self:Create("Frame", {
        Parent = Track,
        Size = UDim2.new((Default - Min)/(Max - Min), 0, 1, 0),
        BackgroundColor3 = self.Themes.Accent,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
    
    local ValueLabel = self:Create("TextLabel", {
        Parent = Frame,
        Size = UDim2.new(0, 40, 0, 15),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        Text = tostring(Default),
        TextColor3 = self.Themes.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local function Update(input)
        local Size = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(Size, 0, 1, 0)
        local Value = math.floor(Min + (Max - Min) * Size)
        ValueLabel.Text = tostring(Value)
        Callback(Value)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Update(input)
            local MoveConn, EndConn
            MoveConn = InputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
            EndConn = InputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    MoveConn:Disconnect()
                    EndConn:Disconnect()
                end
            end)
        end
    end)
end

function ProjectTX:Button(props)
    local Name = props.Name or "Button"
    local Callback = props.Callback or function() end
    
    local Button = self:Create("TextButton", {
        Parent = self.Content,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = self.Themes.Element,
        Text = Name,
        TextColor3 = self.Themes.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 4)})
    self:Create("UIStroke", {Parent = Button, Color = self.Themes.Stroke, Thickness = 1})
    
    Button.MouseButton1Click:Connect(Callback)
end

function ProjectTX:Dropdown(props)
    local Name = props.Name or "Dropdown"
    local Options = props.Options or {}
    local Default = props.Default or Options[1] or "None"
    local Callback = props.Callback or function() end
    
    local Frame = self:Create("Frame", {
        Parent = self.Content,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    local Label = self:Create("TextLabel", {
        Parent = Frame,
        Size = UDim2.new(0, 80, 1, 0),
        Text = Name,
        TextColor3 = self.Themes.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Main = self:Create("TextButton", {
        Parent = Frame,
        Size = UDim2.new(1, -85, 0, 25),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = self.Themes.Element,
        Text = Default,
        TextColor3 = self.Themes.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 4)})
    self:Create("UIStroke", {Parent = Main, Color = self.Themes.Stroke, Thickness = 1})

    local DropFrame = self:Create("ScrollingFrame", {
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = self.Themes.Section,
        BorderSizePixel = 0,
        ZIndex = 10,
        Visible = false,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Themes.Accent
    })
    self:Create("UIListLayout", {Parent = DropFrame})
    self:Create("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 4)})
    self:Create("UIStroke", {Parent = DropFrame, Color = self.Themes.Stroke, Thickness = 1})

    local function Toggle()
        DropFrame.Visible = not DropFrame.Visible
        DropFrame.Size = DropFrame.Visible and UDim2.new(1, 0, 0, math.min(#Options * 25, 100)) or UDim2.new(1, 0, 0, 0)
    end

    Main.MouseButton1Click:Connect(Toggle)

    for _, opt in pairs(Options) do
        local OptBtn = self:Create("TextButton", {
            Parent = DropFrame,
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            Text = opt,
            TextColor3 = self.Themes.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ZIndex = 11
        })
        OptBtn.MouseButton1Click:Connect(function()
            Main.Text = opt
            Toggle()
            Callback(opt)
        end)
    end
end

function ProjectTX:Label(props)
    local Name = props.Name or "Label"
    
    self:Create("TextLabel", {
        Parent = self.Content,
        Size = UDim2.new(1, 0, 0, 20),
        Text = Name,
        TextColor3 = self.Themes.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

function ProjectTX:Overlay(props)
    local Title = props.Title or "VALLEY.GG"
    
    local Screen = self:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ProjectTX_Overlay"
    })
    
    local Main = self:Create("Frame", {
        Parent = Screen,
        Size = UDim2.new(0, 160, 0, 180),
        Position = UDim2.new(0, 20, 0.4, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0
    })
    self:Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 8)})
    self:Create("UIStroke", {Parent = Main, Color = self.Themes.Stroke, Thickness = 1})

    local LogoIcon = self:Create("ImageLabel", {
        Parent = Main,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 15, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxassetid://132646272379361",
        BackgroundTransparency = 1,
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    })

    local Content = self:Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundTransparency = 1
    })
    self:Create("UIListLayout", {Parent = Content, Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center})

    local Overlay = {
        Main = Main,
        Content = Content
    }

    function Overlay:Button(props)
        local Name = props.Name or "Button"
        local Callback = props.Callback or function() end
        
        local Btn = Instance.new("TextButton")
        Btn.Name = Name
        Btn.Parent = Content
        Btn.Size = UDim2.new(1, 0, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Btn.Text = Name
        Btn.TextColor3 = Color3.fromRGB(255, 60, 60)
        Btn.TextSize = 14
        Btn.Font = Enum.Font.GothamBold
        Btn.BorderSizePixel = 0
        
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.fromRGB(40, 20, 20)
        Stroke.Thickness = 1
        
        Btn.MouseButton1Click:Connect(Callback)
        return Btn
    end

    -- Draggable
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
        end
    end)
    InputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    InputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)

    return Overlay
end

return ProjectTX
