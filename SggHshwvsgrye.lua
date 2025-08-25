-- Animasyonlu Toggle ve Button, Slider, Keybind, Watermark sistemi
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.Tabs = {}
Library.Keybinds = {}
Library.WatermarkText = "Hile Menu"

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HileUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0, 220, 0, 25)
Watermark.Position = UDim2.new(1, -230, 0, 10)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 = Color3.fromRGB(0, 255, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 14
Watermark.TextXAlignment = Enum.TextXAlignment.Right
Watermark.Text = Library.WatermarkText
Watermark.Parent = ScreenGui

RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    Watermark.Text = Library.WatermarkText.." | FPS: "..fps
end)

-- Keybind Frame
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(0, 200, 0, 220)
KeybindFrame.Position = UDim2.new(0, 10, 0.2, 0)
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

-- Animasyonlu Toggle
function Library:CreateToggle(parent, name, default, callback)
    local state = default or false
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1,-10,0,30)
    Btn.Position = UDim2.new(0,5,0,#parent:GetChildren()*35)
    Btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Text = name.." : "..tostring(state)
    Btn.Parent = parent

    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = name.." : "..tostring(state)
        -- Animasyon: background color fade
        local goal = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(80,80,80)
        spawn(function()
            for i=0,1,0.1 do
                Btn.BackgroundColor3 = Btn.BackgroundColor3:lerp(goal,0.3)
                wait(0.02)
            end
            Btn.BackgroundColor3 = goal
        end)
        pcall(callback,state)
    end)
end

-- Animasyonlu Button
function Library:CreateButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1,-10,0,30)
    Btn.Position = UDim2.new(0,5,0,#parent:GetChildren()*35)
    Btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Text = name
    Btn.Parent = parent

    Btn.MouseButton1Click:Connect(function()
        spawn(function()
            Btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
            wait(0.1)
            Btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
        end)
        pcall(callback)
    end)
end

-- Slider
function Library:CreateSlider(parent,name,min,max,default,callback)
    default = default or min
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,40)
    frame.Position = UDim2.new(0,5,0,#parent:GetChildren()*45)
    frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
    frame.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,20)
    title.BackgroundTransparency = 1
    title.Text = name.." : "..default
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-10,0,10)
    bar.Position = UDim2.new(0,5,0,25)
    bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
    bar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
    fill.Parent = bar

    local dragging=false
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    bar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local val=math.floor(min+(max-min)*rel)
            fill.Size=UDim2.new(rel,0,1,0)
            title.Text=name.." : "..val
            pcall(callback,val)
        end
    end)
end

-- Keybind ekleme
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
                if i2.UserInputType == Enum.UserInputType.Keyboard then
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

return Library
