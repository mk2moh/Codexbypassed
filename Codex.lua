-- Moh Executor v6 â€” Phase 1 Core Redesign
-- AMOLED theme, sidebar file tree, console, settings persist, fixed FPS/Ping
local synversion = "2.23.11"
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Http = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local LogService = game:GetService("LogService")

pcall(function() CoreGui:FindFirstChild("MohExec"):Destroy() end)

-- AMOLED PALETTE
local C = {
	bg = Color3.fromRGB(5,5,8), bg2 = Color3.fromRGB(12,12,16),
	panel = Color3.fromRGB(18,18,24), card = Color3.fromRGB(22,22,30),
	input = Color3.fromRGB(28,28,38), stroke = Color3.fromRGB(40,40,55),
	tab = Color3.fromRGB(35,35,48), tabOn = Color3.fromRGB(50,50,70),
	btn = Color3.fromRGB(30,30,42), hoverBg = Color3.fromRGB(0,50,90),
	hoverBdr = Color3.fromRGB(60,130,180), white = Color3.fromRGB(230,230,235),
	muted = Color3.fromRGB(120,120,140), dim = Color3.fromRGB(80,80,100),
	green = Color3.fromRGB(60,200,80), red = Color3.fromRGB(220,60,60),
	yellow = Color3.fromRGB(220,200,60), accent = Color3.fromRGB(80,130,220),
	blue = Color3.fromRGB(50,120,220), sidebar = Color3.fromRGB(10,10,14),
	folder = Color3.fromRGB(200,180,80), script = Color3.fromRGB(160,160,180),
}
local SC = {keyword=Color3.fromRGB(200,160,255),builtin=Color3.fromRGB(100,190,255),string=Color3.fromRGB(160,240,160),number=Color3.fromRGB(255,120,120),comment=Color3.fromRGB(90,90,110),operator=Color3.fromRGB(240,220,120),iden=Color3.fromRGB(210,210,220)}
local F = Font.new("rbxasset://fonts/families/SourceSansPro.json",Enum.FontWeight.Regular)
local FB = Font.new("rbxasset://fonts/families/SourceSansPro.json",Enum.FontWeight.Bold)
local FC = Font.new("rbxasset://fonts/families/Inconsolata.json",Enum.FontWeight.Regular)
local ICON = "rbxassetid://9483813933"

local KW,BT={},{}
for _,w in ipairs({"and","break","continue","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","self","then","true","type","typeof","until","while","export"})do KW[w]=true end
for _,w in ipairs({"assert","error","getfenv","getmetatable","ipairs","loadstring","newproxy","next","pairs","pcall","print","rawequal","rawget","rawlen","rawset","require","select","setfenv","setmetatable","tonumber","tostring","unpack","xpcall","collectgarbage","spawn","delay","wait","warn","tick","time","game","workspace","script","shared","Enum","Instance","Color3","Vector3","Vector2","CFrame","UDim2","UDim","BrickColor","TweenInfo","math","string","table","coroutine","task","debug","os","utf8","bit32"})do BT[w]=true end

local TABS_F="MohExecTabs.json"
local TREE_F="MohExecTree.json"
local SETS_F="MohExecSettings.json"
local AE_DIR="MohAutoExec"

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function n(cl,p,k)
	local o=Instance.new(cl)
	for a,b in pairs(p)do if a~="Parent"then pcall(function()o[a]=b end)end end
	if k then for _,c in ipairs(k)do c.Parent=o end end
	if p.Parent then o.Parent=p.Parent end;return o
end
local _dd={}
local function drag(fr,hd) hd=hd or fr;local d,ds,sp
	hd.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true;ds=i.Position;sp=fr.Position;_dd[fr]=0;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then d=false end end)end end)
	UIS.InputChanged:Connect(function(i) if d and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local dt=i.Position-ds;_dd[fr]=math.abs(dt.X)+math.abs(dt.Y);fr.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y)end end)
end
local function wasD(f)return(_dd[f]or 0)>5 end
local function hover(b) local ob,obc,obs=b.BackgroundColor3,b.BorderColor3,b.BorderSizePixel;b.MouseEnter:Connect(function()b.BackgroundColor3=C.hoverBg;b.BorderColor3=C.hoverBdr;b.BorderSizePixel=1 end);b.MouseLeave:Connect(function()b.BackgroundColor3=ob;b.BorderColor3=obc;b.BorderSizePixel=obs end)end
local function mb(t,w,par,ord) local b=n("TextButton",{Text=t,Size=UDim2.fromOffset(w,24),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=F,TextSize=13,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=ord or 0,Parent=par});hover(b);return b end
local function c3h(c)return string.format("%.2x%.2x%.2x",c.R*255,c.G*255,c.B*255)end
local function makeWin(title,w,h,pos,z) z=z or 10;local win=n("Frame",{Size=UDim2.fromOffset(w,h),Position=pos,BackgroundColor3=C.bg,BorderSizePixel=0,Visible=false,ZIndex=z,Parent=nil,ClipsDescendants=true});local bar=n("Frame",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.panel,BorderSizePixel=0,ZIndex=z,Parent=win});drag(win,bar);n("ImageLabel",{Image=ICON,Size=UDim2.fromOffset(16,19),Position=UDim2.fromOffset(4,3),BackgroundTransparency=1,ZIndex=z,Parent=bar});n("TextLabel",{Text=title,Size=UDim2.new(1,-30,1,0),Position=UDim2.fromOffset(24,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=z,Parent=bar});local xb=n("TextButton",{Text="X",Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-26,0,0),BackgroundColor3=C.panel,TextColor3=C.muted,FontFace=F,TextSize=13,BorderSizePixel=0,AutoButtonColor=false,ZIndex=z,Parent=bar});hover(xb);xb.MouseButton1Click:Connect(function()win.Visible=false end);return win end

------------------------------------------------------------
-- SETTINGS PERSISTENCE
------------------------------------------------------------
local settings = {showFps=true,showStats=true,wrap=false,fontSize=14,antiAfk=false}
pcall(function() if isfile and isfile(SETS_F)then local d=Http:JSONDecode(readfile(SETS_F));if type(d)=="table"then for k,v in pairs(d)do settings[k]=v end end end end)
local function saveSettings() pcall(function() writefile(SETS_F,Http:JSONEncode(settings))end)end

------------------------------------------------------------
-- SYNTAX HIGHLIGHTER
------------------------------------------------------------
local function hlLine(line)
	local r={};local i,len=1,#line
	while i<=len do local ch=line:sub(i,i)
		if ch=="-"and line:sub(i,i+1)=="--"then table.insert(r,'<font color="#'..c3h(SC.comment)..'">'..line:sub(i):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")..'</font>');break
		elseif ch=='"'or ch=="'"then local q,j=ch,i+1;while j<=len do local c2=line:sub(j,j);if c2=="\\"then j+=2 elseif c2==q then j+=1;break else j+=1 end end;table.insert(r,'<font color="#'..c3h(SC.string)..'">'..line:sub(i,j-1):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")..'</font>');i=j;continue
		elseif ch:match("%d")or(ch=="."and i<len and line:sub(i+1,i+1):match("%d"))then local j=i;while j<=len and line:sub(j,j):match("[%d%.eExXaAbBcCdDfF_]")do j+=1 end;table.insert(r,'<font color="#'..c3h(SC.number)..'">'..line:sub(i,j-1)..'</font>');i=j;continue
		elseif ch:match("[%a_]")then local j=i;while j<=len and line:sub(j,j):match("[%w_]")do j+=1 end;local w=line:sub(i,j-1);local col=KW[w]and SC.keyword or BT[w]and SC.builtin or SC.iden;table.insert(r,'<font color="#'..c3h(col)..'">'..w..'</font>');i=j;continue
		elseif ch:match("[%+%-%*/%%^#=~<>%.,:;%(%)%[%]{}]")then table.insert(r,'<font color="#'..c3h(SC.operator)..'">'..ch:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")..'</font>');i+=1;continue
		else table.insert(r,ch:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"));i+=1;continue end
	end;return table.concat(r)
end

------------------------------------------------------------
-- GUI ROOT
------------------------------------------------------------
local gui=n("ScreenGui",{Name="MohExec",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=CoreGui})

-- TOAST
local toastC=n("Frame",{Size=UDim2.new(0,250,0,100),Position=UDim2.new(0.5,-125,0,60),BackgroundTransparency=1,ZIndex=50,Parent=gui})
local function toast(msg,dur) dur=dur or 2.5;local t=n("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundColor3=C.panel,TextColor3=C.white,FontFace=F,TextSize=11,Text="  "..msg,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=0.05,ZIndex=50,Parent=toastC},{n("UICorner",{CornerRadius=UDim.new(0,4)})});task.delay(dur,function()local tw=TS:Create(t,TweenInfo.new(0.5),{BackgroundTransparency=1,TextTransparency=1});tw:Play();tw.Completed:Connect(function()t:Destroy()end)end)end

-- FPS/PING MONITOR (next to chat button, y=4 to be at very top)
local monF=n("Frame",{Size=UDim2.fromOffset(120,18),Position=UDim2.fromOffset(165,4),BackgroundColor3=C.bg,BackgroundTransparency=0.2,BorderSizePixel=0,ZIndex=40,Visible=settings.showFps,Parent=gui},{n("UICorner",{CornerRadius=UDim.new(0,5)}),n("UIStroke",{Color=C.stroke,Thickness=1,Transparency=0.5})})
local fpsL=n("TextLabel",{Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,TextColor3=C.green,FontFace=FB,TextSize=11,Text="FPS: --",ZIndex=40,Parent=monF})
local pingL=n("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.fromScale(0.5,0),BackgroundTransparency=1,TextColor3=C.accent,FontFace=FB,TextSize=11,Text="Ping: --",ZIndex=40,Parent=monF})

-- More accurate FPS: average over frames
task.spawn(function()
	local frames=0;local lastTime=tick()
	RS.RenderStepped:Connect(function() frames+=1 end)
	while gui.Parent do
		task.wait(0.5) -- update every 0.5s for accuracy
		local now=tick();local dt=now-lastTime
		local fps=math.round(frames/dt)
		frames=0;lastTime=now
		fpsL.Text="FPS: "..fps
		local ping=math.round(LP:GetNetworkPing()*1000)
		pingL.Text="Ping: "..ping.."ms"
	end
end)

-- FLOAT ICON
local fIcon=n("ImageButton",{Size=UDim2.fromOffset(36,36),Position=UDim2.new(0.7,0,0.7,0),BackgroundColor3=C.panel,Visible=false,Parent=gui},{n("UICorner",{CornerRadius=UDim.new(1,0)}),n("ImageLabel",{Image=ICON,Size=UDim2.fromOffset(23,26),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1})});drag(fIcon)

------------------------------------------------------------
-- MAIN WINDOW (editor left, sidebar right)
------------------------------------------------------------
-- Global UI Scale
local uiScale=settings.uiScale or 1
local uiScaleObj=n("UIScale",{Scale=uiScale,Parent=gui})
local main=n("Frame",{Name="Main",Size=UDim2.fromOffset(820,400),Position=UDim2.fromOffset(20,25),BackgroundColor3=C.bg,BorderSizePixel=0,Parent=gui},{n("UIStroke",{Color=C.stroke,Thickness=1,Transparency=0.3})})
local tbar=n("Frame",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.panel,BorderSizePixel=0,Parent=main});drag(main,tbar)
n("ImageLabel",{Image=ICON,Size=UDim2.fromOffset(18,21),Position=UDim2.fromOffset(5,2),BackgroundTransparency=1,Parent=tbar})
local titleL=n("TextLabel",{Text="Synapse X - "..synversion,Size=UDim2.new(1,-60,1,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=14,Parent=tbar})
local bClose=n("TextButton",{Text="X",Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-26,0,0),BackgroundColor3=C.panel,TextColor3=C.muted,FontFace=F,TextSize=13,BorderSizePixel=0,AutoButtonColor=false,Parent=tbar});hover(bClose)
local bMin=n("TextButton",{Text="_",Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-52,0,0),BackgroundColor3=C.panel,TextColor3=C.muted,FontFace=F,TextSize=13,BorderSizePixel=0,AutoButtonColor=false,Parent=tbar});hover(bMin)

------------------------------------------------------------
-- RIGHT SIDEBAR (script tree + options)
------------------------------------------------------------
local sideW=160
local sidebar=n("Frame",{Size=UDim2.new(0,sideW,1,-26),Position=UDim2.new(1,-sideW,0,26),BackgroundColor3=C.sidebar,BorderSizePixel=0,Parent=main},{n("UIStroke",{Color=C.stroke,Thickness=1,Transparency=0.5})})

-- Sidebar header
n("TextLabel",{Text="Scripts",Size=UDim2.new(1,0,0,20),BackgroundColor3=C.panel,BorderSizePixel=0,TextColor3=C.white,FontFace=FB,TextSize=12,ZIndex=2,Parent=sidebar})

-- Sidebar scroll area
local sideScroll=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-44),Position=UDim2.fromOffset(0,20),BackgroundColor3=C.sidebar,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),Parent=sidebar},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1)}),n("UIPadding",{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)})})

-- Options button at bottom of sidebar
local sideOptBtn=n("TextButton",{Text="Options",Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,1,-24),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,Parent=sidebar});hover(sideOptBtn)

------------------------------------------------------------
-- SCRIPT TREE DATA (folders + scripts)
------------------------------------------------------------
local treeData = {
	-- Built-in (non-deletable)
	{name="Dex Explorer",builtin=true,source='loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()'},
	{name="Infinite Yield",builtin=true,source='loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()'},
	{name="Remote Spy",builtin=true,source='loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()'},
	{name="Rejoin",builtin=true,source='game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId)'},
	-- User folders/scripts loaded below
}

local userTree = {} -- {type="folder",name="...",open=true,children={...}} or {type="script",name="...",source="..."}

-- Load user tree from file
pcall(function()
	if isfile and isfile(TREE_F)then
		local d=Http:JSONDecode(readfile(TREE_F))
		if type(d)=="table"then userTree=d end
	end
end)

local function saveTree() pcall(function() writefile(TREE_F,Http:JSONEncode(userTree))end)end

-- Render the sidebar tree
local addTab -- forward declaration
local function renderTree()
	for _,c in ipairs(sideScroll:GetChildren())do if c:IsA("Frame")or c:IsA("TextButton")then c:Destroy()end end
	local order=0

	-- Built-in scripts first
	for _,bi in ipairs(treeData)do
		order+=1
		local btn=n("TextButton",{Text="  > "..bi.name,Size=UDim2.new(1,-4,0,20),BackgroundColor3=C.card,TextColor3=C.accent,FontFace=FB,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=order,Parent=sideScroll});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=btn})
		hover(btn)
		btn.MouseButton1Click:Connect(function()
			pcall(loadstring(bi.source))
		end)
	end

	-- Separator
	order+=1
	n("Frame",{Size=UDim2.new(1,-8,0,1),BackgroundColor3=C.stroke,BorderSizePixel=0,LayoutOrder=order,Parent=sideScroll})

	-- User folders and scripts
	local function renderItem(item,depth)
		order+=1
		local indent=string.rep("  ",depth)

		if item.type=="folder" then
			local arrow=item.open and "v " or "> "
			local childCount=item.children and #item.children or 0
			local btn=n("TextButton",{Text=indent..arrow..item.name.." ("..childCount..")",Size=UDim2.new(1,-4,0,20),BackgroundColor3=C.bg2,TextColor3=C.folder,FontFace=FB,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=order,Parent=sideScroll});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=btn})

			-- Single tap: toggle expand only
			btn.MouseButton1Click:Connect(function()
				item.open=not item.open;saveTree();renderTree()
			end)

			-- Long hold (0.6s): Rename + Delete popup
			local holding=false
			btn.InputBegan:Connect(function(inp)
				if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
					holding=true
					inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then holding=false end end)
					task.delay(0.6,function()
						if not holding then return end
						local popup=n("Frame",{Size=UDim2.fromOffset(160,55),Position=UDim2.new(0.3,0,0.38,0),BackgroundColor3=C.panel,BorderSizePixel=0,ZIndex=30,Parent=gui},{n("UICorner",{CornerRadius=UDim.new(0,5)})})
						n("TextLabel",{Text=item.name,Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,TextColor3=C.white,FontFace=FB,TextSize=11,ZIndex=30,Parent=popup})
						local popX=n("TextButton",{Text="X",Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-20,0,0),BackgroundTransparency=1,TextColor3=C.muted,FontFace=FB,TextSize=12,AutoButtonColor=false,ZIndex=30,Parent=popup});popX.MouseButton1Click:Connect(function() popup:Destroy() end)
						local renB=n("TextButton",{Text="Rename",Size=UDim2.fromOffset(70,24),Position=UDim2.fromOffset(4,24),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=30,Parent=popup});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=renB})
						local delB=n("TextButton",{Text="Delete",Size=UDim2.fromOffset(70,24),Position=UDim2.fromOffset(82,24),BackgroundColor3=C.red,TextColor3=C.white,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=30,Parent=popup});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=delB})
						renB.MouseButton1Click:Connect(function()
							popup:Destroy()
							local rb=n("TextBox",{Size=UDim2.fromOffset(160,22),Position=UDim2.new(0.3,0,0.4,0),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=12,Text=item.name,ClearTextOnFocus=true,BorderSizePixel=0,ZIndex=30,Parent=gui});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=rb})
							rb:CaptureFocus()
							rb.FocusLost:Connect(function()
								if rb.Text~=""then item.name=rb.Text end
								rb:Destroy();saveTree();renderTree();toast("Renamed")
							end)
						end)
						delB.MouseButton1Click:Connect(function()
							local function removeFrom(list) for i,it in ipairs(list)do if it==item then table.remove(list,i);return true elseif it.type=="folder"and it.children then if removeFrom(it.children)then return true end end end end
							removeFrom(userTree);saveTree();renderTree();popup:Destroy();toast("Deleted")
						end)
						task.delay(3,function() if popup and popup.Parent then popup:Destroy() end end)
					end)
				end
			end)

			if item.open and item.children then
				for _,child in ipairs(item.children)do
					renderItem(child,depth+1)
				end
			end
		elseif item.type=="script" then
			local btn=n("TextButton",{Text=indent.."  "..item.name,Size=UDim2.new(1,-4,0,18),BackgroundColor3=C.bg,TextColor3=C.script,FontFace=F,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=order,Parent=sideScroll});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=btn})
			hover(btn)

			-- Single tap: load into editor
			btn.MouseButton1Click:Connect(function()
				addTab(item.name,item.source)
			end)

			-- Long hold: Rename + Delete popup
			local holding=false
			btn.InputBegan:Connect(function(inp)
				if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
					holding=true
					inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then holding=false end end)
					task.delay(0.6,function()
						if not holding then return end
						local popup=n("Frame",{Size=UDim2.fromOffset(160,55),Position=UDim2.new(0.3,0,0.38,0),BackgroundColor3=C.panel,BorderSizePixel=0,ZIndex=30,Parent=gui},{n("UICorner",{CornerRadius=UDim.new(0,5)})})
						n("TextLabel",{Text=item.name,Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,TextColor3=C.white,FontFace=FB,TextSize=11,ZIndex=30,Parent=popup})
						local popX=n("TextButton",{Text="X",Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-20,0,0),BackgroundTransparency=1,TextColor3=C.muted,FontFace=FB,TextSize=12,AutoButtonColor=false,ZIndex=30,Parent=popup});popX.MouseButton1Click:Connect(function() popup:Destroy() end)
						local renB=n("TextButton",{Text="Rename",Size=UDim2.fromOffset(70,24),Position=UDim2.fromOffset(4,24),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=30,Parent=popup});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=renB})
						local delB=n("TextButton",{Text="Delete",Size=UDim2.fromOffset(70,24),Position=UDim2.fromOffset(82,24),BackgroundColor3=C.red,TextColor3=C.white,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=30,Parent=popup});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=delB})
						renB.MouseButton1Click:Connect(function()
							popup:Destroy()
							local rb=n("TextBox",{Size=UDim2.fromOffset(160,22),Position=UDim2.new(0.3,0,0.4,0),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=12,Text=item.name,ClearTextOnFocus=true,BorderSizePixel=0,ZIndex=30,Parent=gui});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=rb})
							rb:CaptureFocus()
							rb.FocusLost:Connect(function()
								if rb.Text~=""then item.name=rb.Text end
								rb:Destroy();saveTree();renderTree();toast("Renamed")
							end)
						end)
						delB.MouseButton1Click:Connect(function()
							local function removeFrom(list) for i,it in ipairs(list)do if it==item then table.remove(list,i);return true elseif it.type=="folder"and it.children then if removeFrom(it.children)then return true end end end end
							removeFrom(userTree);saveTree();renderTree();popup:Destroy();toast("Deleted: "..item.name)
						end)
						task.delay(3,function() if popup and popup.Parent then popup:Destroy() end end)
					end)
				end
			end)
		end
	end

	for _,item in ipairs(userTree)do renderItem(item,0)end

	-- "+ New Folder" button (recreated every render, uses task.defer for safety)
	order+=1
	local nfb=n("TextButton",{Text="+ New Folder",Size=UDim2.new(1,-8,0,18),BackgroundColor3=C.btn,TextColor3=C.folder,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=999998,Parent=sideScroll});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=nfb});hover(nfb)
	nfb.MouseButton1Click:Connect(function()
		table.insert(userTree,{type="folder",name="New Folder",open=true,children={}})
		saveTree()
		task.defer(renderTree) -- defer to avoid destroying self mid-callback
		toast("Folder created")
	end)


end
renderTree()

------------------------------------------------------------
-- TAB BAR (bigger: 22px height)
------------------------------------------------------------
local tabBar=n("ScrollingFrame",{Size=UDim2.new(1,-sideW,0,30),Position=UDim2.fromOffset(0,26),BackgroundColor3=C.bg2,BorderSizePixel=0,ScrollingDirection=Enum.ScrollingDirection.X,ScrollBarThickness=2,AutomaticCanvasSize=Enum.AutomaticSize.X,CanvasSize=UDim2.fromScale(0,0),Parent=main},{n("UIListLayout",{Name="TL",FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1)})})

------------------------------------------------------------
-- EDITOR (left side, minus sidebar)
------------------------------------------------------------
local edF=n("Frame",{Size=UDim2.new(1,-sideW,1,-83),Position=UDim2.fromOffset(0,56),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true,Parent=main})
local lBar=n("Frame",{Size=UDim2.new(0,30,1,0),BackgroundColor3=C.bg2,BorderSizePixel=0,ZIndex=3,Parent=edF})
local lNums=n("TextLabel",{Size=UDim2.new(1,-4,0,9999),BackgroundTransparency=1,TextColor3=C.dim,FontFace=FC,TextSize=settings.fontSize,TextXAlignment=Enum.TextXAlignment.Right,TextYAlignment=Enum.TextYAlignment.Top,Text="1",ZIndex=4,Parent=lBar})
local cScr=n("ScrollingFrame",{Size=UDim2.new(1,-30,1,-16),Position=UDim2.fromOffset(30,0),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=5,AutomaticCanvasSize=Enum.AutomaticSize.XY,CanvasSize=UDim2.fromScale(0,0),ScrollingDirection=Enum.ScrollingDirection.XY,Parent=edF})
local cBox=n("TextBox",{Size=UDim2.new(1,-6,0,9999),Position=UDim2.fromOffset(3,0),BackgroundTransparency=1,TextColor3=SC.iden,TextTransparency=0.7,FontFace=FC,TextSize=settings.fontSize,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,MultiLine=true,ClearTextOnFocus=false,Text="",TextWrapped=settings.wrap,AutomaticSize=Enum.AutomaticSize.XY,ZIndex=3,Parent=cScr})
local cHL=n("TextLabel",{Size=UDim2.new(1,-6,0,9999),Position=UDim2.fromOffset(3,0),BackgroundTransparency=1,TextColor3=SC.iden,FontFace=FC,TextSize=settings.fontSize,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Text="",TextWrapped=settings.wrap,RichText=true,AutomaticSize=Enum.AutomaticSize.XY,ZIndex=4,Parent=cScr})

-- Stats bar
local sBar=n("Frame",{Size=UDim2.new(1,-30,0,16),Position=UDim2.new(0,30,1,-16),BackgroundColor3=C.bg2,BorderSizePixel=0,ZIndex=5,Visible=settings.showStats,Parent=edF})
local sLbl=n("TextLabel",{Size=UDim2.new(1,-8,1,0),Position=UDim2.fromOffset(4,0),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,Text="Lines: 1 | Chars: 0",ZIndex=5,Parent=sBar})
local tInd=n("TextLabel",{Size=UDim2.new(0,50,1,0),Position=UDim2.fromOffset(4,0),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Text="Tab 1/1",ZIndex=5,Parent=sBar})

cScr:GetPropertyChangedSignal("CanvasPosition"):Connect(function() lNums.Position=UDim2.fromOffset(0,-cScr.CanvasPosition.Y)end)

local function updLines() local t=cBox.Text;local nc=1;for _ in t:gmatch("\n")do nc+=1 end;local l={};for i=1,nc do l[i]=tostring(i)end;lNums.Text=table.concat(l,"\n");sLbl.Text="Lines: "..nc.." | Chars: "..#t end
local hlD=false
local HL_MAX = 10000 -- RichText char limit safety
local function doHL()
	if hlD then return end; hlD = true
	task.defer(function()
		local src = cBox.Text
		if #src > HL_MAX then
			-- Too large for RichText, show plain colored text
			cHL.Text = ""
			cBox.TextTransparency = 0
			cBox.TextColor3 = SC.iden
		else
			cBox.TextTransparency = 0.7
			local ls = string.split(src, "\n")
			local h = {}
			for i, l in ipairs(ls) do h[i] = hlLine(l) end
			cHL.Text = table.concat(h, "\n")
		end
		hlD = false
	end)
end
cBox:GetPropertyChangedSignal("Text"):Connect(function() updLines();doHL()end)

------------------------------------------------------------
-- BUTTON BAR
------------------------------------------------------------
local bb=n("Frame",{Size=UDim2.new(1,-sideW,0,27),Position=UDim2.new(0,0,1,-27),BackgroundColor3=C.bg2,BorderSizePixel=0,Parent=main},{n("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),VerticalAlignment=Enum.VerticalAlignment.Center}),n("UIPadding",{PaddingLeft=UDim.new(0,3)})})
local bExec=mb("Execute",58,bb,1)
local bClear=mb("Clear",42,bb,2)
local bPaste=mb("Paste",42,bb,3)
local bSave=mb("Save",38,bb,4)
local bCopy=mb("Copy",38,bb,5)
local bBlox=mb("ScriptBlox",66,bb,6)

------------------------------------------------------------
-- TAB SYSTEM
------------------------------------------------------------
local tabs,aTab,tabN={},nil,0

local function saveTabs() pcall(function() local d={};for _,t in ipairs(tabs)do if aTab==t then t.source=cBox.Text end;table.insert(d,{name=t.name,source=t.source or""})end;writefile(TABS_F,Http:JSONEncode(d))end)end
local function updTabInd() local idx=0;for i,t in ipairs(tabs)do if t==aTab then idx=i end end;tInd.Text="Tab "..idx.."/"..#tabs end
local function selTab(tab) if aTab then aTab.source=cBox.Text;aTab.frame.BackgroundColor3=C.tab end;aTab=tab;cBox.Text=tab.source or"";tab.frame.BackgroundColor3=C.tabOn;updLines();doHL();updTabInd()end

addTab = function(name,source,noSave)
	tabN+=1;name=name or("Script "..tabN);source=source or""
	local tf=n("Frame",{Size=UDim2.fromOffset(0,28),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=C.tab,BorderSizePixel=0,LayoutOrder=#tabs+1,Parent=tabBar},{n("UICorner",{CornerRadius=UDim.new(0,3)}),n("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder})})
	local tl=n("TextButton",{Text="  "..name.."  ",Size=UDim2.fromOffset(0,28),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=1,Parent=tf})
	local xb=n("TextButton",{Text="x",Size=UDim2.fromOffset(18,28),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=11,AutoButtonColor=false,LayoutOrder=2,Parent=tf})
	local tab={frame=tf,label=tl,name=name,source=source}
	table.insert(tabs,tab)
	local lastT=0
	tl.MouseButton1Click:Connect(function() local now=tick();if now-lastT<0.4 then tl.Visible=false;local rb=n("TextBox",{Size=UDim2.new(0,80,1,0),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=12,Text=tab.name,ClearTextOnFocus=true,BorderSizePixel=0,ZIndex=10,LayoutOrder=1,Parent=tf});rb:CaptureFocus();rb.FocusLost:Connect(function()if rb.Text~=""then tab.name=rb.Text;tl.Text="  "..tab.name.."  "end;rb:Destroy();tl.Visible=true;saveTabs()end)else selTab(tab)end;lastT=now end)
	xb.MouseButton1Click:Connect(function() if #tabs<=1 then return end;if aTab==tab then for _,t in ipairs(tabs)do if t~=tab then selTab(t);break end end end;for i,t in ipairs(tabs)do if t==tab then table.remove(tabs,i);break end end;tf:Destroy();saveTabs();updTabInd()end)
	selTab(tab);if not noSave then saveTabs()end;return tab
end
n("TextButton",{Text=" + ",Size=UDim2.fromOffset(20,28),BackgroundColor3=C.tab,TextColor3=C.white,FontFace=F,TextSize=15,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=999999,Parent=tabBar}).MouseButton1Click:Connect(function()addTab()end)

-- Load saved tabs
pcall(function() if isfile and isfile(TABS_F)then local d=Http:JSONDecode(readfile(TABS_F));if type(d)=="table"and #d>0 then for _,t in ipairs(d)do addTab(t.name,t.source,true)end;return end end;addTab(nil,nil,true)end)
cBox:GetPropertyChangedSignal("Text"):Connect(function() if aTab then aTab.source=cBox.Text end;task.defer(saveTabs)end)

------------------------------------------------------------
-- CONSOLE VIEWER
------------------------------------------------------------
local conW=makeWin("Console",400,250,UDim2.new(0.15,0,0.2,0));conW.Parent=gui
local conScroll=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-26),Position=UDim2.fromOffset(0,26),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),ZIndex=10,Parent=conW},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1)}),n("UIPadding",{PaddingLeft=UDim.new(0,4),PaddingTop=UDim.new(0,2),PaddingRight=UDim.new(0,4)})})
local conOrder=0

local consolePaused=false
local function addConLine(msg,msgType)
	if consolePaused then return end
	conOrder+=1
	local col=C.white
	if msgType==Enum.MessageType.MessageError then col=C.red
	elseif msgType==Enum.MessageType.MessageWarning then col=C.yellow
	elseif msgType==Enum.MessageType.MessageInfo then col=C.accent end
	n("TextLabel",{Text=msg,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,TextColor3=col,FontFace=FC,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=10,LayoutOrder=conOrder,Parent=conScroll})
	-- Auto scroll to bottom
	task.defer(function() conScroll.CanvasPosition=Vector2.new(0,conScroll.AbsoluteCanvasSize.Y)end)
end

-- Hook print/warn/error for console
local _origPrint,_origWarn=print,warn
print=function(...) local args={...};local parts={};for k=1,#args do parts[k]=tostring(args[k])end;local msg=table.concat(parts,"  ");_origPrint(...);pcall(addConLine,msg,Enum.MessageType.MessageOutput)end
warn=function(...) local args={...};local parts={};for k=1,#args do parts[k]=tostring(args[k])end;local msg=table.concat(parts,"  ");_origWarn(...);pcall(addConLine,msg,Enum.MessageType.MessageWarning)end
-- LogService hook removed (print/warn hooks handle it to avoid double logging)

------------------------------------------------------------
-- SAVE DIALOG (with folder selection)
------------------------------------------------------------
local svDia=n("Frame",{Size=UDim2.fromOffset(300,110),Position=UDim2.new(0.28,0,0.35,0),BackgroundColor3=C.panel,BorderSizePixel=0,Visible=false,ZIndex=20,Parent=gui});drag(svDia)
n("ImageLabel",{Image=ICON,Size=UDim2.fromOffset(16,19),Position=UDim2.fromOffset(4,2),BackgroundTransparency=1,ZIndex=21,Parent=svDia})
n("TextLabel",{Text="Save Script",Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=13,ZIndex=21,Parent=svDia})
n("TextButton",{Text="x",Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-26,0,1),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=15,BorderSizePixel=0,AutoButtonColor=false,ZIndex=21,Parent=svDia}).MouseButton1Click:Connect(function()svDia.Visible=false end)
local svNB=n("TextBox",{Size=UDim2.fromOffset(290,20),Position=UDim2.fromOffset(5,26),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=12,PlaceholderText="File Name",PlaceholderColor3=C.dim,Text="",ClearTextOnFocus=true,BorderSizePixel=0,ZIndex=21,Parent=svDia});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=svNB})

-- Folder selector
n("TextLabel",{Text="Save to folder:",Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(5,50),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=21,Parent=svDia})
local folderNames={"(Root)"}
for _,item in ipairs(userTree)do if item.type=="folder"then table.insert(folderNames,item.name)end end
local selFolder=1
local folderBtn=n("TextButton",{Text=folderNames[1],Size=UDim2.fromOffset(290,20),Position=UDim2.fromOffset(5,64),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,ZIndex=21,Parent=svDia});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=folderBtn})
folderBtn.MouseButton1Click:Connect(function() selFolder=(selFolder%#folderNames)+1;folderBtn.Text=folderNames[selFolder]end)

local svBt=n("TextButton",{Text="Save File",Size=UDim2.fromOffset(290,20),Position=UDim2.fromOffset(5,88),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,ZIndex=21,Parent=svDia});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=svBt});hover(svBt)

local function doSave()
	if aTab then aTab.source=cBox.Text end
	local nm=svNB.Text;if nm==""then nm=aTab and aTab.name or"script"end
	if not nm:match("%.lua$")then nm=nm..".lua"end
	if aTab and aTab.source and aTab.source~=""then
		local entry={type="script",name=nm,source=aTab.source}
		if selFolder==1 then
			table.insert(userTree,entry)
		else
			local folderName=folderNames[selFolder]
			for _,item in ipairs(userTree)do
				if item.type=="folder"and item.name==folderName then
					if not item.children then item.children={} end
					table.insert(item.children,entry);break
				end
			end
		end
		saveTree();renderTree();svDia.Visible=false;svNB.Text="";toast("Saved: "..nm)
	end
end
svBt.MouseButton1Click:Connect(doSave);svNB.FocusLost:Connect(function(e)if e then doSave()end end)

-- Create folder button in sidebar
-- newFolderBtn moved inside renderTree


------------------------------------------------------------
-- PLAYER UTILITIES (Phase 2)
------------------------------------------------------------
local noclipOn,flyOn,godOn,espOn,infJumpOn=false,false,false,false,false
local noclipC,flyC,flyBV,espHL,infJumpC

local plW=makeWin("Player Utilities",280,380,UDim2.new(0.35,0,0.04,0));plW.Parent=gui
local plScr=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-26),Position=UDim2.fromOffset(0,26),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),ZIndex=10,Parent=plW},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3)}),n("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingTop=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)})})

local function plHeader(t,o) n("TextLabel",{Text="-- "..t.." --",Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,TextColor3=C.accent,FontFace=FB,TextSize=12,LayoutOrder=o,ZIndex=10,Parent=plScr}) end

local function plToggle(name,o,cb)
	local row=n("Frame",{Size=UDim2.new(1,0,0,24),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=o,ZIndex=10,Parent=plScr},{n("UICorner",{CornerRadius=UDim.new(0,3)})})
	n("TextLabel",{Text="  "..name,Size=UDim2.new(0.72,0,1,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=row})
	local st=false
	local tb=n("TextButton",{Text="",Size=UDim2.fromOffset(16,16),Position=UDim2.new(0.82,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.fromRGB(167,167,167),FontFace=F,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row})
	tb.MouseButton1Click:Connect(function() st=not st;tb.Text=st and"x"or"";tb.BackgroundColor3=st and Color3.fromRGB(112,112,112)or Color3.fromRGB(167,167,167);if cb then cb(st)end end)
end

local function plNum(name,o,def,mn,mx,step,cb)
	local val=def
	local row=n("Frame",{Size=UDim2.new(1,0,0,24),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=o,ZIndex=10,Parent=plScr},{n("UICorner",{CornerRadius=UDim.new(0,3)})})
	n("TextLabel",{Text="  "..name,Size=UDim2.new(0.48,0,1,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=row})
	local vl=n("TextLabel",{Text=tostring(val),Size=UDim2.fromOffset(35,18),Position=UDim2.new(0.56,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,TextColor3=C.white,FontFace=FB,TextSize=12,ZIndex=10,Parent=row})
	local function upd(v) val=math.clamp(v,mn,mx);vl.Text=tostring(val);if cb then cb(val)end end
	local db=n("TextButton",{Text="-",Size=UDim2.fromOffset(24,20),Position=UDim2.new(0.76,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=14,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=db});db.MouseButton1Click:Connect(function() upd(val-step)end)
	local ib=n("TextButton",{Text="+",Size=UDim2.fromOffset(24,20),Position=UDim2.new(0.9,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=14,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=ib});ib.MouseButton1Click:Connect(function() upd(val+step)end)
end

local function plBtn(name,o,cb)
	local b=n("TextButton",{Text=name,Size=UDim2.new(1,0,0,24),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=F,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=o,ZIndex=10,Parent=plScr});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=b});hover(b);b.MouseButton1Click:Connect(cb)
end

plHeader("Movement",1)
plNum("Walk Speed",2,16,0,500,8,function(v) pcall(function() if LP.Character then LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed=v end end)end)
plNum("Jump Power",3,50,0,500,10,function(v) pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid");h.UseJumpPower=true;h.JumpPower=v end end)end)
plNum("Gravity",4,196,0,500,10,function(v) workspace.Gravity=v end)

plHeader("Toggles",10)
plToggle("God Mode",11,function(on) godOn=on;pcall(function() if LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid");h.MaxHealth=on and math.huge or 100;h.Health=on and math.huge or 100 end end);toast(on and"God ON"or"God OFF")end)

plToggle("Noclip",12,function(on) noclipOn=on
	if on then noclipC=RS.Stepped:Connect(function() pcall(function() if LP.Character then for _,p in ipairs(LP.Character:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end end end)end)
	else if noclipC then noclipC:Disconnect();noclipC=nil end end
	toast(on and"Noclip ON"or"Noclip OFF")
end)

plToggle("Infinite Jump",13,function(on) infJumpOn=on
	if on then infJumpC=UIS.JumpRequest:Connect(function() pcall(function() if LP.Character then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)end end)end)
	else if infJumpC then infJumpC:Disconnect();infJumpC=nil end end
	toast(on and"InfJump ON"or"InfJump OFF")
end)

plToggle("Fly (Mobile)",14,function(on) flyOn=on
	pcall(function()
		if on then
			local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			flyBV=Instance.new("BodyVelocity",hrp);flyBV.MaxForce=Vector3.new(math.huge,math.huge,math.huge);flyBV.Velocity=Vector3.zero
			-- PlatformStand removed for mobile compatibility
			flyC=RS.RenderStepped:Connect(function()
				if flyBV and hrp then
					local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
					if hum then
						local cam=workspace.CurrentCamera
						local mv=hum.MoveDirection
						if mv.Magnitude>0 then
							-- Use camera's look direction for vertical component
							local camLook=cam.CFrame.LookVector
							local verticalComponent=camLook.Y
							local flatDir=Vector3.new(mv.X,0,mv.Z).Unit
							-- Blend horizontal movement with camera pitch
							flyBV.Velocity=Vector3.new(flatDir.X*80, verticalComponent*80, flatDir.Z*80)
						else
							flyBV.Velocity=Vector3.zero
						end
					end
				end
			end)
		else
			if flyC then flyC:Disconnect();flyC=nil end
			if flyBV then flyBV:Destroy();flyBV=nil end
			-- PlatformStand removed for mobile compatibility
		end
	end)
	toast(on and"Fly ON (use joystick)"or"Fly OFF")
end)

plToggle("Fullbright",15,function(on)
	pcall(function()
		local l=game:GetService("Lighting")
		if on then l.Brightness=2;l.ClockTime=14;l.FogEnd=100000;l.GlobalShadows=false
			for _,e in ipairs(l:GetChildren())do if e:IsA("PostEffect")or e:IsA("Atmosphere")then e.Enabled=false end end
		else l.Brightness=1;l.GlobalShadows=true
			for _,e in ipairs(l:GetChildren())do if e:IsA("PostEffect")or e:IsA("Atmosphere")then e.Enabled=true end end
		end
	end)
	toast(on and"Fullbright ON"or"Fullbright OFF")
end)

plToggle("ESP (Team Check)",16,function(on) espOn=on
	if on then
		espHL={}
		local function addESP(plr)
			if plr==LP then return end
			local function apply()
				pcall(function()
					if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart")then return end
					local old=plr.Character:FindFirstChild("MohESP");if old then old:Destroy()end
					local old2=plr.Character:FindFirstChild("MohHL");if old2 then old2:Destroy()end
					local isTeam=(LP.Team and plr.Team==LP.Team)
					local col=isTeam and C.blue or C.red
					local bb=Instance.new("BillboardGui");bb.Name="MohESP";bb.Size=UDim2.fromOffset(200,50);bb.AlwaysOnTop=true;bb.StudsOffset=Vector3.new(0,3,0);bb.Parent=plr.Character.HumanoidRootPart
					local tl=Instance.new("TextLabel",bb);tl.Size=UDim2.fromScale(1,1);tl.BackgroundTransparency=1;tl.TextColor3=col;tl.Font=Enum.Font.GothamBold;tl.TextSize=14;tl.Text=plr.DisplayName
					local hl=Instance.new("Highlight");hl.Name="MohHL";hl.FillColor=col;hl.FillTransparency=0.7;hl.OutlineColor=col;hl.OutlineTransparency=0.3;hl.Parent=plr.Character
				end)
			end
			apply()
			local conn=plr.CharacterAdded:Connect(function() task.wait(1);if espOn then apply()end end)
			table.insert(espHL,{plr=plr,conn=conn})
		end
		for _,p in ipairs(Players:GetPlayers())do addESP(p)end
		table.insert(espHL,{conn=Players.PlayerAdded:Connect(function(p) if espOn then task.wait(2);addESP(p)end end)})
		toast("ESP ON (Blue=Team Red=Enemy)")
	else
		if espHL then for _,e in ipairs(espHL)do if e.conn then e.conn:Disconnect()end end end
		for _,p in ipairs(Players:GetPlayers())do pcall(function() if p.Character then local bb=p.Character:FindFirstChild("MohESP");if bb then bb:Destroy()end;local hl2=p.Character:FindFirstChild("MohHL");if hl2 then hl2:Destroy()end end end)end
		espHL=nil;toast("ESP OFF")
	end
end)

plHeader("Teleport",20)

-- TP to player with search and distance sort
local tpSearchBox=n("TextBox",{Text="",Size=UDim2.new(1,0,0,22),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=12,PlaceholderText="Search player...",PlaceholderColor3=C.dim,ClearTextOnFocus=false,BorderSizePixel=0,LayoutOrder=21,ZIndex=10,Parent=plScr});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=tpSearchBox})

local tpListFrame=n("ScrollingFrame",{Size=UDim2.new(1,0,0,120),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),LayoutOrder=22,ZIndex=10,Parent=plScr},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)}),n("UIPadding",{PaddingTop=UDim.new(0,2),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2)})})

local function refreshTPList(filter)
	for _,c in ipairs(tpListFrame:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end
	local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	local playerList={}
	for _,p in ipairs(Players:GetPlayers())do
		if p==LP then continue end
		if filter and filter~=""and not p.Name:lower():find(filter:lower())and not p.DisplayName:lower():find(filter:lower())then continue end
		local dist=math.huge
		if hrp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then
			dist=math.round((p.Character.HumanoidRootPart.Position-hrp.Position).Magnitude)
		end
		table.insert(playerList,{player=p,dist=dist})
	end
	table.sort(playerList,function(a,b) return a.dist<b.dist end)
	for i,pd in ipairs(playerList)do
		local p=pd.player
		local distTxt=pd.dist<math.huge and(" ("..pd.dist.."m)")or""
		local btn=n("TextButton",{Text="  "..p.DisplayName..distTxt,Size=UDim2.new(1,0,0,20),BackgroundColor3=C.card,TextColor3=C.white,FontFace=F,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=i,ZIndex=10,Parent=tpListFrame});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=btn});hover(btn)
		btn.MouseButton1Click:Connect(function()
			pcall(function()
				local myHrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
				local theirHrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if myHrp and theirHrp then
					myHrp.CFrame=theirHrp.CFrame*CFrame.new(0,0,3)
					toast("TP to "..p.DisplayName)
				end
			end)
		end)
	end
end

refreshTPList()
tpSearchBox:GetPropertyChangedSignal("Text"):Connect(function() refreshTPList(tpSearchBox.Text)end)
tpSearchBox.FocusLost:Connect(function() refreshTPList(tpSearchBox.Text)end)
-- Refresh player list periodically
task.spawn(function() while plW.Parent do task.wait(5);if plW.Visible then refreshTPList(tpSearchBox.Text)end end end)

plHeader("Actions",30)
plBtn("Reset Character",31,function() pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").Health=0 end)end)
plBtn("Refresh Player List",32,function() refreshTPList(tpSearchBox.Text);toast("Refreshed")end)


------------------------------------------------------------
-- OPTIONS WINDOW
------------------------------------------------------------
-- Forward declarations for windows referenced in Options
local smW, aeW
local smDisplayed, loadServers = 0, nil

local optW=makeWin("Options",300,360,UDim2.new(0.35,0,0.12,0));optW.Parent=gui
local optScr=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-26),Position=UDim2.fromOffset(0,26),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),ZIndex=10,Parent=optW},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3)}),n("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingTop=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingBottom=UDim.new(0,6)})})

local function oLabel(t,o) n("TextLabel",{Text="-- "..t.." --",Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,TextColor3=C.accent,FontFace=FB,TextSize=13,LayoutOrder=o,ZIndex=10,Parent=optScr})end
local function oToggle(name,o,default,cb)
	local row=n("Frame",{Size=UDim2.new(1,0,0,24),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=o,ZIndex=10,Parent=optScr},{n("UICorner",{CornerRadius=UDim.new(0,3)})})
	n("TextLabel",{Text="  "..name,Size=UDim2.new(0.72,0,1,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=row})
	local st=default
	local tb=n("TextButton",{Text=st and"x"or"",Size=UDim2.fromOffset(14,14),Position=UDim2.new(0.82,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=st and Color3.fromRGB(112,112,112)or Color3.fromRGB(167,167,167),FontFace=F,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row})
	tb.MouseButton1Click:Connect(function() st=not st;tb.Text=st and"x"or"";tb.BackgroundColor3=st and Color3.fromRGB(112,112,112)or Color3.fromRGB(167,167,167);if cb then cb(st)end end)
end
local function oBtn(name,o,cb) local b=n("TextButton",{Text=name,Size=UDim2.new(1,0,0,24),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=F,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=o,ZIndex=10,Parent=optScr});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=b});hover(b);b.MouseButton1Click:Connect(cb)end
local function oNum(name,o,def,mn,mx,step,cb)
	local val=def;local row=n("Frame",{Size=UDim2.new(1,0,0,24),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=o,ZIndex=10,Parent=optScr},{n("UICorner",{CornerRadius=UDim.new(0,3)})})
	n("TextLabel",{Text="  "..name,Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=row})
	local vl=n("TextLabel",{Text=tostring(val),Size=UDim2.fromOffset(30,16),Position=UDim2.new(0.6,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,TextColor3=C.white,FontFace=FB,TextSize=11,ZIndex=10,Parent=row})
	local function upd(v) val=math.clamp(v,mn,mx);vl.Text=tostring(val);if cb then cb(val)end end
	n("TextButton",{Text="-",Size=UDim2.fromOffset(18,16),Position=UDim2.new(0.78,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=13,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row}).MouseButton1Click:Connect(function()upd(val-step)end)
	n("TextButton",{Text="+",Size=UDim2.fromOffset(18,16),Position=UDim2.new(0.9,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=13,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row}).MouseButton1Click:Connect(function()upd(val+step)end)
end

oLabel("Editor",1)
oToggle("Text Wrap",2,settings.wrap,function(on) settings.wrap=on;cBox.TextWrapped=on;cHL.TextWrapped=on;saveSettings()end)
oNum("Font Size",3,settings.fontSize,8,24,1,function(v) settings.fontSize=v;cBox.TextSize=v;cHL.TextSize=v;lNums.TextSize=v;saveSettings()end)
oToggle("Show Stats",4,settings.showStats,function(on) settings.showStats=on;pcall(function() sBar.Visible=on end);saveSettings()end)
oToggle("Show FPS/Ping",5,settings.showFps,function(on) settings.showFps=on;pcall(function() monF.Visible=on end);saveSettings()end)
oToggle("Anti AFK",6,settings.antiAfk,function(on) settings.antiAfk=on;saveSettings();if on then pcall(function()local VU=game:GetService("VirtualUser");LP.Idled:Connect(function()VU:CaptureController();VU:ClickButton2(Vector2.new())end)end)end end)

oLabel("Utilities",10)
oBtn("Server Manager",10,function() smW.Visible=not smW.Visible;if smW.Visible and smDisplayed==0 then loadServers(true) end end)
oBtn("Player Utilities",11,function() plW.Visible=not plW.Visible end)
-- Server Utilities merged into Server Manager
oBtn("Console",13,function() conW.Visible=not conW.Visible end)
oBtn("Clear Console",14,function() for _,c in ipairs(conScroll:GetChildren())do if c:IsA("TextLabel")then c:Destroy()end end;conOrder=0;toast("Console cleared")end)
oToggle("Pause Console",15,settings.consolePaused or false,function(on) consolePaused=on;if on then print=_origPrint;warn=_origWarn else print=function(...) local args={...};local parts={};for k=1,#args do parts[k]=tostring(args[k])end;local msg=table.concat(parts,"  ");_origPrint(...);pcall(addConLine,msg,Enum.MessageType.MessageOutput)end;warn=function(...) local args={...};local parts={};for k=1,#args do parts[k]=tostring(args[k])end;local msg=table.concat(parts,"  ");_origWarn(...);pcall(addConLine,msg,Enum.MessageType.MessageWarning)end end;toast(on and "Console paused (Roblox console active)" or "Console resumed")end)
oBtn("AutoExec Manager",16,function() aeW.Visible=not aeW.Visible end)

oLabel("Other",20)
-- FPS Cap selector (cycling)
local fpsCaps={30,60,120,144,0}
local fpsIdx=2
-- Restore saved FPS cap
if settings.fpsCap then for i,v in ipairs(fpsCaps) do if v==settings.fpsCap then fpsIdx=i;pcall(function()setfpscap(v==0 and math.huge or v)end);break end end end
local fpsCapBtn=n("TextButton",{Text="FPS Cap: "..(settings.fpsCap and(settings.fpsCap==0 and"Unlimited"or tostring(settings.fpsCap))or"60"),Size=UDim2.new(1,0,0,24),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=F,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=21,ZIndex=10,Parent=optScr});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=fpsCapBtn});hover(fpsCapBtn)
fpsCapBtn.MouseButton1Click:Connect(function() fpsIdx=(fpsIdx%#fpsCaps)+1;local cap=fpsCaps[fpsIdx];pcall(function()setfpscap(cap==0 and math.huge or cap)end);fpsCapBtn.Text="FPS Cap: "..(cap==0 and"Unlimited"or tostring(cap));toast("FPS: "..(cap==0 and"Unlimited"or tostring(cap)));settings.fpsCap=cap;saveSettings()end)
oBtn("Reset Positions",22,function() main.Position=UDim2.fromOffset(20,25);toast("Reset")end)
oNum("UI Scale",8,settings.uiScale or 1,0.5,1.5,0.1,function(v) settings.uiScale=v;uiScaleObj.Scale=v;saveSettings()end)
oBtn("Clear All Tabs",23,function() for _,t in ipairs(tabs)do t.frame:Destroy()end;table.clear(tabs);tabN=0;aTab=nil;addTab();toast("Cleared")end)

sideOptBtn.MouseButton1Click:Connect(function() optW.Visible=not optW.Visible end)

------------------------------------------------------------
-- SCRIPTBLOX
------------------------------------------------------------
local sbW=makeWin("ScriptBlox",440,320,UDim2.new(0.1,0,0.05,0));sbW.Parent=gui
local sRow=n("Frame",{Size=UDim2.new(1,0,0,26),Position=UDim2.fromOffset(0,26),BackgroundColor3=C.panel,BorderSizePixel=0,ZIndex=10,Parent=sbW})
local sBox=n("TextBox",{Size=UDim2.new(1,-135,0,20),Position=UDim2.fromOffset(4,3),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=13,PlaceholderText="Search...",PlaceholderColor3=C.dim,Text="",ClearTextOnFocus=false,BorderSizePixel=0,ZIndex=10,Parent=sRow});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=sBox});n("UIPadding",{PaddingLeft=UDim.new(0,5),Parent=sBox})
local sBt=mb("Search",50,sRow,0);sBt.Position=UDim2.new(1,-125,0,3);sBt.Size=UDim2.fromOffset(50,20);sBt.ZIndex=10
local gBt=mb("This Game",65,sRow,0);gBt.Position=UDim2.new(1,-70,0,3);gBt.Size=UDim2.fromOffset(65,20);gBt.ZIndex=10
local sbR=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-52),Position=UDim2.fromOffset(0,56),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),ZIndex=10,Parent=sbW},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)}),n("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,3),PaddingBottom=UDim.new(0,3)})})
local sbSt=n("TextLabel",{Text="Search for scripts",Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=12,ZIndex=10,Parent=sbR})
local sbQ,sbP,sbMP,sbLd,sbCt="",1,1,false,0
local function clSB() for _,c in ipairs(sbR:GetChildren())do if c:IsA("Frame")then c:Destroy()end end;sbCt=0 end
local function addSC(scr,ord)
	local t=scr.title or"?";local g=(scr.game and scr.game.name)or"Universal";local v=scr.views or 0;local sl=scr.slug or""
	local cd=n("Frame",{Size=UDim2.new(1,0,0,52),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=ord,ZIndex=10,Parent=sbR},{n("UICorner",{CornerRadius=UDim.new(0,4)})})
	n("TextLabel",{Text=t,Size=UDim2.new(0.6,0,0,14),Position=UDim2.fromOffset(5,3),BackgroundTransparency=1,TextColor3=C.white,FontFace=FB,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=10,Parent=cd})
	local inf=g.." | "..v.." views";if scr.isPatched then inf=inf.." | PATCHED"end
	n("TextLabel",{Text=inf,Size=UDim2.new(0.95,0,0,11),Position=UDim2.fromOffset(5,17),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=10,Parent=cd})
	local function gs() if scr.script then return scr.script end;local ok,s=pcall(function()return Http:JSONDecode(game:HttpGet("https://scriptblox.com/api/script/"..sl)).script.script end);return ok and s end
	local bsz,by=UDim2.fromOffset(36,16),32
	local b1=n("TextButton",{Text="Run",Size=bsz,Position=UDim2.new(1,-152,0,by),BackgroundColor3=C.green,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=cd});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=b1});b1.MouseButton1Click:Connect(function()b1.Text="...";local s=gs();if s then pcall(loadstring(s));b1.Text="OK!"else b1.Text="Err"end;task.delay(1,function()b1.Text="Run"end)end)
	local b2=n("TextButton",{Text="Edit",Size=bsz,Position=UDim2.new(1,-112,0,by),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=cd});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=b2});b2.MouseButton1Click:Connect(function()b2.Text="...";local s=gs();if s then addTab(t:sub(1,20),s);sbW.Visible=false end;b2.Text="Edit"end)
	local b3=n("TextButton",{Text="Save",Size=bsz,Position=UDim2.new(1,-72,0,by),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=cd});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=b3});b3.MouseButton1Click:Connect(function()b3.Text="...";local s=gs();if s then svNB.Text=t:sub(1,25);folderNames={"(Root)"};for _,fi in ipairs(userTree)do if fi.type=="folder"then table.insert(folderNames,fi.name)end end;selFolder=1;folderBtn.Text=folderNames[1];aTab={name=t:sub(1,25),source=s};svDia.Visible=true;sbW.Visible=false;b3.Text="Save";toast("Choose folder and save")else b3.Text="Err";task.delay(1,function()b3.Text="Save"end)end end)
	local b4=n("TextButton",{Text="Copy",Size=bsz,Position=UDim2.new(1,-32,0,by),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=cd});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=b4});b4.MouseButton1Click:Connect(function()b4.Text="...";local s=gs();if s then pcall(function()setclipboard(s)end);b4.Text="OK!"else b4.Text="Err"end;task.delay(1,function()b4.Text="Copy"end)end)
end
local function ldSB(q,pg,app)
	if sbLd then return end;sbLd=true;if not app then clSB()end;sbSt.Text="Loading...";sbSt.Visible=true
	task.spawn(function()
		local ok,d=pcall(function()local u=(q==""or not q)and("https://scriptblox.com/api/script/fetch?page="..pg.."&max=15")or("https://scriptblox.com/api/script/search?q="..Http:UrlEncode(q).."&page="..pg.."&max=15");return Http:JSONDecode(game:HttpGet(u))end)
		if not ok or not d or not d.result or not d.result.scripts then sbSt.Text="Failed.";sbLd=false;return end
		sbMP=d.result.totalPages or 1;sbP=pg
		if #d.result.scripts==0 and not app then sbSt.Text="No results.";sbLd=false;return end
		sbSt.Visible=false;for _,s in ipairs(d.result.scripts)do sbCt+=1;addSC(s,sbCt)end
		sbSt.Text=sbP<sbMP and("Page "..sbP.."/"..sbMP.." - scroll more")or"End.";sbSt.Visible=true;sbLd=false
	end)
end
local function srSB(q)sbQ=q;sbP=1;sbMP=1;ldSB(q,1,false)end
sbR:GetPropertyChangedSignal("CanvasPosition"):Connect(function()if sbLd or sbP>=sbMP then return end;if sbR.AbsoluteCanvasSize.Y-sbR.CanvasPosition.Y-sbR.AbsoluteSize.Y<50 then ldSB(sbQ,sbP+1,true)end end)
sBt.MouseButton1Click:Connect(function()srSB(sBox.Text)end)
sBox.FocusLost:Connect(function(e)if e then srSB(sBox.Text)end end)
gBt.MouseButton1Click:Connect(function()local ok,gn=pcall(function()return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end);sBox.Text=ok and gn or"";srSB(sBox.Text)end)

------------------------------------------------------------


------------------------------------------------------------
-- AUTOEXEC MANAGER
------------------------------------------------------------
local aeScripts={}
pcall(function() makefolder(AE_DIR);if isfolder and isfolder(AE_DIR)then for _,p in ipairs(listfiles(AE_DIR))do if isfile(p)then table.insert(aeScripts,{name=p:match("([^/\\]+)$")or p,source=readfile(p)})end end end end)

aeW=makeWin("Auto Execute",300,280,UDim2.new(0.3,0,0.12,0));aeW.Parent=gui
local aeAddBtn=n("TextButton",{Text="+ Add Current Script",Size=UDim2.new(1,-8,0,22),Position=UDim2.fromOffset(4,29),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=aeW});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=aeAddBtn})
local aeList=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-55),Position=UDim2.fromOffset(0,55),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),ZIndex=10,Parent=aeW},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)}),n("UIPadding",{PaddingTop=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingBottom=UDim.new(0,4)})})

local function refreshAE()
	for _,c in ipairs(aeList:GetChildren())do if c:IsA("Frame")then c:Destroy()end end
	for i,s in ipairs(aeScripts)do
		local row=n("Frame",{Size=UDim2.new(1,0,0,24),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=i,ZIndex=10,Parent=aeList},{n("UICorner",{CornerRadius=UDim.new(0,3)})})
		n("TextLabel",{Text=" "..s.name,Size=UDim2.new(1,-30,1,0),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=10,Parent=row})
		local del=n("TextButton",{Text="X",Size=UDim2.fromOffset(20,18),Position=UDim2.new(1,-24,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.red,TextColor3=C.white,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=row});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=del})
		del.MouseButton1Click:Connect(function() pcall(function() if isfile(AE_DIR.."/"..s.name)then delfile(AE_DIR.."/"..s.name)end end);table.remove(aeScripts,i);refreshAE();toast("Removed")end)
	end
end
refreshAE()

aeAddBtn.MouseButton1Click:Connect(function()
	if aTab then aTab.source=cBox.Text end
	if aTab and aTab.source and aTab.source~="" then
		local nm=aTab.name;if not nm:match("%.lua$")then nm=nm..".lua"end
		pcall(function() makefolder(AE_DIR);writefile(AE_DIR.."/"..nm,aTab.source)end)
		table.insert(aeScripts,{name=nm,source=aTab.source});refreshAE();toast("Added to AutoExec")
	end
end)

------------------------------------------------------------
-- SERVER MANAGER (Phase 3)
------------------------------------------------------------
smW=makeWin("Server Manager",480,420,UDim2.new(0.08,0,0.04,0));smW.Parent=gui

-- Filter bar
-- Server Info Bar
local smInfoBar=n("Frame",{Size=UDim2.new(1,0,0,56),Position=UDim2.fromOffset(0,26),BackgroundColor3=C.bg2,BorderSizePixel=0,ZIndex=10,Parent=smW})
n("TextLabel",{Text="PlaceId: "..game.PlaceId,Size=UDim2.new(0.5,0,0,14),Position=UDim2.fromOffset(6,3),BackgroundTransparency=1,TextColor3=C.muted,FontFace=FC,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smInfoBar})
n("TextLabel",{Text="JobId: "..game.JobId:sub(1,20).."...",Size=UDim2.new(0.5,0,0,14),Position=UDim2.fromOffset(6,16),BackgroundTransparency=1,TextColor3=C.muted,FontFace=FC,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smInfoBar})

local smCopyPid=n("TextButton",{Text="Copy PlaceId",Size=UDim2.fromOffset(75,16),Position=UDim2.new(0.52,0,0,3),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=F,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smInfoBar});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=smCopyPid});hover(smCopyPid)
smCopyPid.MouseButton1Click:Connect(function() pcall(function() setclipboard(tostring(game.PlaceId))end);smCopyPid.Text="Copied!";task.delay(1,function() smCopyPid.Text="Copy PlaceId"end)end)

local smCopyJid=n("TextButton",{Text="Copy JobId",Size=UDim2.fromOffset(65,16),Position=UDim2.new(0.52,0,0,22),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=F,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smInfoBar});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=smCopyJid});hover(smCopyJid)
smCopyJid.MouseButton1Click:Connect(function() pcall(function() setclipboard(game.JobId)end);smCopyJid.Text="Copied!";task.delay(1,function() smCopyJid.Text="Copy JobId"end)end)

local smRejoinBtn=n("TextButton",{Text="Rejoin",Size=UDim2.fromOffset(50,16),Position=UDim2.new(0.72,0,0,3),BackgroundColor3=C.green,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smInfoBar});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=smRejoinBtn});hover(smRejoinBtn)
smRejoinBtn.MouseButton1Click:Connect(function() pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId)end)end)

-- Join by JobId
local smJoinBox=n("TextBox",{Text="",Size=UDim2.new(0.55,0,0,16),Position=UDim2.fromOffset(6,37),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=10,PlaceholderText="Paste JobId to join...",PlaceholderColor3=C.dim,ClearTextOnFocus=false,BorderSizePixel=0,ZIndex=10,Parent=smInfoBar});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=smJoinBox})
local smJoinBtn=n("TextButton",{Text="Join",Size=UDim2.fromOffset(35,16),Position=UDim2.new(0.57,0,0,37),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smInfoBar});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=smJoinBtn});hover(smJoinBtn)
smJoinBtn.MouseButton1Click:Connect(function() if smJoinBox.Text~=""then pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,smJoinBox.Text)end);toast("Joining...")end end)

n("TextLabel",{Text="Players: "..#Players:GetPlayers().."/"..Players.MaxPlayers,Size=UDim2.fromOffset(100,16),Position=UDim2.new(0.72,0,0,22),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smInfoBar})

local smFilterBar=n("Frame",{Size=UDim2.new(1,0,0,52),Position=UDim2.fromOffset(0,82),BackgroundColor3=C.panel,BorderSizePixel=0,ZIndex=10,Parent=smW})

-- Sort dropdown (cycling button)
local smSortOptions={"Default","Smallest First","Largest First","Newest","Oldest"}
local smSortIdx=1
local smSortBtn=n("TextButton",{Text="Sort: Default",Size=UDim2.fromOffset(140,20),Position=UDim2.fromOffset(4,3),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smFilterBar});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=smSortBtn})
smSortBtn.MouseButton1Click:Connect(function()
	smSortIdx=(smSortIdx%#smSortOptions)+1
	smSortBtn.Text="Sort: "..smSortOptions[smSortIdx]
end)

-- Refresh button
local smRefreshBtn=n("TextButton",{Text="Refresh",Size=UDim2.fromOffset(60,20),Position=UDim2.fromOffset(150,3),BackgroundColor3=C.accent,TextColor3=C.white,FontFace=FB,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smFilterBar});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=smRefreshBtn});hover(smRefreshBtn)

-- Server count label
local smCountLbl=n("TextLabel",{Text="Servers: --",Size=UDim2.fromOffset(100,20),Position=UDim2.new(1,-108,0,3),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=10,Parent=smFilterBar})

-- Min/Max players filter
n("TextLabel",{Text="Min Players:",Size=UDim2.fromOffset(70,18),Position=UDim2.fromOffset(4,27),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smFilterBar})
local smMinBox=n("TextBox",{Text="0",Size=UDim2.fromOffset(35,18),Position=UDim2.fromOffset(75,27),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=10,BorderSizePixel=0,ClearTextOnFocus=true,ZIndex=10,Parent=smFilterBar});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=smMinBox})

n("TextLabel",{Text="Max Players:",Size=UDim2.fromOffset(70,18),Position=UDim2.fromOffset(120,27),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smFilterBar})
local smMaxBox=n("TextBox",{Text="100",Size=UDim2.fromOffset(35,18),Position=UDim2.fromOffset(192,27),BackgroundColor3=C.input,TextColor3=C.white,FontFace=F,TextSize=10,BorderSizePixel=0,ClearTextOnFocus=true,ZIndex=10,Parent=smFilterBar});n("UICorner",{CornerRadius=UDim.new(0,2),Parent=smMaxBox})

-- Exclude full toggle
local smExcludeFull=true
local smExcBtn=n("TextButton",{Text="x",Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(240,29),BackgroundColor3=Color3.fromRGB(112,112,112),TextColor3=Color3.fromRGB(0,0,0),FontFace=F,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smFilterBar})
n("TextLabel",{Text="Hide Full",Size=UDim2.fromOffset(55,18),Position=UDim2.fromOffset(258,27),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smFilterBar})
smExcBtn.MouseButton1Click:Connect(function() smExcludeFull=not smExcludeFull;smExcBtn.Text=smExcludeFull and"x"or"";smExcBtn.BackgroundColor3=smExcludeFull and Color3.fromRGB(112,112,112)or Color3.fromRGB(167,167,167) end)

-- Exclude current server toggle
local smExcCurrent=true
local smExcCurBtn=n("TextButton",{Text="x",Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(320,29),BackgroundColor3=Color3.fromRGB(112,112,112),TextColor3=Color3.fromRGB(0,0,0),FontFace=F,TextSize=11,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=smFilterBar})
n("TextLabel",{Text="Hide Current",Size=UDim2.fromOffset(70,18),Position=UDim2.fromOffset(338,27),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smFilterBar})
smExcCurBtn.MouseButton1Click:Connect(function() smExcCurrent=not smExcCurrent;smExcCurBtn.Text=smExcCurrent and"x"or"";smExcCurBtn.BackgroundColor3=smExcCurrent and Color3.fromRGB(112,112,112)or Color3.fromRGB(167,167,167) end)

-- Server list scroll
local smList=n("ScrollingFrame",{Size=UDim2.new(1,0,1,-134),Position=UDim2.fromOffset(0,134),BackgroundColor3=C.bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0),ZIndex=10,Parent=smW},{n("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)}),n("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingBottom=UDim.new(0,4)})})
local smStatus=n("TextLabel",{Text="Press Refresh to load servers",Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=12,ZIndex=10,Parent=smList})

smAllServers={}
smPage=1
smLoading=false
smCursor=""
smDisplayed=0

local function clearSM()
	for _,c in ipairs(smList:GetChildren())do if c:IsA("Frame")then c:Destroy()end end
	smDisplayed=0
end

local function addServerCard(srv,ord)
	local players=srv.playing or 0
	local maxP=srv.maxPlayers or 0
	local jobId=srv.id or""
	local ping=srv.ping or 0
	local fps=srv.fps or 0
	local fillPct=maxP>0 and math.round(players/maxP*100)or 0
	local isCurrent=(jobId==game.JobId)

	local card=n("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=C.card,BorderSizePixel=0,LayoutOrder=ord,ZIndex=10,Parent=smList},{n("UICorner",{CornerRadius=UDim.new(0,4)})})

	-- Server info
	local pColor=fillPct>80 and C.red or fillPct>50 and C.yellow or C.green
	n("TextLabel",{Text=players.."/"..maxP.." players ("..fillPct.."%)",Size=UDim2.new(0.4,0,0,14),Position=UDim2.fromOffset(6,4),BackgroundTransparency=1,TextColor3=pColor,FontFace=FB,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=card})

	-- JobId (truncated)
	n("TextLabel",{Text="ID: "..jobId:sub(1,16).."...",Size=UDim2.new(0.5,0,0,12),Position=UDim2.fromOffset(6,18),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=card})

	-- Ping/FPS/Region info
	local region="Unknown"
	if ping>0 then
		if ping<50 then region="Nearby"
		elseif ping<100 then region="Close"
		elseif ping<150 then region="Medium"
		elseif ping<250 then region="Far"
		else region="Very Far" end
	end
	local infoTxt=""
	if ping>0 then infoTxt=infoTxt.."Ping:"..ping.."ms " end
	if fps>0 then infoTxt=infoTxt.."FPS:"..math.round(fps).." " end
	infoTxt=infoTxt.."Region:"..region
	if isCurrent then infoTxt=">> Current Server <<" end

	-- Ping color indicator
	local pingCol=C.dim
	if ping>0 and ping<80 then pingCol=C.green
	elseif ping>0 and ping<150 then pingCol=C.yellow
	elseif ping>0 then pingCol=C.red end

	n("TextLabel",{Text=infoTxt,Size=UDim2.new(0.55,0,0,12),Position=UDim2.fromOffset(6,32),BackgroundTransparency=1,TextColor3=isCurrent and C.accent or pingCol,FontFace=F,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=card})

	-- Player IDs count (if available)
	local playerIds=srv.playerIds
	local playerIdCount=playerIds and #playerIds or 0
	if playerIdCount>0 and not isCurrent then
		n("TextLabel",{Text="IDs: "..playerIdCount,Size=UDim2.fromOffset(40,12),Position=UDim2.new(0.58,0,0,32),BackgroundTransparency=1,TextColor3=C.dim,FontFace=F,TextSize=8,ZIndex=10,Parent=card})
	end

	-- Fill bar
	local barBg=n("Frame",{Size=UDim2.new(0.35,0,0,6),Position=UDim2.new(0.4,0,0,8),BackgroundColor3=C.bg,BorderSizePixel=0,ZIndex=10,Parent=card},{n("UICorner",{CornerRadius=UDim.new(1,0)})})
	n("Frame",{Size=UDim2.new(fillPct/100,0,1,0),BackgroundColor3=pColor,BorderSizePixel=0,ZIndex=10,Parent=barBg},{n("UICorner",{CornerRadius=UDim.new(1,0)})})

	-- Join button
	local joinBtn=n("TextButton",{Text=isCurrent and"Current"or"Join",Size=UDim2.fromOffset(44,20),Position=UDim2.new(1,-100,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=isCurrent and C.dim or C.green,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=card});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=joinBtn})
	if not isCurrent then
		joinBtn.MouseButton1Click:Connect(function()
			joinBtn.Text="..."
			pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,jobId) end)
			toast("Joining server...")
		end)
	end

	-- Copy ID button
	local cpBtn=n("TextButton",{Text="Copy ID",Size=UDim2.fromOffset(44,20),Position=UDim2.new(1,-52,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=10,BorderSizePixel=0,AutoButtonColor=false,ZIndex=10,Parent=card});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=cpBtn})
	cpBtn.MouseButton1Click:Connect(function()
		pcall(function() setclipboard(jobId) end)
		cpBtn.Text="OK!"
		task.delay(1,function() cpBtn.Text="Copy ID" end)
	end)
end

loadServers=function(reset)
	if smLoading then toast('Already loading...');return end
	smLoading=true
	if reset then clearSM();smCursor="";smAllServers={};smPage=1 end
	smStatus.Text="Loading servers...";smStatus.Visible=true

	task.spawn(function()
		local ok,data=pcall(function()
			local url='https://games.roblox.com/v1/games/'..game.PlaceId..'/servers/Public?sortOrder=Desc&limit=10'
			if smCursor~="" then url=url..'&cursor='..smCursor end
			local raw=game:HttpGet(url)
			return Http:JSONDecode(raw)
		end)

		if not ok or not data or not data.data then
			smStatus.Text="Failed to load. Try Refresh."
			smLoading=false
			return
		end

		smCursor=data.nextPageCursor or""
		local servers=data.data or {}
		local minP=tonumber(smMinBox.Text)or 0
		local maxP=tonumber(smMaxBox.Text)or 100

		-- Filter
		local filtered={}
		for _,srv in ipairs(servers)do
			local p=srv.playing or 0
			local mp=srv.maxPlayers or 0
			if smExcludeFull and p>=mp then continue end
			if smExcCurrent and srv.id==game.JobId then continue end
			if p<minP then continue end
			if p>maxP and maxP>0 then continue end
			table.insert(filtered,srv)
		end

		-- Sort
		local sortMode=smSortOptions[smSortIdx]
		if sortMode=="Smallest First" then
			table.sort(filtered,function(a,b) return(a.playing or 0)<(b.playing or 0)end)
		elseif sortMode=="Largest First" then
			table.sort(filtered,function(a,b) return(a.playing or 0)>(b.playing or 0)end)
		end

		for _,srv in ipairs(filtered)do
			table.insert(smAllServers,srv)
		end

		smStatus.Visible=false
		for _,srv in ipairs(filtered)do
			smDisplayed+=1
			addServerCard(srv,smDisplayed)
		end

		smCountLbl.Text="Servers: "..smDisplayed
		if smCursor=="" then
			smStatus.Text="All servers loaded ("..smDisplayed..")"
			smStatus.Visible=true
		else
			smStatus.Text="Scroll for more..."
			smStatus.Visible=true
		end

		smLoading=false
	end)
end

-- Infinite scroll
smList:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	if smLoading or smCursor=="" then return end
	if smList.AbsoluteCanvasSize.Y-smList.CanvasPosition.Y-smList.AbsoluteSize.Y<50 then
		loadServers(false)
	end
end)

-- Fixed 45s auto-refresh with countdown
local smCountdown=45
local smCountdownLbl=n("TextLabel",{Text="Auto: 45s",Size=UDim2.fromOffset(70,20),Position=UDim2.fromOffset(218,3),BackgroundTransparency=1,TextColor3=C.muted,FontFace=F,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=smFilterBar})

smRefreshBtn.MouseButton1Click:Connect(function()
	if smLoading then return end -- prevent double-request
	loadServers(true)
	smCountdown=45 -- reset countdown on manual refresh
end)

-- Auto-refresh loop (45s fixed)
task.spawn(function()
	while smW and smW.Parent do
		task.wait(1)
		if smW.Visible then
			smCountdown=smCountdown-1
			smCountdownLbl.Text="Auto: "..smCountdown.."s"
			if smCountdown<=0 and not smLoading then
				loadServers(true)
				smCountdown=45
			end
		end
	end
end)


-- CONFIRM CLOSE
------------------------------------------------------------
local cfW=n("Frame",{Size=UDim2.fromOffset(260,65),Position=UDim2.new(0.3,0,0.4,0),BackgroundColor3=C.panel,BorderSizePixel=0,Visible=false,ZIndex=25,Parent=gui})
n("TextLabel",{Text="Close executor?",Size=UDim2.new(1,-10,0,24),Position=UDim2.fromOffset(5,3),BackgroundTransparency=1,TextColor3=C.white,FontFace=F,TextSize=13,ZIndex=25,Parent=cfW})
local cfY=n("TextButton",{Text="Yes",Size=UDim2.fromOffset(110,24),Position=UDim2.fromOffset(8,34),BackgroundColor3=C.red,TextColor3=C.white,FontFace=FB,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,ZIndex=25,Parent=cfW});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=cfY})
local cfN=n("TextButton",{Text="Cancel",Size=UDim2.fromOffset(110,24),Position=UDim2.fromOffset(140,34),BackgroundColor3=C.btn,TextColor3=C.white,FontFace=FB,TextSize=12,BorderSizePixel=0,AutoButtonColor=false,ZIndex=25,Parent=cfW});n("UICorner",{CornerRadius=UDim.new(0,3),Parent=cfN})
cfY.MouseButton1Click:Connect(function()saveTabs();gui:Destroy()end);cfN.MouseButton1Click:Connect(function()cfW.Visible=false end)

------------------------------------------------------------
-- BUTTON CONNECTIONS
------------------------------------------------------------
bExec.MouseButton1Click:Connect(function()if aTab then aTab.source=cBox.Text end;if aTab and aTab.source and aTab.source~=""then local ok,err=pcall(loadstring(aTab.source));if not ok then toast("Error: "..tostring(err):sub(1,40));pcall(addConLine,"[ERROR] "..tostring(err),Enum.MessageType.MessageError)end end end)
bClear.MouseButton1Click:Connect(function() cBox.Text="" end)
bPaste.MouseButton1Click:Connect(function()pcall(function()local c=getclipboard();if c and c~=""then cBox.Text=c end end)end)
bSave.MouseButton1Click:Connect(function()
	if aTab then aTab.source=cBox.Text end
	if aTab and aTab.source and aTab.source~="" then
		svNB.Text=aTab.name
		-- Rebuild folder list dynamically
		folderNames={"(Root)"}
		for _,item in ipairs(userTree) do if item.type=="folder" then table.insert(folderNames,item.name) end end
		selFolder=1;folderBtn.Text=folderNames[1]
		svDia.Visible=true
		task.defer(function() svNB:CaptureFocus() end)
	end
end)
bCopy.MouseButton1Click:Connect(function()if aTab then aTab.source=cBox.Text end;if aTab and aTab.source then pcall(function()setclipboard(aTab.source)end)end end)
bBlox.MouseButton1Click:Connect(function()sbW.Visible=not sbW.Visible;if sbW.Visible and sbCt==0 then srSB("")end end)
bMin.MouseButton1Click:Connect(function()main.Visible=false;fIcon.Visible=true;saveTabs()end)
fIcon.MouseButton1Click:Connect(function()if wasD(fIcon)then return end;main.Visible=true;fIcon.Visible=false end)
bClose.MouseButton1Click:Connect(function()saveTabs();cfW.Visible=true end)

------------------------------------------------------------
-- AUTO ATTACH
------------------------------------------------------------
task.spawn(function()
	titleL.Text="Synapse X - "..synversion.." (checking...)"
	task.wait(0.4);titleL.Text="Synapse X - "..synversion.." (injecting...)"
	task.wait(0.8);titleL.Text="Synapse X - "..synversion.." (ready!)"
	-- AutoExec
	pcall(function()if isfolder and isfolder(AE_DIR)then for _,p in ipairs(listfiles(AE_DIR))do if isfile(p)then pcall(loadstring(readfile(p)))end end end end)
	task.wait(1);titleL.Text="Synapse X - "..synversion;
end)

-- Apply saved settings on load
if settings.antiAfk then pcall(function()local VU=game:GetService("VirtualUser");LP.Idled:Connect(function()VU:CaptureController();VU:ClickButton2(Vector2.new())end)end)end

return gui
