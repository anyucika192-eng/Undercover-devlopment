--==================================================
-- Undercover Slotted - Loader System v3.1
-- Free & Paid Key Support - Final
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ================= COLOR SCHEME =================
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
    Locked = Color3.fromRGB(60, 60, 70),
    Unavailable = Color3.fromRGB(40, 30, 30),
    Gold = Color3.fromRGB(255, 215, 0),
}

-- ================= REMOVE OLD UI =================
pcall(function()
    game.CoreGui.UndercoverSlotted:Destroy()
end)

-- ================= MAIN GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UndercoverSlotted"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true

-- ================= KEY WINDOW =================
local keyWindow = Instance.new("Frame", gui)
keyWindow.Size = UDim2.new(0, 420, 0, 240)
keyWindow.Position = UDim2.new(0.5, -210, 0.5, -120)
keyWindow.BackgroundColor3 = COLORS.Background
keyWindow.BorderSizePixel = 0
keyWindow.ClipsDescendants = true
local keyCorner = Instance.new("UICorner", keyWindow)
keyCorner.CornerRadius = UDim.new(0, 12)

local keyBorder = Instance.new("UIStroke", keyWindow)
keyBorder.Color = COLORS.Border
keyBorder.Thickness = 1
keyBorder.Transparency = 0.3

-- Key Window Shadow
local keyShadow = Instance.new("Frame", keyWindow)
keyShadow.Size = UDim2.new(1, 20, 1, 20)
keyShadow.Position = UDim2.new(0, -10, 0, -10)
keyShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyShadow.BackgroundTransparency = 0.6
keyShadow.BorderSizePixel = 0
keyShadow.ZIndex = 0
local keyShadowCorner = Instance.new("UICorner", keyShadow)
keyShadowCorner.CornerRadius = UDim.new(0, 12)

-- Key Window Title Bar
local keyTitleBar = Instance.new("Frame", keyWindow)
keyTitleBar.Size = UDim2.new(1, 0, 0, 36)
keyTitleBar.BackgroundColor3 = COLORS.TitleBar
keyTitleBar.BorderSizePixel = 0

local keyTitleLine = Instance.new("Frame", keyTitleBar)
keyTitleLine.Size = UDim2.new(1, 0, 0, 1)
keyTitleLine.Position = UDim2.new(0, 0, 1, -1)
keyTitleLine.BackgroundColor3 = COLORS.Border
keyTitleLine.BorderSizePixel = 0
keyTitleLine.BackgroundTransparency = 0.3

local keyTitleText = Instance.new("TextLabel", keyTitleBar)
keyTitleText.Size = UDim2.new(1, 0, 1, 0)
keyTitleText.BackgroundTransparency = 1
keyTitleText.Text = "Loader"
keyTitleText.Font = Enum.Font.GothamBold
keyTitleText.TextSize = 13
keyTitleText.TextColor3 = COLORS.Text
keyTitleText.TextXAlignment = Enum.TextXAlignment.Center
keyTitleText.TextYAlignment = Enum.TextYAlignment.Center
keyTitleText.TextTransparency = 0.7

local keyAccentDot = Instance.new("Frame", keyTitleBar)
keyAccentDot.Size = UDim2.new(0, 5, 0, 5)
keyAccentDot.Position = UDim2.new(0.5, 75, 0.5, -2.5)
keyAccentDot.BackgroundColor3 = COLORS.Accent
keyAccentDot.BorderSizePixel = 0
local keyDotCorner = Instance.new("UICorner", keyAccentDot)
keyDotCorner.CornerRadius = UDim.new(1, 0)

-- Key Window Content
local keyContent = Instance.new("Frame", keyWindow)
keyContent.Size = UDim2.new(1, -40, 1, -56)
keyContent.Position = UDim2.new(0, 20, 0, 42)
keyContent.BackgroundTransparency = 1

local keyLabel = Instance.new("TextLabel", keyContent)
keyLabel.Size = UDim2.new(1, 0, 0, 20)
keyLabel.Position = UDim2.new(0, 0, 0, 4)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "ENTER ACTIVATION KEY"
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 12
keyLabel.TextColor3 = COLORS.TextSecondary
keyLabel.TextXAlignment = Enum.TextXAlignment.Center

local keySubLabel = Instance.new("TextLabel", keyContent)
keySubLabel.Size = UDim2.new(1, 0, 0, 16)
keySubLabel.Position = UDim2.new(0, 0, 0, 26)
keySubLabel.BackgroundTransparency = 1
keySubLabel.Text = "Enter your product key to continue"
keySubLabel.Font = Enum.Font.Gotham
keySubLabel.TextSize = 9
keySubLabel.TextColor3 = COLORS.TextMuted
keySubLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Key Input Box
local keyInputFrame = Instance.new("Frame", keyContent)
keyInputFrame.Size = UDim2.new(1, 0, 0, 34)
keyInputFrame.Position = UDim2.new(0, 0, 0, 50)
keyInputFrame.BackgroundColor3 = COLORS.Card
keyInputFrame.BorderSizePixel = 0
local keyInputCorner = Instance.new("UICorner", keyInputFrame)
keyInputCorner.CornerRadius = UDim.new(0, 6)

local keyInputBorder = Instance.new("UIStroke", keyInputFrame)
keyInputBorder.Color = COLORS.BorderLight
keyInputBorder.Thickness = 1

local keyInput = Instance.new("TextBox", keyInputFrame)
keyInput.Size = UDim2.new(1, -16, 1, 0)
keyInput.Position = UDim2.new(0, 8, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.Text = ""
keyInput.PlaceholderText = "Enter key..."
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 13
keyInput.TextColor3 = COLORS.Text
keyInput.PlaceholderColor3 = COLORS.TextMuted
keyInput.ClearTextOnFocus = true

-- Key Error Label
local keyError = Instance.new("TextLabel", keyContent)
keyError.Size = UDim2.new(1, 0, 0, 14)
keyError.Position = UDim2.new(0, 0, 0, 90)
keyError.BackgroundTransparency = 1
keyError.Text = ""
keyError.Font = Enum.Font.Gotham
keyError.TextSize = 9
keyError.TextColor3 = COLORS.Danger
keyError.TextXAlignment = Enum.TextXAlignment.Center
keyError.Visible = false

-- Key Buttons
local keyButtonFrame = Instance.new("Frame", keyContent)
keyButtonFrame.Size = UDim2.new(1, 0, 0, 32)
keyButtonFrame.Position = UDim2.new(0, 0, 0, 114)
keyButtonFrame.BackgroundTransparency = 1

local keyUnlockBtn = Instance.new("TextButton", keyButtonFrame)
keyUnlockBtn.Size = UDim2.new(0.45, -6, 1, 0)
keyUnlockBtn.Position = UDim2.new(0, 0, 0, 0)
keyUnlockBtn.BackgroundColor3 = COLORS.Accent
keyUnlockBtn.BorderSizePixel = 0
keyUnlockBtn.Text = "UNLOCK"
keyUnlockBtn.Font = Enum.Font.GothamBold
keyUnlockBtn.TextSize = 11
keyUnlockBtn.TextColor3 = COLORS.Text
keyUnlockBtn.AutoButtonColor = false
local keyUnlockCorner = Instance.new("UICorner", keyUnlockBtn)
keyUnlockCorner.CornerRadius = UDim.new(0, 6)

local keyCloseBtn = Instance.new("TextButton", keyButtonFrame)
keyCloseBtn.Size = UDim2.new(0.45, -6, 1, 0)
keyCloseBtn.Position = UDim2.new(0.55, 6, 0, 0)
keyCloseBtn.BackgroundColor3 = COLORS.Button
keyCloseBtn.BorderSizePixel = 0
keyCloseBtn.Text = "CLOSE"
keyCloseBtn.Font = Enum.Font.GothamBold
keyCloseBtn.TextSize = 11
keyCloseBtn.TextColor3 = COLORS.TextSecondary
keyCloseBtn.AutoButtonColor = false
local keyCloseCorner = Instance.new("UICorner", keyCloseBtn)
keyCloseCorner.CornerRadius = UDim.new(0, 6)

-- Button Hover Effects
keyUnlockBtn.MouseEnter:Connect(function()
    TweenService:Create(keyUnlockBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    }):Play()
end)
keyUnlockBtn.MouseLeave:Connect(function()
    TweenService:Create(keyUnlockBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.Accent
    }):Play()
end)

keyCloseBtn.MouseEnter:Connect(function()
    TweenService:Create(keyCloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.ButtonHover
    }):Play()
end)
keyCloseBtn.MouseLeave:Connect(function()
    TweenService:Create(keyCloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.Button
    }):Play()
end)

-- ================= KEY VALIDATION =================
local enteredKey = nil

local function ValidateKey(inputKey)
    local lower = inputKey:lower()
    if lower == "free" then
        return true, "free"
    elseif lower == "550E8400-E29B-41D4-A716-446655440000" then
        return true, "550E8400-E29B-41D4-A716-446655440000"
    end
    return false, nil
end

local function ShowKeyError(text)
    keyError.Text = text
    keyError.Visible = true
    keyError.TextColor3 = COLORS.Danger
    TweenService:Create(keyError, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(keyInputFrame, TweenInfo.new(0.05), {
        Position = UDim2.new(0, 2, 0, 50)
    }):Play()
    task.wait(0.05)
    TweenService:Create(keyInputFrame, TweenInfo.new(0.05), {
        Position = UDim2.new(0, -2, 0, 50)
    }):Play()
    task.wait(0.05)
    TweenService:Create(keyInputFrame, TweenInfo.new(0.05), {
        Position = UDim2.new(0, 0, 0, 50)
    }):Play()
end

-- ================= LOADER WINDOW =================
local loaderWindow = Instance.new("Frame", gui)
loaderWindow.Size = UDim2.new(0, 640, 0, 380)
loaderWindow.Position = UDim2.new(0.5, -320, 0.5, -190)
loaderWindow.BackgroundColor3 = COLORS.Background
loaderWindow.BorderSizePixel = 0
loaderWindow.ClipsDescendants = true
loaderWindow.Visible = false
local loaderCorner = Instance.new("UICorner", loaderWindow)
loaderCorner.CornerRadius = UDim.new(0, 12)

local loaderBorder = Instance.new("UIStroke", loaderWindow)
loaderBorder.Color = COLORS.Border
loaderBorder.Thickness = 1
loaderBorder.Transparency = 0.3

-- Loader Window Shadow
local loaderShadow = Instance.new("Frame", loaderWindow)
loaderShadow.Size = UDim2.new(1, 20, 1, 20)
loaderShadow.Position = UDim2.new(0, -10, 0, -10)
loaderShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loaderShadow.BackgroundTransparency = 0.6
loaderShadow.BorderSizePixel = 0
loaderShadow.ZIndex = 0
local loaderShadowCorner = Instance.new("UICorner", loaderShadow)
loaderShadowCorner.CornerRadius = UDim.new(0, 12)

-- ================= LOADER TITLE BAR =================
local loaderTitleBar = Instance.new("Frame", loaderWindow)
loaderTitleBar.Size = UDim2.new(1, 0, 0, 44)
loaderTitleBar.BackgroundColor3 = COLORS.TitleBar
loaderTitleBar.BorderSizePixel = 0

local loaderTitleLine = Instance.new("Frame", loaderTitleBar)
loaderTitleLine.Size = UDim2.new(1, 0, 0, 1)
loaderTitleLine.Position = UDim2.new(0, 0, 1, -1)
loaderTitleLine.BackgroundColor3 = COLORS.Border
loaderTitleLine.BorderSizePixel = 0
loaderTitleLine.BackgroundTransparency = 0.3

-- Left: Title
local loaderTitleText = Instance.new("TextLabel", loaderTitleBar)
loaderTitleText.Size = UDim2.new(0, 180, 1, 0)
loaderTitleText.Position = UDim2.new(0, 16, 0, 0)
loaderTitleText.BackgroundTransparency = 1
loaderTitleText.Text = "Loader"
loaderTitleText.Font = Enum.Font.GothamBlack
loaderTitleText.TextSize = 14
loaderTitleText.TextColor3 = COLORS.Text
loaderTitleText.TextXAlignment = Enum.TextXAlignment.Left
loaderTitleText.TextYAlignment = Enum.TextYAlignment.Center

local loaderSubTitle = Instance.new("TextLabel", loaderTitleBar)
loaderSubTitle.Size = UDim2.new(0, 120, 0, 14)
loaderSubTitle.Position = UDim2.new(0, 16, 0, 28)
loaderSubTitle.BackgroundTransparency = 1
loaderSubTitle.Text = "v2.0 Select Version"
loaderSubTitle.Font = Enum.Font.Gotham
loaderSubTitle.TextSize = 9
loaderSubTitle.TextColor3 = COLORS.TextMuted
loaderSubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Right: Discord
local changelogText = Instance.new("TextLabel", loaderTitleBar)
changelogText.Size = UDim2.new(0, 160, 1, 0)
changelogText.Position = UDim2.new(1, -176, 0, 0)
changelogText.BackgroundTransparency = 1
changelogText.Text = ".gg/SoftwareShopz"
changelogText.Font = Enum.Font.GothamBold
changelogText.TextSize = 10
changelogText.TextColor3 = COLORS.TextMuted
changelogText.TextXAlignment = Enum.TextXAlignment.Right
changelogText.TextYAlignment = Enum.TextYAlignment.Center
changelogText.TextTransparency = 0.5

-- ================= LOADER CONTENT =================
local loaderContent = Instance.new("Frame", loaderWindow)
loaderContent.Size = UDim2.new(1, -32, 1, -74)
loaderContent.Position = UDim2.new(0, 16, 0, 50)
loaderContent.BackgroundTransparency = 1

-- ================= LEFT SIDE - CHARACTER + VERSIONS =================
local leftSide = Instance.new("Frame", loaderContent)
leftSide.Size = UDim2.new(0, 200, 1, 0)
leftSide.BackgroundTransparency = 1

-- Character Preview (Top Left)
local charPreview = Instance.new("Frame", leftSide)
charPreview.Size = UDim2.new(1, 0, 0, 140)
charPreview.BackgroundColor3 = COLORS.Card
charPreview.BorderSizePixel = 0
local charCorner = Instance.new("UICorner", charPreview)
charCorner.CornerRadius = UDim.new(0, 8)

local charBorder = Instance.new("UIStroke", charPreview)
charBorder.Color = COLORS.BorderLight
charBorder.Thickness = 1

-- Avatar Image
local avatarImage = Instance.new("ImageLabel", charPreview)
avatarImage.Size = UDim2.new(0, 72, 0, 72)
avatarImage.Position = UDim2.new(0.5, -36, 0, 16)
avatarImage.BackgroundColor3 = COLORS.Border
avatarImage.BorderSizePixel = 0
local avatarCorner = Instance.new("UICorner", avatarImage)
avatarCorner.CornerRadius = UDim.new(1, 0)

-- Username
local loaderUsername = Instance.new("TextLabel", charPreview)
loaderUsername.Size = UDim2.new(1, -16, 0, 20)
loaderUsername.Position = UDim2.new(0, 8, 0, 96)
loaderUsername.BackgroundTransparency = 1
loaderUsername.Text = LocalPlayer.Name
loaderUsername.Font = Enum.Font.GothamBold
loaderUsername.TextSize = 13
loaderUsername.TextColor3 = COLORS.Text
loaderUsername.TextXAlignment = Enum.TextXAlignment.Center
loaderUsername.TextTruncate = Enum.TextTruncate.AtEnd

-- Status
local loaderStatus = Instance.new("TextLabel", charPreview)
loaderStatus.Size = UDim2.new(1, -16, 0, 16)
loaderStatus.Position = UDim2.new(0, 8, 0, 118)
loaderStatus.BackgroundTransparency = 1
loaderStatus.Text = "● Select a version"
loaderStatus.Font = Enum.Font.Gotham
loaderStatus.TextSize = 10
loaderStatus.TextColor3 = COLORS.TextMuted
loaderStatus.TextXAlignment = Enum.TextXAlignment.Center

-- ================= KEY STATUS TEXT =================
local keyStatusText = Instance.new("TextLabel", leftSide)
keyStatusText.Size = UDim2.new(1, 0, 0, 20)
keyStatusText.Position = UDim2.new(0, 0, 0, 152)
keyStatusText.BackgroundTransparency = 1
keyStatusText.Text = "Free Key"
keyStatusText.Font = Enum.Font.GothamBold
keyStatusText.TextSize = 11
keyStatusText.TextColor3 = COLORS.Accent
keyStatusText.TextXAlignment = Enum.TextXAlignment.Center
keyStatusText.TextTransparency = 0

-- ================= FREE BUTTON =================
local freeButton = Instance.new("TextButton", leftSide)
freeButton.Size = UDim2.new(1, 0, 0, 44)
freeButton.Position = UDim2.new(0, 0, 0, 178)
freeButton.BackgroundColor3 = COLORS.Card
freeButton.BorderSizePixel = 0
freeButton.Text = ""
freeButton.AutoButtonColor = false
local freeCorner = Instance.new("UICorner", freeButton)
freeCorner.CornerRadius = UDim.new(0, 6)

local freeBorder = Instance.new("UIStroke", freeButton)
freeBorder.Color = COLORS.BorderLight
freeBorder.Thickness = 1
freeBorder.Transparency = 0.3

local freeLabel = Instance.new("TextLabel", freeButton)
freeLabel.Size = UDim2.new(1, -20, 0, 18)
freeLabel.Position = UDim2.new(0, 12, 0, 5)
freeLabel.BackgroundTransparency = 1
freeLabel.Text = "Free Menu"
freeLabel.Font = Enum.Font.GothamBold
freeLabel.TextSize = 12
freeLabel.TextColor3 = COLORS.Text
freeLabel.TextXAlignment = Enum.TextXAlignment.Left

local freeSub = Instance.new("TextLabel", freeButton)
freeSub.Size = UDim2.new(1, -20, 0, 14)
freeSub.Position = UDim2.new(0, 12, 0, 24)
freeSub.BackgroundTransparency = 1
freeSub.Text = "Basic features"
freeSub.Font = Enum.Font.Gotham
freeSub.TextSize = 9
freeSub.TextColor3 = COLORS.TextMuted
freeSub.TextXAlignment = Enum.TextXAlignment.Left

local freeCheck = Instance.new("TextLabel", freeButton)
freeCheck.Size = UDim2.new(0, 20, 0, 20)
freeCheck.Position = UDim2.new(1, -28, 0.5, -10)
freeCheck.BackgroundTransparency = 1
freeCheck.Text = ""
freeCheck.Font = Enum.Font.Gotham
freeCheck.TextSize = 14
freeCheck.TextColor3 = COLORS.Success
freeCheck.TextXAlignment = Enum.TextXAlignment.Center
freeCheck.Visible = false

-- ================= ULTIMATE BUTTON =================
local ultimateButton = Instance.new("TextButton", leftSide)
ultimateButton.Size = UDim2.new(1, 0, 0, 44)
ultimateButton.Position = UDim2.new(0, 0, 0, 228)
ultimateButton.BackgroundColor3 = COLORS.Card
ultimateButton.BorderSizePixel = 0
ultimateButton.Text = ""
ultimateButton.AutoButtonColor = false
ultimateButton.Visible = false
local ultimateCorner = Instance.new("UICorner", ultimateButton)
ultimateCorner.CornerRadius = UDim.new(0, 6)

local ultimateBorder = Instance.new("UIStroke", ultimateButton)
ultimateBorder.Color = COLORS.BorderLight
ultimateBorder.Thickness = 1
ultimateBorder.Transparency = 0.3

local ultimateLabel = Instance.new("TextLabel", ultimateButton)
ultimateLabel.Size = UDim2.new(1, -20, 0, 18)
ultimateLabel.Position = UDim2.new(0, 12, 0, 5)
ultimateLabel.BackgroundTransparency = 1
ultimateLabel.Text = "Ultimate Menu"
ultimateLabel.Font = Enum.Font.GothamBold
ultimateLabel.TextSize = 12
ultimateLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ultimateLabel.TextXAlignment = Enum.TextXAlignment.Left

local ultimateSub = Instance.new("TextLabel", ultimateButton)
ultimateSub.Size = UDim2.new(1, -20, 0, 14)
ultimateSub.Position = UDim2.new(0, 12, 0, 24)
ultimateSub.BackgroundTransparency = 1
ultimateSub.Text = "Premium"
ultimateSub.Font = Enum.Font.Gotham
ultimateSub.TextSize = 9
ultimateSub.TextColor3 = Color3.fromRGB(120, 80, 80)
ultimateSub.TextXAlignment = Enum.TextXAlignment.Left

local ultimateCheck = Instance.new("TextLabel", ultimateButton)
ultimateCheck.Size = UDim2.new(0, 20, 0, 20)
ultimateCheck.Position = UDim2.new(1, -28, 0.5, -10)
ultimateCheck.BackgroundTransparency = 1
ultimateCheck.Text = ""
ultimateCheck.Font = Enum.Font.Gotham
ultimateCheck.TextSize = 14
ultimateCheck.TextColor3 = COLORS.Gold
ultimateCheck.TextXAlignment = Enum.TextXAlignment.Center
ultimateCheck.Visible = false

-- ================= RIGHT SIDE - CHANGELOG AREA =================
local rightSide = Instance.new("Frame", loaderContent)
rightSide.Size = UDim2.new(1, -216, 1, 0)
rightSide.Position = UDim2.new(0, 212, 0, 0)
rightSide.BackgroundColor3 = COLORS.Card
rightSide.BorderSizePixel = 0
local rightCorner = Instance.new("UICorner", rightSide)
rightCorner.CornerRadius = UDim.new(0, 8)

local rightBorder = Instance.new("UIStroke", rightSide)
rightBorder.Color = COLORS.BorderLight
rightBorder.Thickness = 1
rightBorder.Transparency = 0.3

-- Changelog Title
local changelogTitle = Instance.new("TextLabel", rightSide)
changelogTitle.Size = UDim2.new(1, -24, 0, 28)
changelogTitle.Position = UDim2.new(0, 12, 0, 8)
changelogTitle.BackgroundTransparency = 1
changelogTitle.Text = "CHANGELOG"
changelogTitle.Font = Enum.Font.GothamBold
changelogTitle.TextSize = 12
changelogTitle.TextColor3 = COLORS.Text
changelogTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Changelog Line
local changelogLine = Instance.new("Frame", rightSide)
changelogLine.Size = UDim2.new(1, -24, 0, 1)
changelogLine.Position = UDim2.new(0, 12, 0, 40)
changelogLine.BackgroundColor3 = COLORS.BorderLight
changelogLine.BorderSizePixel = 0
changelogLine.BackgroundTransparency = 0.3

-- Changelog Scroll
local changelogScroll = Instance.new("ScrollingFrame", rightSide)
changelogScroll.Size = UDim2.new(1, -24, 1, -96)
changelogScroll.Position = UDim2.new(0, 12, 0, 48)
changelogScroll.BackgroundTransparency = 1
changelogScroll.ScrollBarThickness = 3
changelogScroll.CanvasSize = UDim2.new(0, 0, 0, 200)
changelogScroll.ScrollBarImageColor3 = COLORS.SliderTrack
changelogScroll.ScrollBarImageTransparency = 0.3

-- Changelog Content
local changelogContent = Instance.new("TextLabel", changelogScroll)
changelogContent.Size = UDim2.new(1, -12, 0, 200)
changelogContent.Position = UDim2.new(0, 0, 0, 0)
changelogContent.BackgroundTransparency = 1
changelogContent.Text = [[
v2.0
  • Loader UI updated
  • Updated Paid Menu

v1.0 - Initial Release
  • Released Loader for Free and Ultimate

📌 Next Update:
  • Ultimate Menu Features
  • More ESP Options
]]
changelogContent.Font = Enum.Font.Gotham
changelogContent.TextSize = 10
changelogContent.TextColor3 = COLORS.TextSecondary
changelogContent.TextXAlignment = Enum.TextXAlignment.Left
changelogContent.TextYAlignment = Enum.TextYAlignment.Top
changelogContent.TextWrapped = true
changelogContent.LineHeight = 1.4

-- ================= BUTTONS AT BOTTOM (Load + Exit) =================
local bottomButtonFrame = Instance.new("Frame", loaderWindow)
bottomButtonFrame.Size = UDim2.new(0, 300, 0, 38)
bottomButtonFrame.Position = UDim2.new(1, -316, 1, -52)
bottomButtonFrame.BackgroundTransparency = 1

-- LOAD Button
local loadButton = Instance.new("TextButton", bottomButtonFrame)
loadButton.Size = UDim2.new(0, 140, 1, 0)
loadButton.Position = UDim2.new(0, 0, 0, 0)
loadButton.BackgroundColor3 = COLORS.Accent
loadButton.BorderSizePixel = 0
loadButton.Text = "▶ LOAD"
loadButton.Font = Enum.Font.GothamBold
loadButton.TextSize = 13
loadButton.TextColor3 = COLORS.Text
loadButton.AutoButtonColor = false
loadButton.TextTransparency = 0.4
local loadCorner = Instance.new("UICorner", loadButton)
loadCorner.CornerRadius = UDim.new(0, 6)

local loadBorder = Instance.new("UIStroke", loadButton)
loadBorder.Color = Color3.fromRGB(60, 80, 100)
loadBorder.Thickness = 1
loadBorder.Transparency = 0.5

loadButton.MouseEnter:Connect(function()
    TweenService:Create(loadButton, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.AccentLight
    }):Play()
end)
loadButton.MouseLeave:Connect(function()
    TweenService:Create(loadButton, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.Accent
    }):Play()
end)

-- EXIT Button (RED - Next to Load)
local exitButton = Instance.new("TextButton", bottomButtonFrame)
exitButton.Size = UDim2.new(0, 140, 1, 0)
exitButton.Position = UDim2.new(1, -140, 0, 0)
exitButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
exitButton.BorderSizePixel = 0
exitButton.Text = "EXIT"
exitButton.Font = Enum.Font.GothamBold
exitButton.TextSize = 13
exitButton.TextColor3 = COLORS.Text
exitButton.AutoButtonColor = false
local exitCorner = Instance.new("UICorner", exitButton)
exitCorner.CornerRadius = UDim.new(0, 6)

local exitBorder = Instance.new("UIStroke", exitButton)
exitBorder.Color = Color3.fromRGB(200, 60, 60)
exitBorder.Thickness = 1
exitBorder.Transparency = 0.3

exitButton.MouseEnter:Connect(function()
    TweenService:Create(exitButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    }):Play()
    TweenService:Create(exitBorder, TweenInfo.new(0.15), {
        Color = Color3.fromRGB(255, 80, 80)
    }):Play()
end)

exitButton.MouseLeave:Connect(function()
    TweenService:Create(exitButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    }):Play()
    TweenService:Create(exitBorder, TweenInfo.new(0.15), {
        Color = Color3.fromRGB(200, 60, 60)
    }):Play()
end)

-- Exit Button Click
exitButton.MouseButton1Click:Connect(function()
    TweenService:Create(exitButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(loaderWindow, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.3)
    loaderWindow.Visible = false
    
    if keyWindow.Visible then
        TweenService:Create(keyWindow, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        keyWindow.Visible = false
    end
    
    gui:Destroy()
end)

-- ================= SELECTION STATE =================
local selectedVersion = nil
local keyType = "free"

-- ================= LOAD FUNCTIONS =================
local function LoadFreeScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/anyucika192-eng/Undercover-devlopment/refs/heads/main/Free%20uc.lua"))()
end

local function LoadPaidScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/anyucika192-eng/Undercover-devlopment/refs/heads/main/Uc%20Ult.lua"))()
end

-- ================= LOAD BUTTON ACTION =================
loadButton.MouseButton1Click:Connect(function()
    if selectedVersion == "free" then
        TweenService:Create(loaderWindow, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.3)
        loaderWindow.Visible = false
        
        LoadFreeScript()
    elseif selectedVersion == "ultimate" then
        TweenService:Create(loaderWindow, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.3)
        loaderWindow.Visible = false
        
        LoadPaidScript()
    else
        -- Shake animation
        TweenService:Create(loadButton, TweenInfo.new(0.05), {
            Position = UDim2.new(0, 10, 0, 0)
        }):Play()
        task.wait(0.05)
        TweenService:Create(loadButton, TweenInfo.new(0.05), {
            Position = UDim2.new(0, -10, 0, 0)
        }):Play()
        task.wait(0.05)
        TweenService:Create(loadButton, TweenInfo.new(0.05), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    end
end)

-- ================= FREE BUTTON CLICK =================
freeButton.MouseButton1Click:Connect(function()
    selectedVersion = "free"
    freeBorder.Color = COLORS.Success
    freeBorder.Transparency = 0
    freeButton.BackgroundColor3 = Color3.fromRGB(30, 50, 40)
    freeCheck.Text = "✓"
    freeCheck.Visible = true
    
    -- Deselect ultimate
    ultimateBorder.Color = COLORS.BorderLight
    ultimateBorder.Transparency = 0.3
    ultimateButton.BackgroundColor3 = COLORS.Card
    ultimateCheck.Visible = false
    
    loadButton.TextTransparency = 0
    loaderStatus.Text = "● Free Menu Selected"
    loaderStatus.TextColor3 = COLORS.Success
end)

freeButton.MouseEnter:Connect(function()
    if selectedVersion ~= "free" then
        TweenService:Create(freeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.CardHover
        }):Play()
    end
end)

freeButton.MouseLeave:Connect(function()
    if selectedVersion ~= "free" then
        TweenService:Create(freeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.Card
        }):Play()
    end
end)

-- ================= ULTIMATE BUTTON CLICK =================
ultimateButton.MouseButton1Click:Connect(function()
    if keyType == "550E8400-E29B-41D4-A716-446655440000" then
        selectedVersion = "ultimate"
        ultimateBorder.Color = COLORS.Gold
        ultimateBorder.Transparency = 0
        ultimateButton.BackgroundColor3 = Color3.fromRGB(50, 45, 20)
        ultimateCheck.Text = "✓"
        ultimateCheck.Visible = true
        
        -- Deselect free
        freeBorder.Color = COLORS.BorderLight
        freeBorder.Transparency = 0.3
        freeButton.BackgroundColor3 = COLORS.Card
        freeCheck.Visible = false
        
        loadButton.TextTransparency = 0
        loaderStatus.Text = "● Ultimate Menu Selected"
        loaderStatus.TextColor3 = COLORS.Gold
    else
        -- Locked feedback
        local originalText = ultimateSub.Text
        ultimateSub.Text = "🔒 Premium only"
        ultimateSub.TextColor3 = COLORS.Danger
        
        TweenService:Create(ultimateButton, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(60, 30, 30)
        }):Play()
        
        task.wait(0.3)
        
        TweenService:Create(ultimateButton, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Card
        }):Play()
        ultimateSub.Text = originalText
        ultimateSub.TextColor3 = Color3.fromRGB(120, 80, 80)
    end
end)

ultimateButton.MouseEnter:Connect(function()
    TweenService:Create(ultimateButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(40, 35, 25)
    }):Play()
end)

ultimateButton.MouseLeave:Connect(function()
    if selectedVersion ~= "ultimate" then
        TweenService:Create(ultimateButton, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.Card
        }):Play()
    end
end)

-- ================= UPDATE AVATAR =================
local function updateAvatar()
    local userId = LocalPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    avatarImage.Image = content
end

updateAvatar()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateAvatar()
end)

-- ================= KEY WINDOW EVENTS =================
-- Unlock Button
keyUnlockBtn.MouseButton1Click:Connect(function()
    local inputKey = keyInput.Text
    local valid, key = ValidateKey(inputKey)
    
    if valid then
        keyError.Visible = false
        keyType = key
        
        TweenService:Create(keyWindow, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.3)
        keyWindow.Visible = false
        
        -- Update loader based on key
        if keyType == "free" then
            keyStatusText.Text = "Free Key"
            keyStatusText.TextColor3 = COLORS.Accent
            ultimateButton.Visible = false
            freeButton.Position = UDim2.new(0, 0, 0, 178)
            loaderStatus.Text = "● Free Mode"
            loaderStatus.TextColor3 = COLORS.TextMuted
        else -- "paid"
            keyStatusText.Text = "Paid Key"
            keyStatusText.TextColor3 = COLORS.Gold
            ultimateButton.Visible = true
            freeButton.Position = UDim2.new(0, 0, 0, 178)
            loaderStatus.Text = "● Premium Mode"
            loaderStatus.TextColor3 = COLORS.Gold
        end
        
        loaderWindow.Visible = true
        loaderWindow.Size = UDim2.new(0, 0, 0, 0)
        loaderWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(loaderWindow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 640, 0, 380),
            Position = UDim2.new(0.5, -320, 0.5, -190)
        }):Play()
    else
        ShowKeyError("Invalid key!")
    end
end)

-- Close Button
keyCloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(keyWindow, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    keyWindow.Visible = false
end)

-- Enter key support
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        keyUnlockBtn.MouseButton1Click:Fire()
    end
end)

-- ================= ANIMATION LOOP =================
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    if loaderWindow.Visible then
        hue = (hue + dt * 0.3) % 1
        keyAccentDot.BackgroundColor3 = Color3.fromHSV(hue, 0.7, 0.8)
    end
end)

-- ================= CLEANUP =================
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "UndercoverSlotted" then
        -- Cleanup if needed
    end
end)
