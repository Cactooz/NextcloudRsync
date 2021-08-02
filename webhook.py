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
	print("DESCRIPTION\nSends a webhook request with a logfile to the specified webhook url.\nThe first command layout just sends an embed notifying that something ended successfully or failed.\nThe second command layout can attach or write the logfile to the message/embed.")
	print("\nCOMMAND LAYOUT\npython3 ./webhook.py WEBHOOKURL FILEPATH FILENAME COLOR TITLE DESCRIPTION MESSAGECONTENT")
	print("\nALTERNATIVE COMMAND LAYOUT\npython3 ./webhook.py -ARGUMENT WEBHOOKURL FILEPATH FILENAME COLOR TITLE DESCRIPTION MESSAGECONTENT")
	print("\nARGUMENTS\n-a: send the file as an attachment.\n-w: write the logfile into the embed description. NOTE that this overrides the description.\n-aw: -a and -w combined. Both attach and write the logfile.\n-h: Print this help text.")
	exit(0)

if sys.argv[1] == "-a" or sys.argv[1] == "-aw" or sys.argv[1] == "-w":
	i = 1
else:
	i = 0

#Webhook url
webhookurl = sys.argv[1+i]

#Path to logfile
logurl = sys.argv[2+i]

#Name of the logfile
logfile = sys.argv[3+i]

#Color for the webhook
#red = 1671168
#green = 65280
color = sys.argv[4+i] 

#Title of the webhook
title = sys.argv[5+i]

#Description of the webhook
description = sys.argv[6+i]

#Message that allows mentiones outside of the webhook
message = sys.argv[7+i]

#Setup Discord webhook link
discord = Discord(url=webhookurl)

#Send the JSON to the webhook and a message
if sys.argv[1] == "-w" or sys.argv[1] == "-aw":
	description = "**Logfile:**\n"
	file = open(logfile,'r')
	lines = file.readlines()
	for line in lines:
		if line != "\n":
			description += "{}\n".format(line)
		file.close()

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
)

if sys.argv[1] == "-a" or sys.argv[1] == "-aw":
	discord.post(
		#Attach the logfile
		file={"file": open(logfile, "rb"),},
	)
