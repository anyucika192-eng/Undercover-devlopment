--==================================================
-- Project Undercover Build20250205 - FREE VERSION
-- .gg/SoftwareShopz
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

-- ================= CONFIGURATION =================
local Configuration = {
    -- Aimbot (FREE - ENABLED)
    Aimbot = false,
    OnePressAimingMode = false,
    AimKey = Enum.UserInputType.MouseButton2,
    AimMode = "Mouse",
    AimPart = "Head",
    AimPartDropdownValues = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
    
    -- Silent Aim (DISABLED - GRAYED OUT)
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
    
    -- Offset (DISABLED - GRAYED OUT)
    UseOffset = false,
    OffsetType = "Static",
    StaticOffsetIncrement = 10,
    DynamicOffsetIncrement = 10,
    AutoOffset = false,
    MaxAutoOffset = 50,
    
    -- Sensitivity & Noise (Sensitivity FREE, Noise DISABLED)
    UseSensitivity = false,
    Sensitivity = 50,
    UseNoise = false,
    NoiseFrequency = 50,
    
    -- TriggerBot (DISABLED - GRAYED OUT)
    TriggerBot = false,
    OnePressTriggeringMode = false,
    SmartTriggerBot = true,
    TriggerKey = Enum.KeyCode.E,
    TriggerBotChance = 100,
    
    -- Checks (ALL DISABLED - GRAYED OUT except AliveCheck)
    AliveCheck = true,
    GodCheck = false,
    TeamCheck = false,
    FriendCheck = false,
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
    
    -- Visuals (Box ESP & Name ESP ENABLED - all others DISABLED)
    FoV = false,
    FoVThickness = 2,
    FoVOpacity = 0.8,
    FoVFilled = false,
    FoVColour = Color3.fromRGB(90, 70, 220),
    ESPBox = false, -- FREE - ENABLED & TOGGLEABLE
    ESPBoxFilled = false,
    CorneredBox = false,
    CornerLength = 6,
    NameESP = false, -- FREE - ENABLED
    HealthESP = false,
    TracerESP = false,
    SkeletonESP = false,
    HighlightESP = false,
    HeadCircle = false,
    ESPThickness = 2,
    ESPOpacity = 0.8,
    ESPColour = Color3.fromRGB(90, 70, 220),
    RainbowVisuals = false,
    RainbowDelay = 5,
    
    -- Misc (DISABLED - GRAYED OUT)
    SpinBot = false,
    SpinBotVelocity = 50,
    SpinPart = "HumanoidRootPart",
    
    -- UI Settings
    AccentColor = Color3.fromRGB(90, 70, 220),
    SecondaryColor = Color3.fromRGB(150, 100, 255),
    MenuSize = "100%",
}

-- ================= FEATURE AVAILABILITY FLAGS =================
local FEATURES = {
    -- Aimbot features (FREE)
    Aimbot = true,
    OnePressAimingMode = true,
    AimKey = true,
    AimMode = true,
    AimPart = true,
    FoVCheck = true,
    FoVRadius = true,
    UseSensitivity = true,
    Sensitivity = true,
    
    -- ESP Features (FREE)
    ESPBox = true, -- Box ESP is FREE
    ESPBoxFilled = true,
    ESPThickness = true,
    ESPOpacity = true,
    NameESP = true,
    
    -- DISABLED FEATURES (Grayed out)
    SilentAim = false,
    AlwaysOnSilent = false,
    ShowSilentFOV = false,
    SilentFOVRadius = false,
    SilentPrediction = false,
    SilentPredictionX = false,
    SilentPredictionY = false,
    SilentVisualizer = false,
    SilentTargetBone = false,
    SilentBoneDropdownValues = false,
    
    TriggerBot = false,
    OnePressTriggeringMode = false,
    SmartTriggerBot = false,
    TriggerKey = false,
    TriggerBotChance = false,
    
    UseOffset = false,
    OffsetType = false,
    StaticOffsetIncrement = false,
    DynamicOffsetIncrement = false,
    AutoOffset = false,
    MaxAutoOffset = false,
    
    UseNoise = false,
    NoiseFrequency = false,
    
    GodCheck = false,
    TeamCheck = false,
    FriendCheck = false,
    FollowCheck = false,
    VerifiedBadgeCheck = false,
    WallCheck = false,
    WaterCheck = false,
    MagnitudeCheck = false,
    TriggerMagnitude = false,
    TransparencyCheck = false,
    IgnoredTransparency = false,
    IgnoredPlayersCheck = false,
    IgnoredPlayers = false,
    TargetPlayersCheck = false,
    TargetPlayers = false,
    
    CorneredBox = false,
    HealthESP = false,
    TracerESP = false,
    SkeletonESP = false,
    HighlightESP = false,
    HeadCircle = false,
    
    SpinBot = false,
    SpinBotVelocity = false,
    SpinPart = false,
    
    OffAimbotAfterKill = false,
    RainbowVisuals = false,
    RainbowDelay = false,
}

-- ================= AIMBOT STATE =================
local Aiming = false
local Target = nil
local Triggering = false
local ShowingFoV = false
local ShowingESP = false

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

-- Logo
local loadingLogo = Instance.new("TextLabel", loadingCenter)
loadingLogo.Size = UDim2.new(1, 0, 0, 40)
loadingLogo.Position = UDim2.new(0, 0, 0, 20)
loadingLogo.BackgroundTransparency = 1
loadingLogo.Text = "UNDERCOVER FREE"
loadingLogo.Font = Enum.Font.GothamBold
loadingLogo.TextSize = 28
loadingLogo.TextColor3 = Color3.fromRGB(250, 250, 250)
loadingLogo.TextXAlignment = Enum.TextXAlignment.Center

-- Subtitle with animated dots
local loadingSub = Instance.new("TextLabel", loadingCenter)
loadingSub.Size = UDim2.new(1, 0, 0, 20)
loadingSub.Position = UDim2.new(0, 0, 0, 62)
loadingSub.BackgroundTransparency = 1
loadingSub.Text = "Loading"
loadingSub.Font = Enum.Font.Gotham
loadingSub.TextSize = 12
loadingSub.TextColor3 = Color3.fromRGB(161, 161, 170)
loadingSub.TextXAlignment = Enum.TextXAlignment.Center

-- Loading bar background
local loadingBarBg = Instance.new("Frame", loadingCenter)
loadingBarBg.Size = UDim2.new(0.8, 0, 0, 8)
loadingBarBg.Position = UDim2.new(0.1, 0, 0, 100)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(39, 39, 42)
loadingBarBg.BorderSizePixel = 0
local loadingBarBgCorner = Instance.new("UICorner", loadingBarBg)
loadingBarBgCorner.CornerRadius = UDim.new(1, 0)

-- Loading bar fill
local loadingBarFill = Instance.new("Frame", loadingBarBg)
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
loadingBarFill.BorderSizePixel = 0
local loadingBarFillCorner = Instance.new("UICorner", loadingBarFill)
loadingBarFillCorner.CornerRadius = UDim.new(1, 0)

-- Loading text
local loadingText = Instance.new("TextLabel", loadingCenter)
loadingText.Size = UDim2.new(1, 0, 0, 20)
loadingText.Position = UDim2.new(0, 0, 0, 120)
loadingText.BackgroundTransparency = 1
loadingText.Text = "0%"
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 14
loadingText.TextColor3 = Color3.fromRGB(99, 102, 241)
loadingText.TextXAlignment = Enum.TextXAlignment.Center

-- Loading animation with dots
local dotTimer = 0
local dotCount = 0
local loadingTextBase = "Loading"

task.spawn(function()
    while loadingGui.Enabled do
        dotTimer = dotTimer + 0.3
        if dotTimer >= 0.5 then
            dotTimer = 0
            dotCount = (dotCount % 3) + 1
            local dots = string.rep(".", dotCount)
            loadingSub.Text = loadingTextBase .. dots
        end
        task.wait(0.1)
    end
end)

-- Loading animation
local function ShowLoadingScreen()
    local steps = 100
    local currentStep = 0
    
    while currentStep < steps do
        local jump = math.random(1, 4)
        currentStep = math.min(currentStep + jump, steps)
        
        loadingBarFill.Size = UDim2.new(currentStep / steps, 0, 1, 0)
        loadingText.Text = math.floor(currentStep) .. "%"
        
        local delay = math.random(3, 15) / 100
        task.wait(delay)
    end
    
    loadingBarFill.Size = UDim2.new(1, 0, 1, 0)
    loadingText.Text = "100%"
    loadingSub.Text = "Loading Complete!"
    task.wait(0.3)
    
    loadingGui.Enabled = false
    gui.Enabled = true
end

task.spawn(ShowLoadingScreen)

-- Color scheme
local COLORS = {
    Background = Color3.fromRGB(18, 18, 20),
    Sidebar = Color3.fromRGB(14, 14, 16),
    TitleBar = Color3.fromRGB(10, 10, 12),
    Content = Color3.fromRGB(22, 22, 26),
    Card = Color3.fromRGB(28, 28, 32),
    Accent = Color3.fromRGB(99, 102, 241),
    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Text = Color3.fromRGB(250, 250, 250),
    TextSecondary = Color3.fromRGB(161, 161, 170),
    TextMuted = Color3.fromRGB(113, 113, 122),
    Border = Color3.fromRGB(39, 39, 42),
    SliderTrack = Color3.fromRGB(39, 39, 42),
    Button = Color3.fromRGB(39, 39, 42),
    ButtonHover = Color3.fromRGB(63, 63, 70),
    TabActive = Color3.fromRGB(30, 30, 36),
    TabInactive = Color3.fromRGB(14, 14, 16),
    Disabled = Color3.fromRGB(50, 50, 55),
    DisabledText = Color3.fromRGB(80, 80, 85),
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
titleBar.Size = UDim2.new(0, BASE_WIDTH, 0, 36)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = COLORS.TitleBar
titleBar.BorderSizePixel = 0

local titleLine = Instance.new("Frame", titleBar)
titleLine.Size = UDim2.new(1, 0, 0, 1)
titleLine.Position = UDim2.new(0, 0, 1, -1)
titleLine.BackgroundColor3 = COLORS.Border
titleLine.BorderSizePixel = 0
titleLine.BackgroundTransparency = 0.3

-- Title text - "UNDERCOVER FREE"
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(0.5, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "UNDERCOVER FREE"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextColor3 = COLORS.Accent
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextYAlignment = Enum.TextYAlignment.Center

-- Discord link - ".gg/SoftwareShopz"
local discordText = Instance.new("TextLabel", titleBar)
discordText.Size = UDim2.new(0.5, 0, 1, 0)
discordText.Position = UDim2.new(0.5, 0, 0, 0)
discordText.BackgroundTransparency = 1
discordText.Text = ".gg/SoftwareShopz"
discordText.Font = Enum.Font.Gotham
discordText.TextSize = 11
discordText.TextColor3 = COLORS.TextSecondary
discordText.TextXAlignment = Enum.TextXAlignment.Right
discordText.TextYAlignment = Enum.TextYAlignment.Center

local accentDot = Instance.new("Frame", titleBar)
accentDot.Size = UDim2.new(0, 6, 0, 6)
accentDot.Position = UDim2.new(0.5, -170, 0.5, -3)
accentDot.BackgroundColor3 = COLORS.Accent
accentDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", accentDot)
dotCorner.CornerRadius = UDim.new(1, 0)

-- Left sidebar
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 0, BASE_HEIGHT - 36)
sidebar.Position = UDim2.new(0, 0, 0, 36)
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
logoArea.Size = UDim2.new(1, 0, 0, 50)
logoArea.BackgroundTransparency = 1

local logoText = Instance.new("TextLabel", logoArea)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "UC"
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 22
logoText.TextColor3 = COLORS.Accent
logoText.TextXAlignment = Enum.TextXAlignment.Center
logoText.TextYAlignment = Enum.TextYAlignment.Center

local versionText = Instance.new("TextLabel", logoArea)
versionText.Size = UDim2.new(1, 0, 0, 14)
versionText.Position = UDim2.new(0, 0, 1, -16)
versionText.BackgroundTransparency = 1
versionText.Text = "FREE v2.05"
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 9
versionText.TextColor3 = COLORS.TextMuted
versionText.TextXAlignment = Enum.TextXAlignment.Center

-- Tab buttons (Rage tab removed)
local tabs = {}
local tabData = {
    {name = "Aimbot", icon = "🎯"},
    {name = "Visuals", icon = "👁"},
    {name = "Settings", icon = "⚙"}
}

local TAB_HEIGHT = 38
local TAB_PADDING = 5
local tabsStartY = 56

for i, data in ipairs(tabData) do
    local tab = Instance.new("TextButton", sidebar)
    tab.Size = UDim2.new(1, -20, 0, TAB_HEIGHT)
    tab.Position = UDim2.new(0, 10, 0, tabsStartY + (i-1) * (TAB_HEIGHT + TAB_PADDING))
    tab.BackgroundColor3 = i == 1 and COLORS.TabActive or COLORS.TabInactive
    tab.BorderSizePixel = 0
    tab.Text = ""
    tab.AutoButtonColor = false
    local tabCorner = Instance.new("UICorner", tab)
    tabCorner.CornerRadius = UDim.new(0, 8)
    
    local tabIndicator = Instance.new("Frame", tab)
    tabIndicator.Size = UDim2.new(0, 3, 0, 18)
    tabIndicator.Position = UDim2.new(0, 6, 0.5, -9)
    tabIndicator.BackgroundColor3 = i == 1 and COLORS.Accent or COLORS.TextMuted
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Name = "Indicator"
    local indicatorCorner = Instance.new("UICorner", tabIndicator)
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    
    local tabIcon = Instance.new("TextLabel", tab)
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 14, 0.5, -10)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = data.icon
    tabIcon.Font = Enum.Font.Gotham
    tabIcon.TextSize = 14
    tabIcon.TextColor3 = COLORS.Text
    tabIcon.TextXAlignment = Enum.TextXAlignment.Center
    tabIcon.Name = "Icon"
    
    local tabLabel = Instance.new("TextLabel", tab)
    tabLabel.Size = UDim2.new(0, 60, 1, 0)
    tabLabel.Position = UDim2.new(0, 40, 0, 0)
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
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            }):Play()
        end
    end)
    
    tab.MouseLeave:Connect(function()
        if tabs[data.name] ~= tab then return end
        if tab.BackgroundColor3 ~= COLORS.TabActive then
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundColor3 = COLORS.TabInactive
            }):Play()
        end
    end)
    
    tabs[data.name] = tab
end

-- ================= PLAYER PROFILE SECTION =================
local profileArea = Instance.new("Frame", sidebar)
profileArea.Size = UDim2.new(1, -16, 0, 55)
profileArea.Position = UDim2.new(0, 8, 1, -63)
profileArea.BackgroundColor3 = COLORS.Card
profileArea.BorderSizePixel = 0
local profileCorner = Instance.new("UICorner", profileArea)
profileCorner.CornerRadius = UDim.new(0, 8)

local profileStroke = Instance.new("UIStroke", profileArea)
profileStroke.Color = COLORS.Border
profileStroke.Thickness = 1
profileStroke.Transparency = 0.5

-- Avatar image
local avatarImage = Instance.new("ImageLabel", profileArea)
avatarImage.Size = UDim2.new(0, 36, 0, 36)
avatarImage.Position = UDim2.new(0, 8, 0.5, -18)
avatarImage.BackgroundColor3 = COLORS.Border
avatarImage.BorderSizePixel = 0
local avatarCorner = Instance.new("UICorner", avatarImage)
avatarCorner.CornerRadius = UDim.new(1, 0)

-- Username label
local usernameLabel = Instance.new("TextLabel", profileArea)
usernameLabel.Size = UDim2.new(1, -56, 0, 16)
usernameLabel.Position = UDim2.new(0, 50, 0, 12)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = LocalPlayer.Name
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 11
usernameLabel.TextColor3 = COLORS.Text
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd

-- Status label
local statusLabel = Instance.new("TextLabel", profileArea)
statusLabel.Size = UDim2.new(1, -56, 0, 14)
statusLabel.Position = UDim2.new(0, 50, 0, 28)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Free Version"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 9
statusLabel.TextColor3 = COLORS.Accent
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Update avatar function
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
contentArea.Size = UDim2.new(0, CONTENT_WIDTH, 0, BASE_HEIGHT - 36)
contentArea.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 36)
contentArea.BackgroundColor3 = COLORS.Content
contentArea.BorderSizePixel = 0

-- Content header
local contentHeader = Instance.new("Frame", contentArea)
contentHeader.Size = UDim2.new(1, -32, 0, 40)
contentHeader.Position = UDim2.new(0, 16, 0, 8)
contentHeader.BackgroundTransparency = 1

local contentTitle = Instance.new("TextLabel", contentHeader)
contentTitle.Size = UDim2.new(0, 200, 1, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Aimbot"
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextSize = 16
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
contentScroll.Size = UDim2.new(1, -32, 1, -56)
contentScroll.Position = UDim2.new(0, 16, 0, 48)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 4
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.ScrollBarImageColor3 = COLORS.SliderTrack
contentScroll.ScrollBarImageTransparency = 0.5

local contentLayout = Instance.new("UIListLayout", contentScroll)
contentLayout.Padding = UDim.new(0, 8)

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
previewTitleBar.Size = UDim2.new(1, 0, 0, 36)
previewTitleBar.BackgroundColor3 = COLORS.TitleBar
previewTitleBar.BorderSizePixel = 0

local previewTitleLine = Instance.new("Frame", previewTitleBar)
previewTitleLine.Size = UDim2.new(1, 0, 0, 1)
previewTitleLine.Position = UDim2.new(0, 0, 1, -1)
previewTitleLine.BackgroundColor3 = COLORS.Border
previewTitleLine.BorderSizePixel = 0
previewTitleLine.BackgroundTransparency = 0.3

local previewIcon = Instance.new("TextLabel", previewTitleBar)
previewIcon.Size = UDim2.new(0, 20, 0, 20)
previewIcon.Position = UDim2.new(0, 12, 0.5, -10)
previewIcon.BackgroundTransparency = 1
previewIcon.Text = "👁"
previewIcon.Font = Enum.Font.Gotham
previewIcon.TextSize = 14
previewIcon.TextColor3 = COLORS.Accent

local previewTitle = Instance.new("TextLabel", previewTitleBar)
previewTitle.Size = UDim2.new(1, -44, 1, 0)
previewTitle.Position = UDim2.new(0, 36, 0, 0)
previewTitle.BackgroundTransparency = 1
previewTitle.Text = "ESP Preview"
previewTitle.Font = Enum.Font.GothamBold
previewTitle.TextSize = 12
previewTitle.TextColor3 = COLORS.Text
previewTitle.TextXAlignment = Enum.TextXAlignment.Left

local previewContent = Instance.new("Frame", previewWindow)
previewContent.Size = UDim2.new(1, -20, 1, -56)
previewContent.Position = UDim2.new(0, 10, 0, 46)
previewContent.BackgroundColor3 = COLORS.Content
previewContent.BorderSizePixel = 0
local previewContentCorner = Instance.new("UICorner", previewContent)
previewContentCorner.CornerRadius = UDim.new(0, 8)

local previewContentBorder = Instance.new("UIStroke", previewContent)
previewContentBorder.Color = COLORS.Border
previewContentBorder.Thickness = 1
previewContentBorder.Transparency = 0.5

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

-- ================= UI COMPONENTS =================

local function isFeatureEnabled(featureName)
    return FEATURES[featureName] == true
end

local function getFeatureColor(featureName)
    if isFeatureEnabled(featureName) then
        return COLORS.Text
    else
        return COLORS.DisabledText
    end
end

local function addSection(text)
    local section = Instance.new("Frame", contentScroll)
    section.Size = UDim2.new(1, 0, 0, 28)
    section.BackgroundTransparency = 1
    
    local accent = Instance.new("Frame", section)
    accent.Size = UDim2.new(0, 2, 0, 16)
    accent.Position = UDim2.new(0, 0, 0.5, -8)
    accent.BackgroundColor3 = COLORS.Accent
    accent.BorderSizePixel = 0
    local accentCorner = Instance.new("UICorner", accent)
    accentCorner.CornerRadius = UDim.new(1, 0)
    
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = COLORS.TextSecondary
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

local function addToggle(text, default, callback, featureName)
    local isEnabled = isFeatureEnabled(featureName)
    local isDisabled = not isEnabled
    
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 6)
    
    if isDisabled then
        local lockIcon = Instance.new("TextLabel", card)
        lockIcon.Size = UDim2.new(0, 20, 0, 20)
        lockIcon.Position = UDim2.new(0, 8, 0.5, -10)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔒"
        lockIcon.Font = Enum.Font.Gotham
        lockIcon.TextSize = 12
        lockIcon.TextColor3 = COLORS.TextMuted
        lockIcon.TextXAlignment = Enum.TextXAlignment.Center
        lockIcon.Name = "LockIcon"
    end
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 280, 1, 0)
    label.Position = UDim2.new(0, isDisabled and 32 or 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    if isDisabled then
        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 65, 0, 16)
        badge.Position = UDim2.new(0, 240, 0.5, -8)
        badge.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
        badge.BackgroundTransparency = 0.6
        badge.BorderSizePixel = 0
        badge.Text = "PREMIUM"
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 8
        badge.TextColor3 = Color3.fromRGB(255, 200, 100)
        badge.TextXAlignment = Enum.TextXAlignment.Center
        local badgeCorner = Instance.new("UICorner", badge)
        badgeCorner.CornerRadius = UDim.new(0, 3)
    end
    
    local toggleFrame = Instance.new("Frame", card)
    toggleFrame.Size = UDim2.new(0, 40, 0, 22)
    toggleFrame.Position = UDim2.new(1, -52, 0.5, -11)
    toggleFrame.BackgroundColor3 = isDisabled and COLORS.Disabled or (default and COLORS.Success or COLORS.SliderTrack)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.BackgroundTransparency = isDisabled and 0.5 or 0
    local toggleCorner = Instance.new("UICorner", toggleFrame)
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    local toggleKnob = Instance.new("Frame", toggleFrame)
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = UDim2.new(0, default and 20 or 2, 0.5, -9)
    toggleKnob.BackgroundColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    toggleKnob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner", toggleKnob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local state = default and isEnabled or false
    
    local function updateToggle()
        if not isEnabled then
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = COLORS.Disabled,
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -9)
            }):Play()
            return
        end
        
        TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = state and COLORS.Success or COLORS.SliderTrack,
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {
            Position = UDim2.new(0, state and 20 or 2, 0.5, -9)
        }):Play()
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not isEnabled then
                local notif = Instance.new("Frame", gui)
                notif.Size = UDim2.new(0, 200, 0, 30)
                notif.Position = UDim2.new(0.5, -100, 0.8, 0)
                notif.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
                notif.BorderSizePixel = 0
                local notifCorner = Instance.new("UICorner", notif)
                notifCorner.CornerRadius = UDim.new(0, 6)
                local notifText = Instance.new("TextLabel", notif)
                notifText.Size = UDim2.new(1, 0, 1, 0)
                notifText.BackgroundTransparency = 1
                notifText.Text = "🔒 Premium Feature - Upgrade to use"
                notifText.Font = Enum.Font.Gotham
                notifText.TextSize = 10
                notifText.TextColor3 = Color3.fromRGB(255, 200, 100)
                notifText.TextXAlignment = Enum.TextXAlignment.Center
                task.delay(2, function()
                    notif:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
                    task.delay(0.3, function() notif:Destroy() end)
                end)
                return
            end
            state = not state
            updateToggle()
            callback(state)
        end
    end)
    
    toggleFrame.MouseEnter:Connect(function()
        if not isEnabled then return end
        TweenService:Create(toggleFrame, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(40, 220, 100) or Color3.fromRGB(55, 55, 60)
        }):Play()
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        if not isEnabled then return end
        TweenService:Create(toggleFrame, TweenInfo.new(0.15), {
            BackgroundColor3 = state and COLORS.Success or COLORS.SliderTrack
        }):Play()
    end)
    
    updateToggle()
    
    return card
end

local function addSlider(text, min, max, default, callback, suffix, featureName)
    local isEnabled = isFeatureEnabled(featureName)
    local isDisabled = not isEnabled
    
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 52)
    card.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 6)
    
    if isDisabled then
        local lockIcon = Instance.new("TextLabel", card)
        lockIcon.Size = UDim2.new(0, 20, 0, 20)
        lockIcon.Position = UDim2.new(0, 8, 0.5, -10)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔒"
        lockIcon.Font = Enum.Font.Gotham
        lockIcon.TextSize = 12
        lockIcon.TextColor3 = COLORS.TextMuted
        lockIcon.TextXAlignment = Enum.TextXAlignment.Center
        lockIcon.Name = "LockIcon"
    end
    
    local labelRow = Instance.new("Frame", card)
    labelRow.Size = UDim2.new(1, -24, 0, 20)
    labelRow.Position = UDim2.new(0, isDisabled and 32 or 12, 0, 6)
    labelRow.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", labelRow)
    label.Size = UDim2.new(0, 250, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    if isDisabled then
        local badge = Instance.new("TextLabel", labelRow)
        badge.Size = UDim2.new(0, 65, 0, 16)
        badge.Position = UDim2.new(0.5, -32, 0.5, -8)
        badge.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
        badge.BackgroundTransparency = 0.6
        badge.BorderSizePixel = 0
        badge.Text = "PREMIUM"
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 8
        badge.TextColor3 = Color3.fromRGB(255, 200, 100)
        badge.TextXAlignment = Enum.TextXAlignment.Center
        local badgeCorner = Instance.new("UICorner", badge)
        badgeCorner.CornerRadius = UDim.new(0, 3)
    end
    
    local valueLabel = Instance.new("TextLabel", labelRow)
    valueLabel.Size = UDim2.new(0, 80, 1, 0)
    valueLabel.Position = UDim2.new(1, -80, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default) .. (suffix or "")
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderTrack = Instance.new("Frame", card)
    sliderTrack.Size = UDim2.new(1, -24, 0, 6)
    sliderTrack.Position = UDim2.new(0, 12, 0, 32)
    sliderTrack.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.SliderTrack
    sliderTrack.BorderSizePixel = 0
    local trackCorner = Instance.new("UICorner", sliderTrack)
    trackCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderTrack)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = isDisabled and COLORS.DisabledText or COLORS.Accent
    sliderFill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderKnob = Instance.new("Frame", sliderTrack)
    sliderKnob.Size = UDim2.new(0, 14, 0, 14)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    sliderKnob.BackgroundColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Visible = false
    local knobCorner = Instance.new("UICorner", sliderKnob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSlider(value)
        if not isEnabled then return end
        local clamped = math.clamp(value, min, max)
        local percentage = (clamped - min) / (max - min)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, -7, 0.5, -7)
        valueLabel.Text = tostring(math.floor(clamped)) .. (suffix or "")
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isEnabled then
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
        if isEnabled then
            sliderKnob.Visible = true
        end
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
        if dragging and isEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local relativeX = math.clamp((mousePos.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = min + (relativeX * (max - min))
            updateSlider(value)
            callback(math.floor(value))
        end
    end)
    
    return card
end

local function addDropdown(text, options, defaultIndex, callback, featureName)
    local isEnabled = isFeatureEnabled(featureName)
    local isDisabled = not isEnabled
    
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 6)
    
    if isDisabled then
        local lockIcon = Instance.new("TextLabel", card)
        lockIcon.Size = UDim2.new(0, 20, 0, 20)
        lockIcon.Position = UDim2.new(0, 8, 0.5, -10)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔒"
        lockIcon.Font = Enum.Font.Gotham
        lockIcon.TextSize = 12
        lockIcon.TextColor3 = COLORS.TextMuted
        lockIcon.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, isDisabled and 32 or 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    if isDisabled then
        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 65, 0, 16)
        badge.Position = UDim2.new(0.5, -32, 0.5, -8)
        badge.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
        badge.BackgroundTransparency = 0.6
        badge.BorderSizePixel = 0
        badge.Text = "PREMIUM"
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 8
        badge.TextColor3 = Color3.fromRGB(255, 200, 100)
        badge.TextXAlignment = Enum.TextXAlignment.Center
        local badgeCorner = Instance.new("UICorner", badge)
        badgeCorner.CornerRadius = UDim.new(0, 3)
    end
    
    local dropdown = Instance.new("TextButton", card)
    dropdown.Size = UDim2.new(0, 140, 0, 28)
    dropdown.Position = UDim2.new(1, -152, 0.5, -14)
    dropdown.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.Button
    dropdown.BorderSizePixel = 0
    dropdown.Text = "  " .. (options[defaultIndex] or options[1])
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 11
    dropdown.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    dropdown.AutoButtonColor = false
    dropdown.TextXAlignment = Enum.TextXAlignment.Left
    local dropdownCorner = Instance.new("UICorner", dropdown)
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    
    local chevron = Instance.new("TextLabel", dropdown)
    chevron.Size = UDim2.new(0, 16, 0, 16)
    chevron.Position = UDim2.new(1, -20, 0.5, -8)
    chevron.BackgroundTransparency = 1
    chevron.Text = "▾"
    chevron.Font = Enum.Font.Gotham
    chevron.TextSize = 10
    chevron.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.TextMuted
    
    local currentIndex = defaultIndex or 1
    
    dropdown.MouseButton1Click:Connect(function()
        if not isEnabled then
            local notif = Instance.new("Frame", gui)
            notif.Size = UDim2.new(0, 200, 0, 30)
            notif.Position = UDim2.new(0.5, -100, 0.8, 0)
            notif.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
            notif.BorderSizePixel = 0
            local notifCorner = Instance.new("UICorner", notif)
            notifCorner.CornerRadius = UDim.new(0, 6)
            local notifText = Instance.new("TextLabel", notif)
            notifText.Size = UDim2.new(1, 0, 1, 0)
            notifText.BackgroundTransparency = 1
            notifText.Text = "🔒 Premium Feature - Upgrade to use"
            notifText.Font = Enum.Font.Gotham
            notifText.TextSize = 10
            notifText.TextColor3 = Color3.fromRGB(255, 200, 100)
            notifText.TextXAlignment = Enum.TextXAlignment.Center
            task.delay(2, function()
                notif:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
                task.delay(0.3, function() notif:Destroy() end)
            end)
            return
        end
        currentIndex = (currentIndex % #options) + 1
        dropdown.Text = "  " .. options[currentIndex]
        callback(options[currentIndex], currentIndex)
    end)
    
    dropdown.MouseEnter:Connect(function()
        if not isEnabled then return end
        TweenService:Create(dropdown, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.ButtonHover
        }):Play()
    end)
    
    dropdown.MouseLeave:Connect(function()
        if not isEnabled then return end
        TweenService:Create(dropdown, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.Button
        }):Play()
    end)
    
    return card
end

local function addKeybind(text, defaultKey, callback, featureName)
    local isEnabled = isFeatureEnabled(featureName)
    local isDisabled = not isEnabled
    
    local card = Instance.new("Frame", contentScroll)
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.Card
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 6)
    
    if isDisabled then
        local lockIcon = Instance.new("TextLabel", card)
        lockIcon.Size = UDim2.new(0, 20, 0, 20)
        lockIcon.Position = UDim2.new(0, 8, 0.5, -10)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔒"
        lockIcon.Font = Enum.Font.Gotham
        lockIcon.TextSize = 12
        lockIcon.TextColor3 = COLORS.TextMuted
        lockIcon.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 250, 1, 0)
    label.Position = UDim2.new(0, isDisabled and 32 or 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    if isDisabled then
        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 65, 0, 16)
        badge.Position = UDim2.new(0.5, -32, 0.5, -8)
        badge.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
        badge.BackgroundTransparency = 0.6
        badge.BorderSizePixel = 0
        badge.Text = "PREMIUM"
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 8
        badge.TextColor3 = Color3.fromRGB(255, 200, 100)
        badge.TextXAlignment = Enum.TextXAlignment.Center
        local badgeCorner = Instance.new("UICorner", badge)
        badgeCorner.CornerRadius = UDim.new(0, 3)
    end
    
    local keyBtn = Instance.new("TextButton", card)
    keyBtn.Size = UDim2.new(0, 80, 0, 28)
    keyBtn.Position = UDim2.new(1, -92, 0.5, -14)
    keyBtn.BackgroundColor3 = isDisabled and COLORS.Disabled or COLORS.Button
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = typeof(defaultKey) == "EnumItem" and defaultKey.Name or "RMB"
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 10
    keyBtn.TextColor3 = isDisabled and COLORS.DisabledText or COLORS.Accent
    keyBtn.AutoButtonColor = false
    local keyCorner = Instance.new("UICorner", keyBtn)
    keyCorner.CornerRadius = UDim.new(0, 6)
    
    local listening = false
    
    keyBtn.MouseButton1Click:Connect(function()
        if not isEnabled then
            local notif = Instance.new("Frame", gui)
            notif.Size = UDim2.new(0, 200, 0, 30)
            notif.Position = UDim2.new(0.5, -100, 0.8, 0)
            notif.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
            notif.BorderSizePixel = 0
            local notifCorner = Instance.new("UICorner", notif)
            notifCorner.CornerRadius = UDim.new(0, 6)
            local notifText = Instance.new("TextLabel", notif)
            notifText.Size = UDim2.new(1, 0, 1, 0)
            notifText.BackgroundTransparency = 1
            notifText.Text = "🔒 Premium Feature - Upgrade to use"
            notifText.Font = Enum.Font.Gotham
            notifText.TextSize = 10
            notifText.TextColor3 = Color3.fromRGB(255, 200, 100)
            notifText.TextXAlignment = Enum.TextXAlignment.Center
            task.delay(2, function()
                notif:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
                task.delay(0.3, function() notif:Destroy() end)
            end)
            return
        end
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = COLORS.Danger
        TweenService:Create(keyBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        }):Play()
    end)
    
    keyBtn.MouseEnter:Connect(function()
        if not listening and isEnabled then
            TweenService:Create(keyBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = COLORS.ButtonHover
            }):Play()
        end
    end)
    
    keyBtn.MouseLeave:Connect(function()
        if not listening and isEnabled then
            TweenService:Create(keyBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = COLORS.Button
            }):Play()
        end
    end)
    
    UIS.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = COLORS.Accent
            TweenService:Create(keyBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = COLORS.Button
            }):Play()
            listening = false
            callback(input.KeyCode)
        elseif listening and input.UserInputType == Enum.UserInputType.MouseButton2 then
            keyBtn.Text = "RMB"
            keyBtn.TextColor3 = COLORS.Accent
            TweenService:Create(keyBtn, TweenInfo.new(0.15), {
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
        Aimbot = "Configure aimbot settings (Free Version)",
        Visuals = "Customize ESP and visual settings",
        Settings = "Application preferences"
    }
    contentTitle.Text = tabName
    contentSubtitle.Text = subtitles[tabName] or ""
    
    for name, tab in pairs(tabs) do
        local isActive = (name == tabName)
        local indicator = tab:FindFirstChild("Indicator")
        local label = tab:FindFirstChild("Label")
        
        TweenService:Create(tab, TweenInfo.new(0.25), {
            BackgroundColor3 = isActive and COLORS.TabActive or COLORS.TabInactive
        }):Play()
        
        if indicator then
            TweenService:Create(indicator, TweenInfo.new(0.25), {
                BackgroundColor3 = isActive and COLORS.Accent or COLORS.TextMuted
            }):Play()
        end
        
        if label then
            TweenService:Create(label, TweenInfo.new(0.25), {
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
        -- Aimbot Section (FREE)
        addElement(addSection("Aimbot Settings"))
        addElement(addToggle("Enable Aimbot", Configuration.Aimbot, function(v) Configuration.Aimbot = v end, "Aimbot"))
        addElement(addToggle("One Press Mode", Configuration.OnePressAimingMode, function(v) Configuration.OnePressAimingMode = v end, "OnePressAimingMode"))
        addElement(addKeybind("Aim Key", Configuration.AimKey, function(v) Configuration.AimKey = v end, "AimKey"))
        
        local aimModes = {"Mouse", "Camera"}
        if not HAS_MOUSEMOVEREL then aimModes = {"Camera"} end
        addElement(addDropdown("Aim Mode", aimModes, 1, function(opt) Configuration.AimMode = opt end, "AimMode"))
        addElement(addDropdown("Aim Part", Configuration.AimPartDropdownValues, 1, function(opt) Configuration.AimPart = opt end, "AimPart"))
        addElement(addSlider("FOV Radius", 10, 500, Configuration.FoVRadius, function(v) Configuration.FoVRadius = v end, nil, "FoVRadius"))
        addElement(addToggle("Show FOV Circle", Configuration.FoVCheck, function(v) Configuration.FoVCheck = v; ShowingFoV = v end, "FoVCheck"))
        addElement(addToggle("Mouse Smoothing", Configuration.UseSensitivity, function(v) Configuration.UseSensitivity = v end, "UseSensitivity"))
        addElement(addSlider("Smoothness", 10, 100, Configuration.Sensitivity, function(v) Configuration.Sensitivity = v end, "%", "Sensitivity"))
        
        -- SILENT AIM - DISABLED
        addElement(addSection("Silent Aim (Premium)"))
        addElement(addToggle("Enable Silent Aim", false, function(v) Configuration.SilentAim = v end, "SilentAim"))
        addElement(addToggle("Always On (No Key)", false, function(v) Configuration.AlwaysOnSilent = v end, "AlwaysOnSilent"))
        addElement(addKeybind("Silent Aim Key", Configuration.SilentAimKey, function(v) Configuration.SilentAimKey = v end, "SilentAimKey"))
        addElement(addToggle("Show Silent FOV", false, function(v) Configuration.ShowSilentFOV = v end, "ShowSilentFOV"))
        addElement(addSlider("Silent FOV Radius", 10, 500, 150, function(v) Configuration.SilentFOVRadius = v end, nil, "SilentFOVRadius"))
        addElement(addToggle("Use Prediction", false, function(v) Configuration.SilentPrediction = v end, "SilentPrediction"))
        addElement(addSlider("Prediction X", 0, 2, 1, function(v) Configuration.SilentPredictionX = v end, nil, "SilentPredictionX"))
        addElement(addSlider("Prediction Y", 0, 2, 1, function(v) Configuration.SilentPredictionY = v end, nil, "SilentPredictionY"))
        addElement(addToggle("Target Visualizer", false, function(v) Configuration.SilentVisualizer = v end, "SilentVisualizer"))
        addElement(addDropdown("Target Bone", Configuration.SilentBoneDropdownValues, 1, function(opt) Configuration.SilentTargetBone = opt end, "SilentTargetBone"))
        
        -- TRIGGERBOT - DISABLED
        addElement(addSection("TriggerBot (Premium)"))
        if HAS_MOUSE1CLICK then
            addElement(addToggle("Enable TriggerBot", false, function(v) Configuration.TriggerBot = v end, "TriggerBot"))
            addElement(addToggle("One Press Mode", false, function(v) Configuration.OnePressTriggeringMode = v end, "OnePressTriggeringMode"))
            addElement(addToggle("Smart Trigger", false, function(v) Configuration.SmartTriggerBot = v end, "SmartTriggerBot"))
            addElement(addKeybind("Trigger Key", Configuration.TriggerKey, function(v) Configuration.TriggerKey = v end, "TriggerKey"))
            addElement(addSlider("Trigger Chance", 1, 100, 100, function(v) Configuration.TriggerBotChance = v end, "%", "TriggerBotChance"))
        else
            local noSupport = Instance.new("Frame", contentScroll)
            noSupport.Size = UDim2.new(1, 0, 0, 30)
            noSupport.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
            noSupport.BorderSizePixel = 0
            local noCorner = Instance.new("UICorner", noSupport)
            noCorner.CornerRadius = UDim.new(0, 6)
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
        
        -- TARGET CHECKS - ALL DISABLED except AliveCheck
        addElement(addSection("Target Checks (Premium)"))
        addElement(addToggle("Alive Check", true, function(v) Configuration.AliveCheck = v end, "AliveCheck"))
        addElement(addToggle("Team Check", false, function(v) Configuration.TeamCheck = v end, "TeamCheck"))
        addElement(addToggle("Wall Check", false, function(v) Configuration.WallCheck = v end, "WallCheck"))
        addElement(addToggle("Friend Check", false, function(v) Configuration.FriendCheck = v end, "FriendCheck"))
        addElement(addToggle("Off After Kill", false, function(v) Configuration.OffAimbotAfterKill = v end, "OffAimbotAfterKill"))
        addElement(addToggle("God Check", false, function(v) Configuration.GodCheck = v end, "GodCheck"))
        addElement(addToggle("Follow Check", false, function(v) Configuration.FollowCheck = v end, "FollowCheck"))
        addElement(addToggle("Verified Badge Check", false, function(v) Configuration.VerifiedBadgeCheck = v end, "VerifiedBadgeCheck"))
        
        -- OFFSET - DISABLED
        addElement(addSection("Offset (Premium)"))
        addElement(addToggle("Use Offset", false, function(v) Configuration.UseOffset = v end, "UseOffset"))
        addElement(addSlider("Static Offset", 0, 50, 10, function(v) Configuration.StaticOffsetIncrement = v end, nil, "StaticOffsetIncrement"))
        addElement(addToggle("Auto Offset", false, function(v) Configuration.AutoOffset = v end, "AutoOffset"))
        
        -- NOISE - DISABLED
        addElement(addSection("Noise (Premium)"))
        addElement(addToggle("Use Noise", false, function(v) Configuration.UseNoise = v end, "UseNoise"))
        addElement(addSlider("Noise Frequency", 0, 100, 50, function(v) Configuration.NoiseFrequency = v end, nil, "NoiseFrequency"))
        
    elseif tabName == "Visuals" then
        -- VISUALS - Box ESP and Name ESP only (ENABLED & TOGGLEABLE)
        addElement(addSection("ESP Settings (Free)"))
        addElement(addToggle("Box ESP", Configuration.ESPBox, function(v) 
            Configuration.ESPBox = v
            ShowingESP = Configuration.ESPBox or Configuration.NameESP
        end, "ESPBox"))
        addElement(addToggle("Name ESP", Configuration.NameESP, function(v) 
            Configuration.NameESP = v
            ShowingESP = Configuration.ESPBox or Configuration.NameESP
        end, "NameESP"))
        
        -- DISABLED VISUALS (Premium)
        addElement(addSection("Advanced ESP (Premium)"))
        addElement(addToggle("Cornered Box", false, function(v) Configuration.CorneredBox = v end, "CorneredBox"))
        addElement(addSlider("Corner Length", 2, 20, 6, function(v) Configuration.CornerLength = v end, nil, "CornerLength"))
        addElement(addToggle("Tracer ESP", false, function(v) Configuration.TracerESP = v end, "TracerESP"))
        addElement(addToggle("Health ESP", false, function(v) Configuration.HealthESP = v end, "HealthESP"))
        addElement(addToggle("Skeleton ESP", false, function(v) Configuration.SkeletonESP = v end, "SkeletonESP"))
        addElement(addToggle("Highlight ESP", false, function(v) Configuration.HighlightESP = v end, "HighlightESP"))
        addElement(addToggle("Head Circle", false, function(v) Configuration.HeadCircle = v end, "HeadCircle"))
        addElement(addToggle("Rainbow ESP", false, function(v) Configuration.RainbowVisuals = v end, "RainbowVisuals"))
        addElement(addSlider("Rainbow Speed", 1, 10, 5, function(v) Configuration.RainbowDelay = v end, nil, "RainbowDelay"))
        
        -- ESP styling (FREE)
        addElement(addSection("ESP Styling"))
        addElement(addSlider("ESP Thickness", 1, 5, 2, function(v) Configuration.ESPThickness = v end, nil, "ESPThickness"))
        addElement(addSlider("ESP Opacity", 0.1, 1, 0.8, function(v) Configuration.ESPOpacity = v end, nil, "ESPOpacity"))
        addElement(addToggle("Filled Box", Configuration.ESPBoxFilled, function(v) Configuration.ESPBoxFilled = v end, "ESPBoxFilled"))
        
    elseif tabName == "Settings" then
        addElement(addSection("UI Settings"))
        addElement(addKeybind("Toggle UI Key", Enum.KeyCode.RightShift, function(v) Configuration.ToggleKey = v end, "ToggleKey"))
        
        addElement(addSection("About"))
        local aboutCard = Instance.new("Frame", contentScroll)
        aboutCard.Size = UDim2.new(1, 0, 0, 80)
        aboutCard.BackgroundColor3 = COLORS.Card
        aboutCard.BorderSizePixel = 0
        local aboutCorner = Instance.new("UICorner", aboutCard)
        aboutCorner.CornerRadius = UDim.new(0, 6)
        addElement(aboutCard)
        
        local aboutTitle = Instance.new("TextLabel", aboutCard)
        aboutTitle.Size = UDim2.new(1, -20, 0, 24)
        aboutTitle.Position = UDim2.new(0, 10, 0, 10)
        aboutTitle.BackgroundTransparency = 1
        aboutTitle.Text = "Undercover Free"
        aboutTitle.Font = Enum.Font.GothamBold
        aboutTitle.TextSize = 14
        aboutTitle.TextColor3 = COLORS.Text
        
        local aboutInfo = Instance.new("TextLabel", aboutCard)
        aboutInfo.Size = UDim2.new(1, -20, 0, 18)
        aboutInfo.Position = UDim2.new(0, 10, 0, 34)
        aboutInfo.BackgroundTransparency = 1
        aboutInfo.Text = "Free Version v2.05  •  .gg/SoftwareShopz"
        aboutInfo.Font = Enum.Font.Gotham
        aboutInfo.TextSize = 10
        aboutInfo.TextColor3 = COLORS.TextMuted
        
        local aboutDiscord = Instance.new("TextLabel", aboutCard)
        aboutDiscord.Size = UDim2.new(1, -20, 0, 18)
        aboutDiscord.Position = UDim2.new(0, 10, 0, 52)
        aboutDiscord.BackgroundTransparency = 1
        aboutDiscord.Text = "🔒 Premium Features Locked - Upgrade to Unlock"
        aboutDiscord.Font = Enum.Font.Gotham
        aboutDiscord.TextSize = 10
        aboutDiscord.TextColor3 = Color3.fromRGB(255, 200, 100)
        aboutDiscord.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Premium upgrade
        addElement(addSection("Premium Upgrade"))
        local premiumCard = Instance.new("Frame", contentScroll)
        premiumCard.Size = UDim2.new(1, 0, 0, 60)
        premiumCard.BackgroundColor3 = Color3.fromRGB(40, 35, 20)
        premiumCard.BorderSizePixel = 0
        local premiumCardCorner = Instance.new("UICorner", premiumCard)
        premiumCardCorner.CornerRadius = UDim.new(0, 6)
        addElement(premiumCard)
        
        local premiumTitle = Instance.new("TextLabel", premiumCard)
        premiumTitle.Size = UDim2.new(1, -20, 0, 20)
        premiumTitle.Position = UDim2.new(0, 10, 0, 8)
        premiumTitle.BackgroundTransparency = 1
        premiumTitle.Text = "⭐ Upgrade to Premium"
        premiumTitle.Font = Enum.Font.GothamBold
        premiumTitle.TextSize = 13
        premiumTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
        premiumTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local premiumDesc = Instance.new("TextLabel", premiumCard)
        premiumDesc.Size = UDim2.new(1, -20, 0, 16)
        premiumDesc.Position = UDim2.new(0, 10, 0, 30)
        premiumDesc.BackgroundTransparency = 1
        premiumDesc.Text = "Unlock Silent Aim, TriggerBot, Advanced ESP & More"
        premiumDesc.Font = Enum.Font.Gotham
        premiumDesc.TextSize = 10
        premiumDesc.TextColor3 = COLORS.TextSecondary
        premiumDesc.TextXAlignment = Enum.TextXAlignment.Left
        
        local premiumBtn = Instance.new("TextButton", premiumCard)
        premiumBtn.Size = UDim2.new(0, 120, 0, 28)
        premiumBtn.Position = UDim2.new(1, -130, 0.5, -14)
        premiumBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        premiumBtn.BorderSizePixel = 0
        premiumBtn.Text = "BUY NOW"
        premiumBtn.Font = Enum.Font.GothamBold
        premiumBtn.TextSize = 11
        premiumBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
        local premiumBtnCorner = Instance.new("UICorner", premiumBtn)
        premiumBtnCorner.CornerRadius = UDim.new(0, 6)
        
        premiumBtn.MouseButton1Click:Connect(function()
            local notif = Instance.new("Frame", gui)
            notif.Size = UDim2.new(0, 300, 0, 40)
            notif.Position = UDim2.new(0.5, -150, 0.8, 0)
            notif.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            notif.BorderSizePixel = 0
            local notifCorner = Instance.new("UICorner", notif)
            notifCorner.CornerRadius = UDim.new(0, 8)
            local notifText = Instance.new("TextLabel", notif)
            notifText.Size = UDim2.new(1, 0, 1, 0)
            notifText.BackgroundTransparency = 1
            notifText.Text = "💳 Visit .gg/SoftwareShopz to upgrade!"
            notifText.Font = Enum.Font.Gotham
            notifText.TextSize = 11
            notifText.TextColor3 = Color3.fromRGB(255, 200, 100)
            notifText.TextXAlignment = Enum.TextXAlignment.Center
            task.delay(3, function()
                notif:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
                task.delay(0.3, function() notif:Destroy() end)
            end)
        end)
    end
    
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end

-- Connect tabs
for name, tab in pairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Aimbot")

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- ================= ISREADY FUNCTION =================
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

-- ================= ESP FUNCTIONS =================

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
        
        -- Box ESP (FREE - ENABLED & TOGGLEABLE)
        pBox.Visible = Configuration.ESPBox
        if Configuration.ESPBox then
            pBox.Size = Vector2.new(boxWidth, boxHeight)
            pBox.Position = boxPos
            pBox.Color = Configuration.ESPColour
            pBox.Thickness = Configuration.ESPThickness
            pBox.Transparency = Configuration.ESPOpacity
            pBox.Filled = Configuration.ESPBoxFilled
        end
        
        -- Name ESP (FREE - ENABLED)
        pName.Visible = Configuration.NameESP
        if Configuration.NameESP then
            pName.Position = Vector2.new(center.X, boxPos.Y - 16)
            pName.Color = Configuration.ESPColour
            pName.Size = 12
            pName.Outline = true
            pName.OutlineColor = Color3.fromRGB(0, 0, 0)
            pName.OutlineTransparency = 0.3
        end
        
        -- ALL OTHER ESP TYPES ARE DISABLED
        for i = 1, 8 do pCorneredBoxLines[i].Visible = false end
        pHealth.Visible = false
        pTracer.Visible = false
        pHeadCircle.Visible = false
        pHighlight.Visible = false
        for i = 1, #pSkeleton do pSkeleton[i].Visible = false end
        
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
            
            -- ONLY Box ESP and Name ESP are rendered (both TOGGLEABLE)
            if onScreen and (Configuration.ESPBox or Configuration.NameESP) then
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
                    
                    -- Box ESP (FREE - TOGGLEABLE)
                    esp.Box.Visible = Configuration.ESPBox
                    if Configuration.ESPBox then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = topLeft
                        esp.Box.Color = Configuration.ESPColour
                        esp.Box.Thickness = Configuration.ESPThickness
                        esp.Box.Transparency = Configuration.ESPOpacity
                        esp.Box.Filled = Configuration.ESPBoxFilled
                    end
                    
                    -- Name ESP (FREE - TOGGLEABLE)
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
                    
                    -- ALL OTHER ESP TYPES DISABLED
                    esp.Tracer.Visible = false
                    esp.Health.Visible = false
                    if HeadCircles[plr] then HeadCircles[plr].Visible = false end
                    if CorneredBoxLines[plr] then
                        for _, l in ipairs(CorneredBoxLines[plr]) do l:Remove() end
                        CorneredBoxLines[plr] = {}
                    end
                    if SkeletonLines[plr] then
                        for _, l in ipairs(SkeletonLines[plr]) do l:Remove() end
                        SkeletonLines[plr] = {}
                    end
                    if Highlights[plr] and Highlights[plr].Parent then
                        Highlights[plr]:Destroy(); Highlights[plr] = nil
                    end
                else
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                end
            else
                for _, d in pairs(esp) do d.Visible = false end
            end
        else
            for _, d in pairs(esp) do d.Visible = false end
            if SkeletonLines[plr] then for _, l in ipairs(SkeletonLines[plr]) do l.Visible = false end end
            if Highlights[plr] and Highlights[plr].Parent then Highlights[plr]:Destroy(); Highlights[plr] = nil end
            if HeadCircles[plr] then HeadCircles[plr].Visible = false end
        end
    end
    
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
end)

-- Cleanup
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "UndercoverSlotted" then
        for plr, esp in pairs(ESP) do
            for _, d in pairs(esp) do d:Remove() end
        end
        for plr, lines in pairs(CorneredBoxLines) do
            for _, l in ipairs(lines) do l:Remove() end
        end
    end
end)