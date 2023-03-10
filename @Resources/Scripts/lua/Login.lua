function Initialize()
	ResourcesFolder = SKIN:GetVariable('@'):gsub('\\', '/')
	
	json = dofile(SKIN:MakePathAbsolute(ResourcesFolder.."Scripts/lua/json.lua"))
	fileSystem = dofile(SKIN:MakePathAbsolute(ResourcesFolder.."Scripts/lua/fileSystem.lua"))
	checkLogin = dofile(ResourcesFolder.."Scripts/lua/CheckLogin.lua")

	InitSkin = dofile(SKIN:MakePathAbsolute(ResourcesFolder.."Scripts/lua/InitSkin.lua"))

	cmdOutputFile = ResourcesFolder.."Scripts/outputLogs/cmdOutput.log"
	loginOutputFile = ResourcesFolder.."Scripts/outputLogs/loginOutput.log"
	LoginPy = ResourcesFolder.."Scripts/python/Login.py"
	
	playerAccountsFile = ResourcesFolder.."PlayerInfo/PlayerAccounts.json"
	playerAccountDataFile = ResourcesFolder.."PlayerInfo/PlayerAccountData.json"

	Username = ""
	Password = ""

	currentConfig = SKIN:GetVariable('CURRENTCONFIG')
end

function Update()
	Username = SKIN:GetVariable('LoginUsername', '')
	Password = SKIN:GetVariable('LoginPassword', '')
end

local clock = os.clock

function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function setOverlayMessage(message, hasConfirmButton, autoHideDelay)
	SKIN:Bang('!HideMeterGroup', 'LoginFormGroup', currentConfig)
	SKIN:Bang('!SetVariable', 'OverlayMessage', message)
	SKIN:Bang('!ShowMeter', 'OverlayMessage', currentConfig)
	SKIN:Bang("!SetOption", "OverlayMessage", "stringAlign", "CenterCenter")
	SKIN:Bang('!Update')

	if hasConfirmButton then
		SKIN:Bang("!SetOption", "OverlayMessage", "stringAlign", "CenterBottom")
		SKIN:Bang('!ShowMeter', 'OverlayMessageConfirmButton', currentConfig)
	end
	if autoHideDelay and not hasConfirmButton then
		sleep(autoHideDelay)
		SKIN:Bang('!HideMeterGroup', 'OverlayMessageGroup', currentConfig)
		SKIN:Bang('!ShowMeterGroup', 'LoginFormGroup', currentConfig)
	end
end

function Login()
	error = false
	if Username == "" then
		SKIN:Bang("!SetOption", "LoginFormUsernameField", "Shape", "Rectangle 0, 0, (#OverlayBoxWidth#*0.8), 32, 8 | Fill Color 52, 55, 70 | StrokeWidth 1 | Stroke Color 245, 36, 36")
		error = true
	end
	
	if Password == "" then
		SKIN:Bang("!SetOption", "LoginFormPasswordField", "Shape", "Rectangle 0, 0, ((#OverlayBoxWidth#*0.8) - 40), 32, 8 | Fill Color 52, 55, 70 | StrokeWidth 1 | Stroke Color 245, 36, 36")
		error = true
	end

	if not error then
		setOverlayMessage('Complete the CAPTCHA')
		os.execute("python "..LoginPy.." -u "..Username.." -p "..Password.." -o "..playerAccountsFile.. " > "..loginOutputFile)
		
		lines = fileSystem.lines_from(loginOutputFile)
		
		for k,v in pairs(lines) do
			if v:find('ERR') ~= nill then
				print('Incorrect Username/Password')
				setOverlayMessage('Incorrect Username/Password', true)
				error = true
				break
			end
		end
	end

	accData = fileSystem.get_json_from_file(playerAccountsFile)

	if not error then
		setOverlayMessage('Login Complete')
		sleep(2)
		checkLogin.checkLogin(accData, currentConfig)
	end
end

function Logout()
	PlayerAccountsDefault = {
		["success"] = false,
		["currentServer"] = 0,
		["ltuid"] = 0,
		["ltoken"] = 0
	}

	PlayerAccountDataDefault = {
		["uid"] = 0,
		["nickname"] = "",
		["level"] = 0,
		["resin"] = 0
	}

	fileSystem.write_json_to_file(playerAccountsFile, PlayerAccountsDefault)
	fileSystem.write_json_to_file(playerAccountDataFile, PlayerAccountDataDefault)
end