function HideOverlayMessage()
	SKIN:Bang('!HideMeterGroup', 'OverlayMessageGroup')
	SKIN:Bang('!ShowMeterGroup', 'LoginFormGroup')
end

function HidePassword()
	Password = SKIN:GetVariable("LoginPassword")
	HiddenPassword = Password:gsub('.', "●")
	SKIN:Bang('!SetOption', "LoginFormPasswordText", "Text", HiddenPassword)
end

function ShowServerFormDropDown()
	SKIN:Bang('!ShowMeter', "ServerFormSelectDropDown")
	SKIN:Bang('!DisableMouseAction', "ServerFormSelect", "LeftMouseUpAction")
	optLen = SKIN:GetVariable("ServerFormSelectOptions")
	for i=1, optLen, 1 do
		SKIN:Bang('!ShowMeter', "ServerFormSelectOption"..i)
		SKIN:Bang('!UpdateMeasure', 'ServerFormSelectOption'..i..'Content')
	end
end

function SelectServer(server)
	SKIN:Bang('!SetVariable', 'SelectedServer', server)
	SKIN:Bang('!EnableMouseAction', "ServerFormSelect", "LeftMouseUpAction")
	SKIN:Bang('!HideMeterGroup', "ServerFormSelectOptionsGroup")
end



