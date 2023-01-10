import asyncio
import genshin
import argparse
import json

parser = argparse.ArgumentParser()

parser.add_argument('-c', '--cookiesdata')
parser.add_argument('-o', '--datafile')

args = parser.parse_args()

with open(args.cookiesdata, "r") as data:
	cookies = json.load(data)
with open(args.datafile, "r") as data:
	accData = json.load(data)
 
client = genshin.Client()

async def updateData():
	client.set_cookies({"ltuid":cookies['ltuid'],"ltoken":cookies["ltoken"]})
	accounts = await client.genshin_accounts()
	user = accounts[cookies['currentServer'] - 1]
	resin = await client.get_notes(accData['uid'])
	playerAccountData = {
		"uid": accData['uid'],
		"nickname": user.nickname,
		"level": user.level,
		"resin": resin.current_resin,
	}
 

	with open(args.datafile, "w") as outfile:
		json.dump(playerAccountData, outfile)
  
	with open(args.cookiesdata, "w") as outfile:
		cookies['accounts'][cookies['currentServer'] - 1]['current_resin'] = resin.current_resin
		json.dump(cookies, outfile)
 
asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
asyncio.run(updateData())