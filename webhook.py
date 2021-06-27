#Import libraries
import sys
import datetime
from discordwebhook import Discord

#-------DESCRIPTION--------
#Sends a webhook request with a logfile to the specified webhook url.

#-----COMMAND LAYOUT-------
#python3 ./webhook.py WEBHOOKURL FILEPATH FILENAME COLOR TITLE DESCRIPTION MESSAGECONTENT

#--------------------------

#Sending help command
if sys.argv[1] == "-h":
	print("DESCRIPTION\nSends a webhook request with a logfile to the specified webhook url.")
	print("\nCOMMAND LAYOUT\npython3 ./webhook.py WEBHOOKURL FILEPATH FILENAME COLOR TITLE DESCRIPTION MESSAGECONTENT")
	exit(0)

#Webhook url
webhookurl = sys.argv[1]

#Path to logfile
logurl = sys.argv[2]

#Name of the logfile
logfile = sys.argv[3]

#Color for the webhook
#red = 1671168
#green = 65280
color = sys.argv[4] 

#Title of the webhook
title = sys.argv[5]

#Description of the webhook
description = sys.argv[6]

#Message that allows mentiones outside of the webhook
message = sys.argv[7]

#Link the logfile to the attachment
attachment = logfile

#Setup Discord webhook link
discord = Discord(url=webhookurl)

#Send the JSON to the webhook and a message
discord.post(
	content = message,
	embeds=[
		{
			"title": title,
			"description": description,
			"timestamp": str(datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()),
			"color": color,
			"fields": [
				{"name": "Log Location", "value": logurl, "inline": True},
				{"name": "Log File", "value": logfile, "inline": True},
			],
		}
	],
	#Attach the logfile
	file={"file": open(attachment, "rb"),
	},
)
