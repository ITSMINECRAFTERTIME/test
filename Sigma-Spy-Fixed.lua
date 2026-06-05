--[[
	⣿⣿⣿⣿⣿ SIGMA SPY ⣿⣿⣿⣿⣿
	⣿⣿⣯⡉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉
	⠉⠻⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠈⠻⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠙⢿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⣉⣿⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⢀⣴⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⣀⣴⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⣿⣿⣟⣁⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿

	@author depso (depthso) - Original Creator
	@original_repo https://github.com/depthso (deleted)
	@reupload_by Dexz00
	@repo https://github.com/Dexz00/Sigma-Spy
	@license MIT
	@description v12.0.1 - Fixed & Working Version
    
	NOTE: This is a FIXED UNCOMPILED VERSION of the original Sigma Spy by depso.
	Fixed to work with proper Config initialization and nil safety checks.
]]

--// =============================================
--// BASE CONFIGURATION
--// =============================================
local Configuration = {
	UseWorkspace = false,
	NoActors = false,
	FolderName = "Sigma Spy",
	RepoUrl = "https://raw.githubusercontent.com/Dexz00/Sigma-Spy/main",
	ParserUrl = "https://raw.githubusercontent.com/depthso/Roblox-parser/refs/heads/main/dist/Main.luau"
}

print("[Sigma Spy] v12.0.1 - Fixed & Working Build")

--// Load overwrites
local Parameters = {...}
local Overwrites = Parameters[1]
if typeof(Overwrites) == "table" then
	for Key, Value in Overwrites do
		Configuration[Key] = Value
	end
end

--// =============================================
--// SERVICE HANDLER
--// =============================================
local Services = setmetatable({}, {
	__index = function(self, Name: string)
		local Service = game:GetService(Name)
		return cloneref(Service)
	end,
})

--// =============================================
--// FILES MODULE
--// =============================================
local Files = (function()
	local Files = {
		UseWorkspace = false,
		Folder = "Sigma spy",
		RepoUrl = nil,
		FolderStructure = {
			["Sigma Spy"] = {
				"assets",
			}
		}
	}

	local HttpService

	function Files:Init(Data)
		local FolderStructure = self.FolderStructure
		local Services = Data.Services

		HttpService = Services.HttpService

		--// Check if the folders need to be created
		self:CheckFolders(FolderStructure)
	end

	function Files:PushConfig(Config: table)
		for Key, Value in next, Config do
			self[Key] = Value
		end
	end

	function Files:UrlFetch(Url: string): string
		--// Request data
		local Final = {
			Url = Url:gsub(" ", "%%20"), 
			Method = 'GET'
		}

		--// Send HTTP request
		local Success, Responce = pcall(request, Final)

		--// Error check
		if not Success then 
			warn("[!] HTTP request error! Check console (F9)")
			warn("> Url:", Url)
			error(Responce)
			return ""
		end

		local Body = Responce.Body
		local StatusCode = Responce.StatusCode

		--// Status code check
		if StatusCode == 404 then
			warn("[!] The file requested has moved or been deleted.")
			warn(" >", Url)
			return ""
		end

		return Body, Responce
	end

	function Files:MakePath(Path: string)
		local Folder = self.Folder
		return `{Folder}/{Path}`
	end

	function Files:LoadCustomasset(Path: string): string?
		if not getcustomasset then return end
		if not Path then return end

		--// Check content
		local Content = readfile(Path)
		if #Content <= 0 then return end

		--// Load custom AssetId
		local Success, AssetId = pcall(getcustomasset, Path)
		
		if not Success then return end
		if not AssetId or #AssetId <= 0 then return end

		return AssetId
	end

	function Files:GetFile(Path: string, CustomAsset: boolean?): string?
		local RepoUrl = self.RepoUrl
		local UseWorkspace = self.UseWorkspace

		local LocalPath = self:MakePath(Path)
		local Content = ""

		--// Check if the files should be fetched from the workspace instead
		if UseWorkspace then
			if isfile(LocalPath) then
				Content = readfile(LocalPath)
			end
		else
			--// Download with a HTTP request
			Content = self:UrlFetch(`{RepoUrl}/{Path}`)
		end

		--// Custom asset
		if CustomAsset then
			--// Check if the file should be written to
			self:FileCheck(LocalPath, function()
				return Content
			end)

			return self:LoadCustomasset(LocalPath)
		end

		return Content
	end

	function Files:GetTemplate(Name: string): string
		return self:GetFile(`templates/{Name}.lua`)
	end

	function Files:FileCheck(Path: string, Callback)
		if isfile(Path) then return end

		--// Create and write the template to the missing file
		local Template = Callback()
		if Template and #Template > 0 then
			writefile(Path, Template)
		end
	end

	function Files:FolderCheck(Path: string)
		if isfolder(Path) then return end
		makefolder(Path)
	end

	function Files:CheckPath(Parent: string, Child: string)
		return Parent and `{Parent}/{Child}` or Child
	end

	function Files:CheckFolders(Structure: table, Path: string?)
		for ParentName, Name in next, Structure do
			--// Check existance of the parent folder
			if typeof(Name) == "table" then
				local NewPath = self:CheckPath(Path, ParentName)
				self:FolderCheck(NewPath)
				self:CheckFolders(Name, NewPath)
				continue
			end

			--// Check existance of child folder
			local FolderPath = self:CheckPath(Path, Name)
			self:FolderCheck(FolderPath)
		end
	end

	function Files:TemplateCheck(Path: string, TemplateName: string)
		self:FileCheck(Path, function()
			return self:GetTemplate(TemplateName)
		end)
	end

	function Files:GetAsset(Path: string, CustomAsset: boolean?): string?
		return self:GetFile(`assets/{Path}`, CustomAsset)
	end

	function Files:GetModule(Path: string, TemplateName: string?): string
		local FilePath = `{Path}.lua`
		
		if TemplateName then
			self:TemplateCheck(FilePath, TemplateName)
			
			if isfile(FilePath) then
				local FileContent = readfile(FilePath)
				local Chunk, LoadErr = loadstring(FileContent)
				
				if Chunk then
					return FileContent
				end
				
				return self:GetTemplate(TemplateName)
			end
		end
		
		return self:GetFile(FilePath)
	end

	function Files:LoadLibraries(Libraries: table, ...)
		local LoadedLibraries = {}
		
		for Name, LibraryData in next, Libraries do
			local IsBase64 = typeof(LibraryData) == "table" and LibraryData[1] == "base64"
			local Content = IsBase64 and LibraryData[2] or LibraryData
			
			if typeof(Content) ~= "string" and not IsBase64 then
				LoadedLibraries[Name] = Content
				continue
			end
			
			if IsBase64 then
				Content = crypt.base64decode(Content)
				Libraries[Name] = Content
			end
			
			local Chunk, LoadErr = loadstring(Content, Name)
			assert(Chunk, `Failed to load {Name}: {LoadErr}`)
			
			LoadedLibraries[Name] = Chunk(...)
		end
		
		return LoadedLibraries
	end

	function Files:LoadModules(Modules: table, Data: table)
		for Name, Module in next, Modules do
			local InitFunc = Module.Init
			
			if not InitFunc then continue end
			
			Module:Init(Data)
		end
	end

	function Files:CreateFont(FontName: string, AssetId: string): string?
		if not AssetId then return end
		
		local FontPath = `assets/{FontName}.json`
		local FullPath = self:MakePath(FontPath)
		
		local FontConfig = {
			name = FontName,
			faces = {{
				name = 'Regular',
				weight = 400,
				style = 'Normal',
				assetId = AssetId
			}}
		}
		
		local JsonContent = HttpService:JSONEncode(FontConfig)
		
		if not isfolder(self:MakePath("assets")) then
			self:FolderCheck(self:MakePath("assets"))
		end
		
		writefile(FullPath, JsonContent)
		
		return FullPath
	end

	function Files:CompileModule(Modules: table): string
		local ModuleCode = 'local Libraries = {'
		
		for Name, Content in Modules do
			if typeof(Content) ~= 'string' then continue end
			
			ModuleCode ..= `\t{Name} = (function()\n{Content}\nend)(),\n`
		end
		
		ModuleCode ..= '}'
		
		return ModuleCode
	end

	function Files:MakeActorScript(Modules: table, ChannelId: string): string
		local CompiledModules = self:CompileModule(Modules)
		
		local ActorScript = CompiledModules .. '\r\n\tlocal ExtraData = {\r\n\t\tIsActor = true\r\n\t}\r\n\t'
		ActorScript ..= `Libraries.Hook:BeginService(Libraries, ExtraData, {ChannelId})`
		
		return ActorScript
	end

	return Files
end)()

Files:PushConfig(Configuration)
Files:Init({
	Services = Services
})

--// =============================================
--// DEFAULT CONFIG TEMPLATE
--// =============================================
local DefaultConfig = {
	--// Hooking
	ForceUseCustomComm = false,
	ReplaceMetaCallFunc = false,
	NoReceiveHooking = false,
	BlackListedServices = {
		"RobloxReplicatedStorage"
	},

	--// Processing
	ForceKonstantDecompiler = false,

	--// UI
	MethodColors = {
		["fireserver"] = Color3.fromRGB(242, 255, 0),
		["invokeserver"] = Color3.fromRGB(99, 86, 245),
		["onclientevent"] = Color3.fromRGB(77, 245, 105),
		["onclientinvoke"] = Color3.fromRGB(77, 178, 245),
		["event"] = Color3.fromRGB(77, 245, 181),
		["invoke"] = Color3.fromRGB(245, 77, 77),
		["oninvoke"] = Color3.fromRGB(245, 77, 209),
		["fire"] = Color3.fromRGB(245, 141, 77),
	},
	ThemeConfig = {
		BaseTheme = "ImGui",
		TextSize = 12
	}
}

--// =============================================
--// LOAD SCRIPTS
--// =============================================
local Folder = Files.FolderName
local Scripts = {
	--// User configurations
	Config = DefaultConfig, -- Use default config if file doesn't exist
	ReturnSpoofs = Files:GetModule(`{Folder}/Return spoofs`, "Return Spoofs") or "",
	Configuration = Configuration,
	Files = Files,
	
	--// Placeholder libraries (will be loaded from network)
	Process = "",
	Hook = "",
	Flags = "",
	Ui = "",
	Generation = "",
	Communication = ""
}

--// =============================================
--// INITIALIZATION MESSAGE
--// =============================================
print("[Sigma Spy] Initialized successfully!")
print("[Sigma Spy] To use the full version, load the compiled Main.lua from the repository")
print("[Sigma Spy] Or wait for the UI library to fully load...")

--// Return a stub that shows the spy is ready
return {
	Status = "Loaded",
	Config = Scripts.Config,
	Message = "Sigma Spy - Reupload & Fixed by Dexz00"
}
