local RexLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ===================== THEME =====================
local Theme = {
    MainBG    = Color3.fromRGB(21, 26, 40),
    Surface   = Color3.fromRGB(35, 40, 58),
    Border    = Color3.fromRGB(68, 72, 88),
    Text      = Color3.fromRGB(229, 235, 250),
    SubText   = Color3.fromRGB(117, 124, 147),
    Accent    = Color3.fromRGB(88, 101, 242),
    AccentDim = Color3.fromRGB(62, 72, 180),
    Error     = Color3.fromRGB(240, 70, 80),
    Success   = Color3.fromRGB(60, 200, 120),
    Warning   = Color3.fromRGB(240, 180, 40),
    Font      = Enum.Font.Gotham,
    FontBold  = Enum.Font.GothamBold,
    FontSemi  = Enum.Font.GothamSemibold,
    TextSize  = 13,
    Rounding  = UDim.new(0, 6),
    TweenSpeed = 0.2,
}

-- ===================== UTILITIES =====================
local function Tween(obj, props, duration, style, direction)
    duration = duration or Theme.TweenSpeed
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    tw:Play()
    return tw
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or Theme.Rounding,
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function AddPadding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 10),
        PaddingRight = UDim.new(0, r or 10),
        Parent = parent
    })
end

local function AddListLayout(parent, padding, dir, hAlign, vAlign, sortOrder)
    return Create("UIListLayout", {
        Padding = UDim.new(0, padding or 6),
        FillDirection = dir or Enum.FillDirection.Vertical,
        HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
        VerticalAlignment = vAlign or Enum.VerticalAlignment.Top,
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
        Parent = parent
    })
end

local function Ripple(button)
    local ripple = Create("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = button.ZIndex + 1,
        Parent = button
    })
    AddCorner(ripple, UDim.new(1, 0))
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.4)
    task.delay(0.4, function()
        ripple:Destroy()
    end)
end

-- ===================== CORE GUI =====================
local ScreenGui

local function GetScreenGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    ScreenGui = Create("ScreenGui", {
        Name = "RexLib_" .. tostring(math.random(100000, 999999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    return ScreenGui
end

-- ===================== NOTIFICATION SYSTEM =====================
local NotifHolder

local function InitNotifications()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = GetScreenGui()
    NotifHolder = Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 280, 1, 0),
        Position = UDim2.new(1, -290, 0, 10),
        BackgroundTransparency = 1,
        Parent = sg
    })
    AddListLayout(NotifHolder, 6, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
end

function RexLib:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local message = config.Message or ""
    local duration = config.Duration or 4
    local ntype = config.Type or "Info"

    InitNotifications()

    local accentColor = Theme.Accent
    if ntype == "Success" then accentColor = Theme.Success
    elseif ntype == "Error" then accentColor = Theme.Error
    elseif ntype == "Warning" then accentColor = Theme.Warning end

    local notif = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = NotifHolder
    })
    AddCorner(notif)
    AddStroke(notif, Theme.Border)

    local accentBar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, -8),
        Position = UDim2.new(0, 6, 0, 4),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = notif
    })
    AddCorner(accentBar, UDim.new(0, 2))

    Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Theme.FontBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 16),
        Position = UDim2.new(0, 16, 0, 32),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Theme.SubText,
        Font = Theme.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notif
    })

    local progressBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = notif
    })

    Tween(notif, {BackgroundTransparency = 0}, 0.3)
    Tween(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration)

    task.delay(duration, function()
        Tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.delay(0.35, function()
            notif:Destroy()
        end)
    end)
end

-- ===================== WINDOW =====================
function RexLib:CreateWindow(config)
    config = config or {}
    local title = config.Title or "RexLib"
    local size = config.Size or UDim2.new(0, 520, 0, 380)
    local sg = GetScreenGui()

    local Window = {}
    Window._tabs = {}
    Window._activeTab = nil

    -- Main container
    local mainFrame = Create("Frame", {
        Name = "Window",
        Size = size,
        Position = UDim2.new(0.5, -(size.X.Offset / 2), 0.5, -(size.Y.Offset / 2)),
        BackgroundColor3 = Theme.MainBG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = sg
    })
    AddCorner(mainFrame)
    AddStroke(mainFrame, Theme.Border)

    -- Entry animation
    mainFrame.Size = UDim2.new(0, size.X.Offset, 0, 0)
    mainFrame.BackgroundTransparency = 1
    Tween(mainFrame, {Size = size, BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Title bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    AddCorner(titleBar)
    -- hide bottom corners
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Theme.FontBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Minimize button
    local minimizeBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -66, 0, 4),
        BackgroundColor3 = Theme.MainBG,
        BackgroundTransparency = 0.5,
        Text = "—",
        TextColor3 = Theme.SubText,
        Font = Theme.FontBold,
        TextSize = 14,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    AddCorner(minimizeBtn, UDim.new(0, 4))

    -- Close button
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -34, 0, 4),
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.7,
        Text = "✕",
        TextColor3 = Theme.SubText,
        Font = Theme.FontBold,
        TextSize = 12,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    AddCorner(closeBtn, UDim.new(0, 4))

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.3, TextColor3 = Theme.Text}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.7, TextColor3 = Theme.SubText}, 0.15)
    end)
    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {BackgroundTransparency = 0.2, TextColor3 = Theme.Text}, 0.15)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.SubText}, 0.15)
    end)

    local minimized = false
    local originalSize = size

    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(mainFrame, {Size = UDim2.new(0, size.X.Offset, 0, 36)}, 0.25, Enum.EasingStyle.Quad)
        else
            Tween(mainFrame, {Size = originalSize}, 0.25, Enum.EasingStyle.Quad)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function()
            mainFrame:Destroy()
        end)
    end)

    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Tab sidebar
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 130, 1, -36),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local sidebarList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    AddListLayout(sidebarList, 3)
    AddPadding(sidebarList, 4, 4, 4, 4)

    -- Content area
    local contentArea = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -132, 1, -38),
        Position = UDim2.new(0, 132, 0, 38),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    -- ===================== TAB =====================
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or ""

        local Tab = {}
        Tab._elements = {}

        -- Tab button in sidebar
        local tabBtn = Create("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.MainBG,
            BackgroundTransparency = 1,
            Text = "",
            BorderSizePixel = 0,
            Parent = sidebarList
        })
        AddCorner(tabBtn, UDim.new(0, 5))

        local tabLabel = Create("TextLabel", {
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, tabIcon ~= "" and 28 or 10, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Theme.SubText,
            Font = Theme.FontSemi,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })

        if tabIcon ~= "" then
            Create("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = tabIcon,
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 14,
                Parent = tabBtn
            })
        end

        -- Indicator bar
        local indicator = Create("Frame", {
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Parent = tabBtn
        })
        AddCorner(indicator, UDim.new(0, 2))

        -- Tab content page
        local page = Create("ScrollingFrame", {
            Name = tabName .. "_Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Border,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        AddListLayout(page, 6)
        AddPadding(page, 6, 6, 8, 8)

        local function ActivateTab()
            -- Deactivate all
            for _, t in pairs(Window._tabs) do
                t.Page.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.15)
                Tween(t.Label, {TextColor3 = Theme.SubText}, 0.15)
                Tween(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
            end
            -- Activate this
            page.Visible = true
            Tween(tabBtn, {BackgroundTransparency = 0.6}, 0.15)
            Tween(tabLabel, {TextColor3 = Theme.Text}, 0.15)
            Tween(indicator, {Size = UDim2.new(0, 3, 0, 18)}, 0.2, Enum.EasingStyle.Back)
            Window._activeTab = tabName
        end

        tabBtn.MouseButton1Click:Connect(ActivateTab)
        tabBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= tabName then
                Tween(tabBtn, {BackgroundTransparency = 0.8}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= tabName then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)

        table.insert(Window._tabs, {
            Name = tabName,
            Button = tabBtn,
            Label = tabLabel,
            Indicator = indicator,
            Page = page,
            Activate = ActivateTab
        })

        -- Auto-activate first tab
        if #Window._tabs == 1 then
            ActivateTab()
        end

        -- ===================== SECTION =====================
        function Tab:CreateSection(name)
            local section = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Parent = page
            })
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16),
                Position = UDim2.new(0, 0, 0, 4),
                BackgroundTransparency = 1,
                Text = string.upper(name or "Section"),
                TextColor3 = Theme.SubText,
                Font = Theme.FontBold,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section
            })
            Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = section
            })
            return section
        end

        -- ===================== LABEL =====================
        function Tab:CreateLabel(text)
            local lbl = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text or "Label",
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = page
            })
            local LabelObj = {}
            function LabelObj:SetText(newText)
                lbl.Text = newText
            end
            return LabelObj
        end

        -- ===================== BUTTON =====================
        function Tab:CreateButton(config)
            config = config or {}
            local btnFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            AddCorner(btnFrame)
            AddStroke(btnFrame, Theme.Border, 1)

            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = btnFrame
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Button",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = btnFrame
            })

            btn.MouseEnter:Connect(function()
                Tween(btnFrame, {BackgroundColor3 = Theme.Border}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btnFrame, {BackgroundColor3 = Theme.Surface}, 0.15)
            end)
            btn.MouseButton1Click:Connect(function()
                Ripple(btnFrame)
                if config.Callback then
                    config.Callback()
                end
            end)

            return btnFrame
        end

        -- ===================== TOGGLE =====================
        function Tab:CreateToggle(config)
            config = config or {}
            local state = config.Default or false

            local toggleFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = page
            })
            AddCorner(toggleFrame)
            AddStroke(toggleFrame, Theme.Border, 1)

            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Toggle",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })

            local toggleBG = Create("Frame", {
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -46, 0.5, -9),
                BackgroundColor3 = state and Theme.Accent or Theme.MainBG,
                BorderSizePixel = 0,
                Parent = toggleFrame
            })
            AddCorner(toggleBG, UDim.new(1, 0))
            AddStroke(toggleBG, Theme.Border, 1)

            local toggleCircle = Create("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,
                Parent = toggleBG
            })
            AddCorner(toggleCircle, UDim.new(1, 0))

            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = toggleFrame
            })

            local ToggleObj = {}
            ToggleObj.Value = state

            local function UpdateVisual()
                if state then
                    Tween(toggleBG, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Tween(toggleCircle, {Position = UDim2.new(1, -15, 0.5, -6)}, 0.2, Enum.EasingStyle.Back)
                else
                    Tween(toggleBG, {BackgroundColor3 = Theme.MainBG}, 0.2)
                    Tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, -6)}, 0.2, Enum.EasingStyle.Back)
                end
            end

            btn.MouseButton1Click:Connect(function()
                state = not state
                ToggleObj.Value = state
                UpdateVisual()
                if config.Callback then
                    config.Callback(state)
                end
            end)

            function ToggleObj:Set(val)
                state = val
                ToggleObj.Value = val
                UpdateVisual()
                if config.Callback then
                    config.Callback(val)
                end
            end

            if config.Flag then
                RexLib.Flags = RexLib.Flags or {}
                RexLib.Flags[config.Flag] = ToggleObj
            end

            return ToggleObj
        end

        -- ===================== SLIDER =====================
        function Tab:CreateSlider(config)
            config = config or {}
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local suffix = config.Suffix or ""
            local current = default

            local sliderFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = page
            })
            AddCorner(sliderFrame)
            AddStroke(sliderFrame, Theme.Border, 1)

            local nameLabel = Create("TextLabel", {
                Size = UDim2.new(0.6, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text = config.Name or "Slider",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })

            local valueLabel = Create("TextLabel", {
                Size = UDim2.new(0.4, -10, 0, 20),
                Position = UDim2.new(0.6, 0, 0, 6),
                BackgroundTransparency = 1,
                Text = tostring(current) .. suffix,
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })

            local sliderBG = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 34),
                BackgroundColor3 = Theme.MainBG,
                BorderSizePixel = 0,
                Parent = sliderFrame
            })
            AddCorner(sliderBG, UDim.new(1, 0))

            local fillPct = (default - min) / (max - min)
            local sliderFill = Create("Frame", {
                Size = UDim2.new(fillPct, 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = sliderBG
            })
            AddCorner(sliderFill, UDim.new(1, 0))

            local sliderKnob = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(fillPct, -7, 0.5, -7),
                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = sliderBG
            })
            AddCorner(sliderKnob, UDim.new(1, 0))

            local inputBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, 26),
                BackgroundTransparency = 1,
                Text = "",
                Parent = sliderFrame
            })

            local sliding = false

            local function Update(input)
                local pos = UDim2.new(0, 10, 0, 34)
                local rel = (input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X
                rel = math.clamp(rel, 0, 1)
                local raw = min + (max - min) * rel
                current = math.floor(raw / increment + 0.5) * increment
                current = math.clamp(current, min, max)
                local pct = (current - min) / (max - min)
                Tween(sliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                Tween(sliderKnob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.05)
                valueLabel.Text = tostring(current) .. suffix
                if config.Callback then
                    config.Callback(current)
                end
            end

            inputBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    Update(input)
                end
            end)
            inputBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            local SliderObj = {}
            SliderObj.Value = current
            function SliderObj:Set(val)
                current = math.clamp(val, min, max)
                SliderObj.Value = current
                local pct = (current - min) / (max - min)
                Tween(sliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                Tween(sliderKnob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.1)
                valueLabel.Text = tostring(current) .. suffix
                if config.Callback then
                    config.Callback(current)
                end
            end

            if config.Flag then
                RexLib.Flags = RexLib.Flags or {}
                RexLib.Flags[config.Flag] = SliderObj
            end

            return SliderObj
        end

        -- ===================== DROPDOWN =====================
        function Tab:CreateDropdown(config)
            config = config or {}
            local options = config.Options or {}
            local default = config.Default or (options[1] or "Select...")
            local selected = default
            local opened = false

            local dropFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            AddCorner(dropFrame)
            AddStroke(dropFrame, Theme.Border, 1)

            Create("TextLabel", {
                Size = UDim2.new(0.5, -10, 0, 34),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Dropdown",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropFrame
            })

            local selectedLabel = Create("TextLabel", {
                Size = UDim2.new(0.5, -20, 0, 34),
                Position = UDim2.new(0.5, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = dropFrame
            })

            local arrow = Create("TextLabel", {
                Size = UDim2.new(0, 16, 0, 34),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                Text = "▾",
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 14,
                Parent = dropFrame
            })

            local optionContainer = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 0),
                Position = UDim2.new(0, 4, 0, 36),
                BackgroundTransparency = 1,
                Parent = dropFrame
            })
            local optLayout = AddListLayout(optionContainer, 2)

            local optionButtons = {}

            local function BuildOptions()
                for _, v in pairs(optionButtons) do v:Destroy() end
                optionButtons = {}
                for _, opt in ipairs(options) do
                    local optBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = Theme.MainBG,
                        BackgroundTransparency = 0.3,
                        Text = opt,
                        TextColor3 = (opt == selected) and Theme.Accent or Theme.SubText,
                        Font = Theme.Font,
                        TextSize = 12,
                        BorderSizePixel = 0,
                        Parent = optionContainer
                    })
                    AddCorner(optBtn, UDim.new(0, 4))
                    table.insert(optionButtons, optBtn)

                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {BackgroundTransparency = 0, TextColor3 = Theme.Text}, 0.1)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, {BackgroundTransparency = 0.3, TextColor3 = (opt == selected) and Theme.Accent or Theme.SubText}, 0.1)
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        selectedLabel.Text = selected
                        opened = false
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.2)
                        if config.Callback then
                            config.Callback(selected)
                        end
                        BuildOptions()
                    end)
                end
            end

            BuildOptions()

            local headerBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundTransparency = 1,
                Text = "",
                Parent = dropFrame
            })

            headerBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local totalH = 34
                if opened then
                    totalH = 34 + 4 + (#options * 28)
                end
                Tween(dropFrame, {Size = UDim2.new(1, 0, 0, totalH)}, 0.2)
                Tween(arrow, {Rotation = opened and 180 or 0}, 0.2)
            end)

            local DropObj = {}
            DropObj.Value = selected
            function DropObj:Set(val)
                selected = val
                DropObj.Value = val
                selectedLabel.Text = val
                BuildOptions()
                if config.Callback then config.Callback(val) end
            end
            function DropObj:Refresh(newOptions, newDefault)
                options = newOptions or options
                if newDefault then
                    selected = newDefault
                    selectedLabel.Text = newDefault
                end
                BuildOptions()
            end

            if config.Flag then
                RexLib.Flags = RexLib.Flags or {}
                RexLib.Flags[config.Flag] = DropObj
            end

            return DropObj
        end

        -- ===================== INPUT (TEXTBOX) =====================
        function Tab:CreateInput(config)
            config = config or {}

            local inputFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = page
            })
            AddCorner(inputFrame)
            AddStroke(inputFrame, Theme.Border, 1)

            Create("TextLabel", {
                Size = UDim2.new(0.4, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Input",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = inputFrame
            })

            local textBox = Create("TextBox", {
                Size = UDim2.new(0.55, -10, 0, 24),
                Position = UDim2.new(0.45, 0, 0.5, -12),
                BackgroundColor3 = Theme.MainBG,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Type here...",
                PlaceholderColor3 = Theme.SubText,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 12,
                ClearTextOnFocus = config.ClearOnFocus or false,
                BorderSizePixel = 0,
                Parent = inputFrame
            })
            AddCorner(textBox, UDim.new(0, 4))
            AddPadding(textBox, 0, 0, 6, 6)

            textBox.Focused:Connect(function()
                Tween(textBox, {BackgroundColor3 = Color3.fromRGB(28, 33, 50)}, 0.15)
            end)
            textBox.FocusLost:Connect(function(enter)
                Tween(textBox, {BackgroundColor3 = Theme.MainBG}, 0.15)
                if enter and config.Callback then
                    config.Callback(textBox.Text)
                end
            end)

            local InputObj = {}
            InputObj.Value = textBox.Text
            function InputObj:Set(val)
                textBox.Text = val
                InputObj.Value = val
            end

            if config.Flag then
                RexLib.Flags = RexLib.Flags or {}
                RexLib.Flags[config.Flag] = InputObj
            end

            return InputObj
        end

        -- ===================== KEYBIND =====================
        function Tab:CreateKeybind(config)
            config = config or {}
            local currentKey = config.Default or Enum.KeyCode.Unknown
            local listening = false

            local kbFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = page
            })
            AddCorner(kbFrame)
            AddStroke(kbFrame, Theme.Border, 1)

            Create("TextLabel", {
                Size = UDim2.new(0.6, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Keybind",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = kbFrame
            })

            local keyBtn = Create("TextButton", {
                Size = UDim2.new(0, 70, 0, 22),
                Position = UDim2.new(1, -80, 0.5, -11),
                BackgroundColor3 = Theme.MainBG,
                Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "None",
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 11,
                BorderSizePixel = 0,
                Parent = kbFrame
            })
            AddCorner(keyBtn, UDim.new(0, 4))

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keyBtn.Text = currentKey.Name
                        listening = false
                        Tween(keyBtn, {BackgroundColor3 = Theme.MainBG}, 0.15)
                        if config.Callback then
                            config.Callback(currentKey)
                        end
                    end
                else
                    if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                        if config.OnPress then
                            config.OnPress()
                        end
                    end
                end
            end)

            local KBObj = {}
            KBObj.Value = currentKey
            function KBObj:Set(key)
                currentKey = key
                KBObj.Value = key
                keyBtn.Text = key.Name
            end

            if config.Flag then
                RexLib.Flags = RexLib.Flags or {}
                RexLib.Flags[config.Flag] = KBObj
            end

            return KBObj
        end

        -- ===================== COLOR PICKER =====================
        function Tab:CreateColorPicker(config)
            config = config or {}
            local currentColor = config.Default or Color3.fromRGB(88, 101, 242)

            local cpFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            AddCorner(cpFrame)
            AddStroke(cpFrame, Theme.Border, 1)

            Create("TextLabel", {
                Size = UDim2.new(0.6, -10, 0, 34),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Color",
                TextColor3 = Theme.Text,
                Font = Theme.FontSemi,
                TextSize = Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = cpFrame
            })

            local preview = Create("Frame", {
                Size = UDim2.new(0, 24, 0, 18),
                Position = UDim2.new(1, -38, 0, 8),
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Parent = cpFrame
            })
            AddCorner(preview, UDim.new(0, 4))
            AddStroke(preview, Theme.Border, 1)

            local opened = false
            local hue, sat, val = currentColor:ToHSV()

            local hueBar, satValBox

            local previewBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundTransparency = 1,
                Text = "",
                Parent = cpFrame
            })

            -- Saturation/Value box
            satValBox = Create("Frame", {
                Size = UDim2.new(1, -60, 0, 100),
                Position = UDim2.new(0, 8, 0, 40),
                BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
                BorderSizePixel = 0,
                Parent = cpFrame
            })
            AddCorner(satValBox, UDim.new(0, 4))

            -- White gradient overlay
            local whiteGrad = Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Parent = satValBox
            })

            -- Black overlay
            local blackOverlay = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                Parent = satValBox
            })
            AddCorner(blackOverlay, UDim.new(0, 4))
            Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Rotation = 90,
                Parent = blackOverlay
            })

            -- Hue bar
            hueBar = Create("Frame", {
                Size = UDim2.new(0, 20, 0, 100),
                Position = UDim2.new(1, -38, 0, 40),
                BorderSizePixel = 0,
                Parent = cpFrame
            })
            AddCorner(hueBar, UDim.new(0, 4))
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1)),
                }),
                Rotation = 90,
                Parent = hueBar
            })

            -- SatVal cursor
            local svCursor = Create("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(sat, -5, 1 - val, -5),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = satValBox
            })
            AddCorner(svCursor, UDim.new(1, 0))
            AddStroke(svCursor, Theme.Text, 2)

            -- Hue cursor
            local hueCursor = Create("Frame", {
                Size = UDim2.new(1, 4, 0, 4),
                Position = UDim2.new(0, -2, hue, -2),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = hueBar
            })
            AddCorner(hueCursor, UDim.new(0, 2))
            AddStroke(hueCursor, Theme.Text, 2)

            local function UpdateColor()
                currentColor = Color3.fromHSV(hue, sat, val)
                preview.BackgroundColor3 = currentColor
                satValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                svCursor.Position = UDim2.new(sat, -5, 1 - val, -5)
                hueCursor.Position = UDim2.new(0, -2, hue, -2)
                if config.Callback then config.Callback(currentColor) end
            end

            local draggingSV, draggingH = false, false

            local svInput = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = satValBox})
            local hInput = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = hueBar})

            svInput.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end
            end)
            svInput.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false end
            end)
            hInput.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingH = true end
            end)
            hInput.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingH = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if draggingSV then
                        sat = math.clamp((input.Position.X - satValBox.AbsolutePosition.X) / satValBox.AbsoluteSize.X, 0, 1)
                        val = 1 - math.clamp((input.Position.Y - satValBox.AbsolutePosition.Y) / satValBox.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                    if draggingH then
                        hue = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end
            end)

            previewBtn.MouseButton1Click:Connect(function()
                opened = not opened
                Tween(cpFrame, {Size = UDim2.new(1, 0, 0, opened and 150 or 34)}, 0.2)
            end)

            local CPObj = {}
            CPObj.Value = currentColor
            function CPObj:Set(color)
                currentColor = color
                hue, sat, val = color:ToHSV()
                CPObj.Value = color
                UpdateColor()
            end

            if config.Flag then
                RexLib.Flags = RexLib.Flags or {}
                RexLib.Flags[config.Flag] = CPObj
            end

            return CPObj
        end

        -- ===================== PARAGRAPH =====================
        function Tab:CreateParagraph(config)
            config = config or {}
            local pFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 54),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = page
            })
            AddCorner(pFrame)
            AddStroke(pFrame, Theme.Border, 1)

            Create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 20),
                Position = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text = config.Title or "Info",
                TextColor3 = Theme.Text,
                Font = Theme.FontBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = pFrame
            })

            local contentLabel = Create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 22),
                Position = UDim2.new(0, 10, 0, 26),
                BackgroundTransparency = 1,
                Text = config.Content or "",
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = pFrame
            })

            local PObj = {}
            function PObj:Set(title, content)
                if title then pFrame:FindFirstChild("TextLabel").Text = title end
                if content then contentLabel.Text = content end
            end
            return PObj
        end

        return Tab
    end

    -- ===================== DESTROY =====================
    function Window:Destroy()
        Tween(mainFrame, {Size = UDim2.new(0, size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function()
            mainFrame:Destroy()
        end)
    end

    return Window
end

-- ===================== THEME ACCESS =====================
function RexLib:GetTheme()
    return Theme
end

function RexLib:SetAccent(color)
    Theme.Accent = color
end

return RexLib
