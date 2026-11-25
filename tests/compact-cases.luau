-- Runs the actual header, geometry and original constructors in a deterministic GUI harness.
setup()
local baseNew=New
New=function(class,props)
    local node=baseNew(class,props)
    node.ZIndex=node.ZIndex or 1
    node.Signals={}
    node.AbsolutePosition=node.AbsolutePosition or Vector2.new(0,0)
    node.AbsoluteSize=node.AbsoluteSize or Vector2.new(300,40)
    for _,name in ipairs({"MouseEnter","MouseLeave","MouseButton1Click","MouseButton1Down","MouseButton1Up","InputBegan","Focused","FocusLost","ChildAdded"}) do node[name]=signal() end
    function node:GetChildren() return table.clone(self.Children) end
    function node:FindFirstChild(name) for _,child in ipairs(self.Children) do if child.Name==name then return child end end end
    function node:GetPropertyChangedSignal(name) self.Signals[name]=self.Signals[name] or signal();return self.Signals[name] end
    function node:IsFocused() return self.FocusedNow==true end
    function node:CaptureFocus() self.FocusedNow=true;self.Captures=(self.Captures or 0)+1 end
    return node
end
local function BindTheme(fn) fn() end
Stroke=function(parent) return {Parent=parent} end
local __KZ_QOL={ToggleRegistry={},KeybindRegistry={}}
local connections={}
local Sidebar=New("Frame",{Parent=Window})
local Topbar=New("Frame",{Parent=Window})
local PageHost=New("Frame",{Parent=Window})
local DropdownLayer=New("Frame",{Parent=Window,AbsoluteSize=Vector2.new(720,432)})
local ICONS={Search="search-icon"}
local focused,expandCalls=nil,0
local UserInputService={InputBegan=signal(),InputChanged=signal(),InputEnded=signal(),GetFocusedTextBox=function() return focused end}
local SetSidebar=function(value) assert(value);expandCalls+=1 end
-- INSERT HEADER
local chipWidth=0
for _,stat in pairs(__KZ_QOL.HeaderStats) do chipWidth+=stat.Frame.Size.X.Offset end
assert(chipWidth+12==228 and __KZ_QOL.HeaderStats.FPS.Label.Text=="-- FPS")
assert(SearchBox.Parent==Sidebar and SearchBox.Position.Y.Offset==76 and SearchInput.PlaceholderText=="Search")
print("PASS sidebar search and three header badges occupy separate layout regions")

Window.Visible=true;__KZ_Cozy.Active=false
UserInputService.InputBegan:Fire({KeyCode=Enum.KeyCode.Slash},false);advance(0)
assert(expandCalls==1 and SearchInput.Captures==1)
focused={};UserInputService.InputBegan:Fire({KeyCode=Enum.KeyCode.Slash},false);advance(0)
assert(expandCalls==1);focused=nil
UserInputService.InputBegan:Fire({KeyCode=Enum.KeyCode.Slash},true);advance(0);assert(expandCalls==1)
Window.Visible=false;__KZ_QOL.FocusSearch();advance(0);assert(expandCalls==1)
Window.Visible=true;__KZ_Cozy.Active=true;__KZ_QOL.FocusSearch();advance(0);assert(expandCalls==1)
__KZ_Cozy.Active=false
__KZ_QOL.SyncSidebarSearch(false)
assert(not SearchInput.Visible and __KZ_QOL.SearchExpand.Visible and not __KZ_QOL.SearchShortcut.Visible)
__KZ_QOL.SearchExpand.MouseButton1Click:Fire();advance(0);assert(expandCalls==2)
__KZ_QOL.SyncSidebarSearch(true);assert(SearchInput.Visible and not __KZ_QOL.SearchExpand.Visible)
print("PASS slash and collapsed magnifier focus search without stealing existing text input")

local population,populationReads,primaryPing,networkPing,networkReads=3,0,31.4,.032,0
local Players={MaxPlayers=14,GetPlayers=function() populationReads+=1;return table.create(population,true) end}
local LocalPlayer={GetNetworkPing=function() networkReads+=1;if networkPing==nil then error("unavailable") end;return networkPing end}
local game={GetService=function(_,name)
    assert(name=="Stats");if primaryPing==nil then error("Stats unavailable") end
    return {Network={ServerStatsItem={["Data Ping"]={GetValue=function()return primaryPing end}}}}
end}
-- INSERT METRICS
assert(__KZ_QOL.ReadPingMillis()==31 and networkReads==0)
primaryPing=nil;assert(__KZ_QOL.ReadPingMillis()==32 and networkReads==1)
primaryPing=0/0;networkPing=.017;assert(__KZ_QOL.ReadPingMillis()==17)
primaryPing=0;assert(__KZ_QOL.ReadPingMillis()==0)
primaryPing=nil;networkPing=nil;assert(__KZ_QOL.ReadPingMillis()==nil)
print("PASS ping uses measured milliseconds, converts fallback seconds and rejects unavailable data")
__KZ_QOL.UpdateHeaderStats(185,31)
assert(__KZ_QOL.HeaderStats.FPS.Label.Text=="185 FPS" and __KZ_QOL.HeaderStats.Ping.Label.Text=="31 ms")
assert(__KZ_QOL.HeaderStats.Players.Label.Text=="3/14")
population=4;Players.MaxPlayers=32;__KZ_QOL.UpdateHeaderStats(144,nil)
assert(__KZ_QOL.HeaderStats.Players.Label.Text=="4/32" and __KZ_QOL.HeaderStats.Ping.Label.Text=="-- ms")
Players.MaxPlayers=0;assert(__KZ_QOL.ServerPopulationText()=="4/--")
Window.Visible=false;local before=populationReads;__KZ_QOL.UpdateHeaderStats(1,1);assert(populationReads==before)
Window.Visible=true;__KZ_Cozy.Active=true;__KZ_QOL.UpdateHeaderStats(1,1);assert(populationReads==before)
__KZ_Cozy.Active=false
print("PASS live server occupancy follows joins and capacity; hidden or loading headers do no update work")

local oldVector=Vector2.new
Vector2.new=function(x,y) return setmetatable({X=x,Y=y},{__div=function(a,b)return oldVector(a.X/b,a.Y/b)end}) end
local SearchResults=New("ScrollingFrame",{Parent=DropdownLayer})
-- INSERT SEARCH POSITION
for _,scale in ipairs({.55,.8,1,1.15}) do
    Scale.Scale=scale
    DropdownLayer.AbsoluteSize=Vector2.new(900*scale,540*scale)
    SearchBox.AbsolutePosition=Vector2.new(Window.AbsolutePosition.X+12*scale,Window.AbsolutePosition.Y+76*scale)
    SearchBox.AbsoluteSize=Vector2.new(164*scale,36*scale)
    PositionSearchResults()
    assert(math.abs(SearchResults.Position.X.Offset-12)<.001)
    assert(math.abs(SearchResults.Position.Y.Offset-118)<.001)
    assert(SearchResults.Position.Y.Offset+SearchResults.Size.Y.Offset<=532)
end
Scale.Scale=1
print("PASS search results stay anchored below the sidebar field across all window scales")

local currentPage="Home"
local navEntries={Home={Button=New("TextButton",{Parent=Sidebar,Size=UDim2.new(1,0,0,38)})}}
local NavIndicatorLayer=New("Frame",{Parent=Sidebar,AbsolutePosition=Vector2.new(0,140)})
__KZ_QOL.NavSelectionGlow=New("Frame",{Parent=NavIndicatorLayer})
-- INSERT NAV INDICATOR
for _,scale in ipairs({.55,.8,1,1.15}) do
    Scale.Scale=scale
    navEntries.Home.Button.AbsolutePosition=Vector2.new(0,140+84*scale)
    __KZ_UpdateNavSelectionGlow(false)
    assert(math.abs(__KZ_QOL.NavSelectionGlow.Position.Y.Offset-84)<.001 and __KZ_QOL.NavSelectionGlow.Size.Y.Offset==38)
end
Scale.Scale=1
print("PASS selected-tab highlight matches compact row height and remains aligned at every scale")

local pages={}
local __KZ_SectionControls={}
local notifications=0
local function Toast() notifications+=1 end
-- INSERT PAGE
-- INSERT SECTIONS
local features=CreatePage("Automatics")
local home=CreatePage("Home")
assert(features.Columns and #features.Columns==2 and home.Columns==nil)
local first,second,third=Section(features,"Quarterback"),Section(features,"Receiving"),Section(features,"Special teams")
assert(first.Parent.Parent==features.Columns[1] and second.Parent.Parent==features.Columns[2] and third.Parent.Parent==features.Columns[1])
assert(first.Parent.Children[3]==first and first.Parent.Children[1].ClassName=="UIListLayout")
local homeCard=Section(home,"Favorites")
assert(homeCard.Parent.Parent==home.Body)
homeCard.LayoutOrder=3;homeCard.Signals.LayoutOrder:Fire();assert(homeCard.Parent.LayoutOrder==3)
first.Visible=false;first.Signals.Visible:Fire();assert(not first.Parent.Visible)
first.Visible=true;first.Signals.Visible:Fire();assert(first.Parent.Visible)
local calls=0
RegisterSectionControl(first,{Set=function(value,fire)assert(value==false and fire);calls+=1 end},false)
__KZ_SectionControls[first].Button.MouseButton1Click:Fire();assert(calls==1 and notifications==1)
print("PASS alternating section columns preserve Home ordering, section visibility and original reset callbacks")

__KZ_QOL.ApplyGlassControl=function()end
__KZ_QOL.RegisterFavoriteRow=function(_,_,row)
    New("TextButton",{Parent=row,Name="MochiPin",Size=UDim2.fromOffset(22,24),ZIndex=8})
end
-- INSERT ROWS
-- INSERT SLIDER
-- INSERT DROPDOWN
local sliderCalls,sliderValue=0,nil
local slider=Slider(features,first,"Catch radius",0,100,35,"",function(value) sliderCalls+=1;sliderValue=value end,1)
local row=features.Searchables[#features.Searchables].Object
advance(0)
assert(row.Size.Y.Offset==58 and sliderCalls==0 and slider.Get()==35)
local title=row:FindFirstChild("ControlTitle")
local field,track
for _,child in ipairs(row:GetChildren()) do
    if child:IsA("TextBox") then field=child
    elseif child:IsA("TextButton") and child.Size.Y.Offset==7 then track=child end
end
assert(title.Position.X.Offset==34 and field.Size.X.Offset==60 and track.Size.X.Offset==-20)
for _,width in ipairs({300,320,380}) do
    local titleRight=title.Position.X.Offset+width*title.Size.X.Scale+title.Size.X.Offset
    local fieldLeft=width+field.Position.X.Offset-field.Size.X.Offset
    assert(titleRight+10<=fieldLeft)
end
slider.Set(72,true);advance(0);assert(slider.Get()==72 and sliderValue==72 and sliderCalls==1)
field.Text="88";field.FocusLost:Fire();advance(0);assert(slider.Get()==88 and sliderCalls==2)
track.AbsolutePosition=Vector2.new(100,100);track.AbsoluteSize=Vector2.new(280,7)
track.InputBegan:Fire({UserInputType=Enum.UserInputType.Touch,Position=Vector2.new(240,100)})
advance(0);assert(slider.Get()==50)
UserInputService.InputEnded:Fire({UserInputType=Enum.UserInputType.Touch})
print("PASS compact sliders reserve pin and value space while preserving exact entry, setters and touch dragging")

local dropdownValue
local dropdown=Dropdown(features,first,"QB type",{"Legit","Classic"},"Legit",function(value) dropdownValue=value end)
local dropdownRow=features.Searchables[#features.Searchables].Object
advance(0)
local box
for _,child in ipairs(dropdownRow:GetChildren()) do if child.ZIndex==10 then box=child end end
assert(dropdownRow.Size.Y.Offset==72 and box.Position.Y.Offset==30 and box.Size.X.Scale==1 and box.Size.X.Offset==-20)
assert(dropdownRow:FindFirstChild("MochiPin").Position.Y.Offset==1)
dropdown.Set("Classic",true);advance(0);assert(dropdown.Get()=="Classic" and dropdownValue=="Classic" and box.Text=="Classic")
dropdown.Refresh({"Legit","Classic","New"})
assert(dropdown.Get()=="Classic")
print("PASS stacked full-width dropdown fields retain selection, callbacks and option refresh")

local pending=ElementBase(features,first,"Removed early",40,"Toggle")
pending:Destroy();advance(0)
local holder=third.Parent;third:Destroy();advance(0);assert(not holder.Parent)
print("PASS deferred presentation skips destroyed rows and removes empty section wrappers")

local request
-- INSERT ASSET FALLBACK
local png=string.char(137,80,78,71,13,10,26,10)..string.rep("p",100)
local apiCalls=0
game.HttpGet=function()return png end
request=function()apiCalls+=1;error("should not need the API")end
assert(__KZ_Cozy.FetchRepositoryArt("raw","assets/cat.png")==png and apiCalls==0)
game.HttpGet=function()error("404")end
request=function(options)
    apiCalls+=1
    assert(options.Url=="https://api.github.com/repos/mochiloader/ui-d/contents/assets/cat.png")
    assert(options.Headers.Accept=="application/vnd.github.raw+json" and not options.Headers.Authorization)
    return {StatusCode=200,Body=png}
end
assert(__KZ_Cozy.FetchRepositoryArt("raw","assets/cat.png")==png and apiCalls==1)
print("PASS asset downloads prefer raw content and fall back to the public API without credentials")
game.HttpGet=function()return "404: Not Found" end
request=function()return {StatusCode=200,Body=string.rep("not an image",100)}end
assert(__KZ_Cozy.FetchRepositoryArt("raw","assets/cat.png")==nil)
request=function()return {StatusCode=429,Body=png}end
assert(__KZ_Cozy.FetchRepositoryArt("raw","assets/cat.png")==nil)
request=nil;assert(__KZ_Cozy.FetchRepositoryArt("raw","assets/cat.png")==nil)
print("PASS failed, throttled or non-image downloads preserve native fallback instead of caching error pages")

-- Exercise the real sidebar controller and pointer events.
do
    local SIDEBAR_COMPACT,SIDEBAR_OPEN=64,188
    local sidebarExpanded,sidebarHoverEnabled=true,true
    local BrandLogoShell,BrandTitle,BrandSub,ProfileName,ProfileStatus=New("Frame",{}),New("TextLabel",{}),New("TextLabel",{}),New("TextLabel",{}),New("TextLabel",{})
    local label,badge=New("TextLabel",{Parent=Sidebar}),New("TextLabel",{Parent=Sidebar})
    local navEntries={Home={Label=label,Badge=badge,ActiveCount=1}}
    local layoutExpanded
    local function ApplyContentLayout(expanded) layoutExpanded=expanded end
    SearchInput.FocusedNow=false;SearchResults.Visible=false
    -- INSERT SIDEBAR
    advance(1)
    assert(not sidebarExpanded and Sidebar.Size.X.Offset==64 and layoutExpanded==false)
    assert(not SearchInput.Visible and __KZ_QOL.SearchExpand.Visible and not badge.Visible)
    Sidebar.MouseEnter:Fire();advance(1)
    assert(sidebarExpanded and Sidebar.Size.X.Offset==188 and SearchInput.Visible and badge.Visible)
    SearchInput.FocusedNow=true;Sidebar.MouseLeave:Fire();advance(1);assert(sidebarExpanded)
    SearchInput.FocusedNow=false;SearchResults.Visible=true;Sidebar.MouseLeave:Fire();advance(1);assert(sidebarExpanded)
    SearchResults.Visible=false;Sidebar.MouseLeave:Fire();advance(1)
    assert(not sidebarExpanded and Sidebar.Size.X.Offset==64 and label.TextTransparency==1)
    sidebarHoverEnabled=false;SetSidebar(true);Sidebar.MouseLeave:Fire();advance(1);assert(sidebarExpanded)
    sidebarHoverEnabled=true;SetSidebar(false);advance(1);assert(not sidebarExpanded)
    print("PASS sidebar starts compact, expands on hover, collapses on leave and protects active search and pinned navigation")
end
