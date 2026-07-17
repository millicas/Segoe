local Segoe = {}
Segoe.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Theme = {
    Background = Color3.fromRGB(21, 26, 40),
    Surface = Color3.fromRGB(35, 40, 58),
    Border = Color3.fromRGB(68, 72, 88),
    Text = Color3.fromRGB(229, 235, 250),
    SubText = Color3.fromRGB(117, 124, 147),
    Accent = Color3.fromRGB(88, 101, 242),
    Error = Color3.fromRGB(240, 70, 80),
    Success = Color3.fromRGB(60, 200, 120),
    Warning = Color3.fromRGB(240, 180, 40),
}

local Fonts = {}
local _order = 0

local function NextOrder()
    _order = _order + 1
    return _order
end

do
    local fb = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular)
    local fbB = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    local map = {
        {url = "https://github.com/millicas/Segoe/raw/refs/heads/main/assets/Segoe%20UI.woff", file = "Segoe/SegoeUI.woff", key = "Regular", fb = fb},
        {url = "https://github.com/millicas/Segoe/raw/refs/heads/main/assets/Segoe%20UI%20Bold.woff", file = "Segoe/SegoeUIBold.woff", key = "Bold", fb = fbB},
        {url = "https://github.com/millicas/Segoe/raw/refs/heads/main/assets/Segoe%20UI%20Italic.woff", file = "Segoe/SegoeUIItalic.woff", key = "Italic", fb = fb},
        {url = "https://github.com/millicas/Segoe/raw/refs/heads/main/assets/Segoe%20UI%20Bold%20Italic.woff", file = "Segoe/SegoeUIBoldItalic.woff", key = "BoldItalic", fb = fbB},
    }
    pcall(function()
        if not isfolder("Segoe") then makefolder("Segoe") end
        for _, f in ipairs(map) do
            if not isfile(f.file) then
                local r = request({Url = f.url})
                if r and r.Body then writefile(f.file, r.Body) end
            end
        end
    end)
    for _, f in ipairs(map) do
        local ok, font = pcall(function() return Font.new(getcustomasset(f.file)) end)
        Fonts[f.key] = ok and font or f.fb
    end
end

local function Anim(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function New(class, props, kids)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, c in ipairs(kids or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Corner(p, r) return New("UICorner", {CornerRadius = r or UDim.new(0, 8), Parent = p}) end
local function Stroke(p, c, t) return New("UIStroke", {Color = c or Theme.Border, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
local function Pad(p, t, b, l, r) return New("UIPadding", {PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = p}) end
local function Lay(p, s, d) return New("UIListLayout", {Padding = UDim.new(0, s or 6), FillDirection = d or Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Parent = p}) end

local ScreenGui
local function GetGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    ScreenGui = New("ScreenGui", {
        Name = "Segoe_" .. math.random(100000, 999999),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end end)
    local parent = game:GetService("CoreGui")
    pcall(function() if gethui then parent = gethui() end end)
    ScreenGui.Parent = parent
    return ScreenGui
end

local NotifHolder
function Segoe:Notify(cfg)
    cfg = cfg or {}
    if not NotifHolder or not NotifHolder.Parent then
        NotifHolder = New("Frame", {
            Size = UDim2.new(0, 250, 1, -20),
            Position = UDim2.new(1, -260, 0, 10),
            BackgroundTransparency = 1,
            Parent = GetGui()
        })
        local nl = Lay(NotifHolder, 6)
        nl.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local accent = Theme.Accent
    if cfg.Type == "Success" then accent = Theme.Success
    elseif cfg.Type == "Error" then accent = Theme.Error
    elseif cfg.Type == "Warning" then accent = Theme.Warning end

    local n = New("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = NotifHolder
    })
    Corner(n, UDim.new(0, 6))
    Stroke(n)

    local bar = New("Frame", {
        Size = UDim2.new(0, 3, 1, -10),
        Position = UDim2.new(0, 6, 0, 5),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = n
    })
    Corner(bar, UDim.new(0, 2))

    local tl = New("TextLabel", {
        Size = UDim2.new(1, -22, 0, 18),
        Position = UDim2.new(0, 16, 0, 8),
        BackgroundTransparency = 1,
        Text = cfg.Title or "Notification",
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = n
    })
    tl.FontFace = Fonts.Bold

    local ml = New("TextLabel", {
        Size = UDim2.new(1, -22, 0, 14),
        Position = UDim2.new(0, 16, 0, 28),
        BackgroundTransparency = 1,
        Text = cfg.Message or "",
        TextColor3 = Theme.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = n
    })
    ml.FontFace = Fonts.Regular

    Anim(n, {BackgroundTransparency = 0}, 0.25)
    local dur = cfg.Duration or 4
    task.delay(dur, function()
        Anim(n, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.25)
        task.delay(0.3, function() n:Destroy() end)
    end)
end

function Segoe:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Segoe"
    local size = cfg.Size or UDim2.new(0, 550, 0, 380)

    local Window = {}
    Window._tabs = {}
    Window._activeTab = nil

    local main = New("Frame", {
        Size = UDim2.new(0, size.X.Offset, 0, 0),
        Position = UDim2.new(0.5, -(size.X.Offset / 2), 0.5, -(size.Y.Offset / 2)),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundTransparency = 1,
        Parent = GetGui()
    })
    Corner(main, UDim.new(0, 10))
    Stroke(main)
    Anim(main, {Size = size, BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back)

    local titleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = main
    })

    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    local titleLabel = New("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    titleLabel.FontFace = Fonts.Bold

    local closeBtn = New("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -32, 0, 7),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.8,
        Text = "\xC3\x97",
        TextColor3 = Theme.SubText,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = titleBar
    })
    closeBtn.FontFace = Fonts.Regular
    Corner(closeBtn, UDim.new(0, 4))

    local minBtn = New("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -60, 0, 7),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.8,
        Text = "\xE2\x80\x94",
        TextColor3 = Theme.SubText,
        TextSize = 10,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = titleBar
    })
    minBtn.FontFace = Fonts.Regular
    Corner(minBtn, UDim.new(0, 4))

    closeBtn.MouseEnter:Connect(function() Anim(closeBtn, {BackgroundTransparency = 0.3, BackgroundColor3 = Theme.Error}, 0.12) end)
    closeBtn.MouseLeave:Connect(function() Anim(closeBtn, {BackgroundTransparency = 0.8, BackgroundColor3 = Theme.Border}, 0.12) end)
    minBtn.MouseEnter:Connect(function() Anim(minBtn, {BackgroundTransparency = 0.3}, 0.12) end)
    minBtn.MouseLeave:Connect(function() Anim(minBtn, {BackgroundTransparency = 0.8}, 0.12) end)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Anim(main, {Size = minimized and UDim2.new(0, size.X.Offset, 0, 38) or size}, 0.25)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Anim(main, {Size = UDim2.new(0, size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function() main:Destroy() end)
    end)

    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local sidebar = New("Frame", {
        Size = UDim2.new(0, 110, 1, -38),
        Position = UDim2.new(0, 0, 0, 38),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = main
    })

    New("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = sidebar
    })

    local tabList = New("ScrollingFrame", {
        Size = UDim2.new(1, -4, 1, -8),
        Position = UDim2.new(0, 2, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar
    })
    Lay(tabList, 2)
    Pad(tabList, 6, 6, 4, 4)

    local content = New("Frame", {
        Size = UDim2.new(1, -114, 1, -42),
        Position = UDim2.new(0, 112, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = main
    })

    function Window:CreateTab(tabCfg)
        tabCfg = tabCfg or {}
        local tabName = tabCfg.Name or "Tab"

        local Tab = {}
        Tab._currentCard = nil

        local tabBtn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            LayoutOrder = NextOrder(),
            Parent = tabList
        })
        Corner(tabBtn, UDim.new(0, 5))

        local tabLabel = New("TextLabel", {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Theme.SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        tabLabel.FontFace = Fonts.Regular

        local indicator = New("Frame", {
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Parent = tabBtn
        })
        Corner(indicator, UDim.new(0, 2))

        local page = New("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Border,
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = content
        })
        Lay(page, 8)
        Pad(page, 4, 4, 4, 4)

        Tab._page = page

        local function Activate()
            for _, t in ipairs(Window._tabs) do
                t.Page.Visible = false
                Anim(t.Button, {BackgroundTransparency = 1}, 0.15)
                Anim(t.Label, {TextColor3 = Theme.SubText}, 0.15)
                Anim(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
            end
            page.Visible = true
            Anim(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
            Anim(tabLabel, {TextColor3 = Theme.Text}, 0.15)
            Anim(indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.2, Enum.EasingStyle.Back)
            Window._activeTab = tabName
        end

        tabBtn.MouseButton1Click:Connect(Activate)
        tabBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= tabName then Anim(tabBtn, {BackgroundTransparency = 0.85}, 0.12) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= tabName then Anim(tabBtn, {BackgroundTransparency = 1}, 0.12) end
        end)

        table.insert(Window._tabs, {
            Name = tabName,
            Button = tabBtn,
            Label = tabLabel,
            Indicator = indicator,
            Page = page,
            Activate = Activate
        })

        if #Window._tabs == 1 then Activate() end

        local function GetCard()
            if not Tab._currentCard then Tab:CreateSection("") end
            return Tab._currentCard
        end

        function Tab:CreateSection(name)
            local card = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                Parent = page
            })
            Corner(card)
            Stroke(card)
            Pad(card, 10, 10, 12, 12)
            Lay(card, 5)

            if name and name ~= "" then
                local sl = New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text = string.upper(name),
                    TextColor3 = Theme.SubText,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = NextOrder(),
                    Parent = card
                })
                sl.FontFace = Fonts.Bold
            end

            self._currentCard = card
            return card
        end

        function Tab:CreateLabel(text)
            local lbl = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = text or "",
                TextColor3 = Theme.SubText,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })
            lbl.FontFace = Fonts.Regular
            local obj = {}
            function obj:Set(t) lbl.Text = t end
            return obj
        end

        function Tab:CreateButton(bCfg)
            bCfg = bCfg or {}
            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Theme.Background,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })
            Corner(frame, UDim.new(0, 6))

            local nl = New("TextLabel", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = bCfg.Name or "Button",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local btn = New("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = frame
            })

            btn.MouseEnter:Connect(function() Anim(frame, {BackgroundTransparency = 0.15}, 0.12) end)
            btn.MouseLeave:Connect(function() Anim(frame, {BackgroundTransparency = 0.4}, 0.12) end)
            btn.MouseButton1Click:Connect(function()
                Anim(frame, {BackgroundTransparency = 0}, 0.06)
                task.delay(0.08, function() Anim(frame, {BackgroundTransparency = 0.4}, 0.15) end)
                if bCfg.Callback then bCfg.Callback() end
            end)
        end

        function Tab:CreateToggle(tCfg)
            tCfg = tCfg or {}
            local state = tCfg.Default or false

            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local nl = New("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                Text = tCfg.Name or "Toggle",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local pill = New("Frame", {
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -38, 0.5, -10),
                BackgroundColor3 = state and Theme.Accent or Theme.Background,
                BorderSizePixel = 0,
                Parent = frame
            })
            Corner(pill, UDim.new(1, 0))
            Stroke(pill, Theme.Border, 1)

            local circle = New("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,
                Parent = pill
            })
            Corner(circle, UDim.new(1, 0))

            local btn = New("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = frame
            })

            local Toggle = {Value = state}

            local function Upd()
                if state then
                    Anim(pill, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Anim(circle, {Position = UDim2.new(1, -17, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
                else
                    Anim(pill, {BackgroundColor3 = Theme.Background}, 0.2)
                    Anim(circle, {Position = UDim2.new(0, 3, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
                end
            end

            btn.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Value = state
                Upd()
                if tCfg.Callback then tCfg.Callback(state) end
            end)

            function Toggle:Set(v)
                state = v
                Toggle.Value = v
                Upd()
                if tCfg.Callback then tCfg.Callback(v) end
            end

            if tCfg.Flag then Segoe.Flags[tCfg.Flag] = Toggle end
            return Toggle
        end

        function Tab:CreateSlider(sCfg)
            sCfg = sCfg or {}
            local min = sCfg.Min or 0
            local max = sCfg.Max or 100
            local default = sCfg.Default or min
            local inc = sCfg.Increment or 1
            local suffix = sCfg.Suffix or ""
            local current = default

            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local nl = New("TextLabel", {
                Size = UDim2.new(0.6, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = sCfg.Name or "Slider",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local vl = New("TextLabel", {
                Size = UDim2.new(0.4, 0, 0, 18),
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(current) .. suffix,
                TextColor3 = Theme.SubText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = frame
            })
            vl.FontFace = Fonts.Regular

            local track = New("Frame", {
                Size = UDim2.new(1, 0, 0, 4),
                Position = UDim2.new(0, 0, 0, 28),
                BackgroundColor3 = Theme.Background,
                BorderSizePixel = 0,
                Parent = frame
            })
            Corner(track, UDim.new(1, 0))

            local pct = (default - min) / (max - min)
            local fill = New("Frame", {
                Size = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = track
            })
            Corner(fill, UDim.new(1, 0))

            local knob = New("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(pct, -6, 0.5, -6),
                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = track
            })
            Corner(knob, UDim.new(1, 0))

            local hitbox = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 24),
                Position = UDim2.new(0, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = frame
            })

            local sliding = false

            local function Slide(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local raw = min + (max - min) * rel
                current = math.clamp(math.floor(raw / inc + 0.5) * inc, min, max)
                local p = (current - min) / (max - min)
                Anim(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                Anim(knob, {Position = UDim2.new(p, -6, 0.5, -6)}, 0.05)
                vl.Text = tostring(current) .. suffix
                if sCfg.Callback then sCfg.Callback(current) end
            end

            hitbox.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; Slide(i) end
            end)
            hitbox.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then Slide(i) end
            end)

            local Slider = {Value = current}
            function Slider:Set(v)
                current = math.clamp(v, min, max)
                Slider.Value = current
                local p = (current - min) / (max - min)
                Anim(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.1)
                Anim(knob, {Position = UDim2.new(p, -6, 0.5, -6)}, 0.1)
                vl.Text = tostring(current) .. suffix
                if sCfg.Callback then sCfg.Callback(current) end
            end

            if sCfg.Flag then Segoe.Flags[sCfg.Flag] = Slider end
            return Slider
        end

        function Tab:CreateDropdown(dCfg)
            dCfg = dCfg or {}
            local options = dCfg.Options or {}
            local selected = dCfg.Default or (options[1] or "")
            local opened = false

            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local nl = New("TextLabel", {
                Size = UDim2.new(0.45, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = dCfg.Name or "Dropdown",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local sl = New("TextLabel", {
                Size = UDim2.new(0.5, -16, 0, 32),
                Position = UDim2.new(0.45, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = Theme.SubText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = frame
            })
            sl.FontFace = Fonts.Regular

            local arrow = New("TextLabel", {
                Size = UDim2.new(0, 14, 0, 32),
                Position = UDim2.new(1, -12, 0, 0),
                BackgroundTransparency = 1,
                Text = "\xE2\x96\xBE",
                TextColor3 = Theme.SubText,
                TextSize = 12,
                Rotation = 0,
                Parent = frame
            })
            arrow.FontFace = Fonts.Regular

            local optC = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 34),
                BackgroundTransparency = 1,
                Parent = frame
            })
            Lay(optC, 2)

            local optBtns = {}

            local function BuildOpts()
                for _, b in ipairs(optBtns) do b:Destroy() end
                optBtns = {}
                for _, opt in ipairs(options) do
                    local ob = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = Theme.Background,
                        BackgroundTransparency = 0.3,
                        Text = opt,
                        TextColor3 = opt == selected and Theme.Accent or Theme.SubText,
                        TextSize = 12,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        LayoutOrder = NextOrder(),
                        Parent = optC
                    })
                    ob.FontFace = Fonts.Regular
                    Corner(ob, UDim.new(0, 4))
                    table.insert(optBtns, ob)

                    ob.MouseEnter:Connect(function() Anim(ob, {BackgroundTransparency = 0, TextColor3 = Theme.Text}, 0.1) end)
                    ob.MouseLeave:Connect(function() Anim(ob, {BackgroundTransparency = 0.3, TextColor3 = opt == selected and Theme.Accent or Theme.SubText}, 0.1) end)
                    ob.MouseButton1Click:Connect(function()
                        selected = opt
                        sl.Text = opt
                        opened = false
                        Anim(frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                        Anim(arrow, {Rotation = 0}, 0.2)
                        if dCfg.Callback then dCfg.Callback(opt) end
                        BuildOpts()
                    end)
                end
            end
            BuildOpts()

            local headerBtn = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 2,
                Parent = frame
            })

            headerBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local h = 32
                if opened then h = 32 + 4 + (#options * 28) end
                Anim(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.2)
                Anim(arrow, {Rotation = opened and 180 or 0}, 0.2)
            end)

            local Drop = {Value = selected}
            function Drop:Set(v)
                selected = v
                Drop.Value = v
                sl.Text = v
                BuildOpts()
                if dCfg.Callback then dCfg.Callback(v) end
            end
            function Drop:Refresh(newOpts, newDef)
                options = newOpts or options
                if newDef then selected = newDef; sl.Text = newDef end
                BuildOpts()
            end

            if dCfg.Flag then Segoe.Flags[dCfg.Flag] = Drop end
            return Drop
        end

        function Tab:CreateInput(iCfg)
            iCfg = iCfg or {}

            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local nl = New("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = iCfg.Name or "Input",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local box = New("TextBox", {
                Size = UDim2.new(0.55, 0, 0, 24),
                Position = UDim2.new(0.45, 0, 0.5, -12),
                BackgroundColor3 = Theme.Background,
                Text = iCfg.Default or "",
                PlaceholderText = iCfg.Placeholder or "...",
                PlaceholderColor3 = Theme.SubText,
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = iCfg.ClearOnFocus or false,
                BorderSizePixel = 0,
                Parent = frame
            })
            box.FontFace = Fonts.Regular
            Corner(box, UDim.new(0, 4))
            Pad(box, 0, 0, 6, 6)
            Stroke(box, Theme.Border, 1)

            box.Focused:Connect(function() Anim(box, {BackgroundColor3 = Color3.fromRGB(28, 33, 52)}, 0.15) end)
            box.FocusLost:Connect(function(enter)
                Anim(box, {BackgroundColor3 = Theme.Background}, 0.15)
                if enter and iCfg.Callback then iCfg.Callback(box.Text) end
            end)

            local Input = {Value = box.Text}
            function Input:Set(v) box.Text = v; Input.Value = v end

            if iCfg.Flag then Segoe.Flags[iCfg.Flag] = Input end
            return Input
        end

        function Tab:CreateKeybind(kCfg)
            kCfg = kCfg or {}
            local key = kCfg.Default or Enum.KeyCode.Unknown
            local listening = false

            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local nl = New("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                BackgroundTransparency = 1,
                Text = kCfg.Name or "Keybind",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local badge = New("TextButton", {
                Size = UDim2.new(0, 60, 0, 22),
                Position = UDim2.new(1, -60, 0.5, -11),
                BackgroundColor3 = Theme.Background,
                Text = key ~= Enum.KeyCode.Unknown and key.Name or "None",
                TextColor3 = Theme.SubText,
                TextSize = 11,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = frame
            })
            badge.FontFace = Fonts.Regular
            Corner(badge, UDim.new(0, 4))
            Stroke(badge, Theme.Border, 1)

            badge.MouseButton1Click:Connect(function()
                listening = true
                badge.Text = "..."
                Anim(badge, {BackgroundColor3 = Theme.Accent}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        badge.Text = key.Name
                        listening = false
                        Anim(badge, {BackgroundColor3 = Theme.Background}, 0.15)
                        if kCfg.Callback then kCfg.Callback(key) end
                    end
                elseif not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
                    if kCfg.OnPress then kCfg.OnPress() end
                end
            end)

            local KB = {Value = key}
            function KB:Set(k) key = k; KB.Value = k; badge.Text = k.Name end

            if kCfg.Flag then Segoe.Flags[kCfg.Flag] = KB end
            return KB
        end

        function Tab:CreateColorPicker(cCfg)
            cCfg = cCfg or {}
            local color = cCfg.Default or Color3.fromRGB(88, 101, 242)
            local opened = false
            local h, s, v = color:ToHSV()

            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local nl = New("TextLabel", {
                Size = UDim2.new(1, -36, 0, 32),
                BackgroundTransparency = 1,
                Text = cCfg.Name or "Color",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            nl.FontFace = Fonts.Regular

            local swatch = New("Frame", {
                Size = UDim2.new(0, 22, 0, 16),
                Position = UDim2.new(1, -22, 0, 8),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                Parent = frame
            })
            Corner(swatch, UDim.new(0, 4))
            Stroke(swatch, Theme.Border, 1)

            local swatchBtn = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 2,
                Parent = frame
            })

            local svBox = New("Frame", {
                Size = UDim2.new(1, -36, 0, 86),
                Position = UDim2.new(0, 0, 0, 36),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                BorderSizePixel = 0,
                Parent = frame
            })
            Corner(svBox, UDim.new(0, 4))

            New("UIGradient", {
                Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
                Parent = svBox
            })

            local blackOv = New("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Parent = svBox
            })
            Corner(blackOv, UDim.new(0, 4))
            New("UIGradient", {
                Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
                Rotation = 90,
                Parent = blackOv
            })

            local hueBar = New("Frame", {
                Size = UDim2.new(0, 16, 0, 86),
                Position = UDim2.new(1, -22, 0, 36),
                BorderSizePixel = 0,
                Parent = frame
            })
            Corner(hueBar, UDim.new(0, 4))
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
                }),
                Rotation = 90,
                Parent = hueBar
            })

            local svCur = New("Frame", {
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(s, -4, 1 - v, -4),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = svBox
            })
            Corner(svCur, UDim.new(1, 0))
            Stroke(svCur, Theme.Text, 2)

            local hueCur = New("Frame", {
                Size = UDim2.new(1, 2, 0, 4),
                Position = UDim2.new(0, -1, h, -2),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = hueBar
            })
            Corner(hueCur, UDim.new(0, 2))
            Stroke(hueCur, Theme.Text, 2)

            local function Refresh()
                color = Color3.fromHSV(h, s, v)
                swatch.BackgroundColor3 = color
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCur.Position = UDim2.new(s, -4, 1 - v, -4)
                hueCur.Position = UDim2.new(0, -1, h, -2)
                if cCfg.Callback then cCfg.Callback(color) end
            end

            local dSV, dH = false, false
            local svHit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5, Parent = svBox})
            local hHit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5, Parent = hueBar})

            svHit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dSV = true end end)
            svHit.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dSV = false end end)
            hHit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dH = true end end)
            hHit.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dH = false end end)

            UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    if dSV then
                        s = math.clamp((i.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((i.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                        Refresh()
                    end
                    if dH then
                        h = math.clamp((i.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        Refresh()
                    end
                end
            end)

            swatchBtn.MouseButton1Click:Connect(function()
                opened = not opened
                Anim(frame, {Size = UDim2.new(1, 0, 0, opened and 130 or 32)}, 0.2)
            end)

            local CP = {Value = color}
            function CP:Set(c)
                color = c
                h, s, v = c:ToHSV()
                CP.Value = c
                Refresh()
            end

            if cCfg.Flag then Segoe.Flags[cCfg.Flag] = CP end
            return CP
        end

        function Tab:CreateParagraph(pCfg)
            pCfg = pCfg or {}
            local frame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = GetCard()
            })

            local tl = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = pCfg.Title or "",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            tl.FontFace = Fonts.Bold

            local cl = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                Position = UDim2.new(0, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = pCfg.Content or "",
                TextColor3 = Theme.SubText,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = frame
            })
            cl.FontFace = Fonts.Regular

            local P = {}
            function P:Set(t, c)
                if t then tl.Text = t end
                if c then cl.Text = c end
            end
            return P
        end

        return Tab
    end

    function Window:Destroy()
        Anim(main, {Size = UDim2.new(0, size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function() main:Destroy() end)
    end

    return Window
end

function Segoe:GetTheme() return Theme end
function Segoe:SetAccent(c) Theme.Accent = c end
function Segoe:Destroy() if ScreenGui then ScreenGui:Destroy() end end

return Segoe
