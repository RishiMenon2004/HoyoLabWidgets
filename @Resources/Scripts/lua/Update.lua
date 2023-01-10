function Initialize()
	ResourcesFolder = SKIN:GetVariable('@'):gsub('\\', '/')

	fileSystem = dofile(SKIN:MakePathAbsolute(ResourcesFolder.."Scripts/lua/fileSystem.lua"))

	UpdatePy = ResourcesFolder.."Scripts/python/UpdateAccountData.py"

	playerAccounts = ResourcesFolder.."PlayerInfo/PlayerAccount.json"
	playerAccountData = ResourcesFolder.."PlayerInfo/PlayerAccountData.json"

	currentConfig = SKIN:GetVariable('CURRENTCONFIG')

end

function UpdateText()
	print("Updating Info")
	accData = fileSystem.get_json_from_file(playerAccountData)
	SKIN:Bang("!SetOption", "PlayerInfoName", "Text", accData["nickname"])
	SKIN:Bang("!SetOption", "PlayerInfoLvl", "Text", "Lv."..accData["level"])
	SKIN:Bang("!SetOption", "PlayerInfoResinText", "Text", accData["resin"].."/160")
end