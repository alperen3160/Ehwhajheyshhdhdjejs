-- Lionarda Tarzı Full Mobile UI Library + Tabs
local Library = {}
Library.__index = Library

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function Library:Init(name)
    local gui = Instance.new("ScreenGui")
    gui.Name = name or "MobileLib"
    gui.Parent = game:GetService("CoreGui")

    self.Gui = gui
    self.Tabs = {}

    -- Toggle Button (üstte show/hide)
    local toggleBtn = Instance.new("TextButton", gui)
    toggleBtn.Size = UDim2.new(0, 100, 0, 30)
    toggleBtn.Position = UDim2.new(0.5, -50, 0, 10)
    toggleBtn.Text = "Open "..(name or "UI")
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Main Frame
    self.MainFrame = Instance.new("Frame", gui)
    self.MainFrame.Size = UDim2.new(0.45, 0, 0.55, 0)
    self.MainFrame.Position = UDim2.new(0.275, 0, 0.2, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.MainFrame.Visible = false
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true

    -- Tab Buttons üstte
    self.TabBar = Instance.new("Frame", self.MainFrame)
    self.TabBar.Size = UDim2.new(1, 0, 0, 30)
    self.TabBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local open = false
    toggleBtn.MouseButton1Click:Connect(function()
        open = not open
        self.MainFrame.Visible = open
        toggleBtn.Text = open and "Close "..(name or "UI") or "Open "..(name or "UI")
    end)

    -- Watermark (sağ üst)
    self.Watermark = Instance.new("TextLabel", gui)
    self.Watermark.Size = UDim2.new(0, 200, 0, 25)
    self.Watermark.Position = UDim2.new(1, -210, 0, 10)
    self.Watermark.BackgroundTransparency = 1
    self.Watermark.Text = "Lionarda Style UI"
    self.Watermark.TextColor3 = Color3.fromRGB(0, 255, 0)
    self.Watermark.TextXAlignment = Enum.TextXAlignment.Right

    RunService.RenderStepped:Connect(function()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        self.Watermark.Text = "FPS: "..fps
    end)

    -- Keybind List (solda)
    self.KeybindFrame = Instance.new("Frame", gui)
    self.KeybindFrame.Size = UDim2.new(0, 200, 0, 200)
    self.KeybindFrame.Position = UDim2.new(0, 10, 0.2, 0)
    self.KeybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local keyTitle = Instance.new("TextLabel", self.KeybindFrame)
    keyTitle.Size = UDim2.new(1, 0, 0, 25)
    keyTitle.Text = "Keybinds"
    keyTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

    self.Keybinds = {}
    return self
end

-- Tab oluşturma
function Library:Tab(tabName)
    if #self.Tabs >= 4 then return error("Max 4 Tab!") end

    local tabBtn = Instance.new("TextButton", self.TabBar)
    tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
    tabBtn.Position = UDim2.new(#self.Tabs * 0.25, 0, 0, 0)
    tabBtn.Text = tabName
    tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)

    local tabFrame = Instance.new("Frame", self.MainFrame)
    tabFrame.Size = UDim2.new(1, 0, 1, -30)
    tabFrame.Position = UDim2.new(0,0,0,30)
    tabFrame.BackgroundTransparency = 0
    tabFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    tabFrame.Visible = #self.Tabs == 0

    local tab = {Frame = tabFrame, Elements = {}}
    table.insert(self.Tabs, tab)

    tabBtn.MouseButton1Click:Connect(function()
        for _,t in pairs(self.Tabs) do t.Frame.Visible = false end
        tabFrame.Visible = true
    end)

    function tab:Label(text)
        local lbl = Instance.new("TextLabel", self.Frame)
        lbl.Size = UDim2.new(1, -20, 0, 25)
        lbl.Position = UDim2.new(0, 10, 0, (#self.Frame:GetChildren()-1) * 30)
        lbl.Text = text
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
    end

    function tab:Button(text, callback)
        local btn = Instance.new("TextButton", self.Frame)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, (#self.Frame:GetChildren()-1) * 35)
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    function tab:Toggle(text, default, callback)
        local state = default or false
        local btn = Instance.new("TextButton", self.Frame)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, (#self.Frame:GetChildren()-1) * 35)
        btn.Text = text.." : "..tostring(state)
        btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text.." : "..tostring(state)
            pcall(callback,state)
        end)
    end

    function tab:Slider(name, min, max, default, callback)
        local frame = Instance.new("Frame", self.Frame)
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.Position = UDim2.new(0, 10, 0, (#self.Frame:GetChildren()-1) * 45)
        frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1,0,0,20)
        title.BackgroundTransparency = 1
        title.Text = name.." : "..tostring(default)
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.TextXAlignment = Enum.TextXAlignment.Left

        local bar = Instance.new("Frame", frame)
        bar.Size = UDim2.new(1,-10,0,10)
        bar.Position = UDim2.new(0,5,0,25)
        bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

        local dragging=false
        bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
        bar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                local rel=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                local val=math.floor(min+(max-min)*rel)
                fill.Size=UDim2.new(rel,0,1,0)
                title.Text=name.." : "..tostring(val)
                pcall(callback,val)
            end
        end)
    end

    function tab:ColorPicker(name, default, callback)
        local frame = Instance.new("Frame", self.Frame)
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.Position = UDim2.new(0, 10, 0, (#self.Frame:GetChildren()-1) * 45)
        frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(0.6,0,1,0)
        lbl.Text = name
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.BackgroundTransparency = 1

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0.4,-5,1,-5)
        btn.Position = UDim2.new(0.6,5,0,2)
        btn.BackgroundColor3 = default or Color3.fromRGB(255,0,0)
        btn.Text = ""

        btn.MouseButton1Click:Connect(function()
            local colors={Color3.fromRGB(255,0,0),Color3.fromRGB(0,255,0),Color3.fromRGB(0,0,255),Color3.fromRGB(255,255,0)}
            local cur=table.find(colors,btn.BackgroundColor3) or 1
            local nextC=colors[(cur%#colors)+1]
            btn.BackgroundColor3=nextC
            pcall(callback,nextC)
        end)
    end

    return tab
end

-- Keybind
function Library:Keybind(name, defaultKey, callback)
    local currentKey=defaultKey or Enum.KeyCode.E
    local label=Instance.new("TextLabel",self.KeybindFrame)
    label.Size=UDim2.new(1,0,0,20)
    label.Position=UDim2.new(0,0,0,(#self.KeybindFrame:GetChildren()-1)*20)
    label.Text=name.." : "..currentKey.Name
    label.BackgroundTransparency=1
    label.TextColor3=Color3.fromRGB(255,255,255)
    label.TextXAlignment=Enum.TextXAlignment.Left

    self.Keybinds[name]=currentKey
    UserInputService.InputBegan:Connect(function(i,gpe) if not gpe and i.KeyCode==self.Keybinds[name] then pcall(callback) end end)

    label.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            label.Text=name.." : ..."
            local con;con=UserInputService.InputBegan:Connect(function(i2,gpe)
                if not gpe and i2.UserInputType==Enum.UserInputType.Keyboard then
                    currentKey=i2.KeyCode
                    self.Keybinds[name]=currentKey
                    label.Text=name.." : "..currentKey.Name
                    con:Disconnect()
                end
            end)
        end
    end)
end

return Library
