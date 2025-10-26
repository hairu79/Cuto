-- kienmupHub | Vision 1.3 - Preview (LocalScript)
-- 500 x 320, dark + orange, 2-column main, toggles working, tabs working, collapse (-) button

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- cleanup
if CoreGui:FindFirstChild("kienhuppremium") then
    CoreGui.kienhuppremium:Destroy()
end

-- colors
local BG = Color3.fromRGB(12,12,12)
local PANEL = Color3.fromRGB(22,22,22)
local PANEL_ALT = Color3.fromRGB(28,28,28)
local ACCENT = Color3.fromRGB(255,165,0) -- orange
local TXT = Color3.fromRGB(230,230,230)
local MUTED = Color3.fromRGB(160,160,160)
local TOGGLE_OFF = Color3.fromRGB(80,80,80)

-- helper
local function new(class, props)
    local inst = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then inst.Parent = v else inst[k] = v end
        end
    end
    return inst
end

-- root gui
local screenGui = new("ScreenGui", {Name = "kienhuppremium", Parent = CoreGui, ResetOnSpawn = false})
screenGui.IgnoreGuiInset = true

-- window
local window = new("Frame", {
    Name = "Window",
    Parent = screenGui,
    Size = UDim2.fromOffset(500,320),
    Position = UDim2.new(0.5, -250, 0.5, -160),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0,12)})

-- header
local header = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,0,48),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = PANEL_ALT,
    BorderSizePixel = 0
})
new("UICorner", {Parent = header, CornerRadius = UDim.new(0,12)})

local titleLabel = new("TextLabel", {
    Parent = header,
    Text = "kienmupHub",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = ACCENT,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,12,0,6),
    Size = UDim2.new(0.7,0,0,20),
    TextXAlignment = Enum.TextXAlignment.Left
})
local subLabel = new("TextLabel", {
    Parent = header,
    Text = "Vision 1.3",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = MUTED,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,12,0,26),
    Size = UDim2.new(0.7,0,0,16),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- collapse button ( - )
local btnCollapse = new("TextButton", {
    Parent = header,
    Size = UDim2.new(0,44,0,30),
    Position = UDim2.new(1,-56,0.5,-15),
    BackgroundColor3 = PANEL,
    Text = "-",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = TXT,
    AutoButtonColor = false
})
new("UICorner", {Parent = btnCollapse, CornerRadius = UDim.new(0,8)})

-- tab bar
local tabBar = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,0,44),
    Position = UDim2.new(0,0,0,48),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
})
new("UICorner", {Parent = tabBar, CornerRadius = UDim.new(0,8)})

local tabScroller = new("ScrollingFrame", {
    Parent = tabBar,
    Size = UDim2.new(1,-24,1,0),
    Position = UDim2.new(0,12,0,0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.X,
    HorizontalScrollBarInset = Enum.ScrollBarInset.Always
})
local tabListLayout = new("UIListLayout", {Parent = tabScroller})
tabListLayout.FillDirection = Enum.FillDirection.Horizontal
tabListLayout.Padding = UDim.new(0,8)
tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

-- content area
local content = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,1, - (48+44)),
    Position = UDim2.new(0,0,0,48+44),
    BackgroundTransparency = 1
})

-- panels (left & right) inside main tab page container (we'll create per-tab pages)
local function makePanel(parent, x)
    local panel = new("Frame", {
        Parent = parent,
        Size = UDim2.new(0.5, -12, 1, -24),
        Position = UDim2.new(x, x==0 and 12 or 6, 0,12),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0
    })
    new("UICorner", {Parent = panel, CornerRadius = UDim.new(0,10)})
    return panel
end

-- tab system
local TabNames = {"kienmup","Main","Settings","Fish","Quests","SeaEvent","Mirage","Race","Drago","Prehistoric","Raids","Combat","Travel","Shop","Misc"}
local TabButtons = {}
local TabPages = {}
local currentTab = nil

local function setActiveTab(name)
    currentTab = name
    for k,btn in pairs(TabButtons) do
        if k == name then
            btn.BackgroundColor3 = ACCENT
            btn.TextColor3 = Color3.fromRGB(20,20,20)
        else
            btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            btn.TextColor3 = TXT
        end
    end
    for k,page in pairs(TabPages) do
        page.Visible = (k == name)
    end
end

-- create tab buttons and pages
for i,name in ipairs(TabNames) do
    local btn = new("TextButton", {
        Parent = tabScroller,
        Size = UDim2.new(0,120,0,32),
        BackgroundColor3 = Color3.fromRGB(35,35,35),
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = TXT,
        AutoButtonColor = false
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    TabButtons[name] = btn

    local page = new("Frame", {
        Parent = content,
        Name = name,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false
    })
    TabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        setActiveTab(name)
    end)
end

-- create Main page content: left & right panels with scrolls + titles
local mainPage = TabPages["Main"]
local leftPanel = makePanel(mainPage, 0)
local rightPanel = makePanel(mainPage, 0.5)

local leftTitle = new("TextLabel", {Parent = leftPanel, Text = "Main Farm", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})
local rightTitle = new("TextLabel", {Parent = rightPanel, Text = "Setting Farm", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local leftScroll = new("ScrollingFrame", {Parent = leftPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
leftScroll.ZIndex = 2
leftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local leftLayout = new("UIListLayout", {Parent = leftScroll})
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0,10)

local rightScroll = new("ScrollingFrame", {Parent = rightPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
rightScroll.ZIndex = 2
rightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local rightLayout = new("UIListLayout", {Parent = rightScroll})
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.Padding = UDim.new(0,10)

-- makeRow (button-based so clicks register)
local function makeRow(parent, height)
    local row = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(1,0,0, height or 46),
        BackgroundColor3 = Color3.fromRGB(38,38,38),
        AutoButtonColor = false,
        Text = ""
    })
    new("UICorner", {Parent = row, CornerRadius = UDim.new(0,8)})
    return row
end

-- Toggle factory (uses internal click; returns control)
local function makeToggle(parent, text, default, callback)
    local row = makeRow(parent, 48)
    local label = new("TextLabel", {
        Parent = row,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = TXT,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,12,0,0),
        Size = UDim2.new(1,-96,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    local sw = new("Frame", {
        Parent = row,
        Size = UDim2.new(0,44,0,24),
        Position = UDim2.new(1,-56,0.5,-12),
        BackgroundColor3 = default and ACCENT or TOGGLE_OFF,
    })
    new("UICorner", {Parent = sw, CornerRadius = UDim.new(1,0)})
    local knob = new("Frame", {
        Parent = sw,
        Size = UDim2.new(0,18,0,18),
        Position = default and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,4,0.5,-9),
        BackgroundColor3 = Color3.fromRGB(245,245,245)
    })
    new("UICorner", {Parent = knob, CornerRadius = UDim.new(1,0)})

    local toggled = default or false
    local function setState(v, animate)
        toggled = v
        local color = toggled and ACCENT or TOGGLE_OFF
        local pos = toggled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,4,0.5,-9)
        if animate then
            TweenService:Create(sw, Tweenkienmup.new(0.14), {BackgroundColor3 = color}):Play()
            TweenService:Create(knob, Tweenkienmup.new(0.14), {Position = pos}):Play()
        else
            sw.BackgroundColor3 = color
            knob.Position = pos
        end
        if callback then pcall(callback, toggled) end
    end

    row.MouseButton1Click:Connect(function()
        setState(not toggled, true)
    end)

    return {Row = row, Set = setState, Get = function() return toggled end}
end

-- Slider factory (simple)
local function makeSlider(parent, text, minv, maxv, default, callback)
    local row = makeRow(parent, 64)
    local label = new("TextLabel", {Parent = row, Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = TXT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,6), Size = UDim2.new(1,-24,0,18), TextXAlignment = Enum.TextXAlignment.Left})
    local bar = new("Frame", {Parent = row, Size = UDim2.new(1,-120,0,12), Position = UDim2.new(0,12,0,34), BackgroundColor3 = Color3.fromRGB(60,60,60)})
    new("UICorner", {Parent = bar, CornerRadius = UDim.new(0,6)})
    local frac = math.clamp((default-minv)/(maxv-minv),0,1)
    local fill = new("Frame", {Parent = bar, Size = UDim2.new(frac,0,1,0), BackgroundColor3 = ACCENT})
    new("UICorner", {Parent = fill, CornerRadius = UDim.new(0,6)})
    local knob = new("Frame", {Parent = bar, Size = UDim2.new(0,14,0,14), Position = UDim2.new(frac,-7,0.5,-7), BackgroundColor3 = Color3.fromRGB(245,245,245)})
    new("UICorner", {Parent = knob, CornerRadius = UDim.new(1,0)})
    local display = new("TextLabel", {Parent = row, Text = tostring(default), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = TXT, BackgroundTransparency = 1, Size = UDim2.new(0,72,0,20), Position = UDim2.new(1,-92,0,22)})
    local dragging = false
    local function updateFromX(x)
        local absX = math.clamp(x - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
        local frac2 = absX / bar.AbsoluteSize.X
        local val = math.floor(minv + (maxv-minv)*frac2 + 0.5)
        fill.Size = UDim2.new(frac2,0,1,0)
        knob.Position = UDim2.new(frac2,-7,0.5,-7)
        display.Text = tostring(val)
        if callback then pcall(callback,val) end
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then updateFromX(i.Position.X); dragging = true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateFromX(i.Position.X) end end)
    return {Row = row}
end

-- Dropdown factory (simple)
local function makeDropdown(parent, text, options, default, callback)
    local row = makeRow(parent, 56)
    local label = new("TextLabel", {Parent = row, Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = TXT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,8), Size = UDim2.new(1,-24,0,18), TextXAlignment = Enum.TextXAlignment.Left})
    local btn = new("TextButton", {Parent = row, Size = UDim2.new(1,-24,0,30), Position = UDim2.new(0,12,0,24), BackgroundColor3 = Color3.fromRGB(55,55,55), Text = default or (options[1] or ""), Font=Enum.Font.Gotham, TextColor3 = TXT, AutoButtonColor=false})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    local menu = new("Frame", {Parent = row, Size = UDim2.new(1,-24,0,#options*30), Position=UDim2.new(0,12,0,24+30), BackgroundColor3 = Color3.fromRGB(45,45,45), Visible=false})
    new("UICorner", {Parent = menu, CornerRadius = UDim.new(0,8)})
    for i,opt in ipairs(options) do
        local optBtn = new("TextButton", {Parent = menu, Size = UDim2.new(1,-12,0,26), Position = UDim2.new(0,6,0,(i-1)*30), BackgroundTransparency = 1, Text = opt, Font = Enum.Font.Gotham, TextColor3 = TXT, AutoButtonColor=false})
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            menu.Visible = false
            if callback then pcall(callback,opt) end
        end)
    end
    btn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)
    return {Row = row}
end

-- populate left toggles (Main)
local leftList = {
    "Auto Farm Max Level","Auto Farm Near Mob","Auto Farm Bone","Auto Random Bone",
    "Auto Farm All Cake Prince","Spawn Cake Prince","Auto Loot","Auto Respawn",
    "Auto Collect","Auto Boost"
}
for i,name in ipairs(leftList) do
    makeToggle(leftScroll, name, false, function(v) print("[MainToggle]", name, v) end)
end

-- populate right controls (Settings)
makeSlider(rightScroll, "Distance Farm", 1, 50, 15, function(v) print("Distance:", v) end)
makeDropdown(rightScroll, "Method Farm", {"Above","Below","Nearest"}, "Above", function(v) print("Method:", v) end)
makeDropdown(rightScroll, "Select Weapon", {"Melee","Range","Hybrid"}, "Melee", function(v) print("Weapon:", v) end)
makeToggle(rightScroll, "Fast Attack & Fast Fruits", true, function(v) print("Fast Attack:", v) end)
makeToggle(rightScroll, "Auto Click M1", false, function(v) print("Auto Click M1:", v) end)

-- balance visuals: right toggles
local rightList = {"Auto Farm Bone","Auto Farm Boss","Auto Track","Auto Heal","Auto Upgrade","Auto Sell","Auto Buy","Auto Merge"}
for i,name in ipairs(rightList) do
    makeToggle(rightScroll, name, false, function(v) print("[RightToggle]", name, v) end)
end

-- ensure canvases update (using AutomaticCanvasSize helps, but we keep safe updates)
local function updateCanvases()
    -- if using AutomaticCanvasSize, scroll frames auto-resize; but keep tab scroller canvas fit
    tabScroller.CanvasSize = UDim2.new(0, tabListLayout.AbsoluteContentSize + 16, 0, 0)
end
tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvases)
RunService.Heartbeat:Connect(updateCanvases)
updateCanvases()

-- set default tab
setActiveTab("Main")

-- drag (header)
do
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = window.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- collapse / expand (light tween)
local collapsed = false
btnCollapse.MouseButton1Click:Connect(function()
    if collapsed then
        -- expand
        TweenService:Create(window, Tweenkienmup.new(0.14), {Size = UDim2.fromOffset(500,320)}):Play()
        TweenService:Create(content, Tweenkienmup.new(0.12), {BackgroundTransparency = 0}):Play()
        for _,v in pairs(window:GetChildren()) do v.Visible = true end
        -- but keep header visible
        header.Visible = true
        collapsed = false
        -- re-show content after size tween
        wait(0.02)
        setActiveTab(currentTab or "Main")
    else
        -- collapse: shrink to header height (keep header visible)
        for k,v in pairs(content:GetChildren()) do v.Visible = false end
        TweenService:Create(window, Tweenkienmup.new(0.12), {Size = UDim2.fromOffset(500,48)}):Play()
        collapsed = true
    end
end)

-- small intro: quick fade-in + slight positional pop
window.Position = UDim2.new(0.5, -250, 0.5, -180)
window.BackgroundTransparency = 1
TweenService:Create(window, Tweenkienmup.new(0.18), {BackgroundTransparency = 0}):Play()
TweenService:Create(window, Tweenkienmup.new(0.18), {Position = UDim2.new(0.5,-250,0.5,-160)}):Play()

print("kienmupHub preview loaded (Vision 1.3).")