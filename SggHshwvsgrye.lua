-- Modern GUI Script - Part 1

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}
Library.Tabs = {}
Library.Keybinds = {}

-- Random CoreGui isim
local function randomString(len)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local s = ''
    for i=1,len do
        s = s .. string.sub(chars, math.random(1,#chars), math.random(1,#chars))
    end
    return s
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = randomString(8)
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8,0,0.6,0)
MainFrame.Position = UDim2.new(0.1,0,0.2,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- UIGradient ile modern arka plan
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(20,20,30)), ColorSequenceKeypoint.new(1,Color3.fromRGB(35,35,50))}
gradient.Rotation = 45
gradient.Parent = MainFrame

-- UICorner ve UIStroke
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,16)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60,60,80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Modern Hile Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0,200,0,25)
Watermark.Position = UDim2.new(1,-210,0,10)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 = Color3.fromRGB(0,255,0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 14
Watermark.TextXAlignment = Enum.TextXAlignment.Right
Watermark.Text = "ModernUI | Demo"
Watermark.Parent = ScreenGui

RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    Watermark.Text = "ModernUI | FPS: "..fps
end)

-- Keybind panel (solda küçük panel)
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(0,200,0,220)
KeybindFrame.Position = UDim2.new(0,10,0.2,0)
KeybindFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeybindFrame.BackgroundTransparency = 0.05
KeybindFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1,0,0,25)
KeyTitle.BackgroundTransparency = 1
KeyTitle.TextColor3 = Color3.fromRGB(255,255,255)
KeyTitle.Text = "Keybinds"
KeyTitle.Font = Enum.Font.Gotham
KeyTitle.TextSize = 14
KeyTitle.Parent = KeybindFrame

local KeyLayout = Instance.new("UIListLayout")
KeyLayout.FillDirection = Enum.FillDirection.Vertical
KeyLayout.Padding = UDim.new(0,2)
KeyLayout.Parent = KeybindFrame

function Library:CreateKeybind(name,defaultKey,callback)
    defaultKey = defaultKey or Enum.KeyCode.E
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,20)
    lbl.Text = name.." : "..defaultKey.Name
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.Parent = KeybindFrame

    table.insert(Library.Keybinds,{Key=defaultKey,Callback=callback,Label=lbl})

    lbl.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            lbl.Text = name.." : ..."
            local con; con = UserInputService.InputBegan:Connect(function(i2)
                if i2.UserInputType==Enum.UserInputType.Keyboard then
                    defaultKey = i2.KeyCode
                    lbl.Text = name.." : "..defaultKey.Name
                    Library.Keybinds[#Library.Keybinds].Key = defaultKey
                    con:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputBegan:Connect(function(i,gpe)
        if not gpe then
            for _,k in pairs(Library.Keybinds) do
                if i.KeyCode==k.Key then pcall(k.Callback) end
            end
        end
    end)
end

-- Sol tab paneli
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0,150,1,-30)
TabBar.Position = UDim2.new(0,0,0,30)
TabBar.BackgroundColor3 = Color3.fromRGB(40,40,50)
TabBar.BackgroundTransparency = 0.05
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Vertical
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabBar

Library.MainFrame = MainFrame
Library.TabBar = TabBar
Library.KeybindFrame = KeybindFrame
Library.Watermark = Watermark

-- Part 2/5: Tab sistemi + Content Frame + Section container

-- Sağ panel: seçilen tab içeriği
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-150,1,-30)
ContentFrame.Position = UDim2.new(0,150,0,30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50,50,60)
ContentFrame.BackgroundTransparency = 0.05
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.Padding = UDim.new(0,5)
ContentLayout.Parent = ContentFrame

-- Tab ekleme fonksiyonu
function Library:AddTab(tabName)
    if #self.Tabs >= 4 then
        warn("Max 4 tab eklenebilir!")
        return
    end

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1,0,0,35)
    TabButton.BackgroundColor3 = Color3.fromRGB(60,60,80)
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 16
    TabButton.Text = tabName
    TabButton.Parent = TabBar

    -- Hover animasyon
    TabButton.MouseEnter:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
    end)
    TabButton.MouseLeave:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(60,60,80)
    end)

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1,0,1,0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 6
    TabContent.Visible = false
    TabContent.Parent = ContentFrame

    local UIList = Instance.new("UIListLayout")
    UIList.FillDirection = Enum.FillDirection.Vertical
    UIList.Padding = UDim.new(0,5)
    UIList.Parent = TabContent

    local tabData = {
        Button = TabButton,
        Content = TabContent,
        Sections = {}
    }

    table.insert(self.Tabs, tabData)

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
        end
        TabContent.Visible = true
    end)

    return TabContent
end

-- Section ekleme fonksiyonu (her tab max 4 section)
function Library:AddSection(tabContent, sectionName)
    if not tabContent.Sections then tabContent.Sections = {} end
    if #tabContent.Sections >= 4 then
        warn("Max 4 section eklenebilir!")
        return
    end

    local SecFrame = Instance.new("Frame")
    SecFrame.Size = UDim2.new(1,-10,0,120)
    SecFrame.BackgroundColor3 = Color3.fromRGB(70,70,90)
    SecFrame.BackgroundTransparency = 0.05
    SecFrame.Parent = tabContent

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,8)
    UICorner.Parent = SecFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,25)
    Title.BackgroundTransparency = 1
    Title.Text = sectionName
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = SecFrame

    local sectionData = {
        Frame = SecFrame,
        Elements = {}
    }

    table.insert(tabContent.Sections, sectionData)
    return sectionData
end

-- Örnek kullanım:
--[[
local tab1 = Library:AddTab("ESP")
local sec1 = Library:AddSection(tab1,"Player ESP")
-- sec1 içine toggle, button, slider vb. ekleyeceğiz Part3 ve Part4’te
]]

-- Part 3/5: Section içi elementler (Button, Toggle, Slider, Label, ColorPicker)

-- Button ekleme
function Library:SectionButton(section, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1,-10,0,30)
    Btn.BackgroundColor3 = Color3.fromRGB(100,100,150)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Text = text
    Btn.Parent = section.Frame
    Btn.Position = UDim2.new(0,5,0,25+#section.Elements*35)

    -- Hover animasyonu
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(100,100,150)
    end)

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    table.insert(section.Elements, Btn)
end

-- Toggle ekleme
function Library:SectionToggle(section, text, default, callback)
    local state = default or false
    local Tog = Instance.new("TextButton")
    Tog.Size = UDim2.new(1,-10,0,30)
    Tog.BackgroundColor3 = Color3.fromRGB(100,100,150)
    Tog.TextColor3 = Color3.fromRGB(255,255,255)
    Tog.Font = Enum.Font.GothamBold
    Tog.TextSize = 14
    Tog.Text = text.." : "..tostring(state)
    Tog.Position = UDim2.new(0,5,0,25+#section.Elements*35)
    Tog.Parent = section.Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,6)
    UICorner.Parent = Tog

    Tog.MouseEnter:Connect(function()
        Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(120,120,180)
    end)
    Tog.MouseLeave:Connect(function()
        Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(100,100,150)
    end)

    Tog.MouseButton1Click:Connect(function()
        state = not state
        Tog.Text = text.." : "..tostring(state)
        Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(100,100,150)
        pcall(callback,state)
    end)

    table.insert(section.Elements, Tog)
end

-- Slider ekleme
function Library:SectionSlider(section, text, min, max, default, callback)
    default = default or min
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,40)
    frame.Position = UDim2.new(0,5,0,25+#section.Elements*45)
    frame.BackgroundColor3 = Color3.fromRGB(80,80,120)
    frame.Parent = section.Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,6)
    UICorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.Text = text.." : "..default
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-10,0,10)
    bar.Position = UDim2.new(0,5,0,25)
    bar.BackgroundColor3 = Color3.fromRGB(120,120,180)
    bar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
    fill.Parent = bar

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
    end)
    bar.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local val = math.floor(min+(max-min)*rel)
            fill.Size = UDim2.new(rel,0,1,0)
            label.Text = text.." : "..val
            pcall(callback,val)
        end
    end)

    table.insert(section.Elements, frame)
end

-- Label ekleme
function Library:SectionLabel(section, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-10,0,20)
    lbl.Position = UDim2.new(0,5,0,25+#section.Elements*25)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = section.Frame
    table.insert(section.Elements, lbl)
end

-- ColorPicker (basit demo: tıkla rastgele renk)
function Library:SectionColorPicker(section, text, default, callback)
    default = default or Color3.fromRGB(255,0,0)
    local frame = Instance.new("TextButton")
    frame.Size = UDim2.new(1,-10,0,30)
    frame.Position = UDim2.new(0,5,0,25+#section.Elements*35)
    frame.BackgroundColor3 = default
    frame.Text = text
    frame.TextColor3 = Color3.fromRGB(255,255,255)
    frame.Font = Enum.Font.GothamBold
    frame.TextSize = 14
    frame.Parent = section.Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,6)
    UICorner.Parent = frame

    frame.MouseButton1Click:Connect(function()
        local newColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
        frame.BackgroundColor3 = newColor
        pcall(callback,newColor)
    end)

    table.insert(section.Elements, frame)
end

-- Part 4/5: Draggable + Mobil uyumlu responsive + Hover animasyonları

-- Draggable ana pencere
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        update(input)
    end
end)

-- Mobil ekran responsive ayar
local function adjustSize()
    local screenSize = workspace.CurrentCamera.ViewportSize
    MainFrame.Size = UDim2.new(0.8,0,0.6,0)
    MainFrame.Position = UDim2.new(0.1,0,0.2,0)
    KeybindFrame.Position = UDim2.new(0,10,0.2,0)
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adjustSize)
adjustSize()

-- Hover animasyonları tüm tab buttonları için
for _, tab in pairs(Library.Tabs) do
    tab.Button.MouseEnter:Connect(function()
        tab.Button:TweenSize(UDim2.new(1,0,0,40), "Out", "Quad", 0.15, true)
        tab.Button.BackgroundColor3 = Color3.fromRGB(0,170,255)
    end)
    tab.Button.MouseLeave:Connect(function()
        tab.Button:TweenSize(UDim2.new(1,0,0,35), "Out", "Quad", 0.15, true)
        tab.Button.BackgroundColor3 = Color3.fromRGB(60,60,80)
    end)
end

-- Hover animasyonu Section başlıkları
for _, tab in pairs(Library.Tabs) do
    for _, section in pairs(tab.Sections) do
        section.Frame.MouseEnter:Connect(function()
            section.Frame:TweenSize(UDim2.new(1,-10,0,section.Frame.Size.Y.Offset+2), "Out", "Quad", 0.15, true)
        end)
        section.Frame.MouseLeave:Connect(function()
            section.Frame:TweenSize(UDim2.new(1,-10,0,section.Frame.Size.Y.Offset-2), "Out", "Quad", 0.15, true)
        end)
    end
end

-- Watermark hover efekti (optional)
Watermark.MouseEnter:Connect(function()
    Watermark.TextColor3 = Color3.fromRGB(255,255,0)
end)
Watermark.MouseLeave:Connect(function()
    Watermark.TextColor3 = Color3.fromRGB(0,255,0)
end)

-- Part 5/5: Final entegrasyon ve export

-- Library içindeki tüm ana elementleri tut
Library.MainFrame = MainFrame
Library.TabBar = TabBar
Library.ContentFrame = ContentFrame
Library.KeybindFrame = KeybindFrame
Library.Watermark = Watermark

-- Watermark toggle fonksiyonu
function Library:ToggleWatermark(state)
    Watermark.Visible = state
end

-- Örnek kullanım fonksiyonları (demo)
--[[
local tab1 = Library:AddTab("ESP")
local sec1 = Library:AddSection(tab1,"Player ESP")
Library:SectionToggle(sec1,"Box ESP",false,function(s) print("Box:",s) end)
Library:SectionSlider(sec1,"FOV",30,120,70,function(val) print("FOV:",val) end)
Library:SectionColorPicker(sec1,"ESP Color",Color3.fromRGB(0,255,0),function(c) print("Color:",c) end)
Library:SectionButton(sec1,"Refresh ESP",function() print("Refreshed") end)
Library:SectionLabel(sec1,"Player count: 0")

Library:CreateKeybind("Toggle UI",Enum.KeyCode.RightControl,function()
    MainFrame.Visible = not MainFrame.Visible
end)

Library:ToggleWatermark(true)
]]

-- Library tek export
-- Burada artık diğer part’lardaki 'return Library' ifadeleri kaldırılacak ve tek return olacak
return Library
