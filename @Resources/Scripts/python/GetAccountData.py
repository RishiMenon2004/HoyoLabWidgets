import argparse
import json

parser = argparse.ArgumentParser()

parser.add_argument('-f', '--file')
parser.add_argument('-o', '--outfile')

args = parser.parse_args()

with open(args.file, "r") as data:
	accData = json.load(data)

currentServer = accData['currentServer']

selectedAccount = accData['accounts'][currentServer - 1]

playerAccountData = {
	"uid": selectedAccount['uid'],
	"nickname": selectedAccount['nickname'],
	"level": selectedAccount['level'],
	"resin": selectedAccount['current_resin'],
}

with open(args.outfile, "w") as outfile:
    json.dump(playerAccountData, outfile)