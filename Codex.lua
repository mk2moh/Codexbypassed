--[[
		CODEX MOBILE UI
	
	- Designed & Built by blackmomo
	- Framework & Codebase by riky47
]]
local cloneref = cloneref or function(v) return v end --to make it work on studio, remove later
do -- Luraph integration
	local dummy = function(...) return ... end
	LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or dummy
	LPH_NO_UPVALUES = LPH_NO_UPVALUES or dummy
	LPH_OBFUSCATED = LPH_OBFUSCATED or false
	LPH_JIT_MAX = LPH_JIT_MAX or dummy
	LPH_ENCFUNC = LPH_ENCFUNC or dummy
	LPH_ENCSTR = LPH_ENCSTR or dummy
	LPH_ENCNUM = LPH_ENCNUM or dummy
	LPH_CRASH = LPH_CRASH or dummy
	LPH_JIT = LPH_JIT or dummy
end

local framework, endpoints do
	endpoints = {
		arceus_neo = "httpsGe//raw.githubusercontent.com/SPDM-Team/Arceus-X-NEO-public/refs/heads/main",
		xploit = "https://raw.githubusercontent.com/Riky47/Xploit-Framework/refs/heads/main",
		scriptblox = "https://scriptblox.com",
		mobile = "https://mobile.codex.lol",
		api = "https://api.codex.lol",

		rbxcdn = {
			tr = "https://tr.rbxcdn.com",
			t1 = "https://t1.rbxcdn.com"
		}
	}

	pcall(function() loadstring(game:HttpGet(`{endpoints.arceus_neo}/init.lua`))() end)

	-- Include Arceus X adapter
	local axinclude, axerr = pcall(function()
		loadstring(game:HttpGet(`{endpoints.arceus_neo}/adapter.lua`))()
	end)

	-- Include framework
	local cloneref = cloneref or function(...) return ... end
	local run: RunService = cloneref(game:GetService("RunService"))

	if run:IsStudio() then 
		if _G.Once then return end _G.Once = true
		framework = require(script.Parent.Parent:WaitForChild("Wave"):WaitForChild("WaveFramework"))
	else
		framework = loadstring(game:HttpGet(`{endpoints.xploit}/index.lua`))()
	end

	if not axinclude and not framework.protected:IsStudio() then
		return framework.console.error("Unable to load Arceus X Adapter: " .. axerr)
	end

	-- Adapter to SPDM file system
	local spdminclude, spdmerr = pcall(function()
		loadstring(framework.utils.http:Get(`{endpoints.xploit}/mods/spdm-fs.lua`))(framework)
	end)

	if not spdminclude and not framework.protected:IsStudio() then
		return framework.console.error("Unable to load SPDM file system adapter: " .. spdmerr)
	end
end

local is_ios = (framework.env.arceus and framework.env.arceus.is_ios or function() return false end)()
local hide_prefix = is_ios and "" or "."

do
	ARCEUS_FOLDERS = {
		WORKSPACE = framework.storage:CreateDirectory("workspace", is_ios and "" or "Workspace"),
		AUTOEXECUTE = framework.storage:CreateDirectory("autoexecute", "Autoexec"),
		SCRIPT_HUB = framework.storage:CreateDirectory("scripthub", "Script Hub"),
		CONFIGS = framework.storage:CreateDirectory("configs", "Configs")
	}
end

local CODEX_FOLDERS = {
	CACHE = ARCEUS_FOLDERS.WORKSPACE:AddSubDirectory("cache", "CxCache"),
	DATA = framework.storage:CreateDirectory("data", "data")
}

local Prefix = "SettingSubframe"
local EXPLOIT_CONFIGS = {
	EXPLOIT_IDENTITY = "Codex",
	UI_VERSION = "1.0.0",

	FILES_KEY = "CODEX_Ob56egZQnpBvo8euq1YH10BBgda2WJhMHVSt9j5ovjgfP15FORmviFVPrQOuSCp0",
	SETTINGS_FILE = hide_prefix.. "settings.cx",
	VERSION_FILE = hide_prefix.. "version.cx",
	TABS_FILE = "codexTabs.json",
	AUTH_FILE = "auth.cx",

	SETTINGS = {
		AutoSaveTabs = true,
		AutoExecute = true,
		OpeningMode = 1,
		AntiAFK = false,
		IconSize = 100,
		PageSize = 100,
		HopDelay = 0,
		FpsCap = 60,

		Theme = "Default",
		ScriptBlox = {
			verified = false,
			paid = false,
			free = false
		}
	},

	PALETTE = {
		Default = {
			MAIN_BLUE_START = Color3.fromHex("#77B7FF"),
			MAIN_BLUE_END = Color3.fromHex("#3085FF"),

			BTN_GREY = Color3.fromHex("#363C4A"),

			BACKGROUND_START = Color3.fromHex("#24272E"),
			BACKGROUND_END = Color3.fromHex("#13161D"),

			BACKGROUND_2 = Color3.fromHex("#292D36"),
			UNSELECTED_BACKGROUND = Color3.fromHex("#252932"),

			STROKE = Color3.fromHex("#363C4A"),

			TEXT_BLUE = Color3.fromHex("#77B7FF"),
			TEXT_SECONDARY = Color3.fromHex("#97A0B5"),

			WHITE = Color3.fromRGB(255, 255, 255),
			REALLY_RED = Color3.fromRGB(255, 0, 0),
			RED_ORANGE = Color3.fromRGB(200, 85, 50),
			FADED_RED = Color3.fromRGB(255, 116, 116),
			DARK_FADED_RED = Color3.fromRGB(59, 25, 22),

			GRADIENT_END = Color3.fromRGB(226, 108, 108),

			SCRIPT_TAB_RED = Color3.fromRGB(148, 19, 21),
			SCRIPT_TAB_END_RED = Color3.fromRGB(156, 63, 65),
			FALLBACK_IMAGE = framework.protected:ProtectAsset("rbxassetid://122902330100796"),

			FONT = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			FONT_CODE = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			FONT_BOLD = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
			FONT_AUTH = Font.new("rbxassetid://12187360881", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			FONT_ITALICIZED = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Italic),
			FONT_UTILS = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			FONT_UTILS_ITALICIZED  = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
		}
	}
}

-- Configure
framework.enums:AddEnum("ScriptBloxSort", "None", "CreatedAt", "UpdatedAt", "Views", "LikeCount", "DislikeCount")
framework.enums:AddEnum("ScriptBloxVerify", "None", "Verified", "Unverified")
framework.enums:AddEnum("ScriptBloxType", "None", "Universal", "Specific")
framework.enums:AddEnum("ScriptBloxPatch", "None", "Patched", "Unpatched")
framework.enums:AddEnum("ScriptBloxSearch", "None", "Default", "Strict")
framework.enums:AddEnum("ScriptBloxAuth", "None", "Key", "Keyless")
framework.enums:AddEnum("ScriptBloxOrder", "None", "Asc", "Desc")
framework.enums:AddEnum("ScriptBloxMode", "None", "Free", "Paid")

framework.protected:UseUndetectedContent(not framework.protected:IsStudio())
framework.protected:ProtectTable(ARCEUS_FOLDERS)
framework.protected:ProtectTable(EXPLOIT_CONFIGS)

framework.settings:SetDirectory(ARCEUS_FOLDERS.CONFIGS)
framework.settings:SetFileName(EXPLOIT_CONFIGS.SETTINGS_FILE)
framework.settings:SetFileKey(EXPLOIT_CONFIGS.FILES_KEY)
framework.settings:SetDefault(EXPLOIT_CONFIGS.SETTINGS)
framework.settings:LoadSettings()

local PALETTE = EXPLOIT_CONFIGS.PALETTE.Default do
	local theme = EXPLOIT_CONFIGS[framework.settings:GetSetting("Theme")]
	if theme then
		PALETTE = theme
	end
end

-- Globals
local tweeninfo = framework.protected:GCProtect(function(delay: number, duration: number, style: Enum.EasingStyle)
	return TweenInfo.new(duration or .35, style or Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, delay or 0)
end)

do -- cloudscripts
	local cloudscripts, configs = {}, {
		propsWhitelist = {"title", "verified", "isUniversal", "isPatched", "script", "key", "views", "createdAt", "slug"}
	}

	local fetchCache, detailsCache = framework.utils.caches.newCache(100), framework.utils.caches.newCache(100)
	local favCache, imgCache = framework.utils.caches.newCache(), framework.utils.caches.newCache(100)
	local marketplace = framework.protected:GetService("MarketplaceService")
	local onFetched = framework.signals.newEvent()
	local maxResults

	local getimageinfo = framework.protected:GCProtect(function(url: string)
		local split = framework.utils.strings.split(url, "/")
		local last = framework.utils.strings.sub(url, -4)

		if framework.utils.strings.sub(url, 1, framework.utils.strings.len(endpoints.rbxcdn.tr)) == endpoints.rbxcdn.tr and framework.utils.strings.find(url, "/Png") then
			return url, `{split[4]}.png`

		elseif framework.utils.strings.sub(url, 1, 15) == "/images/script/" and last == ".png" then
			return `{endpoints.scriptblox}/{url}`, split[4]
		end
	end)

	local loadimage = framework.protected:GCProtect(function(url: string, name: string, gameId: number, img: ImageLabel)
		if (not url or framework.protected:IsStudio()) and gameId then
			local cached = imgCache:Get(gameId)
			if not cached then
				local success, result = pcall(marketplace.GetProductInfo, marketplace, gameId)
				if not success or not result.IconImageAssetId then return end
				cached = result.IconImageAssetId
				imgCache:Push(cached)
			end

			img.Image = framework.protected:ProtectAsset("rbxassetid://" ..cached)
			return
		end

		if not CODEX_FOLDERS.CACHE:IsFile(name) then
			local data = framework.utils.http:Get(url)
			if not data then return end

			CODEX_FOLDERS.CACHE:WriteFile(name, data)
		end

		img.Image = framework.env.getcustomasset(framework.protected:ProtectAsset(`{CODEX_FOLDERS.CACHE.lastPath}/{name}`))
	end)

	local getimage = framework.protected:GCProtect(function(scriptImg: string, gameImg: string, universal: boolean)
		local url, name = getimageinfo(scriptImg)
		if not url and not universal then
			url, name = getimageinfo(gameImg)
		end

		return url, name
	end)

	local formatScript = framework.protected:GCProtect(function(scr: {any})
		local info = {} -- truncating arguments
		info.slug = scr.slug
		info.game = scr.game.name
		info.gameId = scr.game.gameId

		for _, prop in ipairs(configs.propsWhitelist) do
			info[prop] = scr[prop]
		end

		local url, name = getimage(scr.image, scr.game.imageUrl, scr.isUniversal)
		info.imageUrl, info.imageName = url, name
		info.loadImage = function(img: ImageLabel)
			task.spawn(loadimage, url, name, scr.game.gameId, img)
		end

		return info
	end)

	local fetch
	fetch = framework.protected:GCProtect(function(url: string, debounce: {boolean}, c: number)
		local cached = fetchCache:Get(url)
		if cached then return cached end

		if debounce[1] then return end
		debounce[1] = true

		local res = framework.utils.http:Request(url, "GET", {
			["Content-Type"] = "application/json"
		});

		if (not res) and (c or 0) < 3 then task.wait(1)
			debounce[1] = false
			return fetch(url, debounce, c and c +1 or 1)
		end

		if not res or not res.Body then
			return { maxPages = 0, nextPage = 0, scripts = {} } end

		local info = framework.utils.http.json.decode(res.Body)
		if not info then return end
		info = info.result

		local data = {} -- These values can be nil
		data.maxPages = info.totalPages
		data.nextPage = info.nextPage

		local scripts = {}
		data.scripts = scripts

		for _, scr in ipairs(info.scripts) do
			framework.utils.tables.insert(scripts, formatScript(scr))
		end

		fetchCache:Push(url, data)
		debounce[1] = false
		return data
	end)

	local getFilters = framework.protected:GCProtect(function(filters: {boolean}, isFetching: boolean)
		local setts = framework.settings:GetSetting("ScriptBlox")
		local output = ""

		local param, enum = filters.mode, framework.enums.ScriptBloxMode
		if param ~= nil and param ~= enum.None then
			output ..= `&mode={param == enum.Free and "free" or "paid"}`
		end

		param, enum = filters.verify, framework.enums.ScriptBloxVerify
		if param ~= nil and param ~= enum.None then
			output ..= `&verified={param == enum.Verified and 1 or 0}`
		end

		param, enum = filters.type, framework.enums.ScriptBloxType
		if param ~= nil and param ~= enum.None then
			output ..= `&universal={param == enum.Universal and 1 or 0}`
		end

		param, enum = filters.auth, framework.enums.ScriptBloxAuth
		if param ~= nil and param ~= enum.None then
			output ..= `&key={param == enum.Key and 1 or 0}`
		end

		param, enum = filters.patch, framework.enums.ScriptBloxPatch
		if param ~= nil and param ~= enum.None then
			output ..= `&patched={param == enum.Patched and 1 or 0}`
		end

		param, enum = filters.search, framework.enums.ScriptBloxSearch
		if not isFetching and param ~= nil and param ~= enum.None then -- Using search endpoint
			output ..= `&strict={param == enum.Strict and true or false}`
		end

		local sorting
		param, enum = filters.sortBy, framework.enums.ScriptBloxSort
		if param ~= nil and param ~= enum.None then
			local map = {
				[enum.DislikeCount] = "dislikeCount",
				[enum.CreatedAt] = "createdAt",
				[enum.UpdatedAt] = "updatedAt",
				[enum.LikeCount] = "likeCount",
				[enum.Views] = "views"
			}

			output ..= `&sortBy={map[param]}`
			sorting = true
		end

		param, enum = filters.order, framework.enums.ScriptBloxOrder
		if sorting and param ~= nil and param ~= enum.None then
			output ..= `&order={param == enum.Asc and "asc" or "desc"}`
		end

		return output
	end)

	cloudscripts.OnFetched = onFetched
	function cloudscripts.newQuery(query: string?, filters: {boolean}, ...: any)
		query = query or ""

		query = framework.utils.http:UrlEncode(query)
		local fetching = query == ""
		local extra = {...}

		local baseUrl = `{endpoints.scriptblox}/api/script/{(fetching and "fetch?" or `search?q={query}&`)}`
		local query, data, debounce = {}, {}, {}

		function query:Fetch(page: number?)
			local page = page or data.nextPage or data.maxPages or 1
			local url = `{baseUrl}page={page}` -- &max=

			if maxResults then url ..= `&max={maxResults}` end
			url ..= getFilters(filters, fetching)
			data = fetch(url, debounce) or {}

			local scripts = data.scripts or {}
			onFetched:Fire(scripts, page == 1, framework.utils.tables.unpack(extra))
			return scripts
		end

		function query:Refresh() -- current page
			local data = self:Fetch(data.nextPage and data.nextPage -1 or data.maxPages) or {}
			local scripts = data.scripts or {}
			onFetched:Fire(scripts, true, framework.utils.tables.unpack(extra))
			return scripts
		end

		function query:GetFilters()
			return filters
		end

		return query
	end

	function cloudscripts:FetchTrending(...: any)
		local data = fetch(`{endpoints.scriptblox}/api/script/trending`, {}) or {}
		local scripts = data.scripts or {}
		onFetched:Fire(scripts, true, ...)
		return scripts
	end

	function cloudscripts:FetchDetails(slug: string, c: number)
		local cached = detailsCache:Get(slug)
		if cached then return cached end

		local res = framework.utils.http:Request(`{endpoints.scriptblox}/api/script/{slug}`, "GET", {
			["Content-Type"] = "application/json"
		});

		if not res and (c or 0) < 3 then task.wait(1)
			return self:FetchDetails(slug, c and c +1 or 1)
		end

		local info = framework.utils.http.json.decode(res.Body)
		if not info then return end

		local data = formatScript(info.script)
		detailsCache:Push(slug, data)
		return data
	end

	function cloudscripts:SetMaxResults(max: number?)
		maxResults = tonumber(max) -- you can unset by passing empty
	end

	framework.protected:ProtectTable(configs)
	framework.dependencies:Add("cloudscripts", framework.protected:ProtectTable(cloudscripts))
end

do -- Local hubs
	local this = {
		{
			title = "Dark Dex V4",
			description = "A powerful game explorer GUI. Shows every instance of the game and all their properties. Useful for developers.",
			icon = "rbxassetid://14806198159",
			content = "local file = \"dexV4.lua\"; local raw = isfile and isfile(file) and readfile(file); raw = raw or game:HttpGetAsync(\"https://raw.githubusercontent.com/loglizzy/dexV4/main/source.lua\"); if isfile then task.spawn(writefile, file, game:HttpGet(url)); end loadstring(raw)();"
		},
		{
			title = "Unnamed ESP",
			description = "Player ESP for Roblox, fully undetectable, uses built in drawing API.",
			icon = "rbxassetid://14806221310",
			content = "pcall(function() loadstring(game:HttpGet(\"https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua\"))(); end);"
		},
		{
			title = "Hydroxide",
			description = "General purpose pen-testing tool for games on the Roblox engine",
			icon = "rbxassetid://14806229032",
			content = "loadstring(game:HttpGetAsync(\"https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/init.lua\"))(); loadstring(game:HttpGetAsync(\"https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ui/main.lua\"))();"
		},
		{
			title = "Infinite Yield",
			description = "Admin command line script with 300+ commands and 6 years of development",
			icon = "rbxassetid://14806239733",
			content = "loadstring(game:HttpGetAsync(\"https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source\"))();"
		},
		{
			title = "Owl Hub",
			description = "Owl Hub is a free Roblox script hub developed by Google Chrome and CriShoux. It currently has 30+ games.",
			icon = "rbxassetid://14806252030",
			content = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt\"))();"
		},
		{
			title = "Reaper Hub",
			description = "Reaper Hub is a free Roblox script hub developed by Reaper. It currently supports 35+ games using a single loadstring.",
			icon = "rbxassetid://16359517197",
			content = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/AyoReaper/Reaper-Hub/main/loader.lua\"))();"
		}
	};

	framework.dependencies:Add("builtin", framework.protected:ProtectTable(this))
end

do -- Local files
	local savedScripts = {}
	savedScripts.cache = {}

	local removed = framework.signals.newEvent()

	local function reassignIndexes(cache: {any})
		for i, v in cache do
			v.index = i;
		end
		return cache;
	end

	local function loadScriptCache()
		local accumulation = 0;
		local cache = {}

		if framework.protected:IsStudio() then
			cache = framework.utils.tables.deepCopy(framework.dependencies.builtin);
			for i, v in ipairs(cache) do
				v.index = i;
			end

			accumulation = #cache
		end

		if CODEX_FOLDERS.DATA:IsFile("codexScriptCache.json") then
			local r = CODEX_FOLDERS.DATA:ReadJsonFile("codexScriptCache.json")
			if type(r) == "table" then
				local hasFoundDuplicateIndex = false;
				for i, v in r do
					if not (type(v) == "table" and v.title and v.description and v.content and v.index and v.autoExecute ~= nil) then
						continue;
					end

					if v.index > accumulation then
						accumulation = v.index;
					end

					if hasFoundDuplicateIndex == false then -- backwards fix from an old broken update and/or someone trying to fuck with the system
						for i2, v2 in cache do
							if v2.index == v.index then
								hasFoundDuplicateIndex = true;
							end
						end
					end

					cache[#cache + 1] = hasFoundDuplicateIndex and reassignIndexes(v) or v;
				end
			end
		end
		savedScripts.accumulator = accumulation;
		savedScripts.cache = cache;
	end

	local function saveScriptCache()
		local cache = framework.utils.tables.deepCopy(savedScripts.cache);
		for i, v in cache do
			v.onAutoExecuteToggled = nil;
		end

		CODEX_FOLDERS.DATA:WriteJsonFile("codexScriptCache.json", cache);
	end

	savedScripts.OnRemoved = removed
	function savedScripts:AutoExecute()
		for i, v in savedScripts.cache do
			if v.autoExecute then
				framework.execution:Execute(v.content)
			end
		end
	end

	function savedScripts:Get(index: number)
		for i, v in self.cache do
			if v.index == index then
				return i, v;
			end
		end
	end

	function savedScripts:GetList()
		return framework.utils.tables.deepCopy(self.cache)
	end

	function savedScripts:Add(title: string, description: string, content: string)
		self.accumulator += 1;
		local index = self.accumulator;

		local newScript = {
			description = description,
			autoExecute = false,
			content = content,
			title = title,
			index = index
		};

		self.cache[#self.cache + 1] = newScript;
		saveScriptCache();
	end

	function savedScripts:Remove(index: number)
		local i, save = self:Get(index);
		if save then
			local data = table.remove(self.cache, i);
			saveScriptCache();

			removed:Fire(data);
		end
	end

	function savedScripts:ToggleAutomaticExecution(index: number, state: boolean)
		local _, save = self:Get(index);
		if save then
			save.autoExecute = state;
			saveScriptCache();
		end
	end

	loadScriptCache()
	framework.dependencies:Add("scripthub", framework.protected:ProtectTable(savedScripts))
end

do -- Local files
	local allhub = {}
	local cache = {
		Mode = "CloudScripts",
		Query = "",
		Gui = nil,

		Cloud = { Scripts = {} },
		Local = { Scripts = {} },
		Built = { Scripts = {} },
		Small = { Scripts = {} }
	}

	local cloudscripts = framework.dependencies.cloudscripts
	local scripthub = framework.dependencies.scripthub
	local builtin = framework.dependencies.builtin

	local OnNewTab = framework.signals.newEvent()

	local function cleanScripts(table: {any})
		for _, scr in ipairs(table) do scr:Remove() end
		framework.utils.tables.clear(table)
	end

	local function updateButtons()
		for _, v in ipairs({ "CloudScripts", "LocalScripts", "BuiltIn" }) do
			local btn = cache.Gui:Get(v)
			btn.instance.BackgroundColor3 = PALETTE.UNSELECTED_BACKGROUND
			btn.instance.TextTransparency = .5
		end

		local btn = cache.Gui:Get(cache.Mode)
		btn.instance.BackgroundColor3 = PALETTE.BTN_GREY
		btn.instance.TextTransparency = 0
	end

	function allhub:GetMode()
		return cache.Mode
	end

	function allhub:SetGui(ui)
		cache.Gui = ui
		task.spawn(allhub.CloudScripts, allhub)
		task.spawn(allhub.SmallHub, allhub)
	end

	function allhub:Query(query)
		cache.Query = query
		allhub[cache.Mode](allhub)
	end

	function allhub:SmallHub(query: string?)
		query = query ~= "" and query or nil
		if query then query = query:lower() end

		cleanScripts(cache.Small.Scripts)
		local list = scripthub:GetList()

		for i=#list, 1, -1 do
			local v = list[i]

			if query and not v.title
				:lower():find(query) then
				continue
			end

			local comp = cache.Gui:AddComponent("Script", {
				Parent = cache.Gui:Get("SmallScriptsList"),
				LayoutOrder = i,

				Image = PALETTE.FALLBACK_IMAGE,
				Description = "Local file.",
				Title = v.title,

				CopyButtonPos = UDim2.fromScale(.825, .875),
				DelButtonPos = UDim2.fromScale(.685, .875),
				Size = UDim2.fromScale(1, .35),
				ShowDelButton = true,
				Source = v.content,
				Index = v.index,

				OnClick = function()
					OnNewTab:Fire(v.title, v.content)
				end
			})

			table.insert(cache.Small.Scripts, comp)
		end
	end

	allhub.OnNewTab = OnNewTab
	local function checkNoResult(table: {any})
		if #table > 0 then
			if cache.NoRes then cache.NoRes:Remove() end
			cache.NoRes = nil
			return
		else
			if cache.NoRes then return end
		end

		cache.NoRes = cache.Gui:AddComponent("Script", {
			Parent = cache.Gui:Get("ScriptsList"),
			LayoutOrder = 0,

			Image = PALETTE.FALLBACK_IMAGE,
			Description = "No local script has been found.",
			Title = "No results",

			CopyButtonPos = UDim2.fromScale(.895, .875),
			Size = UDim2.fromScale(1, .35),
			Source = ""
		})
	end

	function allhub:NewTab(title: string, content: string)
		OnNewTab:Fire(title, content)
	end

	function allhub:CloudScripts(loadMore: boolean)
		cache.Mode = "CloudScripts"
		updateButtons()

		if cache.Query == "" then
			return cloudscripts:FetchTrending(true)
		end

		local query = cache.Query ~= ""
			and cache.Query or nil
		local newQuery = not not
		query and not loadMore

		if newQuery then
			cache.Cloud.Query = cloudscripts.newQuery(query, {
				patch = framework.enums.ScriptBloxPatch.Unpatched,
				search = framework.enums.ScriptBloxSearch.None,
				verify = framework.enums.ScriptBloxVerify.None,
				sortBy = framework.enums.ScriptBloxSort.Views,
				order = framework.enums.ScriptBloxOrder.None,
				type = framework.enums.ScriptBloxType.None,
				auth = framework.enums.ScriptBloxAuth.None,
				mode = framework.enums.ScriptBloxMode.None
			}, newQuery)
		end

		if not cache.Cloud.Query then
			return cloudscripts:FetchTrending(newQuery)
		end

		return cache.Cloud.Query:Fetch()
	end

	function allhub:LocalScripts()
		cache.Mode = "LocalScripts"
		updateButtons()

		cleanScripts(cache.Cloud.Scripts)
		cleanScripts(cache.Local.Scripts)
		cleanScripts(cache.Built.Scripts)

		local query = cache.Query ~= ""
			and cache.Query or nil
		if query then query = query:lower() end

		local res = scripthub:GetList()
		if #res < 1 then
			return table.insert(cache.Local.Scripts, cache.Gui:AddComponent("Script", {
				Parent = cache.Gui:Get("ScriptsList"),
				LayoutOrder = 0,

				Image = PALETTE.FALLBACK_IMAGE,
				Description = "No local script has been found.",
				Title = "No results",

				CopyButtonPos = UDim2.fromScale(.895, .875),
				Size = UDim2.fromScale(1, .35),
				Source = ""
			}))
		end

		for i, v in ipairs(res) do
			if query and not v.title:lower():find(query) then
				continue
			end

			local comp = cache.Gui:AddComponent("Script", { -- SCRIPTS
				Parent = cache.Gui:Get("ScriptsList"),
				LayoutOrder = i,

				Image = v.icon or PALETTE.FALLBACK_IMAGE,
				Description = v.description or "",
				AutoExecute = v.autoExecute,
				ShowToggle = true,
				Index = v.index or i,
				Title = v.title,

				Size = UDim2.fromScale(1, .35),
				CopyButtonPos = UDim2.fromScale(.895, .875),
				DelButtonPos = UDim2.fromScale(.825, .875),
				ShowDelButton = true,
				Source = v.content
			})

			table.insert(cache.Local.Scripts, comp)
		end

		checkNoResult(cache.Local.Scripts)
	end

	function allhub:BuiltIn()
		cache.Mode = "BuiltIn"
		updateButtons()

		cleanScripts(cache.Cloud.Scripts)
		cleanScripts(cache.Local.Scripts)
		cleanScripts(cache.Built.Scripts)

		local query = cache.Query ~= ""
			and cache.Query or nil
		if query then query = query:lower() end

		for i, v in ipairs(builtin) do
			if query and not v.title:lower():find(query) then
				continue
			end

			local comp = cache.Gui:AddComponent("Script", { -- SCRIPTS
				Parent = cache.Gui:Get("ScriptsList"),
				LayoutOrder = i,

				Image = v.icon,
				Title = v.title,
				Description = v.description,

				Size = UDim2.fromScale(1, .35),
				CopyButtonPos = UDim2.fromScale(.895, .875),
				DelButtonPos = UDim2.fromScale(.825, .875),
				Source = v.content
			})

			table.insert(cache.Built.Scripts, comp)
		end

		checkNoResult(cache.Built.Scripts)
	end

	function allhub:RefreshLocalScripts()
		if cache.Mode == "LocalScripts" then
			allhub:LocalScripts()
		end

		allhub:SmallHub()
	end

	function allhub:ShowSettingsCat(category: string)
		for _, v in ipairs({ "Executor", "Player", "Server" }) do
			local show = category == v

			local btn = cache.Gui:Get(`{v}_Btn`).instance
			btn.BackgroundColor3 = show and PALETTE.BTN_GREY
				or PALETTE.UNSELECTED_BACKGROUND
			btn.TextTransparency = show and 0 or .5

			for _, o in ipairs(cache.Gui:GetByTag(v)) do
				o.instance.Visible = show
			end
		end
	end

	local function loadSrc(scr: {})
		if not scr.script then
			local res = framework.dependencies
				.cloudscripts:FetchDetails(scr.slug)
			scr.script = res and res.script or ""
		end
	end

	cloudscripts.OnFetched:Connect(framework.protected:GCProtect(function(result: string, refresh: boolean)
		if refresh then cleanScripts(cache.Cloud.Scripts) end
		cleanScripts(cache.Local.Scripts)
		cleanScripts(cache.Built.Scripts)

		local there = #cache.Cloud.Scripts
		for i, scr in ipairs(result) do 
			local comp = cache.Gui:AddComponent("Script", { -- SCRIPTS
				Image = PALETTE.FALLBACK_IMAGE,
				Parent = cache.Gui:Get("ScriptsList"),
				LayoutOrder = i +there,

				Title = scr.title,
				Description = scr.description
					or "Script from scriptblox.com",

				Size = UDim2.fromScale(1, .35),
				CopyButtonPos = UDim2.fromScale(.895, .875),
				DelButtonPos = UDim2.fromScale(.825, .875),
				ShowDelButton = true,

				Copy = function()
					loadSrc(scr)
					framework.dependencies.scripthub:Add(scr.title:sub(1, 20),
						"Local file from scriptblox.com", scr.script)
					framework.dependencies.allhub:RefreshLocalScripts()
				end,

				Del = function()
					loadSrc(scr)
					framework.dependencies.allhub:NewTab(scr.title:sub(1, 10), scr.script)
					cache.Gui:Get("PagesLayout").instance:JumpTo(
						cache.Gui:Get("Page_Executor").instance)
				end,

				Execute = function()
					loadSrc(scr)
					framework.execution:Execute(scr.script)
				end
			})

			scr.loadImage(comp.instance
				:FindFirstChildWhichIsA("ImageButton"))
			table.insert(cache.Cloud.Scripts, comp)
			checkNoResult(cache.Cloud.Scripts)
		end
	end))

	scripthub.OnRemoved:Connect(framework.protected:GCProtect(function(script)
		allhub:RefreshLocalScripts()
	end))

	framework.dependencies:Add("allhub", framework.protected:ProtectTable(allhub))
end

-- Create dependencies
do -- exploit

	local exploit = {}
	local is_ios = (framework.env.arceus and framework.env.arceus.is_ios or function()
		return (not framework.protected:IsStudio()) and framework.protected:GetService("UserInputService"):GetPlatform() == Enum.Platform.IOS or false
	end)()

	local is_vng = (framework.env.arceus and framework.env.arceus.is_vng or function()
		return false
	end)()

	local hwid = (framework.env.gethwid or framework.protected:GCProtect(function()
		return framework.protected:GetService("AnalyticsService"):GetClientId()
	end))()

	local _bypassCreds = { username = "moh", password = "admin" }
	local function _isBypassSaved()
		local s = ARCEUS_FOLDERS.CONFIGS:ReadJsonFile(EXPLOIT_CONFIGS.AUTH_FILE, EXPLOIT_CONFIGS.FILES_KEY)
		return s and s.username == _bypassCreds.username and s.password == _bypassCreds.password
	end

	local onAuth = framework.signals.newEvent()
	local expiring, isAuth, token = 0, false, nil

	exploit.OnAuthenticated = onAuth
	function exploit:GetExpiration()
		return expiring
	end

	function exploit:IsAuthenticated()
		if isAuth then
			return true, true -- auth, logged
		end

		if _isBypassSaved() then
			expiring = os.time() + 86400 * 9999
			isAuth = true
			onAuth:Fire(expiring)
			return true, true
		end

		local function parseIsoDate(iso: string?)
			if type(iso) ~= "string" or iso == "" then
				return false
			end

			local ok, parsed = pcall(DateTime.fromIsoDate, iso)
			return ok and parsed or false
		end

		local auth = ARCEUS_FOLDERS.CONFIGS:ReadJsonFile(
			EXPLOIT_CONFIGS.AUTH_FILE,
			EXPLOIT_CONFIGS.FILES_KEY) or {
			token = token
		}

		if not auth or not auth.token then
			return false, false -- not authenticated, not logged
		end

		local response = framework.utils.http:Request(
			`{endpoints.api}/v1/user/subscriptions`, "GET",
			{
				["Content-Type"] = "application/json",
				Authorization = `Bearer {auth.token}`
			}
		)

		if not response or not response.Body then
			return false, false
		end

		local body = framework.utils.http.json.decode(response.Body)
		if not body or not body.data or not body.data.summary then
			return false, false
		end

		local sum = body.data.summary
		local expires

		for _, access in {
			parseIsoDate(sum.enterprise),
			parseIsoDate(sum.freemium),
			parseIsoDate(sum.premium),
			parseIsoDate(sum.free),
			} do

			if not access then continue end
			if not expires or access.UnixTimestamp > expires then
				expires = access.UnixTimestamp
			end
		end

		-- logged account, but no valid sub / key
		if not expires or expires <= os.time() then
			return false, true
		end

		expiring = expires
		isAuth = true

		onAuth:Fire(expires)
		return true, true
	end

	function exploit:Login(username: string, password: string)
		if username == _bypassCreds.username and password == _bypassCreds.password then
			expiring = os.time() + 86400 * 9999
			isAuth = true
			token = "BYPASS_9999"
			ARCEUS_FOLDERS.CONFIGS:WriteJsonFile(EXPLOIT_CONFIGS.AUTH_FILE,
				{ token = token, username = username, password = password },
				EXPLOIT_CONFIGS.FILES_KEY)
			onAuth:Fire(expiring)
			return true
		end

		local response = framework.utils.http:Request(
			`{endpoints.api}/v1/auth/sign-in`, "POST", {

				["Content-Type"] = "application/json"
			}, {

				username = username,
				password = password
			})

		if not response then return end
		local body = framework.utils.http
			.json.decode(response.Body)

		if not body then return end
		local session = body.data.session

		if not session or not session
			.token then return end

		token = session.token
		ARCEUS_FOLDERS.CONFIGS:WriteJsonFile(EXPLOIT_CONFIGS
			.AUTH_FILE, session, EXPLOIT_CONFIGS.FILES_KEY)
		return true
	end

	function exploit:IsIos()
		return is_ios
	end

	function exploit:IsVng()
		return is_vng
	end

	function exploit:GetHwid()
		return hwid
	end

	function exploit:InitUI()
		local playerGui = framework.protected
			:GetService("Players").LocalPlayer.PlayerGui

		local ui = framework.interface.new("main")
		ui.instance.ScreenInsets = Enum.ScreenInsets.None
		ui.instance.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local LINE_THICKNESS = (playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait and
			ui.instance.AbsoluteSize.X or ui.instance.AbsoluteSize.Y) *8 /1080
		local EDITOR_FONT_SIZE = LINE_THICKNESS * 4.25

		local getStartCoords, getScreenRatio do
			local createDummy = framework.protected:GCProtect(function()
				return ui:AddInstance("Frame", {
					Size = UDim2.fromScale(1, 1),
					Visible = false
				})
			end)

			getStartCoords = framework.protected:GCProtect(function()
				local obj = createDummy()
				local coords = obj.instance.AbsolutePosition
				obj:Remove()

				return coords
			end)

			getScreenRatio = framework.protected:GCProtect(function()
				local obj = createDummy()
				local viewportSize = obj.instance.AbsoluteSize
				obj:Remove()

				local width, height = viewportSize.X, viewportSize.Y
				local ratio = playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait
					and height / width or width / height

				return ratio
			end)
		end

		local popups = {}
		popups.notify = framework.protected:GCProtect(function(text: string)
			local gui = framework.protected:GetService("StarterGui")
			local exploit = framework.dependencies.exploit

			gui:SetCore("SendNotification", {
				Title = "Codex " .. (exploit:IsIos() and "iOS" or "Android"),
				Text = text
			})
		end)

		framework.protected:ProtectTable(popups)

		local lastFetch, filters = nil, {
			verify = framework.enums.ScriptBloxVerify.None,
			search = framework.enums.ScriptBloxSearch.None,
			sortBy = framework.enums.ScriptBloxSort.Views,
			patch = framework.enums.ScriptBloxPatch.None,
			order = framework.enums.ScriptBloxOrder.Desc,
			type = framework.enums.ScriptBloxType.None,
			auth = framework.enums.ScriptBloxAuth.None,
			mode = framework.enums.ScriptBloxMode.Free
		}

		ui:CreateComponent("Slider").OnCreating:Connect(function(props: {[string]: any})
			local bar = ui:AddInstance("ImageButton", {
				Size = UDim2.fromScale(.5, 1),
				BackgroundColor3 = PALETTE.WHITE,
				AutoButtonColor = false,
				ZIndex = -1,
				Image = ""
			}, ui:AddInstance("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_END),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_START)
				})
			}))

			local label = ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.958, .5),
				Size = UDim2.fromScale(.35, .35),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, .5),
				FontFace = PALETTE.FONT_BOLD,
				TextScaled = true,
				TextColor3 = PALETTE.WHITE,
				TextXAlignment = Enum.TextXAlignment.Right
			})

			local setValue = framework.protected:GCProtect(function(percent: number)
				props.Callback(framework.utils.maths.clamp(props.Min +percent
					*(props.Max -props.Min), props.Min, props.Max))
			end)

			local setLabel = framework.protected:GCProtect(LPH_NO_VIRTUALIZE(function(percent: number)
				label.instance.Text = `{framework.utils.maths.round(percent*100)}%`
			end))

			local comp = ui:AddInstance("CanvasGroup", {
				AnchorPoint = props.AnchorPoint,
				Position = props.Position,
				Size = props.Size,

				BackgroundColor3 = PALETTE.BTN_GREY
			}, label, ui:AddInstance("ImageLabel", {
				AnchorPoint = Vector2.new(0, .5),
				Position = UDim2.fromScale(.042, .5),
				Size = UDim2.fromScale(.5, .5),
				BackgroundTransparency = 1,
				Image = props.Icon

			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.195, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.5, .35),
				TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = PALETTE.FONT_BOLD,
				BackgroundTransparency = 1,
				TextColor3 = PALETTE.WHITE,
				TextScaled = true,
				Text = props.Id,

			}), bar, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.3, 0)	
			}))

			local start = framework.utils.maths.clamp((props.Def -props.Min)/(props.Max -props.Min), 0, 1)
			bar.Slider = framework.utils.inputs.sliders.horizontal({bar}, start, props.Id)
			setLabel(start)

			bar.Slider.OnPercentageUpdated:Connect(setLabel)
			bar.Slider.OnPercentageChanged:Connect(setValue)
			return comp
		end)

		ui:CreateComponent("Script").OnCreating:Connect(function(props: {[string]: any})
			local comp = ui:AddInstance("CanvasGroup", {
				Position = props.Position,
				Size = props.Size,
				AnchorPoint = props.AnchorPoint,
				BackgroundColor3 = PALETTE.BACKGROUND_2,
				Parent = props.Parent
			}, ui:AddInstance("ImageButton", {
				BackgroundTransparency = .5,
				Size = UDim2.fromScale(1, .45),
				AutoButtonColor = false,
				Image = props.Image,
				MouseButton1Click = props.OnClick,
				ScaleType = Enum.ScaleType.Crop

			}), ui:AddInstance("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.fromScale(.035, .56),
				Size = UDim2.fromScale(.75, .15),
				TextColor3 = PALETTE.WHITE,
				Text = props.Title,
				FontFace = PALETTE.FONT_BOLD

			}), ui:AddInstance("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.fromScale(.035, .725),
				Size = UDim2.fromScale(.75, .125),
				TextColor3 = PALETTE.TEXT_SECONDARY,
				Text = props.Description,
				FontFace = PALETTE.FONT
			}), ui:AddInstance("TextButton", {
				Position = UDim2.fromScale(.965, .875),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundColor3 = PALETTE.WHITE,
				Text = "",
				Size = UDim2.fromScale(1, .25),

				MouseButton1Click = framework.protected:GCProtect(props.Execute or function()
					framework.execution:Execute(props.Source)
				end)
			}, ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})
			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.3, 0)	
			}),ui:AddInstance("UIAspectRatioConstraint"
			), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.5, .5),
				AnchorPoint = Vector2.new(.5, .5),
				Size = UDim2.fromScale(.45, .45),
				BackgroundTransparency = 1,
				Image = "rbxassetid://84207212135058"
			}, ui:AddInstance("UIAspectRatioConstraint"
			))), ui:AddInstance("TextButton", {
				Position = props.CopyButtonPos or UDim2.fromScale(.865, .875),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundColor3 = PALETTE.BTN_GREY,
				Text = "",
				Size = UDim2.fromScale(1, .25),

				MouseButton1Click = props.Copy or framework.protected:GCProtect(function()
					framework.utils.clipboard:Set(props.Source)
				end)
			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.3, 0)	
			}),ui:AddInstance("UIAspectRatioConstraint"
			), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.5, .5),
				AnchorPoint = Vector2.new(.5, .5),
				Size = UDim2.fromScale(.45, .45),
				BackgroundTransparency = 1,
				Image = props.Copy and "rbxassetid://120201446628760" or "rbxassetid://76398608565219"
			}, ui:AddInstance("UIAspectRatioConstraint"
			))), ui:AddInstance("TextButton", {
				Visible = props.ShowDelButton or false,
				Position = props.DelButtonPos or UDim2.fromScale(.825, .875),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundColor3 = PALETTE.BTN_GREY,
				Text = "",
				Size = UDim2.fromScale(1, .25),

				MouseButton1Click = props.Del or framework.protected:GCProtect(function()
					framework.dependencies.scripthub:Remove(props.Index)
				end)
			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.3, 0)	
			}),ui:AddInstance("UIAspectRatioConstraint"
			), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.5, .5),
				AnchorPoint = Vector2.new(.5, .5),
				Size = UDim2.fromScale(.45, .45),
				BackgroundTransparency = 1,
				Image = props.Del and "rbxassetid://124394182878724" or "rbxassetid://71890295601108"
			}, ui:AddInstance("UIAspectRatioConstraint"
			))), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.15, 0)
			}))

			if not props.ShowToggle then return comp end
			local state, toggle, knob = not not props.AutoExecute, nil, nil
			local tween = tweeninfo()

			local function updateColor()
				knob:Tween(tween, {
					BackgroundColor3 = state and
						PALETTE.WHITE or PALETTE.BTN_GREY 
				})
			end

			local function update(enabled: boolean?)
				state = enabled

				-- knob a destra se attivo, a sinistra se spento
				local goalPos = enabled and UDim2.fromScale(1, .5) or UDim2.fromScale(0, .5)
				local goalAnchor = enabled and Vector2.new(1, .5) or Vector2.new(0, .5)

				knob:Tween(tween, {
					Position = goalPos,
					AnchorPoint = goalAnchor
				})

				updateColor()
			end

			knob = ui:AddInstance("Frame", {
				BackgroundColor3 = state and PALETTE.WHITE or PALETTE.BTN_GREY,
				Size = UDim2.fromScale(1, 1.2),
				Position = state and UDim2.fromScale(1, .5) or UDim2.fromScale(0, .5),
				AnchorPoint = state and Vector2.new(1, .5) or Vector2.new(0, .5)
			}, ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.5, .5),
				AnchorPoint = Vector2.new(.5, .5),
				Size = UDim2.fromScale(.55, .55),
				BackgroundTransparency = 1,
				Image = "rbxassetid://72290795689811"
			}), ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})
			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)
			}), ui:AddInstance("UIAspectRatioConstraint"))

			toggle = ui:AddInstance("TextButton", {
				Position = UDim2.fromScale(.75, .865),
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.fromScale(.1, .225),
				Parent = comp,
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = 0.85,
				BackgroundColor3 = PALETTE.WHITE,

				MouseButton1Click = framework.protected:GCProtect(function()
					state = not state
					update(state)

					framework.dependencies.scripthub
						:ToggleAutomaticExecution(props.Index, state)
				end)
			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)

			}), knob, ui:AddInstance("TextLabel", {
				TextXAlignment = Enum.TextXAlignment.Center,
				Position = UDim2.fromScale(.5, -.2),
				AnchorPoint = Vector2.new(.5, 1),
				Size = UDim2.fromScale(1, .4),
				FontFace = PALETTE.FONT_BOLD,
				TextColor3 = PALETTE.WHITE,
				BackgroundTransparency = 1,
				Text = "Auto Exec",
				TextScaled = true
			}))

			return comp
		end)

		ui:CreateComponent("Link").OnCreating:Connect(function(props: {[string]: any})
			return ui:AddInstance("CanvasGroup", { -- COMMUNITY
				Position = props.Position,
				Size = props.Size,
				AnchorPoint = props.AnchorPoint,
				BackgroundColor3 = PALETTE.BACKGROUND_2,
			}, ui:AddInstance("Frame", {
				Size = UDim2.fromScale(1, .45),
				BackgroundColor3 = props.Gradient
					and PALETTE.WHITE or PALETTE.BTN_GREY
			}, ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.085, .5),
				AnchorPoint = Vector2.new(0, .5),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(.4, .4),
				Image = props.Image or "rbxassetid://129203176783987"
			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = props.Gradient
			})), ui:AddInstance("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.fromScale(.075, .56),
				Size = UDim2.fromScale(.75, .15),
				TextColor3 = PALETTE.WHITE,
				Text = props.Title,
				FontFace = PALETTE.FONT_BOLD
			}), ui:AddInstance("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.fromScale(.075, .725),
				Size = UDim2.fromScale(.75, .185),
				TextColor3 = PALETTE.TEXT_SECONDARY,
				Text = props.Description,
				FontFace = PALETTE.FONT
			}), ui:AddInstance("TextButton", {
				Position = UDim2.fromScale(.925, .875),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundColor3 = PALETTE.BTN_GREY,
				Text = "",
				Size = UDim2.fromScale(1, .25),

				MouseButton1Click = framework.protected:GCProtect(function()
					framework.utils.http:OpenUrl(props.Url)
				end)
			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.3, 0)	
			}),ui:AddInstance("UIAspectRatioConstraint"
			), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.5, .5),
				AnchorPoint = Vector2.new(.5, .5),
				Size = UDim2.fromScale(.45, .45),
				BackgroundTransparency = 1,
				Image = "rbxassetid://76398608565219"
			}, ui:AddInstance("UIAspectRatioConstraint"
			))), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.15, 0)
			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.15, 0)
			}))
		end)

		ui:CreateComponent("CodeEditor").OnCreating:Connect(framework.protected:GCProtect(LPH_NO_VIRTUALIZE(function(props: {any})
			local sizes = ui:AddInstance("UISizeConstraint", {
				MaxSize = Vector2.new(math.huge, math.huge),
				MinSize = Vector2.zero
			})

			local lines = ui:AddInstance("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromScale(.025, 0),
				TextColor3 = PALETTE.TEXT_SECONDARY,
				Size = UDim2.fromScale(.05, 0),
				BackgroundTransparency = 1,
				TextTransparency = .45,
				TextSize = EDITOR_FONT_SIZE,
				Text = "",

			}, sizes)

			local textbox = ui:AddInstance("TextBox", {
				Id = props.Id,

				FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextColor3 = PALETTE.TEXT_SECONDARY,
				Size = UDim2.fromScale(1, 1),
				FocusLost = props.FocusLost,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Focused = props.Focused,
				TextSize = EDITOR_FONT_SIZE,
				MultiLine = true
			})

			local scrollx = ui:AddInstance("ScrollingFrame", {
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				AutomaticSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0),
				Position = UDim2.fromScale(.1, 0),
				ScrollBarThickness = LINE_THICKNESS,
				Size = UDim2.fromScale(.9, .7),
				BackgroundTransparency = 1,
				BorderSizePixel = 0

			}, textbox, ui:AddInstance("Frame", {
				Size = UDim2.fromOffset(LINE_THICKNESS, LINE_THICKNESS),
				Position = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1
			}))

			local overlay = ui:AddInstance("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = .5,
				Visible = false,
				ZIndex = 2

			}, ui:AddInstance("Frame", {
				BackgroundColor3 = Color3.fromRGB(138, 138, 138),
				Position = UDim2.fromScale(.5, .1),
				AnchorPoint = Vector2.new(.5, 0),
				Size = UDim2.fromScale(.5, 1)

			}, ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.5, .1),
				AnchorPoint = Vector2.new(.5, 0),
				Size = UDim2.fromScale(.9, .75),
				BackgroundTransparency = 1,
				TextScaled = true

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})))

			local editor = framework.utils.inputs.editors.new(props.Id)
			local scrolly = ui:AddInstance("ScrollingFrame", {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0),
				AnchorPoint = props.AnchorPoint,
				ScrollBarThickness = LINE_THICKNESS,
				BackgroundTransparency = 1,
				Position = props.Position,
				BorderSizePixel = 0,
				Size = props.Size,
				ZIndex = 1,

				OnRemoved = function() editor:Remove() end

			}, lines, scrollx, overlay)

			local highlightmaxchars = 10000
			local constraint = sizes.instance
			local updateLines = framework.protected:GCProtect(function()
				local y = scrollx.instance.AbsoluteSize.Y

				constraint.MinSize = Vector2.zero -- Prevent roblox from being too smart
				constraint.MaxSize = Vector2.new(math.huge, math.huge)

				constraint.MaxSize = Vector2.new(math.huge, y)
				y = framework.utils.maths.clamp(y, constraint.MaxSize.Y, math.huge)
				constraint.MinSize = Vector2.new(0, y)
			end)

			updateLines()
			scrollx.instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLines)
			textbox.instance:GetPropertyChangedSignal("TextEditable"):Connect(function()
				overlay.instance.Visible = not textbox.instance.TextEditable
			end)

			editor:ConnectHighlighter(textbox, highlightmaxchars)
			editor:ConnectLinesCounter(lines)
			editor:SetText(props.Text or "")
			return scrolly
		end)))

		ui:CreateComponent("ScriptTab").OnCreating:Connect(function(props: {[string]: any}, selected)
			local ctf
			if selected then ctf = false end

			return ui:AddInstance("TextButton", {
				Position = UDim2.fromScale(0, .5),
				AnchorPoint = Vector2.new(0, .5),
				BackgroundColor3 = PALETTE.BTN_GREY,
				Text = "",
				Size = UDim2.fromScale(.25, .8),
				LayoutOrder = props.LayoutOrder,
				Visible = props.Visible
			}, ui:AddInstance("UIAspectRatioConstraint", {
				AspectRatio = 2.7

			}), ui:AddInstance("UIPadding", {
				PaddingLeft = UDim.new(.125, 0),	
				PaddingRight = UDim.new(.125, 0),	
				PaddingTop = UDim.new(.225, 0),	
				PaddingBottom = UDim.new(.225, 0),
			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.3, 0)	
			}), ui:AddInstance("ImageButton", {
				Position = UDim2.fromScale(1, .5),
				AnchorPoint = Vector2.new(1, .5),
				Size = UDim2.fromScale(.55, .55),
				BackgroundTransparency = 1,
				Visible = not not selected,
				MouseButton1Click = props.OnClose,
				Image = "rbxassetid://105993318105870"

			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance(selected and "TextBox" or "TextLabel", {
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.fromScale(0, .5),
				AnchorPoint = Vector2.new(0, .5),
				Text = props.Text,
				TextColor3 = PALETTE.WHITE,
				FontFace = PALETTE.FONT_BOLD,
				Size = UDim2.fromScale(.8, .5),
				TextScaled = true,
				BackgroundTransparency = 1,
				ClearTextOnFocus = ctf
			}))
		end)

		ui:CreateComponent("SelectedTab").OnCreating:Connect(function(props: {[string]: any})
			return ui:AddComponent("ScriptTab", props, true)
		end)

		ui:CreateComponent("Setting").OnCreating:Connect(function(props: {[string]: any})
			return ui:AddInstance("Frame", { 
				Position = props.Position or UDim2.fromScale(0, 0),
				Size = props.Size or UDim2.fromScale(1, .15),
				BackgroundColor3 = PALETTE.WHITE,

				Tags = props.Category and
					{ props.Category } or nil

			},  ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
					ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
				})

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.175, 0)
			}), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.05, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.2, .3),
				BackgroundTransparency = 1,
				Image = "rbxassetid://122787494872462"
			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.125, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.15, .2),
				FontFace = PALETTE.FONT_BOLD,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Title or "Title",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.WHITE
			}), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.315, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.475, .2),
				FontFace = PALETTE.FONT,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Description or "Description of the Configuration",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.TEXT_SECONDARY
			}), ui:AddInstance("TextButton", {
				Position = UDim2.fromScale(.95, .5),
				AnchorPoint = Vector2.new(1, .5),
				Size = UDim2.fromScale(.085, .4),
				BackgroundColor3 = PALETTE.BACKGROUND_2,
				Text = "",
				AutoButtonColor = false,
				MouseButton1Click = framework.protected:GCProtect(function()
					-- FUNZIONI 
				end)
			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)
			}), ui:AddInstance("Frame", {
				BackgroundColor3 = props.Enabled and PALETTE.WHITE or PALETTE.UNSELECTED_BACKGROUND,
				Size = UDim2.fromScale(1, 1.1),
				Position = UDim2.fromScale(props.Enabled and 1 or 0, .5),
				AnchorPoint = Vector2.new(props.Enabled and 1 or 0, .5)
			}, ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)
			}), ui:AddInstance("UIAspectRatioConstraint"
			))))
		end)

		ui:CreateComponent("SettingToggle").OnCreating:Connect(framework.protected:GCProtect(function(props: {any})
			local state, toggle, knob = props.Value or false, nil, nil
			local tween = tweeninfo()

			local function updateColor()
				if state then
					-- toggle attivo: sfondo blu, knob bianco
					toggle:Tween(tween, {
						BackgroundTransparency = 0.85,
						BackgroundColor3 = PALETTE.WHITE
					})

					knob:Tween(tween, {
						BackgroundColor3 = PALETTE.WHITE
					})
				else
					-- toggle disattivo: sfondo neutro, knob grigino
					toggle:Tween(tween, {
						BackgroundColor3 = PALETTE.BACKGROUND_2,
						BackgroundTransparency = 0
					})

					knob:Tween(tween, {
						BackgroundColor3 = PALETTE.UNSELECTED_BACKGROUND
					})
				end
			end

			local function update(enabled: boolean?)
				state = enabled

				-- knob a destra se attivo, a sinistra se spento
				local goalPos = enabled and UDim2.fromScale(1, .5) or UDim2.fromScale(0, .5)
				local goalAnchor = enabled and Vector2.new(1, .5) or Vector2.new(0, .5)

				knob:Tween(tween, {
					Position = goalPos,
					AnchorPoint = goalAnchor
				})

				updateColor()
			end

			knob = ui:AddInstance("Frame", {
				BackgroundColor3 = state and PALETTE.WHITE or PALETTE.UNSELECTED_BACKGROUND,
				Size = UDim2.fromScale(1, 1.1),
				Position = state and UDim2.fromScale(1, .5) or UDim2.fromScale(0, .5),
				AnchorPoint = state and Vector2.new(1, .5) or Vector2.new(0, .5)
			}, ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})
			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)
			}), ui:AddInstance("UIAspectRatioConstraint"))

			toggle = ui:AddInstance("TextButton", {
				Position = UDim2.fromScale(.95, .5),
				AnchorPoint = Vector2.new(1, .5),
				Size = UDim2.fromScale(.1, .4),
				BackgroundColor3 = PALETTE.BACKGROUND_2,
				Text = "",
				AutoButtonColor = false,

				MouseButton1Click = framework.protected:GCProtect(function()
					state = not state
					update(state)

					props.Callback(state)
				end)
			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)
			}), knob)

			local comp = ui:AddInstance("Frame", { 
				Parent = props.Parent,
				Position = props.Position or UDim2.fromScale(0, 0),
				Size = props.Size or UDim2.fromScale(1, .15),
				BackgroundColor3 = PALETTE.WHITE,
				ZIndex = -(props.LayoutOrder or 0),
				LayoutOrder = props.LayoutOrder,

				Tags = props.Category and
					{ props.Category } or nil

			},  ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
					ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
				})

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.175, 0)
			}), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.05, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.2, .3),
				BackgroundTransparency = 1,
				Image = "rbxassetid://122787494872462"
			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.125, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.15, .2),
				FontFace = PALETTE.FONT_BOLD,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Title or "Title",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.WHITE
			}), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.315, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.475, .2),
				FontFace = PALETTE.FONT,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Description or "Description of the Configuration",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.TEXT_SECONDARY
			}), toggle)

			props.Callback(state)
			update(state)
			return comp
		end))

		ui:CreateComponent("SettingDropdown").OnCreating:Connect(framework.protected:GCProtect(function(props: {any})
			local btn, list, content, listLayout
			local lastText = props.Options[1].Name

			btn = ui:AddInstance("TextButton", {
				Text = lastText,
				Position = UDim2.fromScale(.95, .5),
				AnchorPoint = Vector2.new(1, .5),
				Size = UDim2.fromScale(.15, .4),
				BackgroundTransparency = .85,
				BackgroundColor3 = PALETTE.WHITE,
				TextColor3 = PALETTE.TEXT_SECONDARY,
				TextScaled = true,

				MouseButton1Click = framework.protected:GCProtect(function()
					content.instance.Visible = not content.instance.Visible
				end)

			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)

			}), ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})

			}), ui:AddInstance("UIPadding", {
				PaddingBottom = UDim.new(0, LINE_THICKNESS),
				PaddingRight = UDim.new(0, LINE_THICKNESS),
				PaddingLeft = UDim.new(0, LINE_THICKNESS),
				PaddingTop = UDim.new(0, LINE_THICKNESS)
			}))

			-- contenitore autosize
			content = ui:AddInstance("Frame", {
				Position = UDim2.fromScale(.95, .85),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = PALETTE.BTN_GREY,
				Size = UDim2.fromScale(.15, 0),
				AnchorPoint = Vector2.new(1, 0),
				Visible = false,

			}, ui:AddInstance("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, LINE_THICKNESS*5), -- padding maggiore per touch
				SortOrder = Enum.SortOrder.LayoutOrder

			}), ui:AddInstance("UIPadding", {
				PaddingBottom = UDim.new(0, LINE_THICKNESS),
				PaddingRight = UDim.new(0, LINE_THICKNESS),
				PaddingLeft = UDim.new(0, LINE_THICKNESS),
				PaddingTop = UDim.new(0, LINE_THICKNESS)

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.1, 0)
			}))

			listLayout = content.instance:FindFirstChildOfClass("UIListLayout")

			-- opzioni
			for _, option in ipairs(props.Options) do
				ui:AddInstance("TextButton", {
					Parent = content.instance,
					Size = UDim2.new(1, 0, 0, LINE_THICKNESS *6),
					TextColor3 = PALETTE.TEXT_SECONDARY,
					BackgroundTransparency = 1,
					Text = option.Name,
					TextWrapped = true,
					TextScaled = true,

					MouseButton1Click = framework.protected:GCProtect(function()
						btn.instance.Text = option.Name
						lastText = option.Name

						content.instance.Visible = false
						props.Callback(option.Value)
					end)
				})
			end

			if props.Value then
				for _, option in ipairs(props.Options) do
					if props.Value == option.Value then
						lastText = option.Name
						btn.instance.Text = option.Name
						props.Callback(option.Value)
						break
					end
				end
			end

			local comp = ui:AddInstance("Frame", { 
				Parent = props.Parent,
				Position = props.Position or UDim2.fromScale(0, 0),
				Size = props.Size or UDim2.fromScale(1, .15),
				BackgroundColor3 = PALETTE.WHITE,
				ZIndex = -(props.LayoutOrder or 0),
				LayoutOrder = props.LayoutOrder,

				Tags = props.Category and
					{ props.Category } or nil

			},  ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
					ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
				})

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.175, 0)
			}), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.05, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.2, .3),
				BackgroundTransparency = 1,
				Image = "rbxassetid://122787494872462"
			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.125, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.15, .2),
				FontFace = PALETTE.FONT_BOLD,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Title or "Title",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.WHITE
			}), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.315, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.475, .2),
				FontFace = PALETTE.FONT,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Description or "Description of the Configuration",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.TEXT_SECONDARY
			}), btn, content)

			return comp
		end))

		ui:CreateComponent("SettingButton").OnCreating:Connect(framework.protected:GCProtect(function(props: {any})
			local btn = ui:AddInstance("TextButton", {
				Text = "Click",
				Position = UDim2.fromScale(.95, .5),
				AnchorPoint = Vector2.new(1, .5),
				Size = UDim2.fromScale(.15, .4),
				BackgroundTransparency = 0,
				BackgroundColor3 = PALETTE.WHITE,
				TextColor3 = PALETTE.TEXT_SECONDARY,
				TextScaled = true,

				MouseButton1Click = props.Callback

			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.35, 0)

			}), ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})

			}), ui:AddInstance("UIPadding", {
				PaddingBottom = UDim.new(0, LINE_THICKNESS),
				PaddingRight = UDim.new(0, LINE_THICKNESS),
				PaddingLeft = UDim.new(0, LINE_THICKNESS),
				PaddingTop = UDim.new(0, LINE_THICKNESS)
			}))

			local comp = ui:AddInstance("Frame", { 
				Parent = props.Parent,
				Position = props.Position or UDim2.fromScale(0, 0),
				Size = props.Size or UDim2.fromScale(1, .15),
				BackgroundColor3 = PALETTE.WHITE,
				ZIndex = -(props.LayoutOrder or 0),
				LayoutOrder = props.LayoutOrder,

				Tags = props.Category and
					{ props.Category } or nil

			},  ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
					ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
				})

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.175, 0)
			}), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.05, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.2, .3),
				BackgroundTransparency = 1,
				Image = "rbxassetid://122787494872462"
			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.125, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.15, .2),
				FontFace = PALETTE.FONT_BOLD,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Title or "Title",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.WHITE
			}), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.315, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.475, .2),
				FontFace = PALETTE.FONT,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Description or "Description of the Configuration",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.TEXT_SECONDARY
			}), btn)

			return comp
		end))

		ui:CreateComponent("SettingNumeric").OnCreating:Connect(framework.protected:GCProtect(function(props: {any})
			props.Increment = props.Increment or 1
			props.Min = props.Min or -math.huge
			props.Max = props.Max or math.huge
			props.Value = props.Value or 0

			local value = ui:AddInstance("TextLabel", {
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.fromScale(.35, .6),
				Text = tostring(props.Value),
				BackgroundTransparency = 1,
				TextColor3 = PALETTE.WHITE,
				TextScaled = true,
				LayoutOrder = 2
			})

			local function setNum(num: number)
				num = framework.utils.maths.clamp(num, props.Min, props.Max)
				if props.Value ~= num then
					props.Value = num
					value.instance.Text = tostring(num)
					props.Callback(num)
				end
			end

			local down = ui:AddInstance("TextButton", {
				BackgroundColor3 = PALETTE.WHITE,
				Size = UDim2.fromScale(.15, .6),
				BackgroundTransparency = .5,
				TextColor3 = PALETTE.WHITE,
				TextScaled = true,
				LayoutOrder = 1,
				Text = "âˆ’",

				MouseButton1Click = framework.protected:GCProtect(function()
					setNum(props.Value - props.Increment)
				end)

			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}), ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})
			}))

			local up = ui:AddInstance("TextButton", {
				BackgroundColor3 = PALETTE.WHITE,
				Size = UDim2.fromScale(.15, .6),
				BackgroundTransparency = .5,
				TextColor3 = PALETTE.WHITE,
				TextScaled = true,
				LayoutOrder = 3,
				Text = "+",

				MouseButton1Click = framework.protected:GCProtect(function()
					setNum(props.Value + props.Increment)
				end)

			}, ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}), ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
					ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
				})

			}))

			local comp = ui:AddInstance("Frame", { 
				Parent = props.Parent,
				Position = props.Position or UDim2.fromScale(0, 0),
				Size = props.Size or UDim2.fromScale(1, .15),
				BackgroundColor3 = PALETTE.WHITE,
				ZIndex = -(props.LayoutOrder or 0),
				LayoutOrder = props.LayoutOrder,

				Tags = props.Category and
					{ props.Category } or nil

			},  ui:AddInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
					ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
				})

			}), ui:AddInstance("UICorner", {
				CornerRadius = UDim.new(.175, 0)
			}), ui:AddInstance("ImageLabel", {
				Position = UDim2.fromScale(.05, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.2, .3),
				BackgroundTransparency = 1,
				Image = "rbxassetid://122787494872462"
			}, ui:AddInstance("UIAspectRatioConstraint"
			)), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.125, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.15, .2),
				FontFace = PALETTE.FONT_BOLD,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Title or "Title",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.WHITE
			}), ui:AddInstance("TextLabel", {
				Position = UDim2.fromScale(.315, .5),
				AnchorPoint = Vector2.new(0, .5),
				Size = UDim2.fromScale(.37, .2),
				FontFace = PALETTE.FONT,
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = props.Description or "Description of the Configuration",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = PALETTE.TEXT_SECONDARY
			}), ui:AddInstance("Frame", {
				AnchorPoint = Vector2.new(1, .5),
				Position = UDim2.fromScale(.95, .5),
				Size = UDim2.fromScale(.275, .55),
				BackgroundTransparency = 1

			}, ui:AddInstance("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6)

			}), down, value, up))

			props.Callback(props.Value)
			return comp
		end))

		local selectedTab
		local pages, lastPos do
			local stgui = framework.protected:GetService("StarterGui")
			ui.init = framework.protected:GCProtect(function()
				ui:Get("PagesLayout").instance:JumpTo(ui:Get("Page_Key System").instance)
				--ui.toggle(true)
			end)

			pages = {
				{
					hidden = true,
					visible = true,
					name = "Key System",
					image = framework.protected:ProtectAsset("rbxassetid://134506148384956"),

					content = function()
						return {
							ui:AddInstance("CanvasGroup", {
								Size = UDim2.fromScale(.65, 1),
								BackgroundColor3 = PALETTE.WHITE

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.04, 0)
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = Color3.fromHex("#000"),
								ZIndex = -1
							}, ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1

							}, ui:AddInstance("UIGradient", {
								Id = "AuthGradient",

								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromHex("#77B7FF")),
									ColorSequenceKeypoint.new(1, Color3.fromHex("#3085FF"))
								}),
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 0.85),
									NumberSequenceKeypoint.new(1, 0)
								})

							})), ui:AddInstance("Frame", { -- HEADER
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.068, 0),
								PaddingRight = UDim.new(.068, 0),
								PaddingTop = UDim.new(.225, 0),
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("TextLabel", {
								Text = "Key System",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(1, .45),
								TextScaled = true,
								BackgroundTransparency = 1
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(0, .54),
								Text = "Authenticate your session and unlock Codex.",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT,
								Size = UDim2.fromScale(1, .3),
								TextScaled = true,
								BackgroundTransparency = 1
							}))), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .2),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}), ui:AddInstance("Frame", {
								Id = "AuthCircle",

								BackgroundColor3 = PALETTE.MAIN_BLUE_START,
								Position = UDim2.fromScale(.5, .25),
								Size = UDim2.fromScale(.43, .43),
								AnchorPoint = Vector2.new(.5, 0),
								BackgroundTransparency = .6

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(1, 0)

							}), ui:AddInstance("UIAspectRatioConstraint"), ui:AddInstance("Frame", {
								Position = UDim2.fromScale(.5, .5),
								Size = UDim2.fromScale(0.8, 0.8),
								AnchorPoint = Vector2.new(.5, .5),
								BackgroundColor3 = PALETTE.WHITE,
								BackgroundTransparency = .6

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(1, 0)

							}), ui:AddInstance("Frame", {
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								BackgroundColor3 = PALETTE.WHITE,
								Size = UDim2.fromScale(.7, .7),
								BackgroundTransparency = .6

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(1, 0)

							}), ui:AddInstance("ImageLabel", {
								Image = "rbxassetid://85727762623315",
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								ScaleType = Enum.ScaleType.Fit,
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								ImageTransparency = .2

							})))), ui:AddInstance("TextLabel", {
								Id = "KeyStatusText",
								Text = "Ready",
								TextColor3 = PALETTE.WHITE,
								Size = UDim2.fromScale(.5, 0.04),
								Position = UDim2.fromScale(.5, .69),
								AnchorPoint = Vector2.new(.5, 0),
								BackgroundTransparency = 1,
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true

							}), ui:AddInstance("TextLabel", {
								Id = "KeySubStatusText",
								Text = "Press START to detect your authentication state.",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								Size = UDim2.fromScale(.7, 0.035),
								Position = UDim2.fromScale(.5, .735),
								AnchorPoint = Vector2.new(.5, 0),
								BackgroundTransparency = 1,
								TextTransparency = .35,
								FontFace = PALETTE.FONT,
								TextScaled = true,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center

							}), ui:AddInstance("TextLabel", {
								Id = "Expiring_Label",
								Text = "No active key",
								TextColor3 = PALETTE.WHITE,
								Size = UDim2.fromScale(.5, 0.035),
								Position = UDim2.fromScale(.5, .79),
								AnchorPoint = Vector2.new(.5, 0),
								BackgroundTransparency = 1,
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true

							}), ui:AddInstance("Frame", {
								Position = UDim2.fromScale(.5, .84),
								AnchorPoint = Vector2.new(.5, 0),
								Size = UDim2.fromScale(.5, .016),
								BackgroundColor3 = PALETTE.UNSELECTED_BACKGROUND,
								BorderSizePixel = 0

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(1, 0)

							}), ui:AddInstance("Frame", {
								Id = "ExpiringBar",
								Size = UDim2.fromScale(0, 1),
								BackgroundColor3 = PALETTE.WHITE,
								BorderSizePixel = 0

							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(1, 0)
							}))), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .8),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}), ui:AddInstance("Frame", { -- FOOTER
								Position = UDim2.fromScale(0, 1),
								AnchorPoint = Vector2.new(0, 1),
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.068, 0),
								PaddingRight = UDim.new(.068, 0),
								PaddingTop = UDim.new(.225, 0),
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("Frame", {
								Id = "KeyButtonsRow",
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								Size = UDim2.fromScale(.82, .8),
								BackgroundTransparency = 1
							}, ui:AddInstance("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(.035, 0)
							}), ui:AddInstance("TextButton", {
								Id = "KeyStartButton",
								LayoutOrder = 1,
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								AutoButtonColor = false,
								Size = UDim2.fromScale(.48, 1)
							}, ui:AddInstance("UIScale", {
								Id = "KeyStartScale",
								Scale = 1
							}), ui:AddInstance("UIGradient", {
								Id = "KeyStartGradient",
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.35, 0)
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.12, 0),
								PaddingRight = UDim.new(.12, 0),
								PaddingTop = UDim.new(.22, 0),
								PaddingBottom = UDim.new(.22, 0)
							}), ui:AddInstance("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(.06, 0)
							}), ui:AddInstance("ImageLabel", {
								LayoutOrder = 1,
								Size = UDim2.fromScale(.6, .7),
								BackgroundTransparency = 1,
								Image = "rbxassetid://72290795689811"
							}, ui:AddInstance("UIAspectRatioConstraint")), ui:AddInstance("TextLabel", {
								Id = "KeyStartLabel",
								LayoutOrder = 2,
								Size = UDim2.fromScale(.6, .7),
								BackgroundTransparency = 1,
								Text = "LOGIN",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center
							})), ui:AddInstance("TextButton", {
								Id = "KeyUpgradeButton",
								LayoutOrder = 2,
								BackgroundColor3 = PALETTE.BTN_GREY,
								Text = "",
								AutoButtonColor = false,
								Size = UDim2.fromScale(.48, 1)
							}, ui:AddInstance("UIScale", {
								Id = "KeyUpgradeScale",
								Scale = 1
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.35, 0)
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.12, 0),
								PaddingRight = UDim.new(.12, 0),
								PaddingTop = UDim.new(.22, 0),
								PaddingBottom = UDim.new(.22, 0)
							}), ui:AddInstance("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(.06, 0)
							}), ui:AddInstance("ImageLabel", {
								LayoutOrder = 1,
								Size = UDim2.fromScale(.6, .7),
								BackgroundTransparency = 1,
								Image = "rbxassetid://120201446628760"
							}, ui:AddInstance("UIAspectRatioConstraint")), ui:AddInstance("TextLabel", {
								Id = "KeyUpgradeLabel",
								LayoutOrder = 2,
								Size = UDim2.fromScale(.7, .7),
								BackgroundTransparency = 1,
								Text = "GET KEY OR UPGRADE",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center
							})))), 							ui:AddInstance("CanvasGroup", {
								Id = "AuthOverlay",
								Visible = false,
								GroupTransparency = 1,
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								ZIndex = 40
							}, ui:AddInstance("TextButton", {
								Id = "AuthOverlayDismiss",
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = .34,
								Text = "",
								AutoButtonColor = false,
								Modal = true,
								Active = true,
								ZIndex = 40
							}), ui:AddInstance("CanvasGroup", {
								Id = "AuthCard",
								Active = true,
								Position = UDim2.fromScale(.5, .515),
								AnchorPoint = Vector2.new(.5, .5),
								Size = UDim2.fromScale(.56, .52),
								BackgroundColor3 = PALETTE.BACKGROUND_2,
								ZIndex = 41
							}, ui:AddInstance("UIScale", {
								Id = "AuthCardScale",
								Scale = .96
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.05, 0)
							}), ui:AddInstance("UIStroke", {
								Color = PALETTE.STROKE,
								Thickness = math.max(1, LINE_THICKNESS * .55),
								Transparency = .2
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.05, 0)
							}), ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							})), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1
							}, ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.06, 0),
								PaddingRight = UDim.new(.06, 0),
								PaddingTop = UDim.new(.065, 0),
								PaddingBottom = UDim.new(.06, 0)
							}),

							-- HEADER
							ui:AddInstance("Frame", {
								LayoutOrder = 1,
								Position = UDim2.fromScale(0, 0),
								Size = UDim2.fromScale(1, .19),
								BackgroundTransparency = 1
							}, ui:AddInstance("TextLabel", {
								Text = "Sign in",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Position = UDim2.fromScale(0, 0),
								Size = UDim2.fromScale(.78, .42),
								TextScaled = true,
								BackgroundTransparency = 1
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(0, .43),
								Text = "Authenticate your Codex account to continue.",
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT,
								Size = UDim2.fromScale(.8, .28),
								TextScaled = true,
								BackgroundTransparency = 1
							}), ui:AddInstance("ImageButton", {
								Id = "AuthCloseButton",
								Position = UDim2.fromScale(1, .02),
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = PALETTE.BTN_GREY,
								AutoButtonColor = false,
								Size = UDim2.fromScale(.09, .38)
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.32, 0)
							}), ui:AddInstance("UIAspectRatioConstraint", {
								AspectRatio = 1
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								Size = UDim2.fromScale(.42, .42),
								BackgroundTransparency = 1,
								Image = "rbxassetid://105993318105870"
							}))),

							-- USER FIELD
							ui:AddInstance("Frame", {
								Id = "AuthUserField",
								LayoutOrder = 2,
								Position = UDim2.fromScale(0, .22),
								Size = UDim2.fromScale(1, .19),
								BackgroundColor3 = PALETTE.BACKGROUND_2
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.16, 0)
							}), ui:AddInstance("UIStroke", {
								Id = "AuthUserStroke",
								Color = PALETTE.STROKE,
								Thickness = math.max(1, LINE_THICKNESS * .42),
								Transparency = .34
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.07, 0),
								PaddingRight = UDim.new(.07, 0),
								PaddingTop = UDim.new(.15, 0),
								PaddingBottom = UDim.new(.15, 0)
							}), ui:AddInstance("TextLabel", {
								Text = "USERNAME",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(1, .3),
								TextScaled = true,
								TextTransparency = .3,
								BackgroundTransparency = 1
							}), ui:AddInstance("TextBox", {
								Id = "AuthUserBox",
								Position = UDim2.fromScale(0, .34),
								Size = UDim2.fromScale(1, .7),
								Text = "",
								PlaceholderText = "Enter your username",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								PlaceholderColor3 = PALETTE.TEXT_SECONDARY,
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT,
								TextScaled = true,
								ClearTextOnFocus = false,
								BackgroundTransparency = 1
							})),

							-- PASS FIELD
							ui:AddInstance("Frame", {
								Id = "AuthPassField",
								LayoutOrder = 3,
								Position = UDim2.fromScale(0, .475),
								Size = UDim2.fromScale(1, .19),
								BackgroundColor3 = PALETTE.BACKGROUND_2
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.16, 0)
							}), ui:AddInstance("UIStroke", {
								Id = "AuthPassStroke",
								Color = PALETTE.STROKE,
								Thickness = math.max(1, LINE_THICKNESS * .42),
								Transparency = .34
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.07, 0),
								PaddingRight = UDim.new(.07, 0),
								PaddingTop = UDim.new(.15, 0),
								PaddingBottom = UDim.new(.15, 0)
							}), ui:AddInstance("TextLabel", {
								Text = "PASSWORD",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(1, .3),
								TextScaled = true,
								TextTransparency = .3,
								BackgroundTransparency = 1
							}), ui:AddInstance("TextBox", {
								Id = "AuthPassBox",
								Position = UDim2.fromScale(0, .34),
								Size = UDim2.fromScale(1, .7),
								Text = "",
								PlaceholderText = "Enter your password",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								PlaceholderColor3 = PALETTE.TEXT_SECONDARY,
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT,
								TextScaled = true,
								ClearTextOnFocus = false,
								BackgroundTransparency = 1
							})),

							-- FEEDBACK
							ui:AddInstance("TextLabel", {
								Id = "AuthFeedback",
								LayoutOrder = 4,
								AnchorPoint = Vector2.new(.5, 0),
								Position = UDim2.fromScale(0.5, .71),
								Size = UDim2.fromScale(1, .05),
								BackgroundTransparency = 1,
								Text = "Use your Codex account credentials.",
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT,
								TextScaled = true
							}),

							-- LOGIN BUTTON
							ui:AddInstance("TextButton", {
								Id = "AuthLoginButton",
								LayoutOrder = 5,
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .93),
								Size = UDim2.fromScale(1, .13),
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								AutoButtonColor = false
							}, ui:AddInstance("UIScale", {
								Id = "AuthLoginScale",
								Scale = 1
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.22, 0)
							}), ui:AddInstance("UIGradient", {
								Id = "AuthLoginGradient",
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("TextLabel", {
								Id = "AuthLoginText",
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								BackgroundTransparency = 1,
								Size = UDim2.fromScale(.84, .48),
								Text = "LOGIN",
								TextScaled = true,
								FontFace = PALETTE.FONT_BOLD,
								TextColor3 = PALETTE.WHITE
							})),

							-- REGISTER LINK LABEL
							ui:AddInstance("TextButton", {
								Id = "AuthRegisterButton",
								LayoutOrder = 6,
								AnchorPoint = Vector2.new(.5, 1),
								Position = UDim2.fromScale(.5, .995),
								Size = UDim2.fromScale(.34, .05),
								BackgroundTransparency = 1,
								AutoButtonColor = false,
								Text = "Register",
								TextScaled = true,
								TextColor3 = PALETTE.MAIN_BLUE_START,
								FontFace = PALETTE.FONT_BOLD
							}))))),

							ui:AddInstance("CanvasGroup", {
								Position = UDim2.fromScale(1, 0),
								AnchorPoint = Vector2.new(1, 0),
								Size = UDim2.fromScale(.335, 1)
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.075, 0)
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1
							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(.5, .23),
								Size = UDim2.fromScale(.75, .0425),
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(.5, 0),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								Text = "Need help?",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								TextXAlignment = Enum.TextXAlignment.Left
							}), ui:AddComponent("Link", {
								Title = "Discord",
								Description = "Join our Discord and\nopen a ticket!",
								Url = "https://discord.com/invite/codexlol",
								Position = UDim2.fromScale(.5, .3),
								Size = UDim2.fromScale(.75, .25),
								AnchorPoint = Vector2.new(.5, 0),
								Gradient = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(.5, .6),
								Size = UDim2.fromScale(.75, .0425),
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(.5, 0),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								Text = "Changelog",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								TextXAlignment = Enum.TextXAlignment.Left
							}), ui:AddComponent("Link", {
								Title = "v1.0.0",
								Description = "Release of the new\nCodex UI",
								Url = "https://discord.com/invite/codexlol",
								Image = "rbxassetid://116067405018936",
								Position = UDim2.fromScale(.5, .67),
								Size = UDim2.fromScale(.75, .25),
								AnchorPoint = Vector2.new(.5, 0),
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.087, 0),
								PaddingRight = UDim.new(.087, 0),
								PaddingTop = UDim.new(.225, 0),
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(0, .175),
								Text = "Welcome to Codex!",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(1, .35),
								TextScaled = true,
								BackgroundTransparency = 1
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(0, .54),
								Text = "Unlock the power to dominate with us!",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT,
								Size = UDim2.fromScale(1, .3),
								TextScaled = true,
								BackgroundTransparency = 1
							}))), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .2),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}))
						}
					end
				},

				{ name = "Home", image = framework.protected
					:ProtectAsset("rbxassetid://108583946849839"),

					content = function()
						return {
							ui:AddInstance("CanvasGroup", {
								Size = UDim2.fromScale(.65, 1),
								BackgroundColor3 = PALETTE.WHITE

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.04, 0)
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							}), ui:AddInstance("Frame", { -- HEADER
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.068, 0),	
								PaddingRight = UDim.new(.068, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("TextLabel", {
								Id = "Username",
								Text = "Hello, <Username>!",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(1, .4),
								TextScaled = true,
								BackgroundTransparency = 1
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(0, .425),
								Text = "Thank you for using Codex!",
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = PALETTE.TEXT_SECONDARY,
								FontFace = PALETTE.FONT,
								Size = UDim2.fromScale(1, .25),
								TextScaled = true,
								BackgroundTransparency = 1
							}), ui:AddInstance("CanvasGroup", {
								Size = UDim2.fromScale(1, .24),
								Position = UDim2.fromScale(0, 1),
								AnchorPoint = Vector2.new(0, 1),
								BackgroundColor3 = PALETTE.BTN_GREY,

							}, ui:AddInstance("Frame", {
								Id = "ExpiringBar",
								Size = UDim2.fromScale(.5, 1),
								BackgroundColor3 = PALETTE.WHITE

							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							})), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(1, 0)	
							}), ui:AddInstance("TextLabel", {
								Id = "Expiring_Label",

								Text = "Key expires in: 24h",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(1, .95),
								TextScaled = true,
								BackgroundTransparency = 1
							}))), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(.5, .23),
								Size = UDim2.fromScale(.865, .0425),
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(.5, 0),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								Text = "Last saved scripts",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								TextXAlignment = Enum.TextXAlignment.Left
							}), function()

								local scripthub = framework.dependencies.scripthub
								local list = scripthub:GetList()

								if #list > 0 then
									local res = list[#list]

									return {
										ui:AddComponent("Script", {
											Image = PALETTE.FALLBACK_IMAGE,
											Description = res.description or "",
											Title = res.title,
											Position = UDim2.fromScale(.5, .3),
											Size = UDim2.fromScale(.865, .25),
											AnchorPoint = Vector2.new(.5, 0),
											Source = res.content
										})
									}
								end

								return {
									ui:AddComponent("Script", {
										Image = PALETTE.FALLBACK_IMAGE,
										Description = "You can save your scripts from the editor page!",
										Title = "No script saved yet.",
										Position = UDim2.fromScale(.5, .3),
										Size = UDim2.fromScale(.865, .25),
										AnchorPoint = Vector2.new(.5, 0),
										Source = ""
									})
								}

							end, ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(.5, .6),
								Size = UDim2.fromScale(.865, .0425),
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(.5, 0),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								Text = "Quick Actions",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								TextXAlignment = Enum.TextXAlignment.Left

							}), framework.protected:GCProtect(function()
								local cache = {}
								local getHumanoid = framework.protected:GCProtect(function(char)
									local succ, hum: Humanoid = pcall(char.WaitForChild, char, "Humanoid")
									if not succ then return end

									return hum
								end)

								local frames, sliders = {}, {
									{
										Icon = "rbxassetid://15054333892",
										Id = "Gravity",

										AnchorPoint = Vector2.new(.5, 0),
										Position = UDim2.fromScale(.5, .77),
										Size = UDim2.fromScale(.865, .084),

										Def = 196.2, Min = .001, Max = 250, Ena = false,
										Callback = framework.protected:GCProtect(function(value: number)
											framework.protected:GetService("Workspace").Gravity = value
										end)
									},
									{
										Icon = "rbxassetid://15054332032",
										Id = "Jump",

										AnchorPoint = Vector2.new(.5, 0),
										Position = UDim2.fromScale(.5, .87),
										Size = UDim2.fromScale(.865, .084),

										Def = 7.2, Min = 0, Max = 250, Ena = false,
										Callback = framework.protected:GCProtect(function(value: number)
											cache.jump = cache.jump or {}
											local ccon, jcon = 
												cache.jump.ccon, cache.jump.jcon

											if ccon then ccon:Disconnect() end
											if jcon then jcon:Disconnect() end

											local plr: Player = framework.protected:GetService("Players").LocalPlayer
											local char = plr.Character

											if char then
												local hum = getHumanoid(char)
												if hum then
													hum.UseJumpPower = false
													hum.JumpHeight = value
												end
											end

											cache.jump.ccon = plr.CharacterAdded:Connect(function(char)
												local hum = getHumanoid(char)
												if not hum then return end

												hum.UseJumpPower = false
												hum.JumpHeight = value
												cache.jump.jcon = hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()

													hum.UseJumpPower = false
													hum.JumpHeight = value
												end)
											end)
										end)
									},
									{
										Icon = "rbxassetid://15054335513",
										Id = "Speed",

										AnchorPoint = Vector2.new(.5, 0),
										Position = UDim2.fromScale(.5, .67),
										Size = UDim2.fromScale(.865, .084),

										Def = 16, Min = 0, Max = 500, Ena = false,
										Callback = framework.protected:GCProtect(function(value: number)
											cache.speed = cache.speed or {}
											local ccon, scon = 
												cache.speed.ccon, cache.speed.scon

											if ccon then ccon:Disconnect() end
											if scon then scon:Disconnect() end

											local plr: Player = framework.protected:GetService("Players").LocalPlayer
											local char = plr.Character

											if char then
												local hum = getHumanoid(char)
												if hum then hum.WalkSpeed = value end
											end

											cache.speed.ccon = plr.CharacterAdded:Connect(function(char)
												local hum = getHumanoid(char)
												if not hum then return end

												hum.WalkSpeed = value
												cache.speed.jcon = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
													hum.WalkSpeed = value
												end)
											end)
										end)
									}
								}

								for _, v in ipairs(sliders) do
									framework.utils.tables.insert(frames, ui:AddComponent("Slider", v))
								end

								return frames				
							end)), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .2),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							})),

							ui:AddInstance("CanvasGroup", {
								Position = UDim2.fromScale(1, 0),
								AnchorPoint = Vector2.new(1, 0),
								Size = UDim2.fromScale(.335, 1)
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.075, 0)
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(.5, .23),
								Size = UDim2.fromScale(.75, .0425),
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(.5, 0),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								Text = "Community",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								TextXAlignment = Enum.TextXAlignment.Left
							}), ui:AddComponent("Link", {
								Title = "Discord",
								Description = "Join our Discord to stay\nup to date!",
								Url = "https://discord.com/invite/codexlol",

								Position = UDim2.fromScale(.5, .3),
								Size = UDim2.fromScale(.75, .25),
								AnchorPoint = Vector2.new(.5, 0),

								Gradient = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})

							}), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(.5, .6),
								Size = UDim2.fromScale(.75, .0425),
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(.5, 0),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								Text = "Changelog",
								TextColor3 = PALETTE.TEXT_SECONDARY,
								TextXAlignment = Enum.TextXAlignment.Left
							}), ui:AddComponent("Link", {
								Title = "v1.0.0",
								Description = "Publication of the new\nCodex UI",
								Url = "https://discord.com/invite/codexlol",
								Image = "rbxassetid://116067405018936",

								Position = UDim2.fromScale(.5, .67),
								Size = UDim2.fromScale(.75, .25),
								AnchorPoint = Vector2.new(.5, 0),

							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.087, 0),	
								PaddingRight = UDim.new(.087, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(.49, 1),
								Position = UDim2.fromScale(0, .5),
								AnchorPoint = Vector2.new(0, .5),
								BackgroundColor3 = PALETTE.BTN_GREY
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.145, .5),
								AnchorPoint = Vector2.new(0, .5),
								Size = UDim2.fromScale(.33, .33),
								BackgroundTransparency = 1,
								ScaleType = Enum.ScaleType.Fit,
								ImageColor3 = PALETTE.MAIN_BLUE_START,
								Image = "rbxassetid://135688084058237"--"rbxassetid://109687641530205"

							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {
								Id = "Streak_Label", -- Ping

								TextXAlignment = Enum.TextXAlignment.Left,
								Position = UDim2.fromScale(.925, .5),
								AnchorPoint = Vector2.new(1, .5),
								TextScaled = true,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(.475, .3),
								Text = "24",
								BackgroundTransparency = 1,
								TextColor3 = PALETTE.WHITE

							})), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(.49, 1),
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								BackgroundColor3 = PALETTE.BTN_GREY
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.145, .5),
								AnchorPoint = Vector2.new(0, .5),
								Size = UDim2.fromScale(.33, .33),
								BackgroundTransparency = 1,
								ScaleType = Enum.ScaleType.Fit,
								ImageColor3 = PALETTE.MAIN_BLUE_START,
								Image = "rbxassetid://134295344409162"

							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {
								Id = "FPS_Label",

								TextXAlignment = Enum.TextXAlignment.Left,
								Position = UDim2.fromScale(.925, .5),
								AnchorPoint = Vector2.new(1, .5),
								TextScaled = true,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(.475, .3),
								Text = "24",
								BackgroundTransparency = 1,
								TextColor3 = PALETTE.WHITE

							})))), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .2),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}))
						}
					end
				},
				{ name = "Executor", image = framework.protected
					:ProtectAsset("rbxassetid://83325005775131"),

					content = function()
						return {
							ui:AddInstance("CanvasGroup", {
								Size = UDim2.fromScale(.65, 1),
								BackgroundColor3 = PALETTE.WHITE

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.04, 0)
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = Color3.fromHex("#000"),
								ZIndex = -1
							}, ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1

							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							})), ui:AddInstance("ScrollingFrame", { -- HEADER
								Id = "TabsList",

								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE,
								ScrollingDirection = Enum.ScrollingDirection.X,
								CanvasSize = UDim2.fromScale(1,.2)
							}, ui:AddInstance("UIListLayout", {
								Id = "TabsListLayout",

								Padding = UDim.new(0, LINE_THICKNESS *3),
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Left

							}), ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(0, LINE_THICKNESS *5),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("TextButton", {  -- ADD SCRIPT BUTTON
								Id = "NewTab",

								Position = UDim2.fromScale(.275, .5),
								AnchorPoint = Vector2.new(0, .5),
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								Size = UDim2.fromScale(.25, .5),
								LayoutOrder = 999999
							}, ui:AddInstance("UIAspectRatioConstraint"
							), ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://124394182878724"
							})

							))), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .2),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}), ui:AddComponent("CodeEditor", {
								Id = "Main_Editor",

								Position = UDim2.fromScale(.5, .225),
								Size = UDim2.fromScale(.975, .55),
								AnchorPoint = Vector2.new(.5, 0),

								Focused = framework.protected:GCProtect(function()
									framework.utils.inputs.editors
										:Get("Main_Editor"):ToggleHighlighter(false)
								end),

								FocusLost = framework.protected:GCProtect(function()
									local editor = framework.utils.inputs
										.editors:Get("Main_Editor")

									local src = editor:GetText()			
									editor:ToggleHighlighter(true)
								end)

							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 0),
								Position = UDim2.fromScale(0, .8),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}), ui:AddInstance("Frame", { -- FOOTER
								Position = UDim2.fromScale(0, 1),
								AnchorPoint = Vector2.new(0, 1),
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})

							}), ui:AddInstance("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(.03, 0)
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.068, 0),	
								PaddingRight = UDim.new(.068, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("TextButton", {  -- EXECUTE BUTTON
								Position = UDim2.fromScale(0, .5),
								AnchorPoint = Vector2.new(0, .5),
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								Size = UDim2.fromScale(.25, .8),

								MouseButton1Click = framework.protected:GCProtect(function()
									local editor = framework.utils.inputs.editors:Get("Main_Editor")
									framework.execution:Execute(editor:GetText())
								end)
							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.125, 0),	
								PaddingRight = UDim.new(.075, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(0, .5),
								AnchorPoint = Vector2.new(0, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://84207212135058"
							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {
								Id = "ExecuteText",
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								Text = "EXECUTE",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(.8, .5),
								TextScaled = true,
								BackgroundTransparency = 1
							})), ui:AddInstance("TextButton", {  -- CLEAR BUTTON
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								BackgroundColor3 = PALETTE.BTN_GREY,
								Text = "",
								LayoutOrder = 1,
								Size = UDim2.fromScale(.25, .8),

								MouseButton1Click = framework.protected:GCProtect(function()
									local editor = framework.utils.inputs.editors:Get("Main_Editor")
									editor:SetText("")
								end)
							}, ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.125, 0),	
								PaddingRight = UDim.new(.075, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(0, .5),
								AnchorPoint = Vector2.new(0, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://113576539925127"
							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								Text = "Clear Text",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(.8, .5),
								TextScaled = true,
								BackgroundTransparency = 1
							})), ui:AddInstance("TextButton", {  -- EXECUTE CB BUTTON
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								BackgroundColor3 = PALETTE.BTN_GREY,
								Text = "",
								LayoutOrder = 2,
								Size = UDim2.fromScale(.25, .8),

								MouseButton1Click = framework.protected:GCProtect(function()
									framework.execution:Execute(framework.utils.clipboard:Get())
								end)
							}, ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.125, 0),	
								PaddingRight = UDim.new(.075, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(0, .5),
								AnchorPoint = Vector2.new(0, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://76398608565219"
							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								Text = "Execute CB",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(.8, .5),
								TextScaled = true,
								BackgroundTransparency = 1
							})), ui:AddInstance("TextButton", {  -- SAVE BUTTON
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								LayoutOrder = 3,
								Size = UDim2.fromScale(.2, .8),

								MouseButton1Click = framework.protected:GCProtect(function()
									if not selectedTab then return end

									local data = selectedTab:GetData()
									if data.Src:gsub("%s", "") == "" then return end

									framework.dependencies.scripthub
										:Add(data.Name, "Local file.", data.Src)
									framework.dependencies.allhub
										:RefreshLocalScripts()
								end)
							}, ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.125, 0),	
								PaddingRight = UDim.new(.075, 0),	
								PaddingTop = UDim.new(.225, 0),	
								PaddingBottom = UDim.new(.225, 0),
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(0, .5),
								AnchorPoint = Vector2.new(0, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://120201446628760"
							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								Text = "Save",
								TextColor3 = PALETTE.WHITE,
								FontFace = PALETTE.FONT_BOLD,
								Size = UDim2.fromScale(.8, .5),
								TextScaled = true,
								BackgroundTransparency = 1
							})))),

							ui:AddInstance("CanvasGroup", {
								Position = UDim2.fromScale(1, 0),
								AnchorPoint = Vector2.new(1, 0),
								Size = UDim2.fromScale(.335, 1)
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.075, 0)
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, 1),
								BackgroundColor3 = PALETTE.WHITE,
								ZIndex = -1
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.fromScale(0, .2),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}), ui:AddInstance("Frame", {  -- HEADER
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.087, 0),	
								PaddingRight = UDim.new(.087, 0),	
								PaddingTop = UDim.new(.275, 0),	
								PaddingBottom = UDim.new(.275, 0),
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.06, .5),
								Size = UDim2.fromScale(.25, .25),
								AnchorPoint = Vector2.new(0, .5),
								BackgroundTransparency = 1,
								Image = "rbxassetid://84881135782364",
								ZIndex = 50
							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextBox", {  -- SEARCH SCRIPT BOX
								Id = "EditorSearch",
								Size = UDim2.fromScale(.825, 1),
								FontFace = PALETTE.FONT,
								TextScaled = true,
								TextColor3 = PALETTE.WHITE,
								BackgroundColor3 = PALETTE.BTN_GREY,
								TextXAlignment = Enum.TextXAlignment.Left,
								PlaceholderText = "Search...",
								Text = "",

								FocusLost = framework.protected:GCProtect(function()
									framework.dependencies.allhub:SmallHub(
										ui:Get("EditorSearch").instance.Text)
								end)
							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.2, 0),	
								PaddingRight = UDim.new(.075, 0),	
								PaddingTop = UDim.new(.35, 0),	
								PaddingBottom = UDim.new(.35, 0),
							})), ui:AddInstance("TextButton", {  -- FILTER BUTTON
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								Size = UDim2.fromScale(.25, .615),
								LayoutOrder = 999999
							}, ui:AddInstance("UIAspectRatioConstraint"
							), ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://123150198037663"
							}))), ui:AddInstance("ScrollingFrame", {
								Id = "SmallScriptsList",

								Position = UDim2.fromScale(.5, .5),
								Size = UDim2.fromScale(.8, .55),
								AnchorPoint = Vector2.new(.5, .5),
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								ScrollingDirection = Enum.ScrollingDirection.Y,
								CanvasSize = UDim2.fromScale(0, 0),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								ScrollBarThickness = 0

							}, ui:AddInstance("UIListLayout", {
								Id = "SmallScriptsLayout",

								Padding = UDim.new(0, LINE_THICKNESS *3),
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								FillDirection = Enum.FillDirection.Vertical,
								SortOrder = Enum.SortOrder.LayoutOrder

							})), ui:AddInstance("Frame", { -- FOOTER
								Position = UDim2.fromScale(0, 1),
								AnchorPoint = Vector2.new(0, 1),
								Size = UDim2.fromScale(1, .2),
								BackgroundColor3 = PALETTE.WHITE
							},  ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
									ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
								})
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.087, 0),	
								PaddingRight = UDim.new(.087, 0),	
								PaddingTop = UDim.new(.275, 0),	
								PaddingBottom = UDim.new(.275, 0),
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.06, .5),
								Size = UDim2.fromScale(.25, .25),
								AnchorPoint = Vector2.new(0, .5),
								BackgroundTransparency = 1,
								Image = "rbxassetid://134295344409162",
								ZIndex = 50
							}, ui:AddInstance("UIAspectRatioConstraint"
							)), ui:AddInstance("TextLabel", {  -- FPS STATS
								Id = "FPS_Label2",
								Size = UDim2.fromScale(.825, 1),
								FontFace = PALETTE.FONT_BOLD,
								TextScaled = true,
								TextColor3 = PALETTE.WHITE,
								BackgroundColor3 = PALETTE.BTN_GREY,
								TextXAlignment = Enum.TextXAlignment.Left,
								Text = "You currently have 60FPS"

							}, ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)
							}), ui:AddInstance("UIPadding", {
								PaddingLeft = UDim.new(.2, 0),	
								PaddingRight = UDim.new(.075, 0),	
								PaddingTop = UDim.new(.35, 0),	
								PaddingBottom = UDim.new(.35, 0),

							})), ui:AddInstance("TextButton", {  -- BOOSTFPS BUTTON
								Position = UDim2.fromScale(1, .5),
								AnchorPoint = Vector2.new(1, .5),
								BackgroundColor3 = PALETTE.WHITE,
								Text = "",
								Size = UDim2.fromScale(.25, .615),
								LayoutOrder = 999999,

								MouseButton1Click = framework.protected:GCProtect(function()
									framework.execution:ExecuteUrl("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua")
								end)

							}, ui:AddInstance("UIAspectRatioConstraint"
							), ui:AddInstance("UIGradient", {
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
									ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
								})
							}), ui:AddInstance("UICorner", {
								CornerRadius = UDim.new(.3, 0)	
							}), ui:AddInstance("ImageLabel", {
								Position = UDim2.fromScale(.5, .5),
								AnchorPoint = Vector2.new(.5, .5),
								Size = UDim2.fromScale(.55, .55),
								BackgroundTransparency = 1,
								Image = "rbxassetid://72290795689811"
							})
							))), ui:AddInstance("Frame", {
								Size = UDim2.fromScale(1, .0058),
								AnchorPoint = Vector2.new(0, 0),
								Position = UDim2.fromScale(0, .8),
								BackgroundColor3 = PALETTE.STROKE,
								ZIndex = 5
							}))
						}
					end
				},
				{ name = "Script Hub", image = framework.protected
					:ProtectAsset("rbxassetid://135545879070813"),

					content = ui:AddInstance("Frame", {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Tags = { "Page" }

					}, ui:AddInstance("ImageLabel", {
						Position = UDim2.fromScale(.02, .028),
						Size = UDim2.fromScale(.04, .04),
						BackgroundTransparency = 1,
						Image = "rbxassetid://84881135782364",
						ZIndex = 50
					}, ui:AddInstance("UIAspectRatioConstraint"
					)), ui:AddInstance("TextBox", {  -- SEARCH SCRIPT
						Id = "ScriptsSearch",

						Size = UDim2.fromScale(0.3, 0.1),
						FontFace = PALETTE.FONT,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.BTN_GREY,
						TextXAlignment = Enum.TextXAlignment.Left,
						PlaceholderText = "Search...",
						Text = "",

						FocusLost = framework.protected:GCProtect(function()
							framework.dependencies.allhub:Query(
								ui:Get("ScriptsSearch").instance.Text)
						end)
					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.2, 0),	
						PaddingRight = UDim.new(.075, 0),	
						PaddingTop = UDim.new(.35, 0),	
						PaddingBottom = UDim.new(.35, 0),
					})), ui:AddInstance("TextButton", {  -- Cloud Scripts Tab
						Id = "CloudScripts",

						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.fromScale(1-.225-.225, 0),
						Size = UDim2.fromScale(.215, 0.1),
						FontFace = PALETTE.FONT_BOLD,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.BTN_GREY,
						Text = "Cloud Scripts",

						MouseButton1Click = framework.protected:GCProtect(function()
							framework.dependencies.allhub:CloudScripts()
						end)

					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.1, 0),	
						PaddingRight = UDim.new(.1, 0),	
						PaddingTop = UDim.new(.3, 0),	
						PaddingBottom = UDim.new(.3, 0),
					})), ui:AddInstance("TextButton", {  -- LocalScripts Tab
						Id = "LocalScripts",

						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.fromScale(1-.225, 0),
						Size = UDim2.fromScale(0.215, 0.1),
						FontFace = PALETTE.FONT_BOLD,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.UNSELECTED_BACKGROUND,
						TextTransparency = .5,
						Text = "Local Scripts",

						MouseButton1Click = framework.protected:GCProtect(function()
							framework.dependencies.allhub:LocalScripts()
						end)

					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.1, 0),	
						PaddingRight = UDim.new(.1, 0),	
						PaddingTop = UDim.new(.3, 0),	
						PaddingBottom = UDim.new(.3, 0),
					})), ui:AddInstance("TextButton", {  -- Built-In Tab
						Id = "BuiltIn",

						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.fromScale(1, 0),
						Size = UDim2.fromScale(0.215, 0.1),
						FontFace = PALETTE.FONT_BOLD,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.UNSELECTED_BACKGROUND,
						TextTransparency = .5,
						Text = "Built-In Scripts",

						MouseButton1Click = framework.protected:GCProtect(function()
							framework.dependencies.allhub:BuiltIn()
						end)

					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.1, 0),	
						PaddingRight = UDim.new(.1, 0),	
						PaddingTop = UDim.new(.3, 0),	
						PaddingBottom = UDim.new(.3, 0),
					})), ui:AddInstance("ScrollingFrame", {
						Id = "ScriptsList",

						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.fromScale(0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.fromScale(1, .875),
						AnchorPoint = Vector2.new(0, 1),
						BackgroundTransparency = 1,
						ScrollBarThickness = 0,
						BorderSizePixel = 0,
						Tags = { "Page" }

					}, ui:AddInstance("UIListLayout", {
						Id = "ScriptsLayout",

						Padding = UDim.new(0, LINE_THICKNESS *3),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,

					})))
				},
				{ name = "Settings", image = framework.protected
					:ProtectAsset("rbxassetid://122787494872462"),

					content = ui:AddInstance("Frame", {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Tags = { "Page" }

					}, ui:AddInstance("TextButton", {  -- EXECUTOR
						Id = "Executor_Btn",
						Size = UDim2.fromScale(0.32, 0.1),
						FontFace = PALETTE.FONT,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.BTN_GREY,
						Text = "Executor",

						MouseButton1Click = framework.protected:GCProtect(function()
							framework.dependencies.allhub:ShowSettingsCat("Executor")
						end)

					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.1, 0),	
						PaddingRight = UDim.new(.1, 0),	
						PaddingTop = UDim.new(.3, 0),	
						PaddingBottom = UDim.new(.3, 0),
					})), ui:AddInstance("TextButton", {  -- PLAYER
						Id = "Player_Btn",
						Position = UDim2.fromScale(.5, 0),
						AnchorPoint = Vector2.new(.5, 0),
						Size = UDim2.fromScale(.32, 0.1),
						FontFace = PALETTE.FONT_BOLD,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.BTN_GREY,
						Text = "Player",

						MouseButton1Click = framework.protected:GCProtect(function()
							framework.dependencies.allhub:ShowSettingsCat("Player")
						end)

					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.1, 0),	
						PaddingRight = UDim.new(.1, 0),	
						PaddingTop = UDim.new(.3, 0),	
						PaddingBottom = UDim.new(.3, 0),
					})), ui:AddInstance("TextButton", {  -- SERVER
						Id = "Server_Btn",
						Position = UDim2.fromScale(1, 0),
						Size = UDim2.fromScale(.32, 0.1),
						AnchorPoint = Vector2.new(1, 0),
						FontFace = PALETTE.FONT_BOLD,
						TextScaled = true,
						TextColor3 = PALETTE.WHITE,
						BackgroundColor3 = PALETTE.BTN_GREY,
						Text = "Server",

						MouseButton1Click = framework.protected:GCProtect(function()
							framework.dependencies.allhub:ShowSettingsCat("Server")
						end)

					}, ui:AddInstance("UICorner", {
						CornerRadius = UDim.new(.35, 0)
					}), ui:AddInstance("UIPadding", {
						PaddingLeft = UDim.new(.1, 0),	
						PaddingRight = UDim.new(.1, 0),	
						PaddingTop = UDim.new(.3, 0),	
						PaddingBottom = UDim.new(.3, 0),
					})),

					ui:AddInstance("ScrollingFrame", {
						Id = "SettingsList",

						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						CanvasSize = UDim2.fromScale(0, 0),
						Position = UDim2.fromScale(0, 1),
						AnchorPoint = Vector2.new(0, 1),
						Size = UDim2.fromScale(1, .875),
						BackgroundTransparency = 1,
						ScrollBarThickness = 0,
						BorderSizePixel = 0,
						Tags = { "Page" }

					}, ui:AddInstance("UIListLayout", {
						Id = "ScriptsLayout",

						Padding = UDim.new(0, LINE_THICKNESS *3),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
					})))
				}
			}
		end

		-- UI Here
		local main, ficon, swipeBar
		main = ui:AddInstance("CanvasGroup", {
			Id = "Main",

			Position = UDim2.fromScale(.5, .5),
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1

		}, ui:AddInstance("Frame", {
			Id = "SideBar",
			Size = UDim2.fromScale(.11, 1),
			BackgroundColor3 = PALETTE.WHITE

		}, ui:AddInstance("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, PALETTE.BACKGROUND_START),
				ColorSequenceKeypoint.new(1, PALETTE.BACKGROUND_END)
			})
		}), ui:AddInstance("ImageLabel", {
			Position = UDim2.fromScale(.5, .085),
			AnchorPoint = Vector2.new(.5, 0),
			Size = UDim2.fromScale(.35, .8),
			BackgroundTransparency = 1,
			Image = "rbxassetid://91172716703830",
			ScaleType = Enum.ScaleType.Fit

		}, ui:AddInstance("UIAspectRatioConstraint"
		)), ui:AddInstance("Frame", {
			Position = UDim2.fromScale(.5, .985),
			AnchorPoint = Vector2.new(.5, 1),
			Size = UDim2.fromScale(.5, .8),
			BackgroundTransparency = 1

		}, ui:AddInstance("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0.05, 0)

		}), function()

			local child = {}
			local function hideall()
				for _, v in ipairs(child) do
					v.instance.BackgroundTransparency = 1
					local f = v.instance:FindFirstChildWhichIsA("Frame")
					f.BackgroundTransparency = .5
					f:FindFirstChildWhichIsA("ImageLabel").ImageTransparency = .5
				end
			end

			local function show(btn)
				btn.instance.BackgroundTransparency = 0
				local f = btn.instance:FindFirstChildWhichIsA("Frame")
				f.BackgroundTransparency = 0
				f:FindFirstChildWhichIsA("ImageLabel").ImageTransparency = 0
			end

			local UserInputService = framework.protected
				:GetService("UserInputService")
			local baseui = ui.instance
				:FindFirstAncestorWhichIsA("BasePlayerGui")

			UserInputService.InputBegan:Connect(function(input)
				if (input.UserInputType ~= Enum.UserInputType.MouseButton1 and
					input.UserInputType ~= Enum.UserInputType.Touch)
					or not ui.isOpen then return end

				local max = main.instance.Parent.AbsoluteSize
				if framework.utils.maths.isWithin2DBounds(
					input.Position, Vector2.new(0, 0),
					Vector2.new(max.X *(ui.isPageOpen and .1 or .13), max.Y)) then
					return
				end

				local back = ui:Get("Pages").instance
				local guis = baseui:GetGuiObjectsAtPosition(
					input.Position.X, input.Position.Y)

				local valid = {}
				for _, v in ipairs(guis) do
					local page = ui:Get(v)
					if not page or page:HasTags("Page") then
						continue
					end

					table.insert(valid, v)
				end

				if #valid < 2 then
					return ui.close()

				elseif #valid < 3 then
					for _, v in ipairs(guis) do
						if v == back then
							ui.togglePage(false)
							return hideall()
						end
					end
				end
			end)

			local lastPage
			for i, v in ipairs(pages) do
				if v.hidden then continue end
				if not lastPage then lastPage = v end
				local this;

				this = ui:AddInstance("ImageButton", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = PALETTE.BTN_GREY,
				MouseButton1Click = framework.protected:GCProtect(function()
					local layout = ui:Get("PagesLayout").instance
						local closed = false

						if lastPage == v then
							closed = not ui.togglePage()
						else
							ui.togglePage(true)
						end

						layout:JumpTo(ui:Get(`Page_{v.name}`).instance)
						lastPage = v
						hideall()		

						if closed then return end
						show(this)
					end)

				}, ui:AddInstance("Frame", {
					Position = UDim2.fromScale(.5, .5),
					AnchorPoint = Vector2.new(.5, .5),
					Size = UDim2.fromScale(.65, .65),
					BackgroundColor3 = PALETTE.WHITE

				}, ui:AddInstance("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
						ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
					})
				}), ui:AddInstance("ImageLabel", {
					Position = UDim2.fromScale(.5, .5),
					AnchorPoint = Vector2.new(.5, .5),
					Size = UDim2.fromScale(.65, .65),
					ScaleType = Enum.ScaleType.Fit,
					BackgroundTransparency = 1,
					Image = v.image

				}), ui:AddInstance("UICorner", {
					CornerRadius = UDim.new(.3, 0)

				})), ui:AddInstance("UIAspectRatioConstraint", {
					AspectRatio = 1

				}), ui:AddInstance("UICorner", {
					CornerRadius = UDim.new(.25, 0)
				}))

				table.insert(child, this)
			end

			hideall()
			show(child[1])
			return child

		end), ui:AddInstance("ImageButton", {
			Position = UDim2.fromScale(.5, .9),
			AnchorPoint = Vector2.new(.5, 1),
			LayoutOrder = 999,
			Size = UDim2.fromScale(.5, 1),
			BackgroundColor3 = PALETTE.BTN_GREY,
			MouseButton1Click = function() ui.close() end,

		}, ui:AddInstance("Frame", {
			Position = UDim2.fromScale(.5, .5),
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.fromScale(.65, .65),
			BackgroundColor3 = PALETTE.BACKGROUND_2

		}, ui:AddInstance("ImageLabel", {
			Position = UDim2.fromScale(.5, .5),
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.fromScale(.65, .65),
			BackgroundTransparency = 1,
			Image = "rbxassetid://113576539925127"

		}), ui:AddInstance("UICorner", {
			CornerRadius = UDim.new(.3, 0)

		})), ui:AddInstance("UIAspectRatioConstraint", {
			AspectRatio = 1

		}), ui:AddInstance("UICorner", {
			CornerRadius = UDim.new(.25, 0)
		}))), ui:AddInstance("Frame", {
			Id = "Pages",

			Position = UDim2.fromScale(1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.fromScale(.885, 1)

		}, ui:AddInstance("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, PALETTE.MAIN_BLUE_START),
				ColorSequenceKeypoint.new(1, PALETTE.MAIN_BLUE_END)
			}),
			Transparency = NumberSequence.new(1, .25)

		}), ui:AddInstance("Frame", {
			Id = "InnerPages",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(.5, .5),
			Position = UDim2.fromScale(.5, .5),
			ClipsDescendants = true,
			Tags = { "Page" }

		}, ui:AddInstance("UIScale", {
			Id = "PagesScale",
			Scale = 1

		}), ui:AddInstance("UIPageLayout", {
			Id = "PagesLayout",

			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,

			ScrollWheelInputEnabled = false,
			GamepadInputEnabled = false,
			TouchInputEnabled = false,

			EasingStyle = Enum.EasingStyle.Quint,

		}), function()

			local child = {}
			for _, v in ipairs(pages) do
				-- create page
				table.insert(child, ui:AddInstance("Frame", {
					Id = `Page_{v.name}`,
					Visible = v.visible,

					Size = UDim2.fromScale(.95, .95),
					BackgroundTransparency = 1,
					Tags = { "Page" }

				}, v.content))
			end

			return child
		end)))

		ficon = ui:AddInstance("ImageButton", {
			BackgroundColor3 = Color3.fromHex("#000"),
			Position = UDim2.fromScale(.75, .75),
			Size = UDim2.fromScale(.125, .125),
			AnchorPoint = Vector2.new(.5, .5),
			BackgroundTransparency = .5,
			Visible = false

		}, ui:AddInstance("ImageLabel", {
			Image = "rbxassetid://91172716703830",
			Position = UDim2.fromScale(.5, .55),
			AnchorPoint = Vector2.new(.5, .5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(.55, .55),
			BackgroundTransparency = 1

		}), ui:AddInstance("UICorner", {
			CornerRadius = UDim.new(1, 0)

		}), ui:AddInstance("UIScale", {
			Id = "IconScale",
			Scale = 1

		}), ui:AddInstance("UIAspectRatioConstraint")):SetDraggable(true)

		swipeBar = ui:AddInstance("Frame", {
			Id = "SwipeBar",

			Size = UDim2.new(0, LINE_THICKNESS, .15),
			Position = UDim2.fromScale(0.01, .5),
			BackgroundColor3 = PALETTE.WHITE,
			AnchorPoint = Vector2.new(0, .5),
			BackgroundTransparency = .85

		}, ui:AddInstance("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}))

		task.defer(function() -- Settings button slots
			local players = framework.protected:GetService("Players")
			local localPlayer = players.LocalPlayer

			ui:Get("Username").instance.Text =
				`Hello, {localPlayer.DisplayName}!`

			local editor = framework.utils.inputs.editors:Get("Main_Editor")
			editor:SetHighlighterColors({
				local_property = Color3.fromRGB(119, 183, 255),  -- #77B7FF  main blue chiaro
				function_color = Color3.fromRGB(255, 198, 91),   -- warm gold, good contrast
				local_color    = Color3.fromRGB(223, 141, 255),  -- lavender, distinct from pink
				self_color     = Color3.fromRGB(96, 165, 250),   -- blu intermedio
				self_call      = Color3.fromRGB(119, 183, 255),  -- richiamo allo stesso blu del main
				operator       = Color3.fromRGB(248, 113, 113),  -- rosso acceso per gli operatori
				boolean        = Color3.fromRGB(251, 191, 36),   -- giallo/amber per true/false
				numbers        = Color3.fromRGB(16, 185, 129),   -- verde/teal per i numeri
				call           = Color3.fromRGB(48, 133, 255),   -- #3085FF per le chiamate
				comment        = Color3.fromRGB(148, 163, 184),  -- grigio testo (tipo slate-400)
				rbx            = Color3.fromRGB(185, 130, 255),  -- violet, good for Roblox types
				lua            = Color3.fromRGB(140, 255, 230),  -- turquoise, readable and distinct
				str            = Color3.fromRGB(119, 183, 255),  -- #77B7FF per le stringhe (molto leggibili)
				null           = Color3.fromRGB(90, 90, 90)      -- dark gray, subtle
			})

			--[[ 
			    CATEGORY: SERVER 
			]]
			ui:AddComponent("SettingButton", {
				Parent = ui:Get("SettingsList"),
				Category = "Server",
				Description = "Hop to another server.",
				Title = "Server Hop",
				LayoutOrder = 40,

				Callback = function()
					local delay = framework.settings:GetSetting("HopDelay")
					delay = math.max(delay or 0, 0) * 60
					local start = tick()

					repeat task.wait() until tick() - start > delay

					local servers = {}
					local req = framework.utils.http:Request(string.format(
						"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId))

					local body = framework.utils.http.json.decode(req.Body)
					if body and body.data then
						for i, v in next, body.data do
							if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers)
								and v.playing < v.maxPlayers and v.id ~= game.JobId then
								table.insert(servers, 1, v.id)
							end
						end
					end

					if #servers > 0 then
						cloneref(game:GetService("TeleportService"))
							:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], localPlayer)
					end
				end
			})

			ui:AddComponent("SettingNumeric", {
				Parent = ui:Get("SettingsList"),
				Category = "Server",
				Description = "Delay before server hop.",
				Title = "Hop Delay",
				LayoutOrder = 35,

				Max = 60,
				Min = 0,

				Value = framework.settings:GetSetting("HopDelay"),
				Callback = function(delay: number)
					framework.settings:SetSetting("HopDelay", delay)
				end
			})

			ui:AddComponent("SettingButton", {
				Parent = ui:Get("SettingsList"),
				Category = "Server",
				Description = "Rejoin this server instance.",
				Title = "Rejoin Server",
				LayoutOrder = 41,

				Callback = function()
					cloneref(game:GetService("TeleportService"))
						:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
				end
			})

			--[[ 
			    CATEGORY: PLAYER 
			    (Include: FPS, Anti AFK)
			]]
			ui:AddComponent("SettingDropdown", {
				Parent = ui:Get("SettingsList"),
				Category = "Player",
				LayoutOrder = 22,
				Description = "Change FPS limit.",
				Title = "FPS",

				Options = {
					{ Name = "15 FPS", Value = 15 },
					{ Name = "30 FPS", Value = 30 },
					{ Name = "60 FPS", Value = 60 },
					{ Name = "120 FPS", Value = 120 },
					{ Name = "144 FPS", Value = 144 },
					{ Name = "165 FPS", Value = 165 },
					{ Name = "UNLIMITED", Value = 0 }
				},

				Value = framework.settings:GetSetting("FpsCap"),
				Callback = function(cap: number)
					cap = math.max(cap, 0)
					framework.env.setfpscap(cap)
					framework.settings:SetSetting("FpsCap", cap)
				end
			})

			ui:AddComponent("SettingToggle", {
				Description = "Prevents AFK kicks.",
				Parent = ui:Get("SettingsList"),
				Category = "Player",
				Title = "Anti Afk",
				LayoutOrder = 10,

				Value = framework.settings:GetSetting("AntiAFK"),
				Callback = function(state: boolean)
					framework.settings:SetSetting("AntiAFK", state)
					if not state then return end

					local GC = framework.env.getconnections or framework.env.get_signal_cons

					if GC then
						for i,v in pairs(GC(localPlayer.Idled)) do
							if v["Disable"] then v["Disable"](v)
							elseif v["Disconnect"] then v["Disconnect"](v) end
						end
						return
					end

					local VirtualUser = framework.protected:GetService("VirtualUser")
					localPlayer.Idled:Connect(function()
						VirtualUser:CaptureController()
						VirtualUser:ClickButton2(Vector2.new())
					end)
				end
			})

			--[[ 
			    CATEGORY: EXECUTOR 
			    (Include: Auto Save, Auto Execute, UI Settings)
			]]
			ui:AddComponent("SettingToggle", {
				Parent = ui:Get("SettingsList"),
				Category = "Executor",
				Description = "Enables auto saving of tabs.",
				Title = "Auto Save Tabs",
				LayoutOrder = 21,

				Value = framework.settings:GetSetting("AutoSaveTabs"),
				Callback = function(state: boolean)
					framework.settings:SetSetting("AutoSaveTabs", state)
				end
			})

			ui:AddComponent("SettingToggle", {
				Parent = ui:Get("SettingsList"),
				Category = "Executor",
				Description = "Enables auto execution of files.",
				Title = "Auto Execute",
				LayoutOrder = 20,

				Value = framework.settings:GetSetting("AutoExecute"),
				Callback = function(state: boolean)
					framework.settings:SetSetting("AutoExecute", state)
				end
			})

			ui:AddComponent("SettingNumeric", {
				Parent = ui:Get("SettingsList"),
				Category = "Executor",
				Description = "Change opening icon size.",
				Title = "Icon Size",
				LayoutOrder = 31,

				Increment = 10,
				Max = 200,
				Min = 50,

				Value = framework.settings:GetSetting("IconSize"),
				Callback = function(val: number)
					framework.settings:SetSetting("IconSize", val)
					ui:Get("IconScale").instance.Scale = val / 100
				end
			})

			ui:AddComponent("SettingNumeric", {
				Parent = ui:Get("SettingsList"),
				Category = "Executor",
				Description = "Change the size of the pages",
				Title = "Page Size",
				LayoutOrder = 32,

				Increment = 10,
				Max = 100,
				Min = 50,

				Value = framework.settings:GetSetting("PageSize"),
				Callback = function(val: number)
					framework.settings:SetSetting("PageSize", val)
					ui:Get("PagesScale").instance.Scale = val / 100
				end
			})

			ui:AddComponent("SettingDropdown", {
				Parent = ui:Get("SettingsList"),
				Category = "Executor",
				Description = "Change UI opening method.",
				Title = "Opening Mode",
				LayoutOrder = 30,

				Options = {
					{ Name = "Icon", Value = 1 },
					{ Name = "Side Bar", Value = 2 },
					{ Name = "Small Icon", Value = 3 }
				},

				Value = framework.settings:GetSetting("OpeningMode"),
				Callback = function(mode: number)
					framework.settings:SetSetting("OpeningMode", mode)
				end
			})

			ui:AddComponent("SettingButton", {
				Parent = ui:Get("SettingsList"),
				Category = "Executor",
				Description = "Switch back to the legacy UI.",
				Title = "Old UI",
				LayoutOrder = 50,

				Callback = function()
					CODEX_FOLDERS.DATA:WriteFile("OldUI", "-- What u doing here? - SPDM Team")
					players.LocalPlayer:Kick("Rejoin the game to apply the changes.")
				end
			})

			framework.dependencies.allhub:ShowSettingsCat("Executor")
		end)

		do -- Editor
			local editor = framework.utils.inputs.editors:Get("Main_Editor")
			local addTab, tb = nil, ui:Get("Main_Editor").instance
			local saveTabs = nil

			tb:GetPropertyChangedSignal("Text"):Connect(framework.protected:GCProtect(function()
				local txt = editor:GetText()
				if selectedTab then
					selectedTab:GetData().Src = txt
					saveTabs()
				end
			end))

			-- Tabs
			local tabsdata = CODEX_FOLDERS.DATA:ReadJsonFile(EXPLOIT_CONFIGS.TABS_FILE) or framework.protected:GCProtect({})
			local tabs, list = framework.utils.inputs.tabs.new("1"), ui:Get("TabsList")--decided to add new id to get tabs object before defining them

			local tlist = ui:Get("TabsListLayout").instance
			tlist:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(framework.protected:GCProtect(function()
				list.instance.CanvasSize = UDim2.fromOffset(tlist.AbsoluteContentSize.X +LINE_THICKNESS *#list.instance:GetChildren(), 0)
			end))

			local sscriptslist: ScrollingFrame = ui:Get("SmallScriptsList").instance
			local sscriptslayout = ui:Get("SmallScriptsLayout").instance

			sscriptslayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(framework.protected:GCProtect(function()
				sscriptslist.CanvasSize = UDim2.fromOffset(0, sscriptslayout.AbsoluteContentSize.Y +LINE_THICKNESS *#list.instance:GetChildren())
			end))

			local scriptslist: ScrollingFrame = ui:Get("ScriptsList").instance
			local scriptslayout = ui:Get("ScriptsLayout").instance
			local allhub = framework.dependencies.allhub

			allhub:SetGui(ui)
			scriptslayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(framework.protected:GCProtect(function()
				scriptslist.CanvasSize = UDim2.fromOffset(0, scriptslayout.AbsoluteContentSize.Y +LINE_THICKNESS *#list.instance:GetChildren())
			end))

			scriptslist:GetPropertyChangedSignal("CanvasPosition"):Connect(LPH_NO_VIRTUALIZE(function()
				if allhub:GetMode() == "CloudScripts" and framework.utils.maths.floor(
					scriptslist.AbsoluteCanvasSize.Y -scriptslist.CanvasPosition.Y)
						== framework.utils.maths.floor(scriptslist.AbsoluteSize.Y)
				then
					allhub:CloudScripts()
				end
			end))

			local settingslist: ScrollingFrame = ui:Get("ScriptsList").instance
			local settingslayout = ui:Get("ScriptsLayout").instance

			settingslayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(framework.protected:GCProtect(function()
				settingslist.CanvasSize = UDim2.fromOffset(0, settingslayout.AbsoluteContentSize.Y +LINE_THICKNESS *#list.instance:GetChildren())
			end))

			saveTabs = framework.protected:GCProtect(function()
				if framework.settings:GetSetting("AutoSaveTabs") then
					CODEX_FOLDERS.DATA:WriteJsonFile(EXPLOIT_CONFIGS.TABS_FILE, tabsdata)
				end
			end)

			local refreshTabs = framework.protected:GCProtect(function(selectLast: boolean)
				for _, tab in pairs(tabs:GetAll()) do
					tab:Remove()
				end

				local l = #tabsdata
				if l < 1 then
					framework.utils.tables.insert(tabsdata, {})
				end

				for i, info in ipairs(tabsdata) do
					if not info.Name then
						info.Name = "Script " ..i
					end

					local tab = addTab(info, i)
					if selectLast then
						if i == l then
							tab:Select()
						end

					elseif i == 1 then
						local data = tab:GetData()
						if not data.Src or data.Src:gsub("[%s+]", "") == "" then
							data.Src = [[print("Hello World")]]
						end

						tab:Select()
					end
				end
			end)

			addTab = framework.protected:GCProtect(function(info: {any}, index: number)
				local btn = ui:AddComponent("ScriptTab", {
					LayoutOrder = index or #tabsdata,
					Text = info.Name
				})

				local tab = tabs:Add(btn, info)
				local sel = ui:AddComponent("SelectedTab", {
					LayoutOrder = index or #tabsdata,
					Text = info.Name,
					Visible = false,

					OnClose = function()
						framework.utils.tables.remove(tabsdata, index)
						refreshTabs(false)
					end
				})

				local tb, tl = sel.instance:FindFirstChildWhichIsA("TextBox"),
				btn.instance:FindFirstChildWhichIsA("TextLabel")

				tb.FocusLost:Connect(function()
					if tb.Text == "" then
						tb.Text = info.Name
						return
					end

					info.Name = tb.Text
					tl.Text = info.Name
					saveTabs()
				end)

				tab.selected = sel
				sel:SetParent(list)
				btn:SetParent(list)
				return tab
			end)

			ui:Get("NewTab").instance.MouseButton1Click:Connect(framework.protected:GCProtect(function()
				framework.utils.tables.insert(tabsdata, {})
				refreshTabs(true)
			end))

			tabs.OnTabSelected:Connect(framework.protected:GCProtect(function(tab: {any}, previous: {any})
				selectedTab = tab

				if previous and previous.selected.instance then
					local data = previous:GetData()
					data.Src = editor:GetText()

					previous.selected.instance.Visible = false
					previous.button.instance.Visible = true
					task.spawn(saveTabs)
				end

				local data = tab:GetData()
				editor:SetText(data.Src or "")

				tab.selected.instance.Visible = true
				tab.button.instance.Visible = false
			end))

			tabs.OnTabRemoved:Connect(framework.protected:GCProtect(function(tab: {any})
				tab.selected:Remove()
				tab.button:Remove()
				saveTabs()
			end))

			allhub.OnNewTab:Connect(function(name, src)
				framework.utils.tables.insert(tabsdata, {
					Name = name, Src = src})

				refreshTabs(true)
			end)

			refreshTabs(false)
			framework.execution.OnExecuted:Connect(framework.protected:GCProtect(function()
				popups.notify("Script Executed!")
			end))
		end

		local tween = tweeninfo()
		ui.isPageOpen = true
		ui.isOpen = false

		ui.close = framework.protected:GCProtect(function()
			swipeBar:Tween(tween, {
				Position = UDim2.new(.01, 0, .5, 0)
			})

			ui.toggle(false):Wait()
			local mode = framework.settings
				:GetSetting("OpeningMode")

			if mode ~= 2 then
				ficon.toggle(true)
			end

			return mode
		end)

		ui.toggle = framework.protected:GCProtect(function(status: boolean): Tween
			local s = status
			if status then
				s = ui.isPageOpen
			end

			ui:Get("Pages"):Tween(tween, {
				AnchorPoint = Vector2.new(s and 1 or 0, 0)
			})

			if framework.settings:GetSetting("OpeningMode") == 2 then
				local closed = not status

				swipeBar:Tween(tweeninfo(1,1), {
					BackgroundTransparency = closed and .85 or 1
				})
				swipeBar.instance.Visible = closed -- giusto?
			end 

			ui.isOpen = status
			return ui:Get("SideBar"):Tween(tween, {
				AnchorPoint = Vector2.new(status and 0 or 1, 0)
			}).Completed
		end)

		ui.togglePage = framework.protected:GCProtect(function(status: boolean): Tween
			if status == nil then status = not ui.isPageOpen end
			ui:Get("Pages"):Tween(tween, {
				AnchorPoint = Vector2.new(status and 1 or 0, 0)
			})

			ui.isPageOpen = status
			ui:Get("SideBar"):Tween(tween, {
				AnchorPoint = Vector2.new(0, 0)
			})

			return status
		end)

		ficon._original = ficon._original or {
			Size     = ficon.instance.Size,
			Position = ficon.instance.Position,
			Anchor   = ficon.instance.AnchorPoint,
			Parent   = ficon.instance.Parent
		}

		local ficonSize = ficon.instance.Size
		local lastMode = 1

		local ts = framework.protected:GetService("TweenService")
		local ScreenGui = ui:Get("Main").instance.Parent

		local particleCount = 50
		local mainColors = {
			Color3.fromRGB(42, 49, 61),
			Color3.fromRGB(123, 188, 232),
			Color3.fromRGB(78, 120, 163),
			Color3.fromRGB(71, 85, 109),
			Color3.fromRGB(27, 30, 37)
		}

		local function getRandomColor()
			return mainColors[math.random(1, #mainColors)]
		end

		local spawnParticle = function(i, status, iconCenter)
			local particle = Instance.new("Frame")
			local size     = math.random(6, 30)
			particle.Size             = UDim2.new(0, size, 0, size)
			particle.BackgroundColor3 = getRandomColor()
			particle.BackgroundTransparency = 0
			particle.AnchorPoint      = Vector2.new(0.5, 0.5)
			particle.ZIndex           = 10
			particle.Parent           = ScreenGui

			local uiCorner = Instance.new("UICorner", particle)
			uiCorner.CornerRadius = UDim.new(0.5, 0)

			-- spawn sparso
			local sx = math.random(0, ScreenGui.AbsoluteSize.X - size)
			local sy = math.random(0, ScreenGui.AbsoluteSize.Y - size)
			particle.Position = UDim2.new(0, sx, 0, sy)

			-- definisco target e durata
			local targetPos, duration, easing
			if status then
				-- accumulo verso centro ficon
				targetPos = UDim2.new(0, iconCenter.X, 0, iconCenter.Y)
				duration  = math.random(1, 2) + i*0.02
				easing    = Enum.EasingStyle.Quad
			else
				-- classico movimento casuale full-screen
				local ex = math.random(0, ScreenGui.AbsoluteSize.X - size)
				local ey = math.random(0, ScreenGui.AbsoluteSize.Y - size)
				targetPos = UDim2.new(0, ex, 0, ey)
				duration  = math.random(1, 3)
				easing    = Enum.EasingStyle.Sine
			end

			-- tween di movimento + fade + riduzione size
			local tweenInfo = TweenInfo.new(
				duration,
				easing,
				Enum.EasingDirection.Out
			)
			local tween = ts:Create(particle, tweenInfo, {
				Position               = targetPos,
				BackgroundTransparency = 1,
				Size                   = UDim2.new(0, 0, 0, 0)
			})
			tween:Play()
			tween.Completed:Connect(function()
				particle:Destroy()
			end)
		end

		do
			local DEBUG_MODE = false
			local AUTH_KEY_URL = "https://key.codex.lol"
			local AUTH_REGISTER_URL = "https://key.codex.lol/sign-up"

			local overlay = ui:Get("AuthOverlay").instance
			local overlayDismiss = ui:Get("AuthOverlayDismiss").instance
			local authCard = ui:Get("AuthCard").instance
			local authCardScale = ui:Get("AuthCardScale").instance
			local authClose = ui:Get("AuthCloseButton").instance

			local userField = ui:Get("AuthUserField").instance
			local passField = ui:Get("AuthPassField").instance
			local userStroke = ui:Get("AuthUserStroke").instance
			local passStroke = ui:Get("AuthPassStroke").instance

			local userBox = ui:Get("AuthUserBox").instance
			local passBox = ui:Get("AuthPassBox").instance

			local loginBtn = ui:Get("AuthLoginButton").instance
			local loginText = ui:Get("AuthLoginText").instance
			local loginGradient = ui:Get("AuthLoginGradient").instance
			local loginScale = ui:Get("AuthLoginScale").instance
			local registerBtn = ui:Get("AuthRegisterButton").instance

			local startBtn = ui:Get("KeyStartButton").instance
			local startLabel = ui:Get("KeyStartLabel").instance
			local startScale = ui:Get("KeyStartScale").instance

			local upgradeBtn = ui:Get("KeyUpgradeButton").instance
			local upgradeScale = ui:Get("KeyUpgradeScale").instance

			local keyStatus = ui:Get("KeyStatusText").instance
			local keySubStatus = ui:Get("KeySubStatusText").instance
			local authFeedback = ui:Get("AuthFeedback").instance

			local authState = {
				loading = false,
				overlayOpen = false,
				pulseToken = 0,
				focused = { user = false, pass = false }
			}

			local debugIndex = 0
			local activeDebugCase = nil
			local lastInputPosition = nil

			local DEBUG_CASES = {
				{
					name = "DEBUG #1 Â· Login success",
					start = { auth = false, logged = false },
					loginSuccess = true,
					postLogin = { auth = true, logged = true }
				},
				{
					name = "DEBUG #2 Â· Login fail",
					start = { auth = false, logged = false },
					loginSuccess = false
				},
				{
					name = "DEBUG #3 Â· Logged but no valid sub",
					start = { auth = false, logged = true }
				}
			}

			local function trim(text: string)
				return (text:gsub("^%s+", ""):gsub("%s+$", ""))
			end

			local function nextDebugCase()
				debugIndex = (debugIndex % #DEBUG_CASES) + 1
				activeDebugCase = DEBUG_CASES[debugIndex]
				return activeDebugCase
			end

			local function performStartProbe()
				if not DEBUG_MODE then
					return exploit:IsAuthenticated()
				end

				local info = nextDebugCase()
				task.wait(.7)
				return info.start.auth, info.start.logged, info.name
			end

			local function performLoginRequest(username: string, password: string)
				if not DEBUG_MODE then
					return exploit:Login(username, password)
				end

				task.wait(1.05)
				local info = activeDebugCase or nextDebugCase()
				return info.loginSuccess == true
			end

			local function performPostLoginProbe()
				if not DEBUG_MODE then
					return exploit:IsAuthenticated()
				end

				task.wait(.65)
				local info = activeDebugCase or nextDebugCase()
				local state = info.postLogin or info.start
				return state.auth, state.logged, info.name
			end

			local function setKeyState(text: string, sub: string?, kind: string?)
				keyStatus.Text = text
				keySubStatus.Text = sub or ""
				keyStatus.TextColor3 = kind == "error" and PALETTE.FADED_RED or PALETTE.WHITE
			end

			local function setFeedback(text: string, kind: string?)
				authFeedback.Text = text
				authFeedback.TextColor3 =
					kind == "error" and PALETTE.FADED_RED
					or kind == "success" and PALETTE.WHITE
					or PALETTE.TEXT_SECONDARY
			end

			local function buttonPop(scaleObj: UIScale)
				ts:Create(scaleObj, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Scale = .975
				}):Play()

				task.delay(.1, function()
					ts:Create(scaleObj, TweenInfo.new(.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1
					}):Play()
				end)
			end

			local function getBurstCenter(target: GuiObject, inputPos: Vector3?)
				if inputPos then
					return Vector2.new(inputPos.X, inputPos.Y)
				end
				local pos = target.AbsolutePosition
				local size = target.AbsoluteSize
				return Vector2.new(pos.X + size.X * .5, pos.Y + size.Y * .5)
			end

			local function emitAuthBurst(target: GuiObject, inputPos: Vector3?, count: number?, radius: number?, boost: number?)
				count = count or 12
				radius = radius or 90
				boost = boost or 1

				local shortSide = math.min(ScreenGui.AbsoluteSize.X, ScreenGui.AbsoluteSize.Y)
				local mobileBoost = shortSide <= 850 and 1.15 or 1
				local center = getBurstCenter(target, inputPos)

				for _ = 1, count do
					task.spawn(function()
						local particle = Instance.new("Frame")
						local size = math.random(12, 24) * boost * mobileBoost

						particle.AnchorPoint = Vector2.new(.5, .5)
						particle.Size = UDim2.fromOffset(size, size)
						particle.Position = UDim2.fromOffset(center.X, center.Y)
						particle.BackgroundColor3 = getRandomColor()
						particle.BackgroundTransparency = .04
						particle.BorderSizePixel = 0
						particle.ZIndex = 65
						particle.Rotation = math.random(-55, 55)
						particle.Parent = ScreenGui

						local corner = Instance.new("UICorner")
						corner.CornerRadius = UDim.new(.35, 0)
						corner.Parent = particle

						local angle = math.rad(math.random(0, 360))
						local distance = math.random(radius * .45, radius) * mobileBoost
						local targetPos = Vector2.new(
							center.X + math.cos(angle) * distance,
							center.Y + math.sin(angle) * distance
						)

						local tween = ts:Create(
							particle,
							TweenInfo.new(0.62 + math.random() * 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
							{
								Position = UDim2.fromOffset(targetPos.X, targetPos.Y),
								BackgroundTransparency = 1,
								Size = UDim2.fromOffset(size * .22, size * .22),
								Rotation = particle.Rotation + math.random(-120, 120)
							}
						)

						tween:Play()
						tween.Completed:Connect(function()
							particle:Destroy()
						end)
					end)
				end
			end

			local function setFieldVisual(root: Frame, stroke: UIStroke, mode: string)
				local bgColor = PALETTE.BACKGROUND_2
				local strokeColor = PALETTE.STROKE
				local strokeTransparency = .15
				local thickness = LINE_THICKNESS

				if mode == "focus" then
					bgColor = PALETTE.BTN_GREY
					strokeColor = PALETTE.MAIN_BLUE_START
					strokeTransparency = 0
					thickness = LINE_THICKNESS * 1.4
				elseif mode == "error" then
					bgColor = PALETTE.DARK_FADED_RED
					strokeColor = PALETTE.FADED_RED
					strokeTransparency = 0
					thickness = LINE_THICKNESS * 1.4
				end

				ts:Create(root, TweenInfo.new(.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = bgColor
				}):Play()

				ts:Create(stroke, TweenInfo.new(.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Color = strokeColor,
					Transparency = strokeTransparency,
					Thickness = thickness
				}):Play()
			end

			local function shake(root: GuiObject, magnitude: number?, duration: number?)
				magnitude = magnitude or math.max(8, LINE_THICKNESS * 4)
				duration = duration or .28

				local original = root.Position
				local offsets = {
					UDim2.fromOffset(-magnitude, 0),
					UDim2.fromOffset(magnitude, 0),
					UDim2.fromOffset(-magnitude * .7, 0),
					UDim2.fromOffset(magnitude * .7, 0),
					UDim2.fromOffset(-magnitude * .35, 0),
					UDim2.fromOffset(0, 0),
				}

				for _, offset in ipairs(offsets) do
					local tween = ts:Create(
						root,
						TweenInfo.new(duration / #offsets, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
						{ Position = original + offset }
					)
					tween:Play()
					tween.Completed:Wait()
				end

				root.Position = original
			end

			local function refreshIdleFieldStates()
				setFieldVisual(userField, userStroke, authState.focused.user and "focus" or "idle")
				setFieldVisual(passField, passStroke, authState.focused.pass and "focus" or "idle")
			end

			local function openOverlay()
				if authState.overlayOpen then return end

				authState.overlayOpen = true
				overlay.Visible = true
				overlay.GroupTransparency = 1
				authCard.Position = UDim2.fromScale(.5, .53)
				authCardScale.Scale = .965

				setFeedback("Use your Codex account credentials.")
				refreshIdleFieldStates()

				ts:Create(overlay, TweenInfo.new(.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					GroupTransparency = 0
				}):Play()

				ts:Create(authCard, TweenInfo.new(.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.fromScale(.5, .5)
				}):Play()

				ts:Create(authCardScale, TweenInfo.new(.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Scale = 1
				}):Play()
			end

			local function closeOverlay(successFx: boolean?)
				if not authState.overlayOpen then return end

				authState.overlayOpen = false

				if successFx then
					emitAuthBurst(loginBtn, lastInputPosition, 14, 100, 1.02)
				end

				local fadeTween = ts:Create(
					overlay,
					TweenInfo.new(.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ GroupTransparency = 1 }
				)

				ts:Create(authCard, TweenInfo.new(.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.fromScale(.5, .53)
				}):Play()

				ts:Create(authCardScale, TweenInfo.new(.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Scale = .98
				}):Play()

				fadeTween:Play()
				fadeTween.Completed:Connect(function()
					if not authState.overlayOpen then
						overlay.Visible = false
					end
				end)
			end

			local function setLoginLoading(state: boolean)
				authState.loading = state
				authState.pulseToken += 1

				local token = authState.pulseToken
				loginBtn.Active = not state
				authClose.Active = not state
				overlayDismiss.Active = not state
				registerBtn.Active = not state
				upgradeBtn.Active = not state

				if state then
					loginText.Text = "LOGGING IN..."
					setFeedback("Authorizing session...")

					task.spawn(function()
						while authState.loading and authState.pulseToken == token do
							local a = ts:Create(loginScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Scale = 1.02 })
							local b = ts:Create(loginGradient, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Rotation = 108 })
							a:Play() b:Play()
							a.Completed:Wait()

							if not authState.loading or authState.pulseToken ~= token then break end

							local c = ts:Create(loginScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Scale = 1 })
							local d = ts:Create(loginGradient, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Rotation = 90 })
							c:Play() d:Play()
							c.Completed:Wait()
						end
					end)
				else
					loginText.Text = "LOGIN"
					loginScale.Scale = 1
					loginGradient.Rotation = 90
				end
			end

			local function unlockUI(source: GuiObject?, show: boolean)
				if source then
					emitAuthBurst(source, lastInputPosition, 16, 120, 1.08)
				end

				if DEBUG_MODE then
					ui:Get("ExpiringBar").instance.Size = UDim2.fromScale(1, 1)
				end

				setKeyState("Subscription verified", "Codex unlocked successfully.", "success")
				popups.notify(DEBUG_MODE and "DEBUG: Auth success." or "Authentication successful.")
				
				if show then ui.togglePage(show) end
				ui:Get("PagesLayout").instance:JumpTo(ui:Get("Page_Home").instance)

				-- Auto execute
				if framework.settings:GetSetting("AutoExecute") then
					framework.dependencies.scripthub:AutoExecute()

					for _, file in ipairs(ARCEUS_FOLDERS.AUTOEXECUTE:ListFiles()) do
						framework.execution:Execute(framework.storage.readFile(nil, file))
					end
				end
			end

			local function failFields(...)
				local targets = { ... }
				for _, info in ipairs(targets) do
					setFieldVisual(info.root, info.stroke, "error")
					task.spawn(shake, info.root)
				end
				task.delay(.65, refreshIdleFieldStates)
			end
			
			local function checkAuth(ui: boolean)
				local auth, logged = performPostLoginProbe()
				setLoginLoading(false)

				if auth and logged then
					closeOverlay(true)
					unlockUI(loginBtn, ui)
				elseif logged and not auth then
					closeOverlay(true)
					setKeyState("Account linked", "No active key found for this account.", "error")
				elseif ui then
					setFeedback("Authentication state invalid.", "error")
					failFields(
						{ root = userField, stroke = userStroke },
						{ root = passField, stroke = passStroke }
					)
				end
			end

			local function submitLogin()
				if authState.loading then return end

				local username = trim(userBox.Text or "")
				local password = trim(passBox.Text or "")

				if username == "" or password == "" then
					setFeedback("Missing credentials.", "error")
					failFields(
						{ root = userField, stroke = userStroke },
						{ root = passField, stroke = passStroke }
					)
					return
				end

				buttonPop(loginScale)
				emitAuthBurst(loginBtn, lastInputPosition, 10, 48, .95)
				setLoginLoading(true)

				local success = performLoginRequest(username, password)
				if not success then
					setLoginLoading(false)
					setFeedback("Login failed.", "error")
					failFields(
						{ root = userField, stroke = userStroke },
						{ root = passField, stroke = passStroke }
					)
					return
				end

				checkAuth(true)
			end

			local function trackInput(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					lastInputPosition = input.Position
				end
			end

			local function isPointInsideAuthCard(point: Vector3 | Vector2)
				local pos = authCard.AbsolutePosition
				local size = authCard.AbsoluteSize

				local x = point.X
				local y = point.Y

				return x >= pos.X
					and x <= pos.X + size.X
					and y >= pos.Y
					and y <= pos.Y + size.Y
			end

			startBtn.InputBegan:Connect(trackInput)
			loginBtn.InputBegan:Connect(trackInput)
			authClose.InputBegan:Connect(trackInput)
			registerBtn.InputBegan:Connect(trackInput)
			upgradeBtn.InputBegan:Connect(trackInput)

			userBox.InputBegan:Connect(trackInput)
			passBox.InputBegan:Connect(trackInput)
			userField.InputBegan:Connect(trackInput)
			passField.InputBegan:Connect(trackInput)
			authCard.InputBegan:Connect(trackInput)

			overlayDismiss.MouseButton1Click:Connect(function()
				if authState.loading then
					return
				end

				if lastInputPosition and isPointInsideAuthCard(lastInputPosition) then
					return
				end

				closeOverlay(false)
			end)

			userBox.Focused:Connect(function()
				authState.focused.user = true
				refreshIdleFieldStates()
			end)

			userBox.FocusLost:Connect(function(enterPressed)
				authState.focused.user = false
				refreshIdleFieldStates()
				if enterPressed then
					passBox:CaptureFocus()
				end
			end)

			passBox.Focused:Connect(function()
				authState.focused.pass = true
				refreshIdleFieldStates()
			end)

			passBox.FocusLost:Connect(function(enterPressed)
				authState.focused.pass = false
				refreshIdleFieldStates()
				if enterPressed then
					submitLogin()
				end
			end)

			startBtn.MouseButton1Click:Connect(function()
				if authState.loading then return end

				buttonPop(startScale)
				emitAuthBurst(startBtn, lastInputPosition, 12, 72, 1.02)

				startLabel.Text = "CHECKING..."
				setKeyState("Checking session", "Please wait...", nil)

				local auth, logged = performStartProbe()
				startLabel.Text = "START"

				if not logged then
					setKeyState("Login required", "Open the sign-in popup to continue.", "error")
					openOverlay()
				elseif logged and not auth then
					setKeyState("No active key", "No valid subscription found.", "error")
				else
					unlockUI(startBtn)
				end
			end)

			loginBtn.MouseButton1Click:Connect(submitLogin)

			registerBtn.MouseButton1Click:Connect(function()
				if authState.loading then return end
				emitAuthBurst(registerBtn, lastInputPosition, 8, 44, .82)
			end)

			upgradeBtn.MouseButton1Click:Connect(function()
				if authState.loading then return end
				emitAuthBurst(upgradeBtn, lastInputPosition, 8, 44, .82)
			end)

			authClose.MouseButton1Click:Connect(function()
				if not authState.loading then
					closeOverlay(false)
				end
			end)

			refreshIdleFieldStates()
			setKeyState("Ready", "Press START to begin.")
			task.defer(checkAuth)
		end

		ficon.toggle = framework.protected:GCProtect(function(status: boolean): Tween
			--ficon.instance.Visible = true
			--[[return ficon:Tween(tween, {
				Size = status and UDim2.fromScale(
					.125, .125) or UDim2.fromScale(0, 0),
				Visible = status
			}).Completed]]

			local openingMode = framework.settings:GetSetting("OpeningMode")
			if status and openingMode == 2 then return end

			-- === SMALLICON: piccola icona in alto a sinistra, dimensione tipo TopBar ===
			if openingMode == 3 then
				if lastMode == 1 then
					local GuiService = framework.protected:GetService("GuiService")
					local inset      = GuiService:GetGuiInset() -- Vector2 (left/top safe area)

					-- stimiamo dimensione in base alla fascia top (desktop ~36px)
					local TOPBAR_H = math.max(28, inset.Y) -- fallback se inset.Y = 0
					local PADDING  = 6
					local ICON_PX  = math.max(20, TOPBAR_H - (PADDING * 2))

					-- piccolo offset per evitare le icone Roblox a sinistra
					local LEFT_SAFE = 90  -- aumenta se hai piÃ¹ pulsanti
					local LEFT_PAD  = 6
					local TOP_PAD   = 0

					-- applichiamo layout top-left
					ui:Get("IconScale").instance.Scale = 1
					ficon.instance.Parent      = ScreenGui
					ficon.instance.AnchorPoint = Vector2.new(0, 0)
					ficon.instance.Position    = UDim2.new(0, inset.X + LEFT_SAFE + LEFT_PAD, 0, inset.Y + TOP_PAD)--UDim2.new(0, inset.X + LEFT_SAFE + LEFT_PAD, 0, inset.Y + TOP_PAD)
					ficonSize                  = UDim2.fromOffset(ICON_PX, ICON_PX)
				end
			elseif lastMode == 3 then
				-- modalitÃ  ICON (o altro diverso da 1/2): layout originale
				ui:Get("IconScale").instance.Scale =
					framework.settings:GetSetting("IconSize")/100 or 1

				ficon.instance.Parent      = ficon._original.Parent
				ficon.instance.AnchorPoint = ficon._original.Anchor
				ficon.instance.Position    = ficon._original.Position
				ficonSize                  = ficon._original.Size
			end

			-- Se apro l'interfaccia, mostro subito la ficon e parto da size 0
			lastMode = openingMode
			if status then
				ficon.instance.Size    = UDim2.fromScale(0, 0)
				ficon.instance.Visible = true
			end

			-- Posizione del centro di ficon in coordinate di ScreenGui
			local iconCenterAbs = ficon.instance.AbsolutePosition + ficon.instance.AbsoluteSize/2
			local iconCenter = Vector2.new(
				iconCenterAbs.X - ScreenGui.AbsolutePosition.X,
				iconCenterAbs.Y - ScreenGui.AbsolutePosition.Y
			)

			-- spawn, con delay solo in caso di accumulo per fluiditÃ 
			for i = 1, particleCount do
				if status then
					task.delay(i * 0.03, function()
						spawnParticle(i, status, iconCenter) end)
				else
					spawnParticle(i, status, iconCenter)
				end
			end

			wait(0.35)

			-- infine la tween di ficon (uguale alla tua, con ficonSize deciso dalla modalitÃ )
			return ficon:Tween(tween, {
				Size    = status and ficonSize or UDim2.fromScale(0, 0),
				Visible = status
			}).Completed
		end)

		if ui.close() == 2 then
			for i = 1, particleCount do
				task.delay(i * 0.03, function() spawnParticle(i) end)
			end
		end

		do
			local holdable = framework.utils.inputs.buttons.holdable(ficon)
			holdable.OnShortPress:Connect(framework.protected:GCProtect(function()
				ficon.toggle(false):Wait()
				ui.toggle(true)
			end))
		end

		do -- Swipe
			local UserInputService = framework.protected:GetService("UserInputService")
			local RunService = framework.protected:GetService("RunService")
			local startPosition, startOffset
			local isDragging = false

			swipeBar.instance.Visible = framework.settings:GetSetting("OpeningMode") == 2
			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed or framework.settings:GetSetting("OpeningMode") ~= 2 then 
					swipeBar.instance.Visible = false
					swipeBar.instance.BackgroundTransparency = 1
					return
				end

				if ui.isOpen and ui.isPageOpen then return end
				local parent = main.instance.Parent
				local bar = ui:Get("SideBar")

				swipeBar.instance.Visible = true
				swipeBar.instance.BackgroundTransparency = .85
				swipeBar.instance.Position = UDim2.new(.01, ui.isOpen
					and bar.instance.AbsoluteSize.X or 0, .5, 0)

				local maxY = parent.AbsoluteSize.Y
				local maxX = parent.AbsoluteSize.X *(ui.isOpen
					and bar.instance.Size.X.Scale +.02 or .02)

				local inside = framework.utils.maths.isWithin2DBounds(
					input.Position, Vector2.new(ui.isOpen
						and bar.instance.AbsoluteSize.X or 0, 0),
					Vector2.new(maxX, maxY))

				if (input.UserInputType == Enum.UserInputType.MouseButton1 or
					input.UserInputType == Enum.UserInputType.Touch) and inside then
					isDragging = true;

					swipeBar.instance.Position = UDim2.new(0, input.Position.X, 0.5, 0)
					swipeBar.instance.BackgroundColor3 = PALETTE.MAIN_BLUE_START
					swipeBar.instance.BackgroundTransparency = 0

					local maxDrag = main.instance.Parent.AbsoluteSize.X * 0.13
					bar.instance.AnchorPoint = Vector2.new(1 - math.clamp(input.Position.X / maxDrag, 0, 1), 0)

					startPosition, startOffset = input.Position.X, input.Position.X - swipeBar.instance.AbsolutePosition.X;
					local endedConn; endedConn = input.Changed:Connect(function(property)
						if input.UserInputState == Enum.UserInputState.End then
							isDragging = false;

							endedConn:Disconnect();
							ui.toggle(input.Position.X > 40)
							swipeBar.instance.BackgroundColor3 = PALETTE.WHITE
							swipeBar.instance.Position = UDim2.new(
								.01, ui.isOpen and bar.instance.AbsoluteSize.X or 0, .5, 0)
						end
					end);
				end
			end)

			UserInputService.InputChanged:Connect(function(input, gameProcessed)
				if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local maxDrag = main.instance.Parent.AbsoluteSize.X * 0.13

					swipeBar.instance.Position = UDim2.new(0, math.min(
						input.Position.X, maxDrag), .5, 0)

					swipeBar.instance.BackgroundColor3 = PALETTE.MAIN_BLUE_START
					swipeBar.instance.BackgroundTransparency = 0

					local bar = ui:Get("SideBar").instance
					bar.AnchorPoint = Vector2.new(1 -math.clamp(
						input.Position.X /maxDrag, 0, 1), 0)
				end
			end)

			--[[ local UserInputService = framework.protected:GetService("UserInputService")
			local RunService = framework.protected:GetService("RunService")
			local swipeStart = nil
			local swipeEnd = nil

			swipeBar.instance.Visible = framework.settings:GetSetting("OpeningMode") == 2
			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed or framework.settings:GetSetting("OpeningMode") ~= 2 then 
					swipeBar.instance.Visible = false
					return
				end

				swipeBar.instance.Visible = true
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					local screenSize = workspace.CurrentCamera.ViewportSize
					local bottomBound = screenSize.Y *.65
					local rightBound = screenSize.X *.05
					local leftBound = -screenSize.X *.3
					local topBound = screenSize.Y *.35

					local pos = input.Position
					if pos.X >= leftBound and pos.X <= rightBound and pos.Y >= topBound and pos.Y <= bottomBound then
						swipeStart = input.Position
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input, gameProcessed)
				if swipeBar.instance.Visible then gameProcessed = false end
				if gameProcessed or not swipeStart then return end

				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					swipeEnd = input.Position
					local delta = swipeEnd - swipeStart
					if delta.X > 150 and math.abs(delta.Y) < 150 then
						ui.toggle(true)
					end

					swipeBar.instance.Visible = false
					swipeStart = nil
					swipeEnd = nil
				end
			end) ]]
		end

		task.spawn(function()
			local RunService = framework.protected:GetService("RunService")
			local fps2 = ui:Get("FPS_Label2").instance

			while true do
				local f = framework.utils.maths.round(
					1 / RunService.RenderStepped:Wait()
				)
				fps2.Text = `You currently have {f} FPS`
				task.wait(1)
			end
		end)

		--ui.toggle(false)
		return ui
	end

	function exploit:LoadUrl(url: string, retries: number)
		retries = retries or 3
		local res, c = nil, 0

		repeat
			if res ~= nil then
				c += 1
				if retries > 0 and c > retries then
					break
				end

				task.wait(2)
			end

			res = framework.utils.http:Request(url)
		until res

		return res
	end

	framework.dependencies:Add("exploit", framework.protected:ProtectTable(exploit))
end

do -- KeySystem
	local name, ver = framework.env.identifyexecutor()
	local isStudio = framework.protected:IsStudio()

	-- Check for exploit identity
	if not isStudio then
		if not name or not ver then
			return
		end

		local found = name:lower():find(EXPLOIT_CONFIGS.EXPLOIT_IDENTITY:lower())
		if not found then
			return
		end
	else
		-- Check if its authorized to run in studio
		local succ, err = pcall(function()
			if script.Auth.Value == EXPLOIT_CONFIGS.FILES_KEY then
				return true
			end

			return false
		end)

		if not succ or not err then
			return framework.console.error("Missing Authorization")
		end
	end

	-- Build UI
	local exploit = framework.dependencies.exploit
	local ui = exploit:InitUI()
	ui:SetEnabled(true)

	do
		local Players = framework.protected:GetService("Players")
		local expirationTickerRunning = false

		local function bindExpirationTicker()
			if expirationTickerRunning then
				return
			end

			expirationTickerRunning = true

			task.spawn(function()
				local function getTimeLeft()
					return exploit:GetExpiration() - os.time()
				end

				local function formatTimeLeft(timeLeft: number)
					if timeLeft <= 0 then
						return "Expired"
					elseif timeLeft < 60 then
						return framework.utils.strings.format("%ds", timeLeft)
					else
						local days = framework.utils.maths.floor(timeLeft / 86400)
						local hours = framework.utils.maths.floor((timeLeft % 86400) / 3600)
						local minutes = framework.utils.maths.floor((timeLeft % 3600) / 60)

						local timeStr = ""
						if days > 0 then
							timeStr = framework.utils.strings.format("%dd ", days)
						end
						if hours > 0 then
							timeStr ..= framework.utils.strings.format("%dh ", hours)
						end
						if minutes > 0 or hours > 0 or days > 0 then
							timeStr ..= framework.utils.strings.format("%dm", minutes)
						end
						return timeStr
					end
				end

				while true do
					local timeLeft = getTimeLeft()

					if timeLeft <= 0 then
						ui:Get("Expiring_Label").instance.Text = "No active key"
						ui:Get("ExpiringBar").instance.Size = UDim2.fromScale(0, 1)
						expirationTickerRunning = false
						break
					end

					ui:Get("Expiring_Label").instance.Text = `Key expires in: {formatTimeLeft(timeLeft)}`
					ui:Get("ExpiringBar").instance.Size = UDim2.fromScale(
						math.clamp(timeLeft / 86400, 0, 1),
						1
					)

					task.wait(
						timeLeft > 86400 and 3600
							or timeLeft > 3600 and 60
							or 1
					)
				end
			end)
		end

		exploit.OnAuthenticated:Connect(function()
			bindExpirationTicker()
		end)

		-- ui:Get("Expiring_Label").instance.Text = "No active key"
		ui:Get("ExpiringBar").instance.Size = UDim2.fromScale(0, 1)

		if not isStudio then
			ui.init()
		end
	end

	-- Animations
	-- Wave a cascata chiara con staggered reale, migliorata senza cambiare parametri
	do

		local authCircle = ui:Get("AuthCircle")
		task.spawn(function()
			local ts = framework.protected:GetService("TweenService")

			local function getElements()
				local elems = { authCircle.instance }
				for _, desc in ipairs(authCircle.instance:GetDescendants()) do
					if desc:IsA("Frame") then
						table.insert(elems, desc)
					end
				end
				return elems
			end

			local function getCenter()
				return authCircle.instance.AbsolutePosition + authCircle.instance.AbsoluteSize / 2
			end

			local function distanceFromCenter(frame, center)
				local pos = frame.AbsolutePosition + frame.AbsoluteSize / 2
				return (Vector2.new(pos.X, pos.Y) - Vector2.new(center.X, center.Y)).Magnitude
			end

			local baseTrans = {}
			local animating = {}
			local lastSnapshot = {}

			-- parametri (lasciati come li hai)
			local nominalWaveTravel = 1.0      -- tempo totale perchÃ© l'onda arrivi all'esterno
			local pauseAfter = 0.20            -- pausa tra start consecutivi dei cerchi
			local peakHold = .1               -- hold sul picco
			local scalePulseEnabled = true     -- distingue ogni cerchio con un accenno di scala

			local function animate(el, origTrans, origSize)
				if animating[el] then
					return
				end
				animating[el] = true

				-- protezione: se l'elemento Ã¨ stato rimosso, esci
				if not el or not el.Parent then
					animating[el] = false
					return
				end

				-- tempi con variazione leggera
				local fadeOutTime = 0.4 + (math.random() - 0.5) * 0.08
				local fadeInTime = 0.5 + (math.random() - 0.5) * 0.08
				local pulseFactor = 1.04 + (math.random() - 0.5) * 0.02  -- piccola variazione per distinzione

				local tweenOutProps = {
					BackgroundTransparency = 1
				}
				if scalePulseEnabled then
					tweenOutProps.Size = UDim2.new(
						(origSize.X.Scale or 0) * pulseFactor, (origSize.X.Offset or 0) * pulseFactor,
						(origSize.Y.Scale or 0) * pulseFactor, (origSize.Y.Offset or 0) * pulseFactor
					)
				end

				local tweenInProps = {
					BackgroundTransparency = origTrans
				}
				if scalePulseEnabled then
					tweenInProps.Size = origSize
				end

				local tweenOut = ts:Create(el, TweenInfo.new(fadeOutTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tweenOutProps)
				local tweenIn = ts:Create(el, TweenInfo.new(fadeInTime, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tweenInProps)

				tweenOut:Play()
				local outDone = false
				local inDone = false

				tweenOut.Completed:Connect(function()
					outDone = true
					-- hold sul picco
					task.delay(peakHold, function()
						tweenIn:Play()
						tweenIn.Completed:Connect(function()
							inDone = true
							animating[el] = false
						end)
					end)
				end)

				-- fallback di sicurezza: se non si completa entro un tot, reset
				task.delay(fadeOutTime + peakHold + fadeInTime + 0.1, function()
					if not inDone then
						animating[el] = false
					end
				end)
			end

			while true do
				local center = getCenter()
				local elements = getElements()

				-- rileva cambi nella collezione
				local changed = #elements ~= #lastSnapshot
				if not changed then
					for i, el in ipairs(elements) do
						if lastSnapshot[i] ~= el then
							changed = true
							break
						end
					end
				end
				if changed then
					baseTrans = {}
					animating = {}
					for _, el in ipairs(elements) do
						baseTrans[el] = el.BackgroundTransparency
						animating[el] = false
					end
					lastSnapshot = elements
				end

				-- distanze e normalizzazione
				local distances = {}
				local maxDist = 0
				for _, el in ipairs(elements) do
					local d = distanceFromCenter(el, center)
					distances[el] = d
					if d > maxDist then
						maxDist = d
					end
				end
				if maxDist == 0 then
					maxDist = 1
				end

				-- ordina interno -> esterno per cascata
				table.sort(elements, function(a, b)
					return distances[a] < distances[b]
				end)

				-- variazione organica sul travel time
				local waveTravelTime = nominalWaveTravel + (math.random() - 0.5) * 0.4  -- +/-0.2s

				local lastStart = 0
				for _, el in ipairs(elements) do
					local norm = distances[el] / maxDist
					local targetStart = norm * waveTravelTime
					local delta = targetStart - lastStart
					-- jitter controllato
					local jitter = (math.random() - 0.5) * 0.03
					delta = math.max(0, delta + jitter)

					if delta > 0 then
						wait(delta)
					end
					lastStart = targetStart

					local origTrans = baseTrans[el] or el.BackgroundTransparency
					local origSize = el.Size

					-- animazione isolata senza bloccare la cascata
					task.spawn(function()
						animate(el, origTrans, origSize)
					end)

					-- piccola pausa tra start consecutivi (staggered evidente)
					wait(pauseAfter)
				end

				-- attende che l'onda si sia propagata (non troppo aggressivo)
				wait(waveTravelTime)
			end
		end)
	end
	do
		local authGradientObj = ui:Get("AuthGradient")
		if not authGradientObj then
			return
		end

		local grad = authGradientObj.instance

		task.spawn(function()
			local ts = framework.protected:GetService("TweenService")

			-- colori originali, li lasciamo cosÃ¬
			local baseC0 = Color3.fromHex("#77B7FF")
			local baseC1 = Color3.fromHex("#3085FF")

			-- trasparenze:
			-- v = 0  -> stato "normale"
			-- v = 1  -> stato "spento" (piÃ¹ trasparente)
			local normalT0, normalT1 = 0.85, 0      -- come nel tuo snippet
			local offT0, offT1      = 1.0,  0.5     -- piÃ¹ trasparente ma non esagerato

			-- set di base (fisso, non lo tweennamo piÃ¹)
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, baseC0),
				ColorSequenceKeypoint.new(1, baseC1),
			})

			-- valore che useremo per tweennare (0..1)
			local pulse = Instance.new("NumberValue")
			pulse.Name = "AuthGradientPulse"
			pulse.Value = 0
			pulse.Parent = grad

			pulse.Changed:Connect(function(v)
				-- niente cambio di tinta, solo trasparenza
				local t0 = normalT0 + (offT0 - normalT0) * v
				local t1 = normalT1 + (offT1 - normalT1) * v

				grad.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, t0),
					NumberSequenceKeypoint.new(1, t1),
				})
			end)

			-- loop di â€œrespiroâ€ lento
			while grad.Parent do
				-- fade in â†’ gradient piÃ¹ visibile (v 1 â†’ 0)
				local tweenIn = ts:Create(
					pulse,
					TweenInfo.new(
						1.6,
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.Out
					),
					{ Value = 0 }
				)
				tweenIn:Play()
				tweenIn.Completed:Wait()

				task.wait(0.2)

				-- fade out â†’ gradient piÃ¹ trasparente (v 0 â†’ 1)
				local tweenOut = ts:Create(
					pulse,
					TweenInfo.new(
						1.6,
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.In
					),
					{ Value = 1 }
				)
				tweenOut:Play()
				tweenOut.Completed:Wait()

				task.wait(0.4)
			end
		end)
	end
end
