import asyncio
import genshin
import argparse
import json
import GetAccounts

parser = argparse.ArgumentParser()

parser.add_argument('-u', '--username')
parser.add_argument('-p', '--password')
parser.add_argument('-o', '--outfile')

args = parser.parse_args()

client = genshin.Client()

async def login():
    client = genshin.Client(game=genshin.Game.GENSHIN)
    try:
        print('Logging In')
        cookies = await client.login_with_password(args.username, args.password)
        print('Successfully Logged In')
        return(cookies)
    except Exception as e:
        error = "%s" % e
        errorCode = error.split("[")[1].split("]")[0]
        print("ERR: %s" % errorCode)
    
asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
cookies = asyncio.run(login())

ltuid = cookies["ltuid"]
ltoken= cookies["ltoken"]

accounts = GetAccounts.getGameAccounts(ltuid, ltoken)

playerAccountData = {
    "success": True,
    "currentServer": 0,
    "accounts": accounts,
    "ltuid": ltuid,
    "ltoken": ltoken
}

with open(args.outfile, "w") as outfile:
    json.dump(playerAccountData, outfile)