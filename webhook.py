#Import libraries
import sys
import datetime
from discordwebhook import Discord

#-------DESCRIPTION--------
#Sends a webhook request with a logfile to the specified webhook url.
#The first command layout just sends an embed notifying that something ended successfully or failed.
#The second command layout can attach or write the logfile to the message/embed.

#-----COMMAND LAYOUT-------
#python3 ./webhook.py WEBHOOKURL FILEPATH FILENAME COLOR MESSAGECONTENT TITLE DESCRIPTION 
#python3 ./webhook.py -ARGUMENT WEBHOOKURL FILEPATH FILENAME COLOR MESSAGECONTENT TITLE DESCRIPTION 

#--------------------------

#Sending help command
if sys.argv[1] == "-h":
	print("DESCRIPTION\nSends a webhook request with a logfile to the specified webhook url.\nThe first command layout just sends an embed notifying that something ended successfully or failed.\nThe second command layout can attach or write the logfile to the message/embed.")
	print("\nCOMMAND LAYOUT\npython3 ./webhook.py WEBHOOKURL FILEPATH FILENAME COLOR MESSAGECONTENT TITLE DESCRIPTION")
	print("\nALTERNATIVE COMMAND LAYOUT\npython3 ./webhook.py -ARGUMENT WEBHOOKURL FILEPATH FILENAME COLOR MESSAGECONTENT TITLE DESCRIPTION")
	print("\nARGUMENTS\n-a: send the file as an attachment.\n-w: write the logfile into the embed description. NOTE that this overrides the description.\n-aw: -a and -w combined. Both attach and write the logfile.\n-h: Print this help text.")
	exit(0)

#Add an command argument offset if a attach or write argument is used.
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

#Message that allows mentiones outside of the webhook
message = sys.argv[5+i]

#Title of the webhook
title = sys.argv[6+i]

#Setup Discord webhook link
discord = Discord(url=webhookurl)

#Send the JSON to the webhook and a message
if sys.argv[1] == "-w" or sys.argv[1] == "-aw":
	totallength = 0
	#The max character length of the logfile that gets added
	maxlength = 1500
	description = "**Logfile:**\n"
	file = open(logfile,'r')
	lines = file.readlines()
	file.close()
	#Read all lines and add them to the description
	for line in lines:
		if totallength <= maxlength:
			totallength += len(line)
			if line != "\n":
				description += "{}\n".format(line)
	if totallength > maxlength:
		description += "**AND MORE...**\n*This logfile doesn't end here. It was truncated to save space and stay below the 4000 character limit.*"
else:
	#Description of the webhook
	description = sys.argv[7+i]

#Post the Discord message with embed
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

#Attach the logfile if the argument is used
if sys.argv[1] == "-a" or sys.argv[1] == "-aw":
	discord.post(
		file={"file": open(logfile, "rb"),},
	)
