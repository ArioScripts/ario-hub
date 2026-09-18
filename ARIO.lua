local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Ario = {}
Ario.__index = Ario

Ario.Version = "1.0.0"
Ario.Themes = {}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or .18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function Ario:RegisterTheme(name, theme)
    self.Themes[name] = theme
end

Ario:RegisterTheme("Midnight", {
    Background = Color3.fromRGB(12, 14, 20),
    Surface = Color3.fromRGB(20, 23, 32),
    Surface2 = Color3.fromRGB(26, 30, 41),
    Border = Color3.fromRGB(48, 53, 68),
    Text = Color3.fromRGB(240, 243, 250),
    Muted = Color3.fromRGB(145, 153, 170),
    Accent = Color3.fromRGB(72, 130, 255),
    Success = Color3.fromRGB(80, 200, 130),
    Danger = Color3.fromRGB(235, 85, 95),
})

Ario:RegisterTheme("Obsidian", {
    Background = Color3.fromRGB(8, 8, 10),
    Surface = Color3.fromRGB(16, 16, 19),
    Surface2 = Color3.fromRGB(24, 24, 28),
    Border = Color3.fromRGB(42, 42, 48),
    Text = Color3.fromRGB(245, 245, 245),
    Muted = Color3.fromRGB(150, 150, 158),
    Accent = Color3.fromRGB(180, 100, 255),
    Success = Color3.fromRGB(80, 205, 125),
    Danger = Color3.fromRGB(240, 80, 95),
})

Ario:RegisterTheme("Ocean", {
    Background = Color3.fromRGB(7, 17, 27),
    Surface = Color3.fromRGB(11, 29, 43),
    Surface2 = Color3.fromRGB(16, 40, 57),
    Border = Color3.fromRGB(30, 68, 88),
    Text = Color3.fromRGB(235, 248, 255),
    Muted = Color3.fromRGB(135, 173, 190),
    Accent = Color3.fromRGB(35, 190, 255),
    Success = Color3.fromRGB(70, 215, 150),
    Danger = Color3.fromRGB(245, 90, 105),
})

function Ario:CreateWindow(options)
    options = options or {}
    local theme = self.Themes[options.Theme or "Midnight"] or self.Themes.Midnight

    local gui = make("ScreenGui", {
        Name = options.Name or "ArioHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, CoreGui)

    local window = make("Frame", {
        Name = "Window",
        Size = options.Size or UDim2.fromOffset(620, 480),
        Position = UDim2.fromScale(.5, .5),
        AnchorPoint = Vector2.new(.5, .5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, gui)
    make("UICorner", {CornerRadius = UDim.new(0, 14)}, window)
    make("UIStroke", {Color = theme.Border, Thickness = 1, Transparency = .15}, window)

    local top = make("Frame", {
        Size = UDim2.new(1,0,0,62),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0
    }, window)

    local title = make("TextLabel", {
        Position = UDim2.fromOffset(20, 9),
        Size = UDim2.new(1,-100,0,27),
        BackgroundTransparency = 1,
        Text = options.Title or "ARIO HUB",
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    }, top)

    local subtitle = make("TextLabel", {
        Position = UDim2.fromOffset(20, 34),
        Size = UDim2.new(1,-100,0,20),
        BackgroundTransparency = 1,
        Text = options.Subtitle or "ARIO UI Library",
        TextColor3 = theme.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, top)

    local close = make("TextButton", {
        Position = UDim2.new(1,-45,0,17),
        Size = UDim2.fromOffset(28,28),
        BackgroundColor3 = theme.Surface2,
        Text = "×",
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false
    }, top)
    make("UICorner", {CornerRadius = UDim.new(0,8)}, close)
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    local sidebar = make("ScrollingFrame", {
        Position = UDim2.fromOffset(10,72),
        Size = UDim2.new(0,150,1,-82),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new()
    }, window)
    local sideLayout = make("UIListLayout", {Padding = UDim.new(0,6)}, sidebar)

    local pages = make("Frame", {
        Position = UDim2.fromOffset(170,72),
        Size = UDim2.new(1,-180,1,-82),
        BackgroundTransparency = 1
    }, window)

    -- Dragging
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    top.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local W = {
        GUI = gui, Window = window, Theme = theme,
        Sidebar = sidebar, Pages = pages, Tabs = {},
        Current = nil
    }

    function W:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local page = make("ScrollingFrame", {
            Name = tabOptions.Name or "Tab",
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            Visible = false,
            CanvasSize = UDim2.new()
        }, pages)
        local layout = make("UIListLayout", {
            Padding = UDim.new(0,8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, page)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
        end)

        local button = make("TextButton", {
            Size = UDim2.new(1,-4,0,38),
            BackgroundColor3 = theme.Surface,
            Text = "  " .. (tabOptions.Name or "Tab"),
            TextColor3 = theme.Muted,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, sidebar)
        make("UICorner", {CornerRadius = UDim.new(0,9)}, button)

        local T = {Page = page, Button = button, Container = page, Window = W}

        local function select()
            for _, tab in pairs(W.Tabs) do
                tab.Page.Visible = false
                tab.Button.BackgroundColor3 = theme.Surface
                tab.Button.TextColor3 = theme.Muted
            end
            page.Visible = true
            button.BackgroundColor3 = theme.Accent
            button.TextColor3 = theme.Text
            W.Current = T
        end
        button.MouseButton1Click:Connect(select)
        table.insert(W.Tabs, T)
        if #W.Tabs == 1 then select() end

        function T:CreateSection(text)
            local s = make("TextLabel", {
                Size = UDim2.new(1,0,0,26),
                BackgroundTransparency = 1,
                Text = string.upper(text or "SECTION"),
                TextColor3 = theme.Muted,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            }, page)
            return s
        end

        function T:CreateLabel(text)
            return make("TextLabel", {
                Size = UDim2.new(1,0,0,32),
                BackgroundColor3 = theme.Surface,
                Text = "  " .. tostring(text or ""),
                TextColor3 = theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            }, page)
        end

        function T:CreateParagraph(titleText, bodyText)
            local f = make("Frame", {
                Size = UDim2.new(1,0,0,65),
                BackgroundColor3 = theme.Surface
            }, page)
            make("UICorner", {CornerRadius = UDim.new(0,10)}, f)
            make("TextLabel", {
                Position = UDim2.fromOffset(12,7),
                Size = UDim2.new(1,-24,0,20),
                BackgroundTransparency = 1,
                Text = titleText or "Information",
                TextColor3 = theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            }, f)
            make("TextLabel", {
                Position = UDim2.fromOffset(12,28),
                Size = UDim2.new(1,-24,0,30),
                BackgroundTransparency = 1,
                Text = bodyText or "",
                TextColor3 = theme.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left
            }, f)
            return f
        end

        function T:CreateButton(o)
            o = o or {}
            local b = make("TextButton", {
                Size = UDim2.new(1,0,0,42),
                BackgroundColor3 = theme.Surface,
                Text = (o.Name or "Button") .. (o.Tag and ("   ["..o.Tag.."]") or ""),
                TextColor3 = theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                AutoButtonColor = false
            }, page)
            make("UICorner", {CornerRadius = UDim.new(0,10)}, b)
            make("UIStroke", {Color = theme.Border, Transparency = .4}, b)
            b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=theme.Surface2}) end)
            b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=theme.Surface}) end)
            b.MouseButton1Click:Connect(function() if o.Callback then o.Callback() end end)
            return b
        end

        function T:CreateToggle(o)
            o = o or {}
            local state = o.Default == true
            local b = make("TextButton", {
                Size = UDim2.new(1,0,0,42),
                BackgroundColor3 = theme.Surface,
                Text = (o.Name or "Toggle") .. "   " .. (state and "ON" or "OFF"),
                TextColor3 = theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                AutoButtonColor = false
            }, page)
            make("UICorner", {CornerRadius = UDim.new(0,10)}, b)
            local function render()
                b.Text = (o.Name or "Toggle") .. "   " .. (state and "ON" or "OFF")
                b.BackgroundColor3 = state and theme.Accent or theme.Surface
                if o.Callback then o.Callback(state) end
            end
            b.MouseButton1Click:Connect(function() state = not state; render() end)
            return {
                Instance=b,
                Set=function(_,v) state=v==true; render() end,
                Get=function() return state end
            }
        end

        function T:CreateSlider(o)
            o=o or {}
            local min,max,default=o.Min or 0,o.Max or 100,o.Default or o.Min or 0
            local value=math.clamp(default,min,max)
            local f=make("Frame",{Size=UDim2.new(1,0,0,55),BackgroundColor3=theme.Surface},page)
            make("UICorner",{CornerRadius=UDim.new(0,10)},f)
            local label=make("TextLabel",{Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-24,0,20),BackgroundTransparency=1,Text=(o.Name or "Slider").." : "..tostring(value),TextColor3=theme.Text,Font=Enum.Font.GothamMedium,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},f)
            local bar=make("Frame",{Position=UDim2.new(0,12,0,34),Size=UDim2.new(1,-24,0,7),BackgroundColor3=theme.Surface2},f)
            make("UICorner",{CornerRadius=UDim.new(1,0)},bar)
            local fill=make("Frame",{Size=UDim2.new((value-min)/(max-min),0,1,0),BackgroundColor3=theme.Accent},bar)
            make("UICorner",{CornerRadius=UDim.new(1,0)},fill)
            local function set(v)
                value=math.clamp(v,min,max)
                local p=(value-min)/(max-min)
                fill.Size=UDim2.new(p,0,1,0)
                label.Text=(o.Name or "Slider").." : "..tostring(value)
                if o.Callback then o.Callback(value) end
            end
            bar.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    local move; move=UserInputService.InputChanged:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseMovement then
                            local p=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                            set(math.floor(min+(max-min)*p))
                        end
                    end)
                    local ended; ended=UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseButton1 then move:Disconnect(); ended:Disconnect() end
                    end)
                end
            end)
            return {Instance=f,Set=function(_,v) set(v) end,Get=function() return value end}
        end

        function T:CreateDropdown(o)
            o=o or {}
            local opts=o.Options or {}
            local current=o.Default or opts[1] or "Select"
            local b=make("TextButton",{Size=UDim2.new(1,0,0,42),BackgroundColor3=theme.Surface,Text=(o.Name or "Dropdown")..": "..tostring(current),TextColor3=theme.Text,Font=Enum.Font.GothamMedium,TextSize=13,AutoButtonColor=false},page)
            make("UICorner",{CornerRadius=UDim.new(0,10)},b)
            local list=make("Frame",{Position=UDim2.new(0,0,1,4),Size=UDim2.new(1,0,0,0),BackgroundColor3=theme.Surface2,Visible=false,ZIndex=10,ClipsDescendants=true},b)
            make("UICorner",{CornerRadius=UDim.new(0,8)},list)
            local lay=make("UIListLayout",{Padding=UDim.new(0,2)},list)
            for _,v in ipairs(opts) do
                local x=make("TextButton",{Size=UDim2.new(1,-8,0,30),BackgroundTransparency=1,Text=tostring(v),TextColor3=theme.Text,Font=Enum.Font.Gotham,TextSize=12,ZIndex=11},list)
                x.MouseButton1Click:Connect(function()
                    current=v; b.Text=(o.Name or "Dropdown")..": "..tostring(v); list.Visible=false
                    if o.Callback then o.Callback(v) end
                end)
            end
            b.MouseButton1Click:Connect(function()
                list.Visible=not list.Visible
                list.Size=UDim2.new(1,0,0,math.min(#opts*32+5,180))
            end)
            return {Instance=b,Set=function(_,v) current=v;b.Text=(o.Name or "Dropdown")..": "..tostring(v) end,Get=function() return current end}
        end

        function T:CreateInput(o)
            o=o or {}
            local box=make("TextBox",{Size=UDim2.new(1,0,0,42),BackgroundColor3=theme.Surface,PlaceholderText=o.Placeholder or "Type here...",Text=o.Default or "",TextColor3=theme.Text,PlaceholderColor3=theme.Muted,Font=Enum.Font.Gotham,TextSize=13,ClearTextOnFocus=false},page)
            make("UICorner",{CornerRadius=UDim.new(0,10)},box)
            box.FocusLost:Connect(function(enter)
                if o.Callback then o.Callback(box.Text,enter) end
            end)
            return box
        end

        function T:CreateKeybind(o)
            o=o or {}
            local key=o.Default or Enum.KeyCode.RightShift
            local b=make("TextButton",{Size=UDim2.new(1,0,0,42),BackgroundColor3=theme.Surface,Text=(o.Name or "Keybind")..": "..key.Name,TextColor3=theme.Text,Font=Enum.Font.GothamMedium,TextSize=13,AutoButtonColor=false},page)
            make("UICorner",{CornerRadius=UDim.new(0,10)},b)
            local listening=false
            b.MouseButton1Click:Connect(function() listening=true;b.Text=(o.Name or "Keybind")..": Press a key..." end)
            UserInputService.InputBegan:Connect(function(input,gp)
                if listening and input.UserInputType==Enum.UserInputType.Keyboard then
                    key=input.KeyCode;listening=false;b.Text=(o.Name or "Keybind")..": "..key.Name
                    if o.Callback then o.Callback(key) end
                elseif not gp and input.KeyCode==key and o.OnPressed then o.OnPressed() end
            end)
            return {Instance=b,Set=function(_,v) key=v;b.Text=(o.Name or "Keybind")..": "..key.Name end,Get=function() return key end}
        end

        function T:CreateTag(text, kind)
            local colors={NEW=theme.Accent,VIP=Color3.fromRGB(255,185,65),BETA=Color3.fromRGB(170,100,255),FREE=theme.Success}
            local tag=make("TextLabel",{Size=UDim2.fromOffset(65,24),BackgroundColor3=colors[kind or "NEW"] or theme.Accent,Text=text or "TAG",TextColor3=theme.Text,Font=Enum.Font.GothamBold,TextSize=10},page)
            make("UICorner",{CornerRadius=UDim.new(0,7)},tag)
            return tag
        end

        return T
    end

    function W:Notify(o)
        o=o or {}
        local holder=make("Frame",{Position=UDim2.new(1,-320,1,-20),AnchorPoint=Vector2.new(0,1),Size=UDim2.fromOffset(300,0),BackgroundTransparency=1},gui)
        local card=make("TextButton",{Size=UDim2.new(1,0,0,70),BackgroundColor3=theme.Surface,Text="",AutoButtonColor=false},holder)
        make("UICorner",{CornerRadius=UDim.new(0,11)},card)
        make("UIStroke",{Color=theme.Border},card)
        make("TextLabel",{Position=UDim2.fromOffset(14,9),Size=UDim2.new(1,-28,0,20),BackgroundTransparency=1,Text=o.Title or "ARIO HUB",TextColor3=theme.Text,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},card)
        make("TextLabel",{Position=UDim2.fromOffset(14,31),Size=UDim2.new(1,-28,0,30),BackgroundTransparency=1,Text=o.Content or "",TextColor3=theme.Muted,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},card)
        task.delay(o.Duration or 3,function() if holder then holder:Destroy() end end)
    end

    return W
end

return Ario
