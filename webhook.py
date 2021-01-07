#Import libraries
import sys
import datetime
from discordwebhook import Discord

#-------DESCRIPTION--------
#Sends a embed to a Discord webhook with the logfile attached.
#Needs to be set up with a Discord webhook url.

#-----COMMAND LAYOUT-------
#python3 ./webhook.py FILEPATH FILENAME TITLE COLOR

#---------CONFIG-----------
#Webhook url
webhookurl = "https://discordapp.com/api/webhooks/<discord-webhook-url>"

#--------------------------

#Sending help command
if sys.argv[1] == "-h":
	print("DESCRIPTION\nSends a embed to a Discord webhook with the logfile attached.\nNeeds to be set up with a Discord webhook url.")
	print("\nCOMMAND LAYOUT\npython3 ./webhook.py FILEPATH FILENAME TITLE COLOR")
	exit(0)

#Path to logfile
filepath = sys.argv[1]

#Name of the logfile
filename = sys.argv[2]

#Title for the embed
title = sys.argv[3]

#Description of the embed with log file
description = "Log file: {}".format(filename)

#Color of the webhook, red = 16711680 green = 65280
color = sys.argv[4]

#Empty log information
#log = ""

#Footer text for the embed
footer = "Log location: {}".format(filepath)

#Attachment to send along the embed
attachment = "{}/{}".format(filepath, filename)

#Setup Discord webhook link
discord = Discord(url=webhookurl)

#Read log file and add to the embed
file = open(attachment,'r')
lines = file.readlines()
for line in lines:
	log += "{}\n".format(line)
	file.close()


#Send Discord embed post
discord.post(
	embeds=[
		{
			"title": title,
			"description": description,
			"timestamp": str(datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()),
			"color": color,
			"fields": [
				{"name": "Log File", "value": log, "inline": False},
			],
			"footer": {
				"text": footer,
			},
		}
	],
	file={"file": open(attachment, "rb"),
	},
)
