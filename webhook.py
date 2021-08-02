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

#Link the logfile to the attachment
attachment = logfile

#Setup Discord webhook link
discord = Discord(url=webhookurl)

#Send the JSON to the webhook and a message
if sys.argv[1] == "-w" or sys.argv[1] == "-aw":
	log = ""
	file = open(attachment,'r')
	lines = file.readlines()
	for line in lines:
		log += "{}\n".format(line)
		file.close()

	discord.post(
		content = message,
		embeds=[
			{
				"title": title,
				"description": log,
				"timestamp": str(datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()),
				"color": color,
				"fields": [
					{"name": "Log Location", "value": logurl, "inline": True},
					{"name": "Log File", "value": logfile, "inline": True},
				],
			}
		],
	)
else:	
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
		file={"file": open(attachment, "rb"),},
	)
