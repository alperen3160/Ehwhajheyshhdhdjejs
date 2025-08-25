-- Part 1: Base ScreenGui + Main Frame + Watermark + Keybind Frame
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.Tabs = {}
Library.Keybinds = {}
Library.WatermarkText = "Pepsi UI | Demo"

-- Random isim üret (bypass)
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8,0,0.6,0)
MainFrame.Position = UDim2.new(0.1,0,0.2,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UICorner ve Shadow
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(50,50,50)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
Title.Text = "🔥 Pepsi Hile Menu"
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
Watermark.Text = Library.WatermarkText
Watermark.Parent = ScreenGui

RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    Watermark.Text = Library.WatermarkText.." | FPS: "..fps
end)

-- Keybind Frame (sol panel)
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(0,200,0,220)
KeybindFrame.Position = UDim2.new(0,10,0.2,0)
KeybindFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeybindFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1,0,0,25)
KeyTitle.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyTitle.TextColor3 = Color3.fromRGB(255,255,255)
KeyTitle.Text = "Keybinds"
KeyTitle.Font = Enum.Font.Gotham
KeyTitle.TextSize = 14
KeyTitle.Parent = KeybindFrame

local KeyLayout = Instance.new("UIListLayout")
KeyLayout.FillDirection = Enum.FillDirection.Vertical
KeyLayout.Padding = UDim.new(0,2)
KeyLayout.Parent = KeybindFrame

-- Keybind ekleme fonksiyonu
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



-- Part 2: Tab sistemi + Content Frame
-- Tab Bar (sol panel zaten MainFrame içinde olacak)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0.2,0,1,-30)
TabBar.Position = UDim2.new(0,0,0,30)
TabBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Vertical
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabBar

-- Content Frame (tab içerikleri burada olacak)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.8,0,1,-30)
ContentFrame.Position = UDim2.new(0.2,0,0,30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
ContentFrame.Parent = MainFrame

-- Tab ekleme fonksiyonu (max 4 tab)
function Library:AddTab(tabName)
    if #self.Tabs >= 4 then
        warn("Max 4 tab eklenebilir!")
        return
    end

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1,0,0,30)
    TabButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.Parent = TabBar

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1,0,1,0)
    TabContent.Visible = false
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 6
    TabContent.Parent = ContentFrame

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0,5)
    UIList.FillDirection = Enum.FillDirection.Vertical
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

-- Örnek kullanım
--[[
local lib = require(path_to_library)
local tab1 = lib:AddTab("ESP")
local tab2 = lib:AddTab("Aimbot")
local tab3 = lib:AddTab("Misc")
local tab4 = lib:AddTab("Settings")
-- TabButton’lara basınca ilgili ContentFrame görünecek
]]

-- Part 3: Section sistemi + Section başlıkları
function Library:AddSection(tabContent, sectionName)
    if not tabContent.Sections then tabContent.Sections = {} end
    if #tabContent.Sections >= 4 then
        warn("Max 4 section eklenebilir!")
        return
    end

    local SecFrame = Instance.new("Frame")
    SecFrame.Size = UDim2.new(1,-10,0,100)
    SecFrame.Position = UDim2.new(0,5,0,#tabContent.Sections*105)
    SecFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
    SecFrame.Parent = tabContent

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,8)
    UICorner.Parent = SecFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(80,80,80)
    UIStroke.Thickness = 1
    UIStroke.Parent = SecFrame

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

    -- Section içine Button ekleme
    function sectionData:Button(txt,callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1,-10,0,30)
        Btn.Position = UDim2.new(0,5,0,25+#self.Elements*35)
        Btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 14
        Btn.Text = txt
        Btn.Parent = self.Frame
        Btn.MouseButton1Click:Connect(function()
            -- Buton basınca kısa animasyon
            spawn(function()
                Btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
                wait(0.1)
                Btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            end)
            pcall(callback)
        end)
        table.insert(self.Elements,Btn)
    end

    -- Section içine Toggle ekleme
    function sectionData:Toggle(txt,default,callback)
        local state = default or false
        local Tog = Instance.new("TextButton")
        Tog.Size = UDim2.new(1,-10,0,30)
        Tog.Position = UDim2.new(0,5,0,25+#self.Elements*35)
        Tog.BackgroundColor3 = Color3.fromRGB(80,80,80)
        Tog.TextColor3 = Color3.fromRGB(255,255,255)
        Tog.Font = Enum.Font.GothamBold
        Tog.TextSize = 14
        Tog.Text = txt.." : "..tostring(state)
        Tog.Parent = self.Frame
        Tog.MouseButton1Click:Connect(function()
            state = not state
            Tog.Text = txt.." : "..tostring(state)
            Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(80,80,80)
            pcall(callback,state)
        end)
        table.insert(self.Elements,Tog)
    end

    -- Section içine Label ekleme
    function sectionData:Label(txt)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-10,0,25)
        lbl.Position = UDim2.new(0,5,0,25+#self.Elements*30)
        lbl.BackgroundTransparency = 1
        lbl.Text = txt
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = self.Frame
        table.insert(self.Elements,lbl)
    end

    return sectionData
end

-- Örnek kullanım:
--[[
local tab1 = lib:AddTab("ESP")
local sec1 = lib:AddSection(tab1,"Player ESP")
sec1:Toggle("Box ESP",false,function(s) print(s) end)
sec1:Button("Highlight",function() print("Highlight clicked") end)
sec1:Label("Demo Label")
]]

-- Part 4: Slider + ColorPicker + Animasyonlu elementler

-- Slider ekleme
function Library:CreateSlider(section,text,min,max,default,callback)
    default = default or min
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,40)
    frame.Position = UDim2.new(0,5,0,25+#section.Elements*45)
    frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
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
    bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
    bar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
    fill.Parent = bar

    local dragging = false
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    bar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local val = math.floor(min+(max-min)*rel)
            fill.Size = UDim2.new(rel,0,1,0)
            label.Text = text.." : "..val
            pcall(callback,val)
        end
    end)

    table.insert(section.Elements,frame)
end

-- ColorPicker ekleme
function Library:CreateColorPicker(section,name,defaultColor,callback)
    defaultColor = defaultColor or Color3.fromRGB(255,0,0)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,30)
    frame.Position = UDim2.new(0,5,0,25+#section.Elements*40)
    frame.BackgroundColor3 = defaultColor
    frame.Parent = section.Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,6)
    UICorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    frame.MouseButton1Click:Connect(function()
        -- basit demo: rastgele renk değişimi (gerçek picker mobil için eklenebilir)
        local newColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
        frame.BackgroundColor3 = newColor
        pcall(callback,newColor)
    end)

    table.insert(section.Elements,frame)
end

-- Animasyonlu Toggle (hover ve renk)
function Library:CreateAnimatedToggle(section,text,default,callback)
    local state = default or false
    local Tog = Instance.new("TextButton")
    Tog.Size = UDim2.new(1,-10,0,30)
    Tog.Position = UDim2.new(0,5,0,25+#section.Elements*35)
    Tog.BackgroundColor3 = Color3.fromRGB(80,80,80)
    Tog.TextColor3 = Color3.fromRGB(255,255,255)
    Tog.Font = Enum.Font.GothamBold
    Tog.TextSize = 14
    Tog.Text = text.." : "..tostring(state)
    Tog.Parent = section.Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,6)
    UICorner.Parent = Tog

    Tog.MouseEnter:Connect(function()
        Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(100,100,100)
    end)
    Tog.MouseLeave:Connect(function()
        Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(80,80,80)
    end)

    Tog.MouseButton1Click:Connect(function()
        state = not state
        Tog.Text = text.." : "..tostring(state)
        Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(80,80,80)
        pcall(callback,state)
    end)

    table.insert(section.Elements,Tog)
end

-- Part 5: Final dokunuşlar ve mobil uyumlu draggable

-- Ana Frame draggable mobil uyumlu
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Mobil uyumlu boyut ayarlama (responsive)
local function adjustSize()
    local screenSize = workspace.CurrentCamera.ViewportSize
    MainFrame.Size = UDim2.new(0.8,0,0.6,0)
    MainFrame.Position = UDim2.new(0.1,0,0.2,0)
    KeybindFrame.Position = UDim2.new(0,10,0.2,0)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adjustSize)
adjustSize()

-- Library final entegre: tüm elementler kullanılabilir
Library.MainFrame = MainFrame
Library.TabBar = TabBar
Library.ContentFrame = ContentFrame
Library.KeybindFrame = KeybindFrame
Library.ScreenGui = ScreenGui
Library.Watermark = Watermark

-- Demo Watermark toggle
function Library:ToggleWatermark(state)
    Watermark.Visible = state
end

-- Örnek kullanım:
--[[
local lib = require(path_to_library)
local tab1 = lib:AddTab("ESP")
local sec1 = lib:AddSection(tab1,"Player ESP")
sec1:Toggle("Box ESP",false,function(s) print(s) end)
lib:CreateSlider(sec1,"FOV",30,120,70,function(val) print(val) end)
lib:CreateColorPicker(sec1,"ESP Color",Color3.fromRGB(0,255,0),function(c) print(c) end)
lib:CreateAnimatedToggle(sec1,"Snaplines",true,function(s) print(s) end)
lib:CreateKeybind("Toggle UI",Enum.KeyCode.RightControl,function() MainFrame.Visible = not MainFrame.Visible end)
]]

return Library
