-- // Serviços do Roblox
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local HttpService = game:GetService('HttpService')

-- // Variáveis Globais e Configurações
local LovelyLibrary = {}
local Ihatethisui = {}
local UIName = 'LovelyPastel_UILibrary'
local Amount = 0
local ConfigF
local BreakAllLoops = false
local ChangeTheme = false
local NotificationTransparency = 0.05
local Utility = {}
local Config = {}
local ConfigUpdates = {}

-- // Temas Fofos e Pastel
local Themes = {
    ['Strawberry Milk'] = { -- Rosa Pastel (Padrão)
        BackgroundColor = Color3.fromRGB(255, 240, 243),
        SidebarColor = Color3.fromRGB(255, 218, 224),
        PrimaryTextColor = Color3.fromRGB(114, 81, 87),
        SecondaryTextColor = Color3.fromRGB(180, 138, 145),
        UIStrokeColor = Color3.fromRGB(255, 194, 205),
        PrimaryElementColor = Color3.fromRGB(255, 255, 255),
        SecondaryElementColor = Color3.fromRGB(255, 229, 232),
        OtherElementColor = Color3.fromRGB(255, 245, 247),
        ScrollBarColor = Color3.fromRGB(255, 170, 185),
        PromptColor = Color3.fromRGB(255, 229, 232),
        NotificationColor = Color3.fromRGB(255, 240, 243),
        NotificationUIStrokeColor = Color3.fromRGB(255, 170, 185)
    },
    ['Lavender Dream'] = { -- Roxo Pastel
        BackgroundColor = Color3.fromRGB(243, 240, 255),
        SidebarColor = Color3.fromRGB(227, 218, 255),
        PrimaryTextColor = Color3.fromRGB(87, 81, 114),
        SecondaryTextColor = Color3.fromRGB(145, 138, 180),
        UIStrokeColor = Color3.fromRGB(205, 194, 255),
        PrimaryElementColor = Color3.fromRGB(255, 255, 255),
        SecondaryElementColor = Color3.fromRGB(232, 229, 255),
        OtherElementColor = Color3.fromRGB(247, 245, 255),
        ScrollBarColor = Color3.fromRGB(185, 170, 255),
        PromptColor = Color3.fromRGB(232, 229, 255),
        NotificationColor = Color3.fromRGB(243, 240, 255),
        NotificationUIStrokeColor = Color3.fromRGB(185, 170, 255)
    },
    ['Matcha Latte'] = { -- Verde Pastel
        BackgroundColor = Color3.fromRGB(240, 255, 243),
        SidebarColor = Color3.fromRGB(218, 255, 224),
        PrimaryTextColor = Color3.fromRGB(81, 114, 87),
        SecondaryTextColor = Color3.fromRGB(138, 180, 145),
        UIStrokeColor = Color3.fromRGB(194, 255, 205),
        PrimaryElementColor = Color3.fromRGB(255, 255, 255),
        SecondaryElementColor = Color3.fromRGB(229, 255, 232),
        OtherElementColor = Color3.fromRGB(245, 255, 247),
        ScrollBarColor = Color3.fromRGB(170, 255, 185),
        PromptColor = Color3.fromRGB(229, 255, 232),
        NotificationColor = Color3.fromRGB(240, 255, 243),
        NotificationUIStrokeColor = Color3.fromRGB(170, 255, 185)
    },
    ['Sky Cotton'] = { -- Azul Pastel
        BackgroundColor = Color3.fromRGB(240, 248, 255),
        SidebarColor = Color3.fromRGB(218, 237, 255),
        PrimaryTextColor = Color3.fromRGB(81, 99, 114),
        SecondaryTextColor = Color3.fromRGB(138, 161, 180),
        UIStrokeColor = Color3.fromRGB(194, 224, 255),
        PrimaryElementColor = Color3.fromRGB(255, 255, 255),
        SecondaryElementColor = Color3.fromRGB(229, 242, 255),
        OtherElementColor = Color3.fromRGB(245, 251, 255),
        ScrollBarColor = Color3.fromRGB(170, 209, 255),
        PromptColor = Color3.fromRGB(229, 242, 255),
        NotificationColor = Color3.fromRGB(240, 248, 255),
        NotificationUIStrokeColor = Color3.fromRGB(170, 209, 255)
    }
}

local CurrentTheme = Themes['Strawberry Milk']
local CurrentPlatform = "Mobile" -- Padrão Inicial

-- // Sistema de Salvamento Delta Compatibility
local function loadPlatformSettings()
    if isfolder and isfile and makefolder then
        if not isfolder("DeltaCompatibility") then
            makefolder("DeltaCompatibility")
        end
        if isfile("DeltaCompatibility/platform") then
            local data = readfile("DeltaCompatibility/platform")
            if data == "+1" then
                CurrentPlatform = "PC"
            else
                CurrentPlatform = "Mobile"
            end
        else
            writefile("DeltaCompatibility/platform", "-0")
            CurrentPlatform = "Mobile"
        end
    end
end

local function savePlatformSettings(platform)
    CurrentPlatform = platform
    if isfolder and writefile and makefolder then
        if not isfolder("DeltaCompatibility") then
            makefolder("DeltaCompatibility")
        end
        local content = (platform == "PC") and "+1" or "-0"
        writefile("DeltaCompatibility/platform", content)
    end
end

loadPlatformSettings()

-- // Funções de Utilidade Visual
do
    function Utility:Tween(Instance, Properties, Duration, ...)
        local TweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Tween = TweenService:Create(Instance, TweenInfo, Properties)
        Tween:Play()
        return Tween
    end

    function Utility:DestroyUI()
        ChangeTheme = true
        BreakAllLoops = true
        for Index, Value in next, Ihatethisui do
            if Value.Break then Value:Break() end
        end
        if CoreGui:FindFirstChild(UIName) then
            CoreGui:FindFirstChild(UIName):Destroy()
        end
        if CoreGui:FindFirstChild("Lovely_Notifications") then
            CoreGui:FindFirstChild("Lovely_Notifications"):Destroy()
        end
        if CoreGui:FindFirstChild("Lovely_Switcher") then
            CoreGui:FindFirstChild("Lovely_Switcher"):Destroy()
        end
    end

    function Utility:Darken(Color)
        local H, S, V = Color:ToHSV()
        V = math.clamp(V - 0.08, 0, 1)
        return Color3.fromHSV(H, S, V)
    end

    function Utility:Lighten(Color)
        local H, S, V = Color:ToHSV()
        V = math.clamp(V + 0.08, 0, 1)
        return Color3.fromHSV(H, S, V)
    end

    function Utility:SplitColor(Color)
        return {math.floor(Color.R * 255), math.floor(Color.G * 255), math.floor(Color.B * 255)}
    end

    function Utility:JoinColor(Table)
        return Color3.fromRGB(Table[1], Table[2], Table[3])
    end

    function Utility:ToggleUI()
        if CoreGui:FindFirstChild(UIName) then
            local main = CoreGui:FindFirstChild(UIName)
            main.Enabled = not main.Enabled
        end
    end

    function Utility:EnableDragging(Frame)
        local Dragging, DraggingInput, DragStart, StartPosition
        
        local function Update(Input)
            local Delta = Input.Position - DragStart
            Frame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
        
        Frame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Frame.Position
        
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        
        Frame.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                DraggingInput = Input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(Input)
            if Input == DraggingInput and Dragging then
                Update(Input)
            end
        end)
    end

    function Utility:Create(_Instance, Properties, Children)
        local Object = Instance.new(_Instance)
        Properties = Properties or {}
        Children = Children or {}
        
        for Index, Property in next, Properties do
            Object[Index] = Property
        end

        for _, Child in next, Children do
            Child.Parent = Object
        end

        return Object
    end
end

-- // Criar Notificações Fofas
function LovelyLibrary:CreateNotification(Title, Text, Duration)
    Title = Title or 'Aviso Fofo'
    Text = Text or 'Algo mágico aconteceu!'
    Duration = Duration or 4

    task.spawn(function()
        local NotifyGui = CoreGui:FindFirstChild("Lovely_Notifications")
        if not NotifyGui then
            NotifyGui = Utility:Create('ScreenGui', {
                Name = 'Lovely_Notifications',
                Parent = CoreGui
            })
        end

        local Container = NotifyGui:FindFirstChild("Container")
        if not Container then
            Container = Utility:Create('Frame', {
                Name = "Container",
                Parent = NotifyGui,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, -20),
                Size = UDim2.new(0, 280, 0, 500),
                AnchorPoint = Vector2.new(1, 1)
            }, {
                Utility:Create('UIListLayout', {
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            })
        end

        local Box = Utility:Create('Frame', {
            BackgroundColor3 = CurrentTheme.NotificationColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 260, 0, 65),
            BackgroundTransparency = 1,
            LayoutOrder = #Container:GetChildren()
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 12) }),
            Utility:Create('UIStroke', {
                Color = CurrentTheme.NotificationUIStrokeColor,
                Thickness = 2,
                Transparency = 1
            }),
            Utility:Create('TextLabel', {
                Name = 'TitleLabel',
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(1, -24, 0, 20),
                Font = Enum.Font.FredokaOne,
                Text = Title,
                TextColor3 = CurrentTheme.PrimaryTextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = 1
            }),
            Utility:Create('TextLabel', {
                Name = 'ContentLabel',
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 28),
                Size = UDim2.new(1, -24, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = Text,
                TextColor3 = CurrentTheme.SecondaryTextColor,
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = 1
            })
        })

        Box.Parent = Container

        -- Animação de Entrada
        Utility:Tween(Box, {BackgroundTransparency = NotificationTransparency}, 0.4)
        Utility:Tween(Box.UIStroke, {Transparency = 0}, 0.4)
        Utility:Tween(Box.TitleLabel, {TextTransparency = 0}, 0.4)
        Utility:Tween(Box.ContentLabel, {TextTransparency = 0}, 0.4)

        task.wait(Duration)

        -- Animação de Saída
        Utility:Tween(Box, {BackgroundTransparency = 1}, 0.4)
        Utility:Tween(Box.UIStroke, {Transparency = 1}, 0.4)
        Utility:Tween(Box.TitleLabel, {TextTransparency = 1}, 0.4)
        Utility:Tween(Box.ContentLabel, {TextTransparency = 1}, 0.4)
        
        task.wait(0.4)
        Box:Destroy()
    end)
end

-- // Criar Prompts Interativos
function LovelyLibrary:CreatePrompt(Type, Title, Text, ...)
    local Title = Title or 'Aviso'
    local Text = Text or 'Conteúdo do prompt fofo.'
    local Args = {...}

    local MainGui = CoreGui:FindFirstChild(UIName)
    if not MainGui then return end

    local PromptHolder = MainGui.Main.PromptHolder
    for _, Item in next, PromptHolder:GetChildren() do
        if Item:IsA('Frame') then Item:Destroy() end
    end

    local PromptFrame = Utility:Create('Frame', {
        Name = Title..'PromptFrame',
        Parent = PromptHolder,
        BackgroundColor3 = CurrentTheme.PromptColor,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BorderSizePixel = 0,
        ZIndex = 101,
        Size = UDim2.new(0, 0, 0, 0)
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 16) }),
        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 2 }),
        Utility:Create('TextLabel', {
            Name = 'PromptTitle',
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 12),
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.new(0.9, 0, 0, 24),
            Font = Enum.Font.FredokaOne,
            Text = Title,
            TextColor3 = CurrentTheme.PrimaryTextColor,
            TextSize = 18,
            ZIndex = 102,
            TextTransparency = 1
        }),
        Utility:Create('TextLabel', {
            Name = 'PromptText',
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 42),
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.new(0.9, 0, 0, 60),
            Font = Enum.Font.GothamSemibold,
            Text = Text,
            TextColor3 = CurrentTheme.SecondaryTextColor,
            TextSize = 13,
            TextWrapped = true,
            ZIndex = 102,
            TextTransparency = 1
        })
    })

    -- Layout dos Botões
    if Type == 'Text' or Type == 'OneButton' then
        local BtnText = (Type == 'Text') and Args[1] or Args[1][1]
        local Callback = (Type == 'OneButton') and Args[1][2] or function() end

        local Button = Utility:Create('TextButton', {
            Name = 'PromptButton',
            Parent = PromptFrame,
            BackgroundColor3 = CurrentTheme.SecondaryElementColor,
            Position = UDim2.new(0.5, 0, 1, -15),
            AnchorPoint = Vector2.new(0.5, 1),
            Size = UDim2.new(0.8, 0, 0, 32),
            Font = Enum.Font.FredokaOne,
            Text = BtnText,
            TextColor3 = CurrentTheme.PrimaryTextColor,
            TextSize = 14,
            ZIndex = 103,
            TextTransparency = 1,
            BackgroundTransparency = 1
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 10) }),
            Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1.5, Transparency = 1 })
        })

        Utility:Tween(PromptHolder, {BackgroundTransparency = 0.3}, 0.25)
        Utility:Tween(PromptFrame, {Size = UDim2.new(0, 280, 0, 160)}, 0.3)
        task.wait(0.3)
        Utility:Tween(PromptFrame.PromptTitle, {TextTransparency = 0}, 0.2)
        Utility:Tween(PromptFrame.PromptText, {TextTransparency = 0}, 0.2)
        Utility:Tween(Button, {TextTransparency = 0, BackgroundTransparency = 0}, 0.2)
        Utility:Tween(Button.UIStroke, {Transparency = 0}, 0.2)

        Button.MouseButton1Click:Connect(function()
            pcall(Callback)
            Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.2)
            Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            PromptFrame:Destroy()
        end)

    elseif Type == 'TwoButton' then
        local Options = Args[1]
        local Btn1Text = Options[1]
        local Btn1Callback = Options[2]
        local Btn2Text = Options[3]
        local Btn2Callback = Options[4]

        local Button1 = Utility:Create('TextButton', {
            Name = 'PromptButton1',
            Parent = PromptFrame,
            BackgroundColor3 = CurrentTheme.SecondaryElementColor,
            Position = UDim2.new(0.26, 0, 1, -15),
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(0.42, 0, 0, 32),
            Font = Enum.Font.FredokaOne,
            Text = Btn1Text,
            TextColor3 = CurrentTheme.PrimaryTextColor,
            TextSize = 13,
            ZIndex = 103,
            TextTransparency = 1,
            BackgroundTransparency = 1
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 10) }),
            Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1.5, Transparency = 1 })
        })

        local Button2 = Utility:Create('TextButton', {
            Name = 'PromptButton2',
            Parent = PromptFrame,
            BackgroundColor3 = CurrentTheme.PrimaryElementColor,
            Position = UDim2.new(0.74, 0, 1, -15),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0.42, 0, 0, 32),
            Font = Enum.Font.FredokaOne,
            Text = Btn2Text,
            TextColor3 = CurrentTheme.PrimaryTextColor,
            TextSize = 13,
            ZIndex = 103,
            TextTransparency = 1,
            BackgroundTransparency = 1
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 10) }),
            Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1.5, Transparency = 1 })
        })

        Utility:Tween(PromptHolder, {BackgroundTransparency = 0.3}, 0.25)
        Utility:Tween(PromptFrame, {Size = UDim2.new(0, 280, 0, 160)}, 0.3)
        task.wait(0.3)
        Utility:Tween(PromptFrame.PromptTitle, {TextTransparency = 0}, 0.2)
        Utility:Tween(PromptFrame.PromptText, {TextTransparency = 0}, 0.2)
        Utility:Tween(Button1, {TextTransparency = 0, BackgroundTransparency = 0}, 0.2)
        Utility:Tween(Button1.UIStroke, {Transparency = 0}, 0.2)
        Utility:Tween(Button2, {TextTransparency = 0, BackgroundTransparency = 0}, 0.2)
        Utility:Tween(Button2.UIStroke, {Transparency = 0}, 0.2)

        Button1.MouseButton1Click:Connect(function()
            pcall(Btn1Callback)
            Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.2)
            Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            PromptFrame:Destroy()
        end)

        Button2.MouseButton1Click:Connect(function()
            pcall(Btn2Callback)
            Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.2)
            Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            PromptFrame:Destroy()
        end)
    end
end

-- // Destruir UI e Interromper Loops
function LovelyLibrary:DestroyUI()
    Utility:DestroyUI()
end

function LovelyLibrary:ToggleUI()
    Utility:ToggleUI()
end

-- // Criar Janela Principal
function LovelyLibrary:CreateWindow(HubName, GameName, IntroText, IntroIcon, ImprovePerformance, ConfigFolder, Theme)
    local ImprovePerformance = ImprovePerformance or false
    local HubName = HubName or 'Lovely Hub'
    local GameName = GameName or 'Mini World'
    local IntroText = IntroText or 'Carregando Magia...'
    local IntroIcon = IntroIcon or 'rbxassetid://6031225818' -- Icone fofinho padrao
    
    ConfigF = ConfigFolder

    if Theme and Themes[Theme] then
        CurrentTheme = Themes[Theme]
    elseif type(Theme) == 'table' then
        CurrentTheme = Theme
    end

    -- Remover UI anterior se existir
    Utility:DestroyUI()

    local Container = Utility:Create('ScreenGui', {
        Name = UIName,
        Parent = CoreGui,
        Enabled = true
    })

    -- Layout dinâmico adaptável
    local Main = Utility:Create('Frame', {
        Name = 'Main',
        Parent = Container,
        BackgroundColor3 = CurrentTheme.BackgroundColor,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 16) }),
        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 3 })
    })

    -- Configuração do Layout de acordo com a Plataforma Escolhida
    local function applyPlatformLayout()
        if CurrentPlatform == "Mobile" then
            Main.Size = UDim2.new(0, 480, 0, 290)
            Main.Position = UDim2.new(0, 10, 0, 10)
        else
            Main.Size = UDim2.new(0, 580, 0, 360)
            Main.Position = UDim2.new(0.5, -290, 0.5, -180)
        end
    end
    applyPlatformLayout()
    Utility:EnableDragging(Main)

    -- Tela de Introdução Fofa
    local IntroFrame = Utility:Create('Frame', {
        Name = 'IntroFrame',
        Parent = Main,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.BackgroundColor,
        ZIndex = 50
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 16) }),
        Utility:Create('ImageLabel', {
            Name = 'Icon',
            Position = UDim2.new(0.5, 0, 0.4, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 80, 0, 80),
            BackgroundTransparency = 1,
            Image = IntroIcon
        }),
        Utility:Create('TextLabel', {
            Name = 'Txt',
            Position = UDim2.new(0.5, 0, 0.65, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0.8, 0, 0, 30),
            BackgroundTransparency = 1,
            Font = Enum.Font.FredokaOne,
            Text = IntroText,
            TextColor3 = CurrentTheme.PrimaryTextColor,
            TextSize = 18
        })
    })

    task.spawn(function()
        task.wait(2)
        Utility:Tween(IntroFrame.Icon, {ImageTransparency = 1}, 0.5)
        Utility:Tween(IntroFrame.Txt, {TextTransparency = 1}, 0.5)
        Utility:Tween(IntroFrame, {BackgroundTransparency = 1}, 0.6)
        task.wait(0.6)
        IntroFrame:Destroy()
    end)

    -- Criando os Holders Internos
    local PromptHolder = Utility:Create('Frame', {
        Name = 'PromptHolder',
        Parent = Main,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 100
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 16) })
    })

    local Sidebar = Utility:Create('Frame', {
        Name = 'Sidebar',
        Parent = Main,
        BackgroundColor3 = CurrentTheme.SidebarColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 150, 1, 0)
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 16) }),
        -- Ocultar bordas direitas do Sidebar para junção suave
        Utility:Create('Frame', {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -20, 0, 0),
            BackgroundColor3 = CurrentTheme.SidebarColor,
            BorderSizePixel = 0
        }),
        Utility:Create('TextLabel', {
            Name = 'HubLabel',
            Position = UDim2.new(0, 12, 0, 12),
            Size = UDim2.new(1, -24, 0, 20),
            BackgroundTransparency = 1,
            Font = Enum.Font.FredokaOne,
            Text = HubName,
            TextColor3 = CurrentTheme.PrimaryTextColor,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create('TextLabel', {
            Name = 'GameLabel',
            Position = UDim2.new(0, 12, 0, 30),
            Size = UDim2.new(1, -24, 0, 15),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = GameName,
            TextColor3 = CurrentTheme.SecondaryTextColor,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create('ScrollingFrame', {
            Name = 'TabButtons',
            Position = UDim2.new(0, 0, 0, 55),
            Size = UDim2.new(1, 0, 1, -65),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 0
        }, {
            Utility:Create('UIListLayout', {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 6)
            })
        })
    })

    local TabContainer = Utility:Create('Frame', {
        Name = 'TabContainer',
        Parent = Main,
        Position = UDim2.new(0, 160, 0, 10),
        Size = UDim2.new(1, -170, 1, -20),
        BackgroundTransparency = 1
    }, {
        Utility:Create('Folder', { Name = 'Tabs' })
    })

    -- Criar Botão de Alternância de Plataforma (Flutuante e Fofinho)
    local SwitcherGui = Utility:Create('ScreenGui', {
        Name = 'Lovely_Switcher',
        Parent = CoreGui
    })

    local SwitchButton = Utility:Create('TextButton', {
        Name = 'SwitchBtn',
        Parent = SwitcherGui,
        Size = UDim2.new(0, 45, 0, 45),
        Position = UDim2.new(1, -60, 1, -120),
        BackgroundColor3 = CurrentTheme.SidebarColor,
        Font = Enum.Font.FredokaOne,
        Text = (CurrentPlatform == "PC") and "💻" or "📱",
        TextSize = 22,
        AutoButtonColor = false
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }),
        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 2.5 })
    })
    Utility:EnableDragging(SwitchButton)

    SwitchButton.MouseButton1Click:Connect(function()
        if CurrentPlatform == "Mobile" then
            savePlatformSettings("PC")
            SwitchButton.Text = "💻"
            LovelyLibrary:CreateNotification("Mudança de Layout", "Modo Computador ativado!", 3)
        else
            savePlatformSettings("Mobile")
            SwitchButton.Text = "📱"
            LovelyLibrary:CreateNotification("Mudança de Layout", "Modo Mobile ativado!", 3)
        end
        applyPlatformLayout()
    end)

    -- Gerenciamento de Abas
    local Tabs = {}
    local TabCount = 0

    function Tabs:CreateTab(TabName, DefaultVisibility, Icon)
        TabName = TabName or 'Aba'
        Icon = Icon or 'rbxassetid://6031225818'
        TabCount = TabCount + 1

        local TabBtn = Utility:Create('TextButton', {
            Name = TabName..'Btn',
            Parent = Sidebar.TabButtons,
            Size = UDim2.new(0.9, 0, 0, 32),
            BackgroundColor3 = CurrentTheme.PrimaryElementColor,
            BackgroundTransparency = DefaultVisibility and 0 or 1,
            Font = Enum.Font.FredokaOne,
            Text = "  " .. TabName,
            TextColor3 = DefaultVisibility and CurrentTheme.PrimaryTextColor or CurrentTheme.SecondaryTextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 10) }),
            Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1.5, Transparency = DefaultVisibility and 0 or 1 })
        })

        local TabPage = Utility:Create('ScrollingFrame', {
            Name = TabName..'Page',
            Parent = TabContainer.Tabs,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = DefaultVisibility,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = CurrentTheme.ScrollBarColor
        }, {
            Utility:Create('UIListLayout', {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8)
            })
        })

        -- Atualização do tamanho da rolagem automática
        TabPage.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPage.UIListLayout.AbsoluteContentSize.Y + 15)
        end)

        Sidebar.TabButtons.CanvasSize = UDim2.new(0, 0, 0, Sidebar.TabButtons.UIListLayout.AbsoluteContentSize.Y + 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, Page in next, TabContainer.Tabs:GetChildren() do
                Page.Visible = false
            end
            for _, Btn in next, Sidebar.TabButtons:GetChildren() do
                if Btn:IsA('TextButton') then
                    Utility:Tween(Btn, {BackgroundTransparency = 1, TextColor3 = CurrentTheme.SecondaryTextColor}, 0.2)
                    if Btn:FindFirstChild("UIStroke") then
                        Utility:Tween(Btn.UIStroke, {Transparency = 1}, 0.2)
                    end
                end
            end
            TabPage.Visible = true
            Utility:Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = CurrentTheme.PrimaryTextColor}, 0.2)
            if TabBtn:FindFirstChild("UIStroke") then
                Utility:Tween(TabBtn.UIStroke, {Transparency = 0}, 0.2)
            end
        end)

        -- Criar Seções dentro da Aba
        local Sections = {}

        function Sections:CreateSection(SectionName)
            SectionName = SectionName or 'Seção'

            local SectionFrame = Utility:Create('Frame', {
                Name = SectionName..'Section',
                Parent = TabPage,
                Size = UDim2.new(0.96, 0, 0, 40),
                BackgroundColor3 = CurrentTheme.OtherElementColor,
                BorderSizePixel = 0
            }, {
                Utility:Create('UICorner', { CornerRadius = UDim.new(0, 12) }),
                Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1.5 }),
                Utility:Create('TextLabel', {
                    Name = 'Title',
                    Position = UDim2.new(0, 10, 0, 6),
                    Size = UDim2.new(1, -20, 0, 20),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.FredokaOne,
                    Text = SectionName,
                    TextColor3 = CurrentTheme.PrimaryTextColor,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility:Create('Frame', {
                    Name = 'Container',
                    Position = UDim2.new(0, 6, 0, 30),
                    Size = UDim2.new(1, -12, 1, -36),
                    BackgroundTransparency = 1
                }, {
                    Utility:Create('UIListLayout', {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 6)
                    })
                })
            })

            local function resizeSection()
                local contentSize = SectionFrame.Container.UIListLayout.AbsoluteContentSize.Y
                SectionFrame.Size = UDim2.new(0.96, 0, 0, contentSize + 40)
            end

            SectionFrame.Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeSection)

            local Elements = {}

            -- 1. Criar Label (Etiqueta de texto)
            function Elements:CreateLabel(LabelText)
                LabelText = LabelText or 'Texto de exemplo'
                local LabelFunc = {}

                local Label = Utility:Create('Frame', {
                    Name = 'LabelElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundTransparency = 1
                }, {
                    Utility:Create('TextLabel', {
                        Name = 'Txt',
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.GothamSemibold,
                        Text = LabelText,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', { PaddingLeft = UDim.new(0, 8) })
                    })
                })

                function LabelFunc:UpdateLabel(NewText)
                    Label.Txt.Text = NewText
                end

                return LabelFunc
            end

            -- 2. Criar Parágrafo
            function Elements:CreateParagraph(Title, Paragraph)
                Title = Title or 'Título'
                Paragraph = Paragraph or 'Texto longo explicativo aqui...'
                local ParaFunc = {}

                local Para = Utility:Create('Frame', {
                    Name = 'ParagraphElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'TitleLabel',
                        Position = UDim2.new(0, 8, 0, 4),
                        Size = UDim2.new(1, -16, 0, 16),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = Title,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextLabel', {
                        Name = 'BodyLabel',
                        Position = UDim2.new(0, 8, 0, 20),
                        Size = UDim2.new(1, -16, 1, -24),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.GothamSemibold,
                        Text = Paragraph,
                        TextColor3 = CurrentTheme.SecondaryTextColor,
                        TextSize = 11,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    })
                })

                local function adjustParaSize()
                    local serviceSize = TextService:GetTextSize(Para.BodyLabel.Text, 11, Enum.Font.GothamSemibold, Vector2.new(Para.AbsoluteSize.X - 16, 999))
                    Para.Size = UDim2.new(1, 0, 0, serviceSize.Y + 28)
                end
                
                Para:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustParaSize)
                adjustParaSize()

                function ParaFunc:UpdateParagraph(NewTitle, NewParagraph)
                    Para.TitleLabel.Text = NewTitle
                    Para.BodyLabel.Text = NewParagraph
                    adjustParaSize()
                end

                return ParaFunc
            end

            -- 3. Criar Botão
            function Elements:CreateButton(BtnName, Callback)
                BtnName = BtnName or 'Aperte-me'
                Callback = Callback or function() end

                local Button = Utility:Create('TextButton', {
                    Name = 'ButtonElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor,
                    Font = Enum.Font.FredokaOne,
                    Text = "   " .. BtnName,
                    TextColor3 = CurrentTheme.PrimaryTextColor,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('ImageLabel', {
                        Name = 'ClickIcon',
                        Position = UDim2.new(1, -8, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Size = UDim2.new(0, 18, 0, 18),
                        BackgroundTransparency = 1,
                        Image = 'rbxassetid://6035041535',
                        ImageColor3 = CurrentTheme.SecondaryTextColor
                    })
                })

                Button.MouseButton1Down:Connect(function()
                    Utility:Tween(Button, {BackgroundColor3 = CurrentTheme.SecondaryElementColor}, 0.1)
                    pcall(Callback)
                    task.wait(0.1)
                    Utility:Tween(Button, {BackgroundColor3 = CurrentTheme.PrimaryElementColor}, 0.1)
                end)
            end

            -- 4. Criar Slider (Controle Deslizante)
            function Elements:CreateSlider(SliderName, Min, Max, Default, SliderColor, Callback)
                SliderName = SliderName or 'Slider'
                Min = Min or 0
                Max = Max or 100
                Default = Default or Min
                SliderColor = SliderColor or CurrentTheme.ScrollBarColor
                Callback = Callback or function() end
                
                local Value = Default
                local SliderFunc = {}

                local Slider = Utility:Create('Frame', {
                    Name = 'SliderElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 4),
                        Size = UDim2.new(0.6, 0, 0, 16),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = SliderName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextLabel', {
                        Name = 'ValueLabel',
                        Position = UDim2.new(0.6, 0, 0, 4),
                        Size = UDim2.new(0.4, -8, 0, 16),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = tostring(Value),
                        TextColor3 = CurrentTheme.SecondaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Right
                    }),
                    Utility:Create('TextButton', {
                        Name = 'Bar',
                        Position = UDim2.new(0, 8, 0, 24),
                        Size = UDim2.new(1, -16, 0, 8),
                        BackgroundColor3 = CurrentTheme.SecondaryElementColor,
                        Text = ""
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }),
                        Utility:Create('Frame', {
                            Name = 'Fill',
                            Size = UDim2.new(0, 0, 1, 0),
                            BackgroundColor3 = SliderColor
                        }, {
                            Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                        })
                    })
                })

                local function updateFill(perc)
                    Slider.Bar.Fill.Size = UDim2.new(perc, 0, 1, 0)
                    local calcValue = math.floor(Min + (Max - Min) * perc)
                    Slider.ValueLabel.Text = tostring(calcValue)
                    Value = calcValue
                end

                local function updateSliderInput(input)
                    local sizeX = Slider.Bar.AbsoluteSize.X
                    local relativeX = math.clamp(input.Position.X - Slider.Bar.AbsolutePosition.X, 0, sizeX)
                    local percentage = relativeX / sizeX
                    updateFill(percentage)
                    pcall(Callback, Value)
                end

                local activeConnection
                Slider.Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        updateSliderInput(input)
                        activeConnection = UserInputService.InputChanged:Connect(function(changeInput)
                            if changeInput.UserInputType == Enum.UserInputType.MouseMovement or changeInput.UserInputType == Enum.UserInputType.Touch then
                                updateSliderInput(changeInput)
                            end
                        end)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if activeConnection then
                            activeConnection:Disconnect()
                            activeConnection = nil
                        end
                    end
                end)

                -- Inicializar com valor padrão
                local initialPerc = math.clamp((Default - Min) / (Max - Min), 0, 1)
                updateFill(initialPerc)

                function SliderFunc:Set(NewValue)
                    local perc = math.clamp((NewValue - Min) / (Max - Min), 0, 1)
                    updateFill(perc)
                    pcall(Callback, NewValue)
                end

                return SliderFunc
            end

            -- 5. Criar Textbox (Entrada de texto)
            function Elements:CreateTextbox(BoxName, Placeholder, Callback)
                BoxName = BoxName or 'Entrada'
                Placeholder = Placeholder or 'Escreva aqui...'
                Callback = Callback or function() end

                local Textbox = Utility:Create('Frame', {
                    Name = 'TextboxElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0.5, -8, 1, 0),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = BoxName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextBox', {
                        Name = 'Box',
                        Position = UDim2.new(1, -8, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Size = UDim2.new(0.45, 0, 0, 22),
                        BackgroundColor3 = CurrentTheme.SecondaryElementColor,
                        Font = Enum.Font.GothamSemibold,
                        PlaceholderText = Placeholder,
                        Text = "",
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        PlaceholderColor3 = CurrentTheme.SecondaryTextColor,
                        TextSize = 11,
                        ClipsDescendants = true
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 })
                    })
                })

                Textbox.Box.FocusLost:Connect(function(enterPressed)
                    pcall(Callback, Textbox.Box.Text)
                end)
            end

            -- 6. Criar Keybind (Teclas de ativação)
            function Elements:CreateKeybind(BindName, DefaultKey, Callback)
                BindName = BindName or 'Keybind'
                DefaultKey = DefaultKey or 'E'
                Callback = Callback or function() end
                
                local CurrentKey = DefaultKey
                local Listening = false
                local KeybindFunc = {}

                local Keybind = Utility:Create('Frame', {
                    Name = 'KeybindElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0.6, -8, 1, 0),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = BindName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextButton', {
                        Name = 'BindBtn',
                        Position = UDim2.new(1, -8, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Size = UDim2.new(0.3, 0, 0, 22),
                        BackgroundColor3 = CurrentTheme.SecondaryElementColor,
                        Font = Enum.Font.FredokaOne,
                        Text = CurrentKey,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 11
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 })
                    })
                })

                Keybind.BindBtn.MouseButton1Click:Connect(function()
                    Listening = true
                    Keybind.BindBtn.Text = "..."
                end)

                local bindConnection = UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    if Listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            CurrentKey = input.KeyCode.Name
                            Keybind.BindBtn.Text = CurrentKey
                            Listening = false
                        end
                    else
                        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == CurrentKey then
                            pcall(Callback)
                        end
                    end
                end)

                function KeybindFunc:Break()
                    if bindConnection then bindConnection:Disconnect() end
                end

                function KeybindFunc:Set(NewKey)
                    CurrentKey = NewKey
                    Keybind.BindBtn.Text = NewKey
                end

                Ihatethisui[BindName] = KeybindFunc
                return KeybindFunc
            end

            -- 7. Criar Toggle (Interruptor Liga/Desliga)
            function Elements:CreateToggle(ToggleName, Default, ToggleColor, DebounceAmount, Callback)
                ToggleName = ToggleName or 'Toggle'
                Default = Default or false
                ToggleColor = ToggleColor or CurrentTheme.ScrollBarColor
                DebounceAmount = DebounceAmount or 0.2
                Callback = Callback or function() end

                local Toggled = Default
                local ToggleFunc = {}
                local Debouncing = false

                local Toggle = Utility:Create('Frame', {
                    Name = 'ToggleElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0.6, -8, 1, 0),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = ToggleName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextButton', {
                        Name = 'Switch',
                        Position = UDim2.new(1, -8, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Size = UDim2.new(0, 42, 0, 20),
                        BackgroundColor3 = Default and ToggleColor or CurrentTheme.SecondaryElementColor,
                        Text = ""
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1.5 }),
                        Utility:Create('Frame', {
                            Name = 'Circle',
                            Position = Default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Size = UDim2.new(0, 16, 0, 16),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }, {
                            Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                        })
                    })
                })

                local function setToggleState(state)
                    Toggled = state
                    local targetColor = state and ToggleColor or CurrentTheme.SecondaryElementColor
                    local targetPos = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    Utility:Tween(Toggle.Switch, {BackgroundColor3 = targetColor}, 0.2)
                    Utility:Tween(Toggle.Switch.Circle, {Position = targetPos}, 0.2)
                    pcall(Callback, state)
                end

                Toggle.Switch.MouseButton1Click:Connect(function()
                    if Debouncing then return end
                    Debouncing = true
                    setToggleState(not Toggled)
                    task.wait(DebounceAmount)
                    Debouncing = false
                end)

                function ToggleFunc:Set(State)
                    setToggleState(State)
                end

                return ToggleFunc
            end

            -- 8. Criar Dropdown (Menu de Opções)
            function Elements:CreateDropdown(DropName, List, Default, DebounceAmount, Callback)
                DropName = DropName or 'Dropdown'
                List = List or {}
                Default = Default or nil
                Callback = Callback or function() end
                DebounceAmount = DebounceAmount or 0.25

                local Selected = Default or 'Nenhum'
                local Opened = false
                local DropdownFunc = {}

                local Dropdown = Utility:Create('Frame', {
                    Name = 'DropdownElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor,
                    ClipsDescendants = true
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0.5, -8, 0, 34),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = DropName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextButton', {
                        Name = 'OpenBtn',
                        Position = UDim2.new(1, -8, 0, 6),
                        AnchorPoint = Vector2.new(1, 0),
                        Size = UDim2.new(0.45, 0, 0, 22),
                        BackgroundColor3 = CurrentTheme.SecondaryElementColor,
                        Font = Enum.Font.GothamSemibold,
                        Text = Selected,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 11
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 })
                    }),
                    Utility:Create('Frame', {
                        Name = 'OptionHolder',
                        Position = UDim2.new(0, 8, 0, 38),
                        Size = UDim2.new(1, -16, 0, 100),
                        BackgroundTransparency = 1
                    }, {
                        Utility:Create('ScrollingFrame', {
                            Name = 'ListScroller',
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            ScrollBarThickness = 2,
                            ScrollBarImageColor3 = CurrentTheme.ScrollBarColor
                        }, {
                            Utility:Create('UIListLayout', { Padding = UDim.new(0, 4) })
                        })
                    })
                })

                local function rebuildList()
                    for _, Item in next, Dropdown.OptionHolder.ListScroller:GetChildren() do
                        if Item:IsA('TextButton') then Item:Destroy() end
                    end
                    for _, Name in next, List do
                        local Opt = Utility:Create('TextButton', {
                            Name = Name,
                            Parent = Dropdown.OptionHolder.ListScroller,
                            Size = UDim2.new(0.98, 0, 0, 22),
                            BackgroundColor3 = CurrentTheme.SecondaryElementColor,
                            Font = Enum.Font.GothamSemibold,
                            Text = "  " .. Name,
                            TextColor3 = CurrentTheme.SecondaryTextColor,
                            TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left
                        }, {
                            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) })
                        })

                        Opt.MouseButton1Click:Connect(function()
                            Selected = Name
                            Dropdown.OpenBtn.Text = Name
                            pcall(Callback, Name)
                            
                            -- Fechar automaticamente
                            Opened = false
                            Utility:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 34)}, DebounceAmount)
                        end)
                    end
                    Dropdown.OptionHolder.ListScroller.CanvasSize = UDim2.new(0, 0, 0, Dropdown.OptionHolder.ListScroller.UIListLayout.AbsoluteContentSize.Y + 5)
                end

                rebuildList()

                Dropdown.OpenBtn.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    local targetHeight = Opened and 144 or 34
                    Utility:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, targetHeight)}, DebounceAmount)
                end)

                function DropdownFunc:Set(Value)
                    Selected = tostring(Value)
                    Dropdown.OpenBtn.Text = Selected
                    pcall(Callback, Value)
                end

                function DropdownFunc:UpdateDropdown(NewList)
                    List = NewList
                    rebuildList()
                    if not Opened then
                        Dropdown.OpenBtn.Text = "Selecione..."
                    end
                end

                return DropdownFunc
            end

            -- 9. Criar Colorpicker (Seletor de Cores)
            function Elements:CreateColorpicker(PickerName, DefaultColor, DebounceAmount, Callback)
                PickerName = PickerName or 'Cor'
                DefaultColor = DefaultColor or Color3.fromRGB(255, 170, 185)
                DebounceAmount = DebounceAmount or 0.25
                Callback = Callback or function() end

                local CurrentColor = DefaultColor
                local Opened = false
                local PickerFunc = {}

                local Colorpicker = Utility:Create('Frame', {
                    Name = 'ColorpickerElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor,
                    ClipsDescendants = true
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0.5, -8, 0, 34),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = PickerName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextButton', {
                        Name = 'Preview',
                        Position = UDim2.new(1, -8, 0, 6),
                        AnchorPoint = Vector2.new(1, 0),
                        Size = UDim2.new(0, 35, 0, 22),
                        BackgroundColor3 = CurrentColor,
                        Text = ""
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 })
                    }),
                    -- Painel simples de paletas fofas padrão para facilitar no Mobile/PC
                    Utility:Create('Frame', {
                        Name = 'PaletteHolder',
                        Position = UDim2.new(0, 8, 0, 38),
                        Size = UDim2.new(1, -16, 0, 30),
                        BackgroundTransparency = 1
                    }, {
                        Utility:Create('UIListLayout', {
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            Padding = UDim.new(0, 10),
                            VerticalAlignment = Enum.VerticalAlignment.Center
                        })
                    })
                })

                -- 5 tons pastel pré-selecionados para o usuário escolher de forma simples
                local PastelPalette = {
                    Color3.fromRGB(255, 170, 185), -- Rosa fofo
                    Color3.fromRGB(185, 170, 255), -- Lilás fofo
                    Color3.fromRGB(170, 230, 255), -- Azulzinho
                    Color3.fromRGB(170, 255, 185), -- Matcha
                    Color3.fromRGB(255, 240, 170)  -- Melão
                }

                for _, ColorObj in next, PastelPalette do
                    local ColorDot = Utility:Create('TextButton', {
                        Name = 'Dot',
                        Parent = Colorpicker.PaletteHolder,
                        Size = UDim2.new(0, 22, 0, 22),
                        BackgroundColor3 = ColorObj,
                        Text = ""
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 })
                    })

                    ColorDot.MouseButton1Click:Connect(function()
                        CurrentColor = ColorObj
                        Colorpicker.Preview.BackgroundColor3 = ColorObj
                        pcall(Callback, ColorObj)
                        
                        -- Fechar após escolher
                        Opened = false
                        Utility:Tween(Colorpicker, {Size = UDim2.new(1, 0, 0, 34)}, DebounceAmount)
                    end)
                end

                Colorpicker.Preview.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    local targetHeight = Opened and 74 or 34
                    Utility:Tween(Colorpicker, {Size = UDim2.new(1, 0, 0, targetHeight)}, DebounceAmount)
                end)

                function PickerFunc:Set(NewColor)
                    CurrentColor = NewColor
                    Colorpicker.Preview.BackgroundColor3 = NewColor
                    pcall(Callback, NewColor)
                end

                return PickerFunc
            end

            -- 10. Criar Elemento de Imagem
            function Elements:CreateImage(ImgName, URL, ImageSize)
                ImgName = ImgName or 'Galeria'
                URL = URL or 'rbxassetid://6031225818'
                ImageSize = ImageSize or UDim2.new(0, 100, 0, 100)

                local Opened = false
                local ImageFunc = {}

                local ImageElement = Utility:Create('Frame', {
                    Name = 'ImageElement',
                    Parent = SectionFrame.Container,
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = CurrentTheme.PrimaryElementColor,
                    ClipsDescendants = true
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 }),
                    Utility:Create('TextLabel', {
                        Name = 'Title',
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0.6, -8, 0, 34),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.FredokaOne,
                        Text = ImgName,
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextButton', {
                        Name = 'ToggleBtn',
                        Position = UDim2.new(1, -8, 0, 6),
                        AnchorPoint = Vector2.new(1, 0),
                        Size = UDim2.new(0, 50, 0, 22),
                        BackgroundColor3 = CurrentTheme.SecondaryElementColor,
                        Font = Enum.Font.FredokaOne,
                        Text = "Ver",
                        TextColor3 = CurrentTheme.PrimaryTextColor,
                        TextSize = 11
                    }, {
                        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                        Utility:Create('UIStroke', { Color = CurrentTheme.UIStrokeColor, Thickness = 1 })
                    }),
                    Utility:Create('ImageLabel', {
                        Name = 'DisplayImage',
                        Position = UDim2.new(0.5, 0, 0, 40),
                        AnchorPoint = Vector2.new(0.5, 0),
                        Size = ImageSize,
                        BackgroundTransparency = 1,
                        Image = URL,
                        ScaleType = Enum.ScaleType.Fit
                    })
                })

                ImageElement.ToggleBtn.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    local targetHeight = Opened and (ImageSize.Y.Offset + 50) or 34
                    ImageElement.ToggleBtn.Text = Opened and "Fechar" or "Ver"
                    Utility:Tween(ImageElement, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
                end)

                function ImageFunc:UpdateImage(NewURL, NewSize)
                    URL = NewURL
                    ImageElement.DisplayImage.Image = NewURL
                    if NewSize then
                        ImageSize = NewSize
                        ImageElement.DisplayImage.Size = NewSize
                        if Opened then
                            ImageElement.Size = UDim2.new(1, 0, 0, NewSize.Y.Offset + 50)
                        end
                    end
                end

                return ImageFunc
            end

            return Elements
        end

        return Sections
    end

    return Tabs
end

return LovelyLibrary