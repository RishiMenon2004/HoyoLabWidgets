CheckLogin = {}

function CheckLogin.checkLogin(accData, currentConfig)
	
	SKIN:Bang("!HideMeterGroup", "MainSkinGroup", currenConfig)
	SKIN:Bang("!HideMeterGroup", "OverlayMessageGroup", currenConfig)
	SKIN:Bang("!HideMeterGroup", "ServerFormGroup", currenConfig)
	SKIN:Bang("!ShowMeterGroup", "OverlayGroup", currenConfig)
	SKIN:Bang("!ShowMeterGroup", "LoginFormGroup", currenConfig)
	
	if accData["success"] then
		SKIN:Bang("!HideMeterGroup", "LoginFormGroup", currenConfig)
		SKIN:Bang("!HideMeterGroup", "OverlayMessageGroup", currenConfig)
		
		if accData["currentServer"] ~= 0 then
			print(accData["currentServer"])
			return accData["currentServer"]
		end

		SKIN:Bang("!ShowMeterGroup", "ServerFormGroup", currenConfig)
		SKIN:Bang("!SetVariable", "ServerFormSelectOptions", table.getn(accData["accounts"]))
		for i = 1, table.getn(accData["accounts"]), 1 do
			SKIN:Bang("!SetVariable", "ServerFormSelectOption"..i, accData["accounts"][i]["server_name"]:gsub(" Server", "")..", "..accData["accounts"][i]["nickname"])
		end
	end
	return 0
end

return CheckLogin