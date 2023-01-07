import asyncio
import genshin

client = genshin.Client()

async def do(uid, token):
        client.set_cookies({"ltuid":uid,"ltoken":token})
        rawAccounts = await client.genshin_accounts()
        otherDetails = await client.get_genshin_notes()
        accounts = []
        print(otherDetails)
        for account in rawAccounts:
            objAccount = {
				"lang": account.lang,
				"game_biz": account.game_biz,
				"uid": account.uid,
				"nickname": account.nickname,
				"level": account.level,
                "current_resin": otherDetails.current_resin,
				"server": account.server,
				"server_name": account.server_name,
			}
            accounts.append(objAccount)
        return accounts

def getGameAccounts(uid, token):   
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    accounts = asyncio.run(do(uid, token))

    return accounts