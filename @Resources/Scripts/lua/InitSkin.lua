function Initialize()
	ResourcesFolder = SKIN:GetVariable('@'):gsub('\\', '/')
	
	-- libraries
	fileSystem = dofile(ResourcesFolder.."Scripts/lua/fileSystem.lua")
	checkLogin = dofile(ResourcesFolder.."Scripts/lua/CheckLogin.lua")

	cmdOutputFile = ResourcesFolder.."Scripts/outputLogs/cmdOutput.log"
	pyOutputFile = ResourcesFolder.."Scripts/outputLogs/pyOutput.log"
	initSkinFile = ResourcesFolder.."PlayerInfo/initializeSkin.json"
	GetAccountDataPy = ResourcesFolder.."Scripts/python/GetAccountData.py"
	playerAccountsFile = ResourcesFolder.."PlayerInfo/PlayerAccounts.json"
	playerAccountDataFile = ResourcesFolder.."PlayerInfo/PlayerAccountData.json"
	

	initData = fileSystem.get_json_from_file(initSkinFile)
	if initData == nil then
		initData = {
			["alreadyInit"] = false,
			["hasGenshin"] = false
		}
	end
	
	accData = fileSystem.get_json_from_file(playerAccountsFile)
	if accData == nill then
		accData = {
			["success"] = false,
			["currentServer"] = 0,
			["ltuid"] = "",
			["ltoken"] = ""
		}
	end

	currentConfig = SKIN:GetVariable('CURRENTCONFIG')
end

function installPython()
	SKIN:Bang('!CommandMeasure', 'DownloadPython', 'Run')
	os.execute('/tmp/python.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0')
end

function checkPython(firstTime) 
	os.execute("python -V > "..cmdOutputFile)
	local lines = fileSystem.lines_from(cmdOutputFile)
	local firstLine = lines[1]
	if firstLine:find('Python') == nil then
		if firstTime then installPython() end
		checkPython(false)
		return false
	end
	return true
end

function installPyModules()
	os.execute('pip list > '..cmdOutputFile)
	local lines = fileSystem.lines_from(cmdOutputFile)
	local hasGenshin = initData["hasGenshin"]

	for k,v in pairs(lines) do
		if v:find('genshin') ~= nill then
			hasGenshin = true
			break
		else
			hasGenshin = false
		end
	end

	if not hasGenshin then
		os.execute('pip install genshin > '..cmdOutputFile)
		os.execute('pip install genshin[cookies] > '..cmdOutputFile)
		os.execute('pip install rsa > '..cmdOutputFile)
		hasGenshin = true
	end

	initData["hasGenshin"] = hasGenshin
end

function Init()
	SKIN:Bang("!FadeDuration", 500)
	SKIN:Bang("!Hide", currentConfig)
	
	if initData ~= nil and not initData["alreadyInit"] then
		if checkPython(true) then
			installPyModules()
		end
		initData["alreadyInit"] = true
		fileSystem.write_json_to_file(initSkinFile, initData)
	end

	serverSelected = checkLogin.checkLogin(accData, currentConfig)
	
	if serverSelected ~= 0 then
		print("Server is selected")
		SetServerAndUpdateInfo(serverSelected)
	end

	SKIN:Bang("!ShowFade", currentConfig)
	
	print("Skin Initialized")
end

function SetServerAndUpdateInfo(currentServer)
	print("Getting accounts")
	accounts = fileSystem.get_json_from_file(playerAccountsFile)
	if currentServer ~= 0 then
		accounts["currentServer"] = currentServer
		fileSystem.write_json_to_file(playerAccountsFile, accounts)
		print("Account selected")
		os.execute("python "..GetAccountDataPy.." -f "..playerAccountsFile.." -o "..playerAccountDataFile.." > "..pyOutputFile)
		SKIN:Bang("!HideMeterGroup", "ServerFormGroup", currenConfig)
		SKIN:Bang("!HideMeterGroup", "ServerFormSelectOptionsGroup", currenConfig)
		SKIN:Bang("!HideMeterGroup", "OverlayGroup", currenConfig)
		SKIN:Bang("!ShowMeterGroup", "MainSkinGroup", currenConfig)
		UpdateText()
	end
end

function UpdateText()
	accData = fileSystem.get_json_from_file(playerAccountDataFile)
	SKIN:Bang("!SetOption", "PlayerInfoName", "Text", accData["nickname"])
	SKIN:Bang("!SetOption", "PlayerInfoLvl", "Text", "Lv."..accData["level"])
	SKIN:Bang("!SetOption", "PlayerInfoResinText", "Text", accData["resin"].."/160")
end