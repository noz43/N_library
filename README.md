# N_Library - Modern UI Framework for Garry's Mod

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/noz43/N_library)
[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-VGUI-orange.svg)](https://store.steampowered.com/app/4000/)
[![RNDX](https://img.shields.io/badge/Link%20for-RNDX-purple.svg)]([https://github.com/Niflheim-uk/Coherent-RNDX](https://github.com/Srlion/RNDX/tree/master/src))

A comprehensive, modern UI component library for Garry's Mod with RNDX rendering engine

---

## Documentation

### Buttons

**Standard Button**
```lua
local btn = vgui.Create("N.Button")
btn:SetSize(200, 40)
btn:SetLabel("Click Me")
btn:SetStyle("Important")
btn.DoClick = function()
    print("Button clicked!")
end
```

**Icon Button**
```lua
local iconBtn = vgui.Create("N.IconButton")
iconBtn:SetSize(56, 56)
iconBtn:SetIcon("settings")
iconBtn:SetStyle("Important")
iconBtn:SetShape("circle")
```

**Text Button**
```lua
local textBtn = vgui.Create("N.TextButton")
textBtn:SetSize(150, 32)
textBtn:SetLabel("Learn More")
```

---

### Cards

**User Card**
```lua
local card = vgui.Create("N.UserCard")
card:SetSize(250, 50)
card:SetPlayerName("Player Name")
card:SetPlayerInfo("Level 42")
card:SetShape("rounded")
```

**Info Card**
```lua
local infoCard = vgui.Create("N.InfoCard")
infoCard:SetSize(150, 100)
infoCard:SetValue("1,234")
infoCard:SetLabel("Total Sales")
```

**Stat Card**
```lua
local statCard = vgui.Create("N.StatCard")
statCard:SetSize(86, 59)
statCard:SetTitle("Revenue")
statCard:SetValue("$12.5K")
statCard:SetDescription("+12%")
```

**Large Image Card**
```lua
local imageCard = vgui.Create("N.LargeImageCard")
imageCard:SetSize(610, 175)
imageCard:SetImgurImage("abc123.jpg")
imageCard:SetTitle("Featured Content")
imageCard:SetSubtitle("New Update Available")
```

**Text Image Card**
```lua
local textImg = vgui.Create("N.TextImageCard")
textImg:SetSize(520, 170)
textImg:SetTitle("Product Name")
textImg:SetDescription("Description here")
textImg:SetImgurImage("xyz456.jpg")
```

---

### Forms

**Progress Bar**
```lua
local progress = vgui.Create("N.Progress")
progress:SetSize(200, 8)
progress:SetValue(75)
progress:SetTitle("Loading...")
progress:SetBarGradient(true)
```

**Circular Progress**
```lua
local circular = vgui.Create("N.ProgressCircular")
circular:SetSize(70, 70)
circular:SetValue(65)
circular:SetTitle("Complete")
circular:SetUseGradient(true)
```

**Circular Progress Advanced**
```lua
local advanced = vgui.Create("N.ProgressCircularAdvanced")
advanced:SetSize(140, 140)
advanced:SetValue(80)
advanced:SetTitle("Progress")
advanced:SetShowGlow(true)
advanced:SetThickness(18)
```

**Progress Stepper**
```lua
local stepper = vgui.Create("N.ProgressStepper")
stepper:SetSize(300, 60)
stepper:SetSteps({
    {label = "Step 1", description = "Start"},
    {label = "Step 2", description = "Process"},
    {label = "Step 3", description = "Complete"}
})
stepper:SetCurrentStep(2)
```

**Slider**
```lua
local slider = vgui.Create("N.Slider")
slider:SetSize(295, 40)
slider:SetValue(50)
slider:SetMaxValue(100)
slider:SetTitle("Volume")
slider:SetBarGradient(true)
slider.OnValueChanged = function(self, value)
    print("Value:", value)
end
```

**Checkbox**
```lua
local checkbox = vgui.Create("N.Checkbox")
checkbox:SetSize(93, 22)
checkbox:SetLabel("Accept Terms")
checkbox:SetChecked(false)
checkbox.OnChange = function(self, value)
    print("Checked:", value)
end
```

**Radio Button**
```lua
local radio = vgui.Create("N.Checkbox")
radio:SetSize(93, 22)
radio:SetType("radio")
radio:SetRadioGroup("options")
radio:SetLabel("Option A")
radio:SetShape("circle")
```

---

### Layouts

**Frame**
```lua
local frame = vgui.Create("N.Frame")
frame:SetSize(800, 600)
frame:SetFrameTitle("Application")
frame:SetBackgroundColor(Color(33, 25, 41))
frame:SetShadow(true, 20, 25)
frame:Center()
frame:MakePopup()
```

**Panel**
```lua
local panel = vgui.Create("N.Panel")
panel:SetSize(400, 300)
panel:SetBackgroundColor(Color(51, 41, 62))
panel:SetRadius(8)
panel:SetShadow(true, 10, 15)
```

**Scroll Panel**
```lua
local scroll = vgui.Create("N.ScrollPanel")
scroll:SetSize(400, 500)
scroll:SetBackgroundColor(Color(33, 25, 41))

local canvas = scroll:GetCanvas()
```

**Sidebar**
```lua
local sidebar = vgui.Create("N.Sidebar")
sidebar:SetMode("iconstext")
sidebar:AddItem("Dashboard", "home", function()
    print("Dashboard clicked")
end)
sidebar:AddItem("Settings", "settings", function()
    print("Settings clicked")
end)
sidebar:AddFooterItem("Logout", "logout", function()
    print("Logout clicked")
end)
sidebar:SetActive(1)
```

---

### Inputs

**Text Entry**
```lua
local textEntry = vgui.Create("N.TextEntry")
textEntry:SetSize(200, 40)
textEntry:SetPlaceholder("Enter text...")
```

**Search**
```lua
local search = vgui.Create("N.Search")
search:SetSize(250, 40)
search:SetPlaceholder("Search...")
search:SetIconPosition("left")
```

**Text Area**
```lua
local textArea = vgui.Create("N.TextArea")
textArea:SetSize(300, 150)
textArea:SetPlaceholder("Enter description...")
```

---

### Lists

**Dropdown**
```lua
local dropdown = vgui.Create("N.Dropdown")
dropdown:SetSize(200, 40)
dropdown:AddChoice("Option 1")
dropdown:AddChoice("Option 2")
dropdown:AddChoice("Option 3")
dropdown:SetSelected(1)
```

**List**
```lua
local list = vgui.Create("N.List")
list:SetSize(300, 400)
list:AddItem("Item 1")
list:AddItem("Item 2")
list:AddItem("Item 3")
```

**User List**
```lua
local userList = vgui.Create("N.UserList")
userList:SetSize(250, 400)
userList:AddUser("Player 1", "Online")
userList:AddUser("Player 2", "Away")
```

**Mission List**
```lua
local missionList = vgui.Create("N.MissionList")
missionList:SetSize(300, 400)
missionList:AddMission("Mission 1", "Complete")
missionList:AddMission("Mission 2", "In Progress")
```

**Item Grid**
```lua
local itemGrid = vgui.Create("N.ItemGrid")
itemGrid:SetSize(400, 400)
itemGrid:AddItem("item_icon", "Item Name")
```

---

### Modals

**Modal**
```lua
local modal = vgui.Create("N.Modal")
modal:SetSize(400, 300)
modal:SetTitle("Modal Title")
modal:SetContent("Modal content here")
modal:Center()
modal:MakePopup()
```

**Confirm Dialog**
```lua
local confirm = vgui.Create("N.Confirm")
confirm:SetTitle("Confirm Action")
confirm:SetMessage("Are you sure?")
confirm:SetCallback(function()
    print("Confirmed!")
end)
```

**Query Dialog**
```lua
local query = vgui.Create("N.Query")
query:SetTitle("Enter Value")
query:SetMessage("Please enter a value:")
query:SetCallback(function(value)
    print("Value entered:", value)
end)
```

---

### Misc

**Avatar**
```lua
local avatar = vgui.Create("N.Avatar")
avatar:SetSize(64, 64)
avatar:SetPlayer(LocalPlayer())
```

**Badge**
```lua
local badge = vgui.Create("N.Badge")
badge:SetSize(80, 24)
badge:SetText("NEW")
badge:SetColor(Color(179, 115, 226))
```

**Divider**
```lua
local divider = vgui.Create("N.Divider")
divider:SetSize(400, 2)
divider:SetColor(Color(67, 77, 93))
```

---
