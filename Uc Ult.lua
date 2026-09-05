--==================================================
-- Project Undercover Build20250205 - UI REFINED
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- CHECK FOR MOUSE MOVE SUPPORT
local HAS_MOUSEMOVEREL = pcall(function() return mousemoverel end)
local HAS_MOUSE1CLICK = pcall(function() return mouse1click end)

-- MATH UTILITIES
local MathHandler = {}

function MathHandler:CalculateDirection(Origin, Position, Magnitude)
    return typeof(Origin) == "Vector3" and typeof(Position) == "Vector3" and typeof(Magnitude) == "number" and (Position - Origin).Unit * Magnitude or Vector3.zero
end

function MathHandler:CalculateChance(Percentage)
    return typeof(Percentage) == "number" and math.random(1, 100) <= Percentage or false
end

-- CHARACTER MANAGEMENT
local Character, Humanoid, HRP
local function getChar()
    if LocalPlayer.Character then
        Character = LocalPlayer.Character
        task.wait(0.1)
        Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        HRP = Character:FindFirstChild("HumanoidRootPart")
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    task.wait(0.5)
    Humanoid = char:WaitForChild("Humanoid", 5)
    HRP = char:WaitForChild("HumanoidRootPart", 5)
end)

getChar()

-- ================= AIMBOT CONFIG =================
local Configuration = {
    -- Aimbot
    Aimbot = false,
    OnePressAimingMode = false,
    AimKey = Enum.UserInputType.MouseButton2,
    AimMode = "Mouse",
    SilentAimChance = 100,
    OffAimbotAfterKill = false,
    AimPart = "Head",
    AimPartDropdownValues = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
    RandomAimPart = false,
    
    -- Silent Aim
    SilentAim = false,
    SilentAimKey = Enum.KeyCode.E,
    AlwaysOnSilent = false,
    ShowSilentFOV = false,
    SilentFOVRadius = 150,
    SilentPrediction = false,
    SilentPredictionX = 1.0,
    SilentPredictionY = 1.0,
    SilentVisualizer = false,
    SilentTargetBone = "Head",
    SilentBoneDropdownValues = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot" },
    
    -- Offset
    UseOffset = false,
    OffsetType = "Static",
    StaticOffsetIncrement = 10,
    DynamicOffsetIncrement = 10,
    AutoOffset = false,
    MaxAutoOffset = 50,
    
    -- Sensitivity & Noise
    UseSensitivity = false,
    Sensitivity = 50,
    UseNoise = false,
    NoiseFrequency = 50,
    
    -- TriggerBot
    TriggerBot = false,
    OnePressTriggeringMode = false,
    SmartTriggerBot = true,
    TriggerKey = Enum.KeyCode.E,
    TriggerBotChance = 100,
    
    -- Checks
    AliveCheck = true,
    GodCheck = false,
    TeamCheck = false,
    FriendCheck = true,
    FollowCheck = false,
    VerifiedBadgeCheck = false,
    WallCheck = false,
    WaterCheck = false,
    FoVCheck = false,
    FoVRadius = 250,
    MagnitudeCheck = false,
    TriggerMagnitude = 500,
    TransparencyCheck = false,
    IgnoredTransparency = 0.5,
    IgnoredPlayersCheck = false,
    IgnoredPlayers = {},
    TargetPlayersCheck = false,
    TargetPlayers = {},
    
    -- Visuals
    FoV = false,
    FoVThickness = 2,
    FoVOpacity = 0.8,
    FoVFilled = false,
    FoVColour = Color3.fromRGB(44, 62, 80),
    ESPBox = false,
    ESPBoxFilled = false,
    CorneredBox = false,
    CornerLength = 6,
    NameESP = false,
    HealthESP = false,
    TracerESP = false,
    SkeletonESP = false,
    HighlightESP = false,
    HeadCircle = false,
    ESPThickness = 2,
    ESPOpacity = 0.8,
    ESPColour = Color3.fromRGB(44, 62, 80),
    RainbowVisuals = false,
    RainbowDelay = 5,
    
    -- Misc
    SpinBot = false,
    SpinBotVelocity = 50,
    SpinPart = "HumanoidRootPart",
    
    -- UI Settings
    AccentColor = Color3.fromRGB(44, 62, 80),
    SecondaryColor = Color3.fromRGB(52, 73, 94),
    MenuSize = "100%",
}

-- ================= AIMBOT STATE =================
local Aiming = false
local Target = nil
local Triggering = false
local ShowingFoV = false
local ShowingESP = false

-- ================= SILENT AIM VARIABLES =================
local SilentAimActive = false
local SilentTarget = nil
local SilentTargetScreenPos = nil
local SilentFOVCircle = nil
local TargetVisualizer = nil

-- ================= REMOVE OLD UI =================
pcall(function()
    game.CoreGui.UndercoverSlotted:Destroy()
end)

-- ================= PROFESSIONAL UI SYSTEM =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UndercoverSlotted"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false

-- ================= LOADING SCREEN =================
local loadingGui = Instance.new("ScreenGui", game.CoreGui)
loadingGui.Name = "LoadingScreen"
loadingGui.ResetOnSpawn = false
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loadingBg = Instance.new("Frame", loadingGui)
loadingBg.Size = UDim2.new(1, 0, 1, 0)
loadingBg.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
loadingBg.BorderSizePixel = 0

local loadingCenter = Instance.new("Frame", loadingBg)
loadingCenter.Size = UDim2.new(0, 400, 0, 180)
loadingCenter.Position = UDim2.new(0.5, -200, 0.5, -90)
loadingCenter.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
loadingCenter.BorderSizePixel = 0
local loadingCenterCorner = Instance.new("UICorner", loadingCenter)
loadingCenterCorner.CornerRadius = UDim.new(0, 12)

local loadingStroke = Instance.new("UIStroke", loadingCenter)
loadingStroke.Color = Color3.fromRGB(39, 39, 42)
loadingStroke.Thickness = 1

local loadingLogo = Instance.new("TextLabel", loadingCenter)
loadingLogo.Size = UDim2.new(1, 0, 0, 40)
loadingLogo.Position = UDim2.new(0, 0, 0, 20)
loadingLogo.BackgroundTransparency = 1
loadingLogo.Text = "UNDERCOVER"
loadingLogo.Font = Enum.Font.GothamBold
loadingLogo.TextSize = 28
loadingLogo.TextColor3 = Color3.fromRGB(250, 250, 250)
loadingLogo.TextXAlignment = Enum.TextXAlignment.Center

local loadingSub = Instance.new("TextLabel", loadingCenter)
loadingSub.Size = UDim2.new(1, 0, 0, 20)
loadingSub.Position = UDim2.new(0, 0, 0, 62)
loadingSub.BackgroundTransparency = 1
loadingSub.Text = "Bypassing Anti-Cheat Protection..."
loadingSub.Font = Enum.Font.Gotham
loadingSub.TextSize = 12
loadingSub.TextColor3 = Color3.fromRGB(161, 161, 170)
loadingSub.TextXAlignment = Enum.TextXAlignment.Center

local loadingBarBg = Instance.new("Frame", loadingCenter)
loadingBarBg.Size = UDim2.new(0.8, 0, 0, 8)
loadingBarBg.Position = UDim2.new(0.1, 0, 0, 100)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(39, 39, 42)
loadingBarBg.BorderSizePixel = 0
local loadingBarBgCorner = Instance.new("UICorner", loadingBarBg)
loadingBarBgCorner.CornerRadius = UDim.new(1, 0)

local loadingBarFill = Instance.new("Frame", loadingBarBg)
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
loadingBarFill.BorderSizePixel = 0
local loadingBarFillCorner = Instance.new("UICorner", loadingBarFill)
loadingBarFillCorner.CornerRadius = UDim.new(1, 0)

local loadingText = Instance.new("TextLabel", loadingCenter)
loadingText.Size = UDim2.new(1, 0, 0, 20)
loadingText.Position = UDim2.new(0, 0, 0, 120)
loadingText.BackgroundTransparency = 1
loadingText.Text = "0%"
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 14
loadingText.TextColor3 = Color3.fromRGB(44, 62, 80)
loadingText.TextXAlignment = Enum.TextXAlignment.Center

local acStages = {
    "Initializing memory scanner...",
    "Scanning for debuggers...",
    "Bypassing kernel hooks...",
    "Spoofing hardware IDs...",
    "Injecting protection bypass...",
    "Verifying integrity...",
    "Loading drivers...",
    "Finalizing injection...",
    "Starting cheat..."
}

local function ShowLoadingScreen()
    local loadTime = math.random(30, 45) / 10
    local steps = 100
    local currentStep = 0
    local stageIndex = 1
    
    while currentStep < steps do
        local jump = math.random(1, 4)
        currentStep = math.min(currentStep + jump, steps)
        
        loadingBarFill.Size = UDim2.new(currentStep / steps, 0, 1, 0)
        loadingText.Text = math.floor(currentStep) .. "%"
        
        if currentStep > (stageIndex / #acStages) * steps and stageIndex <= #acStages then
            loadingSub.Text = acStages[stageIndex]
            stageIndex = stageIndex + 1
        end
        
        local delay = math.random(3, 15) / 100
        task.wait(delay)
    end
    
    loadingBarFill.Size = UDim2.new(1, 0, 1, 0)
    loadingText.Text = "100%"
    loadingSub.Text = "Bypass Complete! Loading..."
    task.wait(0.3)
    
    loadingGui.Enabled = false
    gui.Enabled = true
end

task.spawn(ShowLoadingScreen)

-- Color scheme (refined to match the picture)
local COLORS = {
    Background = Color3.fromRGB(14, 14, 18),
    Sidebar = Color3.fromRGB(11, 11, 14),
    TitleBar = Color3.fromRGB(9, 9, 12),
    Content = Color3.fromRGB(18, 18, 22),
    Card = Color3.fromRGB(23, 23, 28),
    CardHover = Color3.fromRGB(30, 30, 36),
    Accent = Color3.fromRGB(44, 62, 80),
    AccentLight = Color3.fromRGB(52, 73, 94),
    Success = Color3.fromRGB(46, 204, 113),
    Danger = Color3.fromRGB(231, 76, 60),
    Text = Color3.fromRGB(236, 240, 241),
    TextSecondary = Color3.fromRGB(149, 165, 166),
    TextMuted = Color3.fromRGB(100, 110, 115),
    Border = Color3.fromRGB(40, 40, 45),
    BorderLight = Color3.fromRGB(50, 50, 55),
    SliderTrack = Color3.fromRGB(35, 35, 40),
    Button = Color3.fromRGB(30, 30, 35),
    ButtonHover = Color3.fromRGB(45, 45, 52),
    TabActive = Color3.fromRGB(23, 23, 28),
    TabInactive = Color3.fromRGB(11, 11, 14),
    Section = Color3.fromRGB(44, 62, 80),
}

-- 16:9 ratio
local BASE_WIDTH = 680
local BASE_HEIGHT = 382
local SIDEBAR_WIDTH = 140
local CONTENT_WIDTH = BASE_WIDTH - SIDEBAR_WIDTH
local PREVIEW_WIDTH = 200
local PREVIEW_GAP = 12

-- Animation settings
local ANIM_SPEED = 0.3
local ANIM_EASING = Enum.EasingStyle.Quad
local ANIM_DIRECTION = Enum.EasingDirection.Out

-- Main menu container
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, BASE_WIDTH, 0, BASE_HEIGHT)
mainContainer.Position = UDim2.new(0.5, -BASE_WIDTH/2, 0.5, -BASE_HEIGHT/2)
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Draggable = true
mainContainer.Visible = true
mainContainer.ClipsDescendants = false

-- Drop shadow
local shadow = Instance.new("Frame", mainContainer)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0, 12)

-- Main frame
local mainFrame = Instance.new("Frame", mainContainer)
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainBorder = Instance.new("UIStroke", mainFrame)
mainBorder.Color = COLORS.Border
mainBorder.Thickness = 1
mainBorder.Transparency = 0.5

-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(0, BASE_WIDTH, 0, 34)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = COLORS.TitleBar
titleBar.BorderSizePixel = 0

local titleLine = Instance.new("Frame", titleBar)
titleLine.Size = UDim2.new(1, 0, 0, 1)
titleLine.Position = UDim2.new(0, 0, 1, -1)
titleLine.BackgroundColor3 = COLORS.Border
titleLine.BorderSizePixel = 0
titleLine.BackgroundTransparency = 0.3

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "UNDERCOVER SLOTTED"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.TextColor3 = COLORS.Text
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.TextYAlignment = Enum.TextYAlignment.Center
titleText.TextTransparency = 0.7

local accentDot = Instance.new("Frame", titleBar)
accentDot.Size = UDim2.new(0, 6, 0, 6)
accentDot.Position = UDim2.new(0.5, 65, 0.5, -3)
accentDot.BackgroundColor3 = COLORS.Accent
accentDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", accentDot)
dotCorner.CornerRadius = UDim.new(1, 0)

-- Left sidebar
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 0, BASE_HEIGHT - 34)
sidebar.Position = UDim2.new(0, 0, 0, 34)
sidebar.BackgroundColor3 = COLORS.Sidebar
sidebar.BorderSizePixel = 0

local sidebarBorder = Instance.new("Frame", sidebar)
sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
sidebarBorder.Position = UDim2.new(1, -1, 0, 0)
sidebarBorder.BackgroundColor3 = COLORS.Border
sidebarBorder.BorderSizePixel = 0
sidebarBorder.BackgroundTransparency = 0.3

-- Logo area
local logoArea = Instance.new("Frame", sidebar)
logoArea.Size = UDim2.new(1, 0, 0, 44)
logoArea.BackgroundTransparency = 1

local logoText = Instance.new("TextLabel", logoArea)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "UC"
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 20
logoText.TextColor3 = COLORS.Accent
logoText.TextXAlignment = Enum.TextXAlignment.Center
logoText.TextYAlignment = Enum.TextYAlignment.Center

local versionText = Instance.new("TextLabel", logoArea)
versionText.Size = UDim2.new(1, 0, 0, 14)
versionText.Position = UDim2.new(0, 0, 1, -14)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.05"
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 9
versionText.TextColor3 = COLORS.TextMuted
versionText.TextXAlignment = Enum.TextXAlignment.Center

-- Tab buttons
local tabs = {}
local tabData = {
    {name = "Aimbot", icon = "🎯"},
    {name = "Rage", icon = "⚡"},
    {name = "Visuals", icon = "👁"},
    {name = "Settings", icon = "⚙"}
}

local TAB_HEIGHT = 36
local TAB_PADDING = 4
local tabsStartY = 50

for i, data in ipairs(tabData) do
    local tab = Instance.new("TextButton", sidebar)
    tab.Size = UDim2.new(1, -16, 0, TAB_HEIGHT)
    tab.Position = UDim2.new(0, 8, 0, tabsStartY + (i-1) * (TAB_HEIGHT + TAB_PADDING))
    tab.BackgroundColor3 = i == 1 and COLORS.TabActive or COLORS.TabInactive
    tab.BorderSizePixel = 0
    tab.Text = ""
    tab.AutoButtonColor = false
    local tabCorner = Instance.new("UICorner", tab)
    tabCorner.CornerRadius = UDim.new(0, 6)
    
    local tabIndicator = Instance.new("Frame", tab)
    tabIndicator.Size = UDim2.new(0, 3, 0, 16)
    tabIndicator.Position = UDim2.new(0, 6, 0.5, -8)
    tabIndicator.BackgroundColor3 = i == 1 and COLORS.Accent or COLORS.TextMuted
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Name = "Indicator"
    local indicatorCorner = Instance.new("UICorner", tabIndicator)
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    
    local tabIcon = Instance.new("TextLabel", tab)
    tabIcon.Size = UDim2.new(0, 18, 0, 18)
    tabIcon.Position = UDim2.new(0, 14, 0.5, -9)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = data.icon
    tabIcon.Font = Enum.Font.Gotham
    tabIcon.TextSize = 13
    tabIcon.TextColor3 = COLORS.Text
    tabIcon.TextXAlignment = Enum.TextXAlignment.Center
    tabIcon.Name = "Icon"
    
    local tabLabel = Instance.new("TextLabel", tab)
    tabLabel.Size = UDim2.new(0, 60, 1, 0)
    tabLabel.Position = UDim2.new(0, 38, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = data.name
    tabLabel.Font = Enum.Font.Gotham
    tabLabel.TextSize = 11
    tabLabel.TextColor3 = i == 1 and COLORS.Text or COLORS.TextSecondary
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Name = "Label"
    
    tab.MouseEnter:Connect(function()
        if tabs[data.name] ~= tab then return end
        if tab.BackgroundColor3 ~= COLORS.TabActive then
            TweenService:Create(tab, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            }):Play()
        end
    end)
    
    tab.MouseLeave:Connect(function()
        if tabs[data.name] ~= tab then return end
        if tab.BackgroundColor3 ~= COLORS.TabActive then
            TweenService:Create(tab, TweenInfo.new(0.15), {
                BackgroundColor3 = COLORS.TabInactive
            }):Play()
        end
    end)
    
    tabs[data.name] = tab
end

-- ================= PLAYER PROFILE SECTION =================
local profileArea = Instance.new("Frame", sidebar)
profileArea.Size = UDim2.new(1, -16, 0, 52)
profileArea.Position = UDim2.new(0, 8, 1, -60)
profileArea.BackgroundColor3 = COLORS.Card
profileArea.BorderSizePixel = 0
local profileCorner = Instance.new("UICorner", profileArea)
profileCorner.CornerRadius = UDim.new(0, 6)

local profileStroke = Instance.new("UIStroke", profileArea)
profileStroke.Color = COLORS.Border
profileStroke.Thickness = 1
profileStroke.Transparency = 0.3

-- Avatar image
local avatarImage = Instance.new("ImageLabel", profileArea)
avatarImage.Size = UDim2.new(0, 32, 0, 32)
avatarImage.Position = UDim2.new(0, 8, 0.5, -16)
avatarImage.BackgroundColor3 = COLORS.Border
avatarImage.BorderSizePixel = 0
local avatarCorner = Instance.new("UICorner", avatarImage)
avatarCorner.CornerRadius = UDim.new(1, 0)

-- Username label
local usernameLabel = Instance.new("TextLabel", profileArea)
usernameLabel.Size = UDim2.new(1, -52, 0, 16)
usernameLabel.Position = UDim2.new(0, 46, 0, 10)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = LocalPlayer.Name
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 11
usernameLabel.TextColor3 = COLORS.Text
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd

-- Status label
local statusLabel = Instance.new("TextLabel", profileArea)
statusLabel.Size = UDim2.new(1, -52, 0, 14)
statusLabel.Position = UDim2.new(0, 46, 0, 28)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Connected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 9
statusLabel.TextColor3 = COLORS.Success
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local function updateAvatar()
    local userId = LocalPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    avatarImage.Image = content
end

updateAvatar()

LocalPlayer:GetPropertyChangedSignal("Name"):Connect(function()
    usernameLabel.Text = LocalPlayer.Name
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateAvatar()
end)

-- Content area
local contentArea = Instance.new("Frame", mainFrame)
contentArea.Size = UDim2.new(0, CONTENT_WIDTH, 0, BASE_HEIGHT - 34)
contentArea.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 34)
contentArea.BackgroundColor3 = COLORS.Content
contentArea.BorderSizePixel = 0

-- Content header
local contentHeader = Instance.new("Frame", contentArea)
contentHeader.Size = UDim2.new(1, -28, 0, 38)
contentHeader.Position = UDim2.new(0, 14, 0, 8)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(0, 200, 1, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Aimbot"
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextSize = 15
contentTitle.TextColor3 = COLORS.Text
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Name = "Title"

local contentSubtitle = Instance.new("TextLabel", contentHeader)
contentSubtitle.Size = UDim2.new(0, 300, 0, 14)
contentSubtitle.Position = UDim2.new(0, 0, 1, -12)
contentSubtitle.BackgroundTransparency = 1
contentSubtitle.Text = "Configure aimbot settings"
contentSubtitle.Font = Enum.Font.Gotham
contentSubtitle.TextSize = 10
contentSubtitle.TextColor3 = COLORS.TextMuted
contentSubtitle.TextXAlignment = Enum.TextXAlignment.Left
contentSubtitle.Name = "Subtitle"

local contentScroll = Instance.new("ScrollingFrame", contentArea)
contentScroll.Size = UDim2.new(1, -28, 1, -54)
contentScroll.Position = UDim2.new(0, 14, 0, 46)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 3
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.ScrollBarImageColor3 = COLORS.SliderTrack
contentScroll.ScrollBarImageTransparency = 0.3

local contentLayout = Instance.new("UIListLayout", contentScroll)
contentLayout.Padding = UDim.new(0, 5)

-- ================= ATTACHED ESP PREVIEW =================
local previewWindow = Instance.new("Frame", gui)
previewWindow.Size = UDim2.new(0, PREVIEW_WIDTH, 0, BASE_HEIGHT)
previewWindow.Position = UDim2.new(0.5, BASE_WIDTH/2 + PREVIEW_GAP, 0.5, -BASE_HEIGHT/2)
previewWindow.BackgroundColor3 = COLORS.Background
previewWindow.BorderSizePixel = 0
previewWindow.Visible = true
previewWindow.Active = false
previewWindow.Draggable = false
previewWindow.ClipsDescendants = true
local previewCorner = Instance.new("UICorner", previewWindow)
previewCorner.CornerRadius = UDim.new(0, 10)

local previewBorder = Instance.new("UIStroke", previewWindow)
previewBorder.Color = COLORS.Border
previewBorder.Thickness = 1
previewBorder.Transparency = 0.5

local previewShadow = Instance.new("Frame", previewWindow)
previewShadow.Size = UDim2.new(1, 16, 1, 16)
previewShadow.Position = UDim2.new(0, -8, 0, -8)
previewShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
previewShadow.BackgroundTransparency = 0.5
previewShadow.BorderSizePixel = 0
previewShadow.ZIndex = 0
local previewShadowCorner = Instance.new("UICorner", previewShadow)
previewShadowCorner.CornerRadius = UDim.new(0, 10)

local previewTitleBar = Instance.new("Frame", previewWindow)
previewTitleBar.Size = UDim2.new(1, 0, 0, 34)
previewTitleBar.BackgroundColor3 = COLORS.TitleBar
previewTitleBar.BorderSizePixel = 0

local previewTitleLine = Instance.new("Frame", previewTitleBar)
previewTitleLine.Size = UDim2.new(1, 0, 0, 1)
previewTitleLine.Position = UDim2.new(0, 0, 1, -1)
previewTitleLine.BackgroundColor3 = COLORS.Border
previewTitleLine.BorderSizePixel = 0
previewTitleLine.BackgroundTransparency = 0.3

local previewIcon = Instance.new("TextLabel", previewTitleBar)
previewIcon.Size = UDim2.new(0, 18, 0, 18)
previewIcon.Position = UDim2.new(0, 10, 0.5, -9)
previewIcon.BackgroundTransparency = 1
previewIcon.Text = "👁"
previewIcon.Font = Enum.Font.Gotham
previewIcon.TextSize = 13
previewIcon.TextColor3 = COLORS.Accent

local previewTitle = Instance.new("TextLabel", previewTitleBar)
previewTitle.Size = UDim2.new(1, -40, 1, 0)
previewTitle.Position = UDim2.new(0, 34, 0, 0)
previewTitle.BackgroundTransparency = 1
previewTitle.Text = "ESP Preview"
previewTitle.Font = Enum.Font.GothamBold
previewTitle.TextSize = 12
previewTitle.TextColor3 = COLORS.Text
previewTitle.TextXAlignment = Enum.TextXAlignment.Left

local previewContent = Instance.new("Frame", previewWindow)
previewContent.Size = UDim2.new(1, -16, 1, -50)
previewContent.Position = UDim2.new(0, 8, 0, 42)
previewContent.BackgroundColor3 = COLORS.Content
previewContent.BorderSizePixel = 0
local previewContentCorner = Instance.new("UICorner", previewContent)
previewContentCorner.CornerRadius = UDim.new(0, 6)

local previewContentBorder = Instance.new("UIStroke", previewContent)
previewContentBorder.Color = COLORS.Border
previewContentBorder.Thickness = 1
previewContentBorder.Transparency = 0.3

-- ESP Drawing objects for preview
local pBox = Drawing.new("Square")
local pCorneredBoxLines = {}
for i = 1, 8 do
    pCorneredBoxLines[i] = Drawing.new("Line")
    pCorneredBoxLines[i].Visible = false
end
local pTracer = Drawing.new("Line")
local pHealth = Drawing.new("Line")
local pName = Drawing.new("Text")
local pSkeleton = {}
local pHighlight = Drawing.new("Square")
local pHeadCircle = Drawing.new("Circle")

local skeletonPreviewPoints = {
    {Vector2.new(0, -25), Vector2.new(0, 0)},
    {Vector2.new(0, 0), Vector2.new(18, 4)},
    {Vector2.new(0, 0), Vector2.new(-18, 4)},
    {Vector2.new(18, 4), Vector2.new(26, 25)},
    {Vector2.new(-18, 4), Vector2.new(-26, 25)},
    {Vector2.new(0, 0), Vector2.new(0, 35)},
    {Vector2.new(0, 35), Vector2.new(12, 60)},
    {Vector2.new(0, 35), Vector2.new(-12, 60)}
}

for i = 1, #skeletonPreviewPoints do
    pSkeleton[i] = Drawing.new("Line")
    pSkeleton[i].Thickness = 2
    pSkeleton[i].Visible = false
end

pBox.Thickness = 2
pHealth.Thickness = 3
pTracer.Thickness = 2
pName.Size = 14
pName.Center = true
pName.Font = 2
pName.Text = "Preview"
pName.Outline = true
pName.OutlineColor = Color3.fromRGB(0, 0, 0)

pHighlight.Thickness = 2
pHighlight.Filled = true
pHighlight.Visible = false

pHeadCircle.Thickness = 2
pHeadCircle.Filled = false
pHeadCircle.NumSides = 100
pHeadCircle.Visible = false

for _, d in ipairs({pBox, pTracer, pHealth, pName, pHighlight}) do
    d.Visible = false
end

local function updateCorneredBox(boxPos, boxSize, color, thickness, transparency, cornerLength)
    local tl = boxPos
    local tr = Vector2.new(boxPos.X + boxSize.X, boxPos.Y)
    local bl = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y)
    local br = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y)
    local cl = math.min(cornerLength or 8, boxSize.X / 2, boxSize.Y / 2)
    
    pCorneredBoxLines[1].From = tl
    pCorneredBoxLines[1].To = Vector2.new(tl.X + cl, tl.Y)
    pCorneredBoxLines[2].From = tl
    pCorneredBoxLines[2].To = Vector2.new(tl.X, tl.Y + cl)
    
    pCorneredBoxLines[3].From = Vector2.new(tr.X - cl, tr.Y)
    pCorneredBoxLines[3].To = tr
    pCorneredBoxLines[4].From = tr
    pCorneredBoxLines[4].To = Vector2.new(tr.X, tr.Y + cl)
    
    pCorneredBoxLines[5].From = bl
    pCorneredBoxLines[5].To = Vector2.new(bl.X + cl, bl.Y)
    pCorneredBoxLines[6].From = bl
    pCorneredBoxLines[6].To = Vector2.new(bl.X, bl.Y - cl)
    
    pCorneredBoxLines[7].From = Vector2.new(br.X - cl, br.Y)
    pCorneredBoxLines[7].To = br
    pCorneredBoxLines[8].From = br
    pCorneredBoxLines[8].To = Vector2.new(br.X, br.Y - cl)
    
    for i = 1, 8 do
        pCorneredBoxLines[i].Color = color
        pCorneredBoxLines[i].Thickness = thickness
        pCorneredBoxLines[i].Transparency = transparency
        pCorneredBoxLines[i].Visible = true
    end
end

-- ================= ANIMATION FUNCTIONS =================
local menuVisible = true
local previewVisible = true
local currentMenuTween = nil
local currentPreviewTween = nil

local function updatePreviewPosition()
    if previewVisible and mainContainer.Visible then
        previewWindow.Position = UDim2.new(
            mainContainer.Position.X.Scale,
            mainContainer.Position.X.Offset + BASE_WIDTH + PREVIEW_GAP,
            mainContainer.Position.Y.Scale,
            mainContainer.Position.Y.Offset
        )
    end
end

mainContainer:GetPropertyChangedSignal("Position"):Connect(updatePreviewPosition)

local function ToggleMenu(show)
    if currentMenuTween then
        currentMenuTween:Cancel()
    end
    
    menuVisible = show
    
    if show then
        mainContainer.Visible = true
        currentMenuTween = TweenService:Create(mainContainer, TweenInfo.new(ANIM_SPEED, ANIM_EASING, ANIM_DIRECTION), {
            Size = UDim2.new(0, BASE_WIDTH, 0, BASE_HEIGHT),
            Position = UDim2.new(0.5, -BASE_WIDTH/2, 0.5, -BASE_HEIGHT/2),
            BackgroundTransparency = 1,
        })
        currentMenuTween:Play()
        currentMenuTween.Completed:Connect(function()
            updatePreviewPosition()
        end)
    else
        currentMenuTween = TweenService:Create(mainContainer, TweenInfo.new(ANIM_SPEED, ANIM_EASING, ANIM_DIRECTION), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
        })
        currentMenuTween:Play()
        currentMenuTween.Completed:Connect(function()
            mainContainer.Visible = false
        end)
    end
end

local function TogglePreview(show)
    if currentPreviewTween then
        currentPreviewTween:Cancel()
    end
    
    previewVisible = show
    
    if show then
        previewWindow.Visible = true
        updatePreviewPosition()
        currentPreviewTween = TweenService:Create(previewWindow, TweenInfo.new(ANIM_SPEED * 1.2, ANIM_EASING, ANIM_DIRECTION), {
            Size = UDim2.new(0, PREVIEW_WIDTH, 0, BASE_HEIGHT),
            Position = UDim2.new(
                mainContainer.Position.X.Scale,
                mainContainer.Position.X.Offset + BASE_WIDTH + PREVIEW_GAP,
                mainContainer.Position.Y.Scale,
                mainContainer.Position.Y.Offset
            ),
            BackgroundTransparency = 0,
        })
        currentPreviewTween:Play()
    else
        currentPreviewTween = TweenService:Create(previewWindow, TweenInfo.new(ANIM_SPEED, ANIM_EASING, ANIM_DIRECTION), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, BASE_WIDTH/2 + PREVIEW_GAP + PREVIEW_WIDTH/2, 0.5, 0),
            BackgroundTransparency = 1,
        })
        currentPreviewTween:Play()
        currentPreviewTween.Completed:Connect(function()
            previewWindow.Visible = false
        end)
    end
end

task.spawn(function()
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    previewWindow.Size = UDim2.new(0, 0, 0, 0)
    previewWindow.Position = UDim2.new(0.5, BASE_WIDTH/2 + PREVIEW_GAP + PREVIEW_WIDTH/2, 0.5, 0)
    task.wait(0.1)
    ToggleMenu(true)
    TogglePreview(true)
end)

-- ================= UI COMPONENTS (Refined) =================
local function addSection(text)
    local section = Instance.new("Frame", contentScroll)
    section.Size = UDim2.new(1, 0, 0, 24)
    section.BackgroundTransparency = 1
    
    local accent = Instance.new("Frame", section)
    accent.Size = UDim2.new(0, 2, 0, 14)
    accent.Position = UDim2.new(0, 0, 0.5, -7)
    accent.BackgroundColor3 = COLORS.Accent
    accent.BorderSizePixel = 0
    local accentCorner = Instance.new("UICorner", accent)
    accentCorner.CornerRadius = UDim.new(1, 0)
    
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = COLORS.TextSecondary
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

local function addToggle(text, default, callback)
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 34)
    card.BackgroundColor3 = COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 5)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = COLORS.BorderLight
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.3
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 300, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleFrame = Instance.new("Frame", card)
    toggleFrame.Size = UDim2.new(0, 38, 0, 20)
    toggleFrame.Position = UDim2.new(1, -50, 0.5, -10)
    toggleFrame.BackgroundColor3 = default and COLORS.Success or COLORS.SliderTrack
    toggleFrame.BorderSizePixel = 0
    local toggleCorner = Instance.new("UICorner", toggleFrame)
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    local toggleKnob = Instance.new("Frame", toggleFrame)
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Position = UDim2.new(0, default and 20 or 2, 0.5, -8)
    toggleKnob.BackgroundColor3 = COLORS.Text
    toggleKnob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner", toggleKnob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local state = default
    
    local function updateToggle()
        TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = state and COLORS.Success or COLORS.SliderTrack
        }):Play()
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {
            Position = UDim2.new(0, state and 20 or 2, 0.5, -8)
        }):Play()
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
            callback(state)
        end
    end)
    
    toggleFrame.MouseEnter:Connect(function()
        TweenService:Create(toggleFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(45, 45, 52)
        }):Play()
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        TweenService:Create(toggleFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = state and COLORS.Success or COLORS.SliderTrack
        }):Play()
    end)
    
    return card
end

local function addSlider(text, min, max, default, callback, suffix)
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 48)
    card.BackgroundColor3 = COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 5)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = COLORS.BorderLight
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.3
    
    local labelRow = Instance.new("Frame", card)
    labelRow.Size = UDim2.new(1, -24, 0, 18)
    labelRow.Position = UDim2.new(0, 12, 0, 4)
    labelRow.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", labelRow)
    label.Size = UDim2.new(0, 250, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel", labelRow)
    valueLabel.Size = UDim2.new(0, 80, 1, 0)
    valueLabel.Position = UDim2.new(1, -80, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default) .. (suffix or "")
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextColor3 = COLORS.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderTrack = Instance.new("Frame", card)
    sliderTrack.Size = UDim2.new(1, -24, 0, 4)
    sliderTrack.Position = UDim2.new(0, 12, 0, 28)
    sliderTrack.BackgroundColor3 = COLORS.SliderTrack
    sliderTrack.BorderSizePixel = 0
    local trackCorner = Instance.new("UICorner", sliderTrack)
    trackCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderTrack)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.Accent
    sliderFill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderKnob = Instance.new("Frame", sliderTrack)
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    sliderKnob.BackgroundColor3 = COLORS.Text
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Visible = false
    local knobCorner = Instance.new("UICorner", sliderKnob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSlider(value)
        local clamped = math.clamp(value, min, max)
        local percentage = (clamped - min) / (max - min)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, -6, 0.5, -6)
        valueLabel.Text = tostring(math.floor(clamped)) .. (suffix or "")
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            sliderKnob.Visible = true
            local mousePos = UIS:GetMouseLocation()
            local relativeX = math.clamp((mousePos.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = min + (relativeX * (max - min))
            updateSlider(value)
            callback(math.floor(value))
        end
    end)
    
    sliderTrack.MouseEnter:Connect(function()
        sliderKnob.Visible = true
    end)
    
    sliderTrack.MouseLeave:Connect(function()
        if not dragging then sliderKnob.Visible = false end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            sliderKnob.Visible = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local relativeX = math.clamp((mousePos.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = min + (relativeX * (max - min))
            updateSlider(value)
            callback(math.floor(value))
        end
    end)
    
    return card
end

local function addDropdown(text, options, defaultIndex, callback)
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 34)
    card.BackgroundColor3 = COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 5)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = COLORS.BorderLight
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.3
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton", card)
    dropdown.Size = UDim2.new(0, 130, 0, 26)
    dropdown.Position = UDim2.new(1, -142, 0.5, -13)
    dropdown.BackgroundColor3 = COLORS.Button
    dropdown.BorderSizePixel = 0
    dropdown.Text = "  " .. (options[defaultIndex] or options[1])
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 11
    dropdown.TextColor3 = COLORS.Text
    dropdown.AutoButtonColor = false
    dropdown.TextXAlignment = Enum.TextXAlignment.Left
    local dropdownCorner = Instance.new("UICorner", dropdown)
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    
    local chevron = Instance.new("TextLabel", dropdown)
    chevron.Size = UDim2.new(0, 14, 0, 14)
    chevron.Position = UDim2.new(1, -18, 0.5, -7)
    chevron.BackgroundTransparency = 1
    chevron.Text = "▾"
    chevron.Font = Enum.Font.Gotham
    chevron.TextSize = 10
    chevron.TextColor3 = COLORS.TextMuted
    
    local currentIndex = defaultIndex or 1
    
    dropdown.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        dropdown.Text = "  " .. options[currentIndex]
        callback(options[currentIndex], currentIndex)
    end)
    
    dropdown.MouseEnter:Connect(function()
        TweenService:Create(dropdown, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.ButtonHover
        }):Play()
    end)
    
    dropdown.MouseLeave:Connect(function()
        TweenService:Create(dropdown, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.Button
        }):Play()
    end)
    
    return card
end

local function addKeybind(text, defaultKey, callback)
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 34)
    card.BackgroundColor3 = COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 5)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = COLORS.BorderLight
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.3
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 250, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local keyBtn = Instance.new("TextButton", card)
    keyBtn.Size = UDim2.new(0, 70, 0, 24)
    keyBtn.Position = UDim2.new(1, -82, 0.5, -12)
    keyBtn.BackgroundColor3 = COLORS.Button
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = typeof(defaultKey) == "EnumItem" and defaultKey.Name or "RMB"
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 10
    keyBtn.TextColor3 = COLORS.Accent
    keyBtn.AutoButtonColor = false
    local keyCorner = Instance.new("UICorner", keyBtn)
    keyCorner.CornerRadius = UDim.new(0, 4)
    
    local listening = false
    
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = COLORS.Danger
        TweenService:Create(keyBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        }):Play()
    end)
    
    keyBtn.MouseEnter:Connect(function()
        if not listening then
            TweenService:Create(keyBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = COLORS.ButtonHover
            }):Play()
        end
    end)
    
    keyBtn.MouseLeave:Connect(function()
        if not listening then
            TweenService:Create(keyBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = COLORS.Button
            }):Play()
        end
    end)
    
    UIS.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = COLORS.Accent
            TweenService:Create(keyBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = COLORS.Button
            }):Play()
            listening = false
            callback(input.KeyCode)
        elseif listening and input.UserInputType == Enum.UserInputType.MouseButton2 then
            keyBtn.Text = "RMB"
            keyBtn.TextColor3 = COLORS.Accent
            TweenService:Create(keyBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = COLORS.Button
            }):Play()
            listening = false
            callback(Enum.UserInputType.MouseButton2)
        end
    end)
    
    return card
end

-- Clear content
local currentElements = {}
local function clearContent()
    for _, element in ipairs(currentElements) do
        element:Destroy()
    end
    currentElements = {}
end

local function addElement(element)
    table.insert(currentElements, element)
end

-- Tab switching
local currentTab = "Aimbot"
local function switchTab(tabName)
    if currentTab == tabName then return end
    currentTab = tabName
    
    clearContent()
    contentScroll.CanvasPosition = Vector2.new(0, 0)
    
    local subtitles = {
        Aimbot = "Configure aimbot, silent aim & triggerbot",
        Rage = "Rage settings (coming soon)",
        Visuals = "Customize ESP and visual settings",
        Settings = "Application preferences & about"
    }
    contentTitle.Text = tabName
    contentSubtitle.Text = subtitles[tabName] or ""
    
    for name, tab in pairs(tabs) do
        local isActive = (name == tabName)
        local indicator = tab:FindFirstChild("Indicator")
        local label = tab:FindFirstChild("Label")
        
        TweenService:Create(tab, TweenInfo.new(0.2), {
            BackgroundColor3 = isActive and COLORS.TabActive or COLORS.TabInactive
        }):Play()
        
        if indicator then
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                BackgroundColor3 = isActive and COLORS.Accent or COLORS.TextMuted
            }):Play()
        end
        
        if label then
            TweenService:Create(label, TweenInfo.new(0.2), {
                TextColor3 = isActive and COLORS.Text or COLORS.TextSecondary
            }):Play()
        end
    end
    
    if tabName == "Visuals" then
        TogglePreview(true)
    else
        TogglePreview(false)
    end
    
    if tabName == "Aimbot" then
        addElement(addSection("Aimbot Settings"))
        addElement(addToggle("Enable Aimbot", Configuration.Aimbot, function(v) Configuration.Aimbot = v end))
        addElement(addToggle("One Press Mode", Configuration.OnePressAimingMode, function(v) Configuration.OnePressAimingMode = v end))
        addElement(addKeybind("Aim Key", Configuration.AimKey, function(v) Configuration.AimKey = v end))
        
        local aimModes = {"Mouse", "Camera"}
        if not HAS_MOUSEMOVEREL then aimModes = {"Camera"} end
        addElement(addDropdown("Aim Mode", aimModes, 1, function(opt) Configuration.AimMode = opt end))
        addElement(addDropdown("Aim Part", Configuration.AimPartDropdownValues, 1, function(opt) Configuration.AimPart = opt end))
        addElement(addSlider("FOV Radius", 10, 500, Configuration.FoVRadius, function(v) Configuration.FoVRadius = v end))
        addElement(addToggle("Show FOV Circle", Configuration.FoVCheck, function(v) Configuration.FoVCheck = v; ShowingFoV = v end))
        addElement(addToggle("Mouse Smoothing", Configuration.UseSensitivity, function(v) Configuration.UseSensitivity = v end))
        addElement(addSlider("Smoothness", 10, 100, Configuration.Sensitivity, function(v) Configuration.Sensitivity = v end, "%"))
        
        addElement(addSection("Silent Aim"))
        addElement(addToggle("Enable Silent Aim", Configuration.SilentAim, function(v) Configuration.SilentAim = v end))
        addElement(addToggle("Always On (No Key)", Configuration.AlwaysOnSilent, function(v) Configuration.AlwaysOnSilent = v end))
        addElement(addKeybind("Silent Aim Key", Configuration.SilentAimKey, function(v) Configuration.SilentAimKey = v end))
        addElement(addToggle("Show Silent FOV", Configuration.ShowSilentFOV, function(v) Configuration.ShowSilentFOV = v end))
        addElement(addSlider("Silent FOV Radius", 10, 500, Configuration.SilentFOVRadius, function(v) Configuration.SilentFOVRadius = v end))
        addElement(addToggle("Use Prediction", Configuration.SilentPrediction, function(v) Configuration.SilentPrediction = v end))
        addElement(addSlider("Prediction X", 0, 2, Configuration.SilentPredictionX, function(v) Configuration.SilentPredictionX = v end))
        addElement(addSlider("Prediction Y", 0, 2, Configuration.SilentPredictionY, function(v) Configuration.SilentPredictionY = v end))
        addElement(addToggle("Target Visualizer", Configuration.SilentVisualizer, function(v) Configuration.SilentVisualizer = v end))
        addElement(addDropdown("Target Bone", Configuration.SilentBoneDropdownValues, 1, function(opt) Configuration.SilentTargetBone = opt end))
        
        addElement(addSection("TriggerBot"))
        if HAS_MOUSE1CLICK then
            addElement(addToggle("Enable TriggerBot", Configuration.TriggerBot, function(v) Configuration.TriggerBot = v end))
            addElement(addToggle("One Press Mode", Configuration.OnePressTriggeringMode, function(v) Configuration.OnePressTriggeringMode = v end))
            addElement(addToggle("Smart Trigger", Configuration.SmartTriggerBot, function(v) Configuration.SmartTriggerBot = v end))
            addElement(addKeybind("Trigger Key", Configuration.TriggerKey, function(v) Configuration.TriggerKey = v end))
            addElement(addSlider("Trigger Chance", 1, 100, Configuration.TriggerBotChance, function(v) Configuration.TriggerBotChance = v end, "%"))
        else
            local noSupport = Instance.new("Frame", contentScroll)
            noSupport.Size = UDim2.new(1, 0, 0, 28)
            noSupport.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
            noSupport.BorderSizePixel = 0
            local noCorner = Instance.new("UICorner", noSupport)
            noCorner.CornerRadius = UDim.new(0, 4)
            local noText = Instance.new("TextLabel", noSupport)
            noText.Size = UDim2.new(1, -10, 1, 0)
            noText.Position = UDim2.new(0, 5, 0, 0)
            noText.BackgroundTransparency = 1
            noText.Text = "⚠ TriggerBot not supported on this executor"
            noText.Font = Enum.Font.Gotham
            noText.TextSize = 10
            noText.TextColor3 = COLORS.Danger
            addElement(noSupport)
        end
        
        addElement(addSection("Target Checks"))
        addElement(addToggle("Alive Check", Configuration.AliveCheck, function(v) Configuration.AliveCheck = v end))
        addElement(addToggle("Team Check", Configuration.TeamCheck, function(v) Configuration.TeamCheck = v end))
        addElement(addToggle("Wall Check", Configuration.WallCheck, function(v) Configuration.WallCheck = v end))
        addElement(addToggle("Friend Check", Configuration.FriendCheck, function(v) Configuration.FriendCheck = v end))
        addElement(addToggle("Off After Kill", Configuration.OffAimbotAfterKill, function(v) Configuration.OffAimbotAfterKill = v end))
        
    elseif tabName == "Rage" then
        local placeholder = Instance.new("Frame", contentScroll)
        placeholder.Size = UDim2.new(1, 0, 0, 100)
        placeholder.BackgroundColor3 = COLORS.Card
        placeholder.BorderSizePixel = 0
        local placeholderCorner = Instance.new("UICorner", placeholder)
        placeholderCorner.CornerRadius = UDim.new(0, 5)
        addElement(placeholder)
        
        local comingSoon = Instance.new("TextLabel", placeholder)
        comingSoon.Size = UDim2.new(1, 0, 1, 0)
        comingSoon.BackgroundTransparency = 1
        comingSoon.Text = "🔥 RAGE MODE\nComing Soon..."
        comingSoon.Font = Enum.Font.GothamBold
        comingSoon.TextSize = 18
        comingSoon.TextColor3 = COLORS.Accent
        comingSoon.TextXAlignment = Enum.TextXAlignment.Center
        comingSoon.TextYAlignment = Enum.TextYAlignment.Center
        
    elseif tabName == "Visuals" then
        addElement(addSection("ESP Settings"))
        addElement(addToggle("Box ESP", Configuration.ESPBox, function(v) 
            Configuration.ESPBox = v
            if v then Configuration.CorneredBox = false end
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Cornered Box", Configuration.CorneredBox, function(v) 
            Configuration.CorneredBox = v
            if v then Configuration.ESPBox = false end
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addSlider("Corner Length", 2, 20, Configuration.CornerLength, function(v) Configuration.CornerLength = v end))
        addElement(addToggle("Tracer ESP", Configuration.TracerESP, function(v) 
            Configuration.TracerESP = v
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Health ESP", Configuration.HealthESP, function(v) 
            Configuration.HealthESP = v
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Name ESP", Configuration.NameESP, function(v) 
            Configuration.NameESP = v
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Skeleton ESP", Configuration.SkeletonESP, function(v) 
            Configuration.SkeletonESP = v
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Highlight ESP", Configuration.HighlightESP, function(v) 
            Configuration.HighlightESP = v
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Head Circle", Configuration.HeadCircle, function(v) 
            Configuration.HeadCircle = v
            ShowingESP = Configuration.ESPBox or Configuration.CorneredBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP or Configuration.SkeletonESP or Configuration.HighlightESP or Configuration.HeadCircle
        end))
        addElement(addToggle("Rainbow ESP", Configuration.RainbowVisuals, function(v) Configuration.RainbowVisuals = v end))
        addElement(addSlider("Rainbow Speed", 1, 10, Configuration.RainbowDelay, function(v) Configuration.RainbowDelay = v end))
        
    elseif tabName == "Settings" then
        addElement(addSection("UI Settings"))
        addElement(addKeybind("Toggle UI Key", Enum.KeyCode.RightShift, function(v) Configuration.ToggleKey = v end))
        
        addElement(addSection("About"))
        local aboutCard = Instance.new("Frame", contentScroll)
        aboutCard.Size = UDim2.new(1, 0, 0, 56)
        aboutCard.BackgroundColor3 = COLORS.Card
        aboutCard.BorderSizePixel = 0
        local aboutCorner = Instance.new("UICorner", aboutCard)
        aboutCorner.CornerRadius = UDim.new(0, 5)
        addElement(aboutCard)
        
        local aboutTitle = Instance.new("TextLabel", aboutCard)
        aboutTitle.Size = UDim2.new(1, -20, 0, 22)
        aboutTitle.Position = UDim2.new(0, 10, 0, 10)
        aboutTitle.BackgroundTransparency = 1
        aboutTitle.Text = "Undercover Slotted"
        aboutTitle.Font = Enum.Font.GothamBold
        aboutTitle.TextSize = 14
        aboutTitle.TextColor3 = COLORS.Text
        
        local aboutInfo = Instance.new("TextLabel", aboutCard)
        aboutInfo.Size = UDim2.new(1, -20, 0, 16)
        aboutInfo.Position = UDim2.new(0, 10, 0, 34)
        aboutInfo.BackgroundTransparency = 1
        aboutInfo.Text = "Build beta0212  •  Made by Grandma"
        aboutInfo.Font = Enum.Font.Gotham
        aboutInfo.TextSize = 10
        aboutInfo.TextColor3 = COLORS.TextMuted
    end
    
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end

for name, tab in pairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Aimbot")

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- ================= FIXED ISREADY FUNCTION =================
local function IsReady(TargetChar)
    if not TargetChar or not TargetChar:IsA("Model") then return false end    
    local Humanoid = TargetChar:FindFirstChildWhichIsA("Humanoid")
    if not Humanoid then return false end
    if Humanoid.Health <= 0 then return false end
    
    local TargetPart = TargetChar:FindFirstChild(Configuration.AimPart)
    if not TargetPart or not TargetPart:IsA("BasePart") then 
        TargetPart = TargetChar:FindFirstChild("Head") or TargetChar:FindFirstChild("HumanoidRootPart")
        if not TargetPart then return false end
    end
    
    if not LocalPlayer.Character then return false end
    local NativePart = LocalPlayer.Character:FindFirstChild("Head") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not NativePart or not NativePart:IsA("BasePart") then return false end
    
    local _Player = Players:GetPlayerFromCharacter(TargetChar)
    if not _Player or _Player == LocalPlayer then return false end
    
    if Configuration.TeamCheck and _Player.TeamColor == LocalPlayer.TeamColor then return false end
    if Configuration.FriendCheck and _Player:IsFriendsWith(LocalPlayer.UserId) then return false end
    
    if Configuration.WallCheck then
        local rayDirection = (TargetPart.Position - NativePart.Position)
        local distance = rayDirection.Magnitude
        if distance > 0 then
            rayDirection = rayDirection.Unit * distance
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
            raycastParams.IgnoreWater = not Configuration.WaterCheck
            local raycastResult = workspace:Raycast(NativePart.Position, rayDirection, raycastParams)
            if raycastResult and raycastResult.Instance then
                local hitPlayer = Players:GetPlayerFromCharacter(raycastResult.Instance:FindFirstAncestorOfClass("Model"))
                if hitPlayer and hitPlayer ~= _Player then return false end
            end
        end
    end
    
    local targetPosition = TargetPart.Position
    local viewportPosition, onScreen = Camera:WorldToViewportPoint(targetPosition)
    if not onScreen then return false end
    
    return true, _Player, TargetChar, viewportPosition, targetPosition, (targetPosition - NativePart.Position).Magnitude
end

local function GetTargetBone(character, boneName)
    if not character then return nil end
    return character:FindFirstChild(boneName) or character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
end

local function CalculatePredictedPosition(targetPart, character)
    if not targetPart or not character then return targetPart.Position end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoid and rootPart and Configuration.SilentPrediction then
        local velocity = rootPart.Velocity
        return targetPart.Position + Vector3.new(
            velocity.X * (Configuration.SilentPredictionX or 0) * 0.1,
            velocity.Y * (Configuration.SilentPredictionY or 0) * 0.1,
            velocity.Z * (Configuration.SilentPredictionX or 0) * 0.1
        )
    end
    return targetPart.Position
end

local function IsValidSilentTarget(player)
    if not player or player == LocalPlayer then return false end
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if Configuration.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then return false end
    if Configuration.FriendCheck and player:IsFriendsWith(LocalPlayer.UserId) then return false end
    return true
end

-- NEW: Function to draw cornered box ESP
local function DrawCorneredBox(boxPos, boxSize, color, thickness, transparency, cornerLength)
    local tl = boxPos
    local tr = Vector2.new(boxPos.X + boxSize.X, boxPos.Y)
    local bl = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y)
    local br = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y)
    local cl = math.min(cornerLength or 8, boxSize.X / 2, boxSize.Y / 2)
    
    local lines = {}
    
    local line1 = Drawing.new("Line")
    line1.From = tl
    line1.To = Vector2.new(tl.X + cl, tl.Y)
    table.insert(lines, line1)
    
    local line2 = Drawing.new("Line")
    line2.From = tl
    line2.To = Vector2.new(tl.X, tl.Y + cl)
    table.insert(lines, line2)
    
    local line3 = Drawing.new("Line")
    line3.From = Vector2.new(tr.X - cl, tr.Y)
    line3.To = tr
    table.insert(lines, line3)
    
    local line4 = Drawing.new("Line")
    line4.From = tr
    line4.To = Vector2.new(tr.X, tr.Y + cl)
    table.insert(lines, line4)
    
    local line5 = Drawing.new("Line")
    line5.From = bl
    line5.To = Vector2.new(bl.X + cl, bl.Y)
    table.insert(lines, line5)
    
    local line6 = Drawing.new("Line")
    line6.From = bl
    line6.To = Vector2.new(bl.X, bl.Y - cl)
    table.insert(lines, line6)
    
    local line7 = Drawing.new("Line")
    line7.From = Vector2.new(br.X - cl, br.Y)
    line7.To = br
    table.insert(lines, line7)
    
    local line8 = Drawing.new("Line")
    line8.From = br
    line8.To = Vector2.new(br.X, br.Y - cl)
    table.insert(lines, line8)
    
    for _, line in ipairs(lines) do
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency
        line.Visible = true
    end
    
    return lines
end

local function DrawSkeleton(character, color, thickness, transparency)
    local skeleton = {}
    local parts = {
        Head = character:FindFirstChild("Head"),
        UpperTorso = character:FindFirstChild("UpperTorso"),
        LowerTorso = character:FindFirstChild("LowerTorso"),
        LeftUpperArm = character:FindFirstChild("LeftUpperArm"),
        LeftLowerArm = character:FindFirstChild("LeftLowerArm"),
        LeftHand = character:FindFirstChild("LeftHand"),
        RightUpperArm = character:FindFirstChild("RightUpperArm"),
        RightLowerArm = character:FindFirstChild("RightLowerArm"),
        RightHand = character:FindFirstChild("RightHand"),
        LeftUpperLeg = character:FindFirstChild("LeftUpperLeg"),
        LeftLowerLeg = character:FindFirstChild("LeftLowerLeg"),
        LeftFoot = character:FindFirstChild("LeftFoot"),
        RightUpperLeg = character:FindFirstChild("RightUpperLeg"),
        RightLowerLeg = character:FindFirstChild("RightLowerLeg"),
        RightFoot = character:FindFirstChild("RightFoot")
    }
    if not (parts.Head and parts.UpperTorso and parts.LowerTorso) then return {} end
    
    local connections = {
        {parts.Head, parts.UpperTorso}, {parts.UpperTorso, parts.LowerTorso},
        {parts.UpperTorso, parts.LeftUpperArm}, {parts.LeftUpperArm, parts.LeftLowerArm}, {parts.LeftLowerArm, parts.LeftHand},
        {parts.UpperTorso, parts.RightUpperArm}, {parts.RightUpperArm, parts.RightLowerArm}, {parts.RightLowerArm, parts.RightHand},
        {parts.LowerTorso, parts.LeftUpperLeg}, {parts.LeftUpperLeg, parts.LeftLowerLeg}, {parts.LeftLowerLeg, parts.LeftFoot},
        {parts.LowerTorso, parts.RightUpperLeg}, {parts.RightUpperLeg, parts.RightLowerLeg}, {parts.RightLowerLeg, parts.RightFoot}
    }
    
    for _, connection in ipairs(connections) do
        local part1, part2 = connection[1], connection[2]
        if part1 and part2 then
            local pos1, on1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, on2 = Camera:WorldToViewportPoint(part2.Position)
            if on1 and on2 then
                local line = Drawing.new("Line")
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Color = color
                line.Thickness = thickness
                line.Transparency = transparency
                line.Visible = true
                table.insert(skeleton, line)
            end
        end
    end
    return skeleton
end

local function CreateHighlight(character, color, transparency)
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = transparency
    highlight.OutlineTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    return highlight
end

-- ESP Drawing
local ESP = {}
local SkeletonLines = {}
local Highlights = {}
local HeadCircles = {}
local CorneredBoxLines = {}

local function newESP(plr)
    if plr == LocalPlayer then return end
    ESP[plr] = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Health = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    SkeletonLines[plr] = {}
    Highlights[plr] = nil
    HeadCircles[plr] = Drawing.new("Circle")
    HeadCircles[plr].Thickness = 2
    HeadCircles[plr].Filled = false
    HeadCircles[plr].NumSides = 100
    HeadCircles[plr].Visible = false
    CorneredBoxLines[plr] = {}
    
    for _, d in pairs(ESP[plr]) do d.Visible = false end
    ESP[plr].Name.Size = 16
    ESP[plr].Name.Center = true
    ESP[plr].Name.Font = 2
    ESP[plr].Name.Outline = true
    ESP[plr].Name.OutlineColor = Color3.fromRGB(0, 0, 0)
end

for _, p in ipairs(Players:GetPlayers()) do newESP(p) end

Players.PlayerAdded:Connect(newESP)
Players.PlayerRemoving:Connect(function(p)
    if ESP[p] then for _, d in pairs(ESP[p]) do d:Remove() end; ESP[p] = nil end
    if SkeletonLines[p] then for _, l in ipairs(SkeletonLines[p]) do l:Remove() end; SkeletonLines[p] = nil end
    if Highlights[p] and Highlights[p].Parent then Highlights[p]:Destroy(); Highlights[p] = nil end
    if HeadCircles[p] then HeadCircles[p]:Remove(); HeadCircles[p] = nil end
    if CorneredBoxLines[p] then 
        for _, l in ipairs(CorneredBoxLines[p]) do l:Remove() end
        CorneredBoxLines[p] = nil
    end
end)

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Configuration.FoVColour
FOVCircle.Thickness = Configuration.FoVThickness
FOVCircle.NumSides = 100
FOVCircle.Transparency = Configuration.FoVOpacity
FOVCircle.Filled = Configuration.FoVFilled
FOVCircle.Visible = false

-- ================= INPUT HANDLING =================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local toggleKey = Configuration.ToggleKey or Enum.KeyCode.RightShift
    if input.KeyCode == toggleKey then
        ToggleMenu(not menuVisible)
        if not menuVisible then
            TogglePreview(false)
        else
            if currentTab == "Visuals" then
                TogglePreview(true)
            end
        end
    end
    
    if Configuration.Aimbot then
        local keyMatches = false
        if typeof(Configuration.AimKey) == "EnumItem" then
            keyMatches = Configuration.AimKey == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Configuration.AimKey
        end
        if keyMatches then
            Aiming = Configuration.OnePressAimingMode and not Aiming or true
        end
    end
    
    if Configuration.TriggerBot and HAS_MOUSE1CLICK then
        local keyMatches = false
        if typeof(Configuration.TriggerKey) == "EnumItem" then
            keyMatches = Configuration.TriggerKey == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Configuration.TriggerKey
        end
        if keyMatches then
            Triggering = Configuration.OnePressTriggeringMode and not Triggering or true
        end
    end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if Configuration.Aimbot and not Configuration.OnePressAimingMode then
        local keyMatches = false
        if typeof(Configuration.AimKey) == "EnumItem" then
            keyMatches = Configuration.AimKey == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Configuration.AimKey
        end
        if keyMatches then Aiming = false; Target = nil end
    end
    
    if Configuration.TriggerBot and not Configuration.OnePressTriggeringMode and HAS_MOUSE1CLICK then
        local keyMatches = false
        if typeof(Configuration.TriggerKey) == "EnumItem" then
            keyMatches = Configuration.TriggerKey == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Configuration.TriggerKey
        end
        if keyMatches then Triggering = false end
    end
end)

-- ================= MAIN LOOP =================
local hue = 0

RunService.RenderStepped:Connect(function(dt)
    if not Character or not Character.Parent then getChar(); return end
    if not Humanoid or not HRP then return end
    
    FOVCircle.Position = UIS:GetMouseLocation()
    FOVCircle.Radius = Configuration.FoVRadius
    FOVCircle.Visible = Configuration.FoVCheck and ShowingFoV
    FOVCircle.Color = Configuration.FoVColour
    
    if Configuration.RainbowVisuals then
        hue = (hue + dt / Configuration.RainbowDelay) % 1
        Configuration.ESPColour = Color3.fromHSV(hue, 1, 1)
        FOVCircle.Color = Configuration.ESPColour
    end
    
    -- ESP Preview
    if previewWindow.Visible then
        local center = Vector2.new(
            previewContent.AbsolutePosition.X + previewContent.AbsoluteSize.X/2,
            previewContent.AbsolutePosition.Y + previewContent.AbsoluteSize.Y/2
        )
        local boxWidth, boxHeight = 55, 85
        local boxPos = Vector2.new(center.X - boxWidth/2, center.Y - boxHeight/2)
        local headCenter = Vector2.new(center.X, center.Y - 30)
        
        pBox.Visible = Configuration.ESPBox
        if Configuration.ESPBox then
            pBox.Size = Vector2.new(boxWidth, boxHeight)
            pBox.Position = boxPos
            pBox.Color = Configuration.ESPColour
            pBox.Thickness = Configuration.ESPThickness
            pBox.Transparency = Configuration.ESPOpacity
            pBox.Filled = Configuration.ESPBoxFilled
        end
        
        if Configuration.CorneredBox then
            updateCorneredBox(boxPos, Vector2.new(boxWidth, boxHeight), Configuration.ESPColour, Configuration.ESPThickness, Configuration.ESPOpacity, Configuration.CornerLength)
        else
            for i = 1, 8 do
                pCorneredBoxLines[i].Visible = false
            end
        end
        
        pHealth.Visible = Configuration.HealthESP
        if Configuration.HealthESP then
            pHealth.From = boxPos + Vector2.new(-5, boxHeight)
            pHealth.To = boxPos + Vector2.new(-5, boxHeight * 0.6)
            pHealth.Color = Color3.fromRGB(100, 255, 100)
            pHealth.Thickness = 2
        end
        
        pName.Visible = Configuration.NameESP
        if Configuration.NameESP then
            pName.Position = Vector2.new(center.X, boxPos.Y - 16)
            pName.Color = Configuration.ESPColour
            pName.Size = 12
            pName.Outline = true
            pName.OutlineColor = Color3.fromRGB(0, 0, 0)
            pName.OutlineTransparency = 0.3
        end
        
        pTracer.Visible = Configuration.TracerESP
        if Configuration.TracerESP then
            pTracer.From = Vector2.new(center.X, previewContent.AbsolutePosition.Y + previewContent.AbsoluteSize.Y)
            pTracer.To = center
            pTracer.Color = Configuration.ESPColour
            pTracer.Thickness = Configuration.ESPThickness
        end
        
        pHeadCircle.Visible = Configuration.HeadCircle
        if Configuration.HeadCircle then
            pHeadCircle.Position = headCenter
            pHeadCircle.Radius = 12
            pHeadCircle.Color = Configuration.ESPColour
            pHeadCircle.Thickness = Configuration.ESPThickness
            pHeadCircle.Transparency = Configuration.ESPOpacity
            pHeadCircle.Filled = false
        end
        
        if Configuration.SkeletonESP then
            for i = 1, #pSkeleton do
                pSkeleton[i].Visible = true
                pSkeleton[i].From = center + skeletonPreviewPoints[i][1] * 0.65
                pSkeleton[i].To = center + skeletonPreviewPoints[i][2] * 0.65
                pSkeleton[i].Color = Configuration.ESPColour
                pSkeleton[i].Thickness = Configuration.ESPThickness
                pSkeleton[i].Transparency = Configuration.ESPOpacity
            end
        else
            for i = 1, #pSkeleton do pSkeleton[i].Visible = false end
        end
        
        pHighlight.Visible = Configuration.HighlightESP
        if Configuration.HighlightESP then
            pHighlight.Size = Vector2.new(boxWidth + 6, boxHeight + 6)
            pHighlight.Position = boxPos - Vector2.new(3, 3)
            pHighlight.Color = Configuration.ESPColour
            pHighlight.Transparency = 0.5
        end
    else
        for _, d in ipairs({pBox, pTracer, pHealth, pName, pHighlight, pHeadCircle}) do 
            d.Visible = false 
        end
        for i = 1, 8 do pCorneredBoxLines[i].Visible = false end
        for i = 1, #pSkeleton do pSkeleton[i].Visible = false end
    end
    
    -- ================= ACTUAL ESP =================
    for plr, esp in pairs(ESP) do
        local char = plr.Character
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        
        if char and hum and hrp and hum.Health > 0 and plr ~= LocalPlayer then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if Configuration.HighlightESP then
                if not Highlights[plr] or not Highlights[plr].Parent then
                    Highlights[plr] = CreateHighlight(char, Configuration.ESPColour, Configuration.ESPOpacity)
                else
                    Highlights[plr].FillColor = Configuration.ESPColour
                    Highlights[plr].FillTransparency = Configuration.ESPOpacity
                end
            elseif Highlights[plr] and Highlights[plr].Parent then
                Highlights[plr]:Destroy(); Highlights[plr] = nil
            end
            
            if onScreen and ShowingESP then
                local headPos = head and head.Position or hrp.Position + Vector3.new(0, 2, 0)
                local headScreen, headOn = Camera:WorldToViewportPoint(headPos)
                local footPos = hrp.Position - Vector3.new(0, 2.5, 0)
                local footScreen, footOn = Camera:WorldToViewportPoint(footPos)
                
                if headOn and footOn then
                    local headY = headScreen.Y
                    local footY = footScreen.Y
                    local height = math.abs(footY - headY)
                    local width = height * 0.4
                    local centerX = pos.X
                    local topLeft = Vector2.new(centerX - width/2, headY)
                    
                    esp.Box.Visible = Configuration.ESPBox
                    if Configuration.ESPBox then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = topLeft
                        esp.Box.Color = Configuration.ESPColour
                        esp.Box.Thickness = Configuration.ESPThickness
                        esp.Box.Transparency = Configuration.ESPOpacity
                        esp.Box.Filled = Configuration.ESPBoxFilled
                    end
                    
                    if Configuration.CorneredBox then
                        if CorneredBoxLines[plr] then
                            for _, l in ipairs(CorneredBoxLines[plr]) do l:Remove() end
                        end
                        CorneredBoxLines[plr] = DrawCorneredBox(topLeft, Vector2.new(width, height), Configuration.ESPColour, Configuration.ESPThickness, Configuration.ESPOpacity, Configuration.CornerLength)
                    elseif CorneredBoxLines[plr] then
                        for _, l in ipairs(CorneredBoxLines[plr]) do l:Remove() end
                        CorneredBoxLines[plr] = {}
                    end
                    
                    esp.Tracer.Visible = Configuration.TracerESP
                    if Configuration.TracerESP then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                        esp.Tracer.Color = Configuration.ESPColour
                        esp.Tracer.Thickness = Configuration.ESPThickness
                        esp.Tracer.Transparency = Configuration.ESPOpacity
                    end
                    
                    esp.Health.Visible = Configuration.HealthESP
                    if Configuration.HealthESP then
                        local healthPercent = hum.Health / hum.MaxHealth
                        local healthHeight = height * healthPercent
                        esp.Health.From = topLeft + Vector2.new(-6, height)
                        esp.Health.To = topLeft + Vector2.new(-6, height - healthHeight)
                        esp.Health.Color = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                        esp.Health.Thickness = 3
                    end
                    
                    esp.Name.Visible = Configuration.NameESP
                    if Configuration.NameESP then
                        esp.Name.Position = Vector2.new(centerX, topLeft.Y - 20)
                        esp.Name.Text = plr.Name
                        esp.Name.Color = Configuration.ESPColour
                        esp.Name.Size = 14
                        esp.Name.Transparency = 1 - Configuration.ESPOpacity
                        esp.Name.Outline = true
                        esp.Name.OutlineColor = Color3.fromRGB(0, 0, 0)
                        esp.Name.OutlineTransparency = 0.2
                    end
                else
                    esp.Box.Visible = false
                    if CorneredBoxLines[plr] then
                        for _, l in ipairs(CorneredBoxLines[plr]) do l:Remove() end
                        CorneredBoxLines[plr] = {}
                    end
                end
                
                if head and Configuration.HeadCircle then
                    local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                    if headOnScreen and HeadCircles[plr] then
                        HeadCircles[plr].Visible = true
                        HeadCircles[plr].Position = Vector2.new(headPos.X, headPos.Y)
                        local dist = (Camera.CFrame.Position - head.Position).Magnitude
                        local radius = math.clamp(1200 / dist, 6, 30)
                        HeadCircles[plr].Radius = radius
                        HeadCircles[plr].Color = Configuration.ESPColour
                        HeadCircles[plr].Thickness = Configuration.ESPThickness
                        HeadCircles[plr].Transparency = Configuration.ESPOpacity
                        HeadCircles[plr].Filled = false
                    elseif HeadCircles[plr] then
                        HeadCircles[plr].Visible = false
                    end
                elseif HeadCircles[plr] then
                    HeadCircles[plr].Visible = false
                end
                
                if Configuration.SkeletonESP then
                    if SkeletonLines[plr] then for _, l in ipairs(SkeletonLines[plr]) do l:Remove() end end
                    SkeletonLines[plr] = DrawSkeleton(char, Configuration.ESPColour, Configuration.ESPThickness, Configuration.ESPOpacity)
                elseif SkeletonLines[plr] then
                    for _, l in ipairs(SkeletonLines[plr]) do l:Remove() end; SkeletonLines[plr] = {}
                end
            else
                for _, d in pairs(esp) do d.Visible = false end
                if SkeletonLines[plr] then for _, l in ipairs(SkeletonLines[plr]) do l.Visible = false end end
                if HeadCircles[plr] then HeadCircles[plr].Visible = false end
                if CorneredBoxLines[plr] then
                    for _, l in ipairs(CorneredBoxLines[plr]) do l:Remove() end
                    CorneredBoxLines[plr] = {}
                end
            end
        else
            for _, d in pairs(esp) do d.Visible = false end
            if SkeletonLines[plr] then for _, l in ipairs(SkeletonLines[plr]) do l.Visible = false end end
            if Highlights[plr] and Highlights[plr].Parent then Highlights[plr]:Destroy(); Highlights[plr] = nil end
            if HeadCircles[plr] then HeadCircles[plr].Visible = false end
            if CorneredBoxLines[plr] then
                for _, l in ipairs(CorneredBoxLines[plr]) do l:Remove() end
                CorneredBoxLines[plr] = {}
            end
        end
    end
    
    -- Silent Aim
    local silentKeyPressed = false
    if typeof(Configuration.SilentAimKey) == "EnumItem" then
        silentKeyPressed = Configuration.SilentAimKey == Enum.UserInputType.MouseButton2 and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UIS:IsKeyDown(Configuration.SilentAimKey)
    end
    SilentAimActive = Configuration.SilentAim and (Configuration.AlwaysOnSilent or silentKeyPressed)
    
    if SilentAimActive then
        local mousePos = UIS:GetMouseLocation()
        local closestTarget, closestDistance, closestScreenPos = nil, Configuration.SilentFOVRadius, nil
        for _, player in ipairs(Players:GetPlayers()) do
            if IsValidSilentTarget(player) then
                local bone = GetTargetBone(player.Character, Configuration.SilentTargetBone)
                if bone then
                    local predPos = CalculatePredictedPosition(bone, player.Character)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(predPos)
                    if onScreen then
                        local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if dist <= Configuration.SilentFOVRadius and dist < closestDistance then
                            closestDistance = dist; closestTarget = player; closestScreenPos = screenPos
                        end
                    end
                end
            end
        end
        SilentTarget = closestTarget; SilentTargetScreenPos = closestScreenPos
    else
        SilentTarget = nil; SilentTargetScreenPos = nil
    end
    
    if Configuration.ShowSilentFOV and SilentAimActive then
        if not SilentFOVCircle then
            SilentFOVCircle = Drawing.new("Circle"); SilentFOVCircle.NumSides = 100
            SilentFOVCircle.Thickness = 2; SilentFOVCircle.Filled = false
            SilentFOVCircle.Color = Color3.fromRGB(255, 100, 100); SilentFOVCircle.Transparency = 0.5
        end
        SilentFOVCircle.Position = UIS:GetMouseLocation()
        SilentFOVCircle.Radius = Configuration.SilentFOVRadius; SilentFOVCircle.Visible = true
    elseif SilentFOVCircle then SilentFOVCircle.Visible = false end
    
    if Configuration.SilentVisualizer and SilentTarget and SilentTargetScreenPos then
        if not TargetVisualizer then
            TargetVisualizer = {
                Circle = Drawing.new("Circle"), InnerCircle = Drawing.new("Circle"),
                Line1 = Drawing.new("Line"), Line2 = Drawing.new("Line")
            }
            TargetVisualizer.Circle.NumSides = 50; TargetVisualizer.Circle.Thickness = 2; TargetVisualizer.Circle.Filled = false
            TargetVisualizer.Circle.Color = Color3.fromRGB(255, 255, 255)
            TargetVisualizer.InnerCircle.NumSides = 30; TargetVisualizer.InnerCircle.Thickness = 1; TargetVisualizer.InnerCircle.Filled = true
            TargetVisualizer.InnerCircle.Color = Color3.fromRGB(255, 0, 0); TargetVisualizer.InnerCircle.Transparency = 0.3
            TargetVisualizer.Line1.Thickness = 2; TargetVisualizer.Line2.Thickness = 2
        end
        local pos = Vector2.new(SilentTargetScreenPos.X, SilentTargetScreenPos.Y)
        TargetVisualizer.Circle.Position = pos; TargetVisualizer.Circle.Radius = 15 + math.sin(os.clock()*10)*3; TargetVisualizer.Circle.Visible = true
        TargetVisualizer.InnerCircle.Position = pos; TargetVisualizer.InnerCircle.Radius = 5; TargetVisualizer.InnerCircle.Visible = true
        TargetVisualizer.Line1.From = pos - Vector2.new(20,20); TargetVisualizer.Line1.To = pos + Vector2.new(20,20); TargetVisualizer.Line1.Visible = true
        TargetVisualizer.Line2.From = pos + Vector2.new(-20,20); TargetVisualizer.Line2.To = pos + Vector2.new(20,-20); TargetVisualizer.Line2.Visible = true
    elseif TargetVisualizer then for _, obj in pairs(TargetVisualizer) do obj.Visible = false end end
    
    -- ================= AIMBOT =================
    if Configuration.Aimbot and Aiming then
        local mousePos = UIS:GetMouseLocation()
        local closestTarget, closestDistance = nil, Configuration.FoVCheck and Configuration.FoVRadius or math.huge
        
        if Target and Target:IsA("Model") then
            local success, player, char, vp = IsReady(Target)
            if success and vp then
                closestTarget = Target
                closestDistance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(vp.X, vp.Y)).Magnitude
            else
                Target = nil
            end
        end
        
        if not Target then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local success, plr, char, vp = IsReady(player.Character)
                    if success and vp then
                        local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(vp.X, vp.Y)).Magnitude
                        if (Configuration.FoVCheck and dist <= Configuration.FoVRadius or not Configuration.FoVCheck) and dist < closestDistance then
                            closestDistance = dist; closestTarget = player.Character
                        end
                    end
                end
            end
        end
        
        if closestTarget then
            Target = closestTarget
            local success, player, char, vp, wp = IsReady(Target)
            if success and vp and wp then
                if Configuration.AimMode == "Camera" then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, wp), Configuration.UseSensitivity and Configuration.Sensitivity/100 or 0.3)
                elseif Configuration.AimMode == "Mouse" and HAS_MOUSEMOVEREL then
                    local dx, dy = vp.X - mousePos.X, vp.Y - mousePos.Y
                    if Configuration.UseSensitivity then
                        local s = math.max(Configuration.Sensitivity/5, 1)
                        dx, dy = math.clamp(dx/s, -25, 25), math.clamp(dy/s, -25, 25)
                    else
                        dx, dy = math.clamp(dx, -50, 50), math.clamp(dy, -50, 50)
                    end
                    pcall(function() mousemoverel(dx, dy) end)
                end
            end
        else Target = nil end
    else Target = nil end
    
    -- TriggerBot
    if Configuration.TriggerBot and Triggering and HAS_MOUSE1CLICK and not (Configuration.SmartTriggerBot and not Aiming) then
        local mt = Mouse.Target
        if mt then
            local char = mt:FindFirstAncestorOfClass("Model")
            if char then
                local plr = Players:GetPlayerFromCharacter(char)
                if plr and plr ~= LocalPlayer then
                    local success = IsReady(char)
                    if success and MathHandler:CalculateChance(Configuration.TriggerBotChance) then
                        pcall(function() mouse1click() end)
                        task.wait(0.03)
                    end
                end
            end
        end
    end
end)

-- Cleanup
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "UndercoverSlotted" then
        if SilentFOVCircle then SilentFOVCircle:Remove() end
        if TargetVisualizer then for _, obj in pairs(TargetVisualizer) do obj:Remove() end end
        for plr, esp in pairs(ESP) do
            for _, d in pairs(esp) do d:Remove() end
        end
        for plr, lines in pairs(CorneredBoxLines) do
            for _, l in ipairs(lines) do l:Remove() end
        end
    end
end)