--// Random isimli CoreGui ve mobil uyumlu draggable UI
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.Tabs = {}

-- Random isim üret
local function randomString(len)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local s = ''
    for i=1,len do
        s = s .. string.sub(chars, math.random(1,#chars), math.random(1,#chars))
    end
    return s
end

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = randomString(8)
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8,0,0.6,0) -- mobil uyumlu oran
MainFrame.Position = UDim2.new(0.1,0,0.2,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
Title.Text = "🔥 Hile Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0.2,0,1, -30)
TabBar.Position = UDim2.new(0,0,0,30)
TabBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Vertical
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.8,0,1,-30)
ContentFrame.Position = UDim2.new(0.2,0,0,30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
ContentFrame.Parent = MainFrame

-- Tab ekleme
function Library:AddTab(name)
    if #self.Tabs>=4 then warn("Max 4 tab!") return end
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1,0,0,30)
    tabBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tabBtn.Parent = TabBar

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1,0,1,0)
    tabContent.Visible = false
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = ContentFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0,5)
    layout.Parent = tabContent

    local data = {Button=tabBtn, Content=tabContent, Sections={}}
    table.insert(self.Tabs, data)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
        end
        tabContent.Visible = true
    end)

    return tabContent
end

-- Section ekleme
function Library:AddSection(tabContent, name)
    if not tabContent.Sections then tabContent.Sections={} end
    if #tabContent.Sections>=4 then warn("Max 4 section!") return end

    local secFrame = Instance.new("Frame")
    secFrame.Size = UDim2.new(1,-10,0,100)
    secFrame.Position = UDim2.new(0,5,0,#tabContent.Sections*105)
    secFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
    secFrame.Parent = tabContent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,25)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.Parent = secFrame

    local sectionData = {Frame=secFrame, Elements={}}

    table.insert(tabContent.Sections, sectionData)

    -- Section içine Button
    function sectionData:Button(txt,callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1,-10,0,30)
        Btn.Position = UDim2.new(0,5,0,25+#self.Elements*35)
        Btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
        Btn.Text = txt
        Btn.Parent = self.Frame
        Btn.MouseButton1Click:Connect(callback)
        table.insert(self.Elements,Btn)
    end

    -- Section içine Toggle
    function sectionData:Toggle(txt,default,callback)
        local state = default or false
        local Tog = Instance.new("TextButton")
        Tog.Size = UDim2.new(1,-10,0,30)
        Tog.Position = UDim2.new(0,5,0,25+#self.Elements*35)
        Tog.BackgroundColor3 = Color3.fromRGB(80,80,80)
        Tog.TextColor3 = Color3.fromRGB(255,255,255)
        Tog.Text = txt.." : "..tostring(state)
        Tog.Parent = self.Frame
        Tog.MouseButton1Click:Connect(function()
            state = not state
            Tog.Text = txt.." : "..tostring(state)
            pcall(callback,state)
        end)
        table.insert(self.Elements,Tog)
    end

    return sectionData
end

return Library
