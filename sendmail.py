#Import libraries
import smtplib
import sys
import getpass
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime

#-------DESCRIPTION--------
#Sends a mail with a logfile to the specified email.
#Needs to be set up with emails, server, username and password.

#-----COMMAND LAYOUT-------
#python3 ./sendmail.py FILEPATH FILENAME MAILSUBJECT

#---------CONFIG-----------
#Email address that sends the email
fromaddress = 'sender@server.com'

#Email address that receives the email
toaddress = 'reciver@server.com'

#Server username and password to login with
username = 'username'
password = 'password'

#SMTP server IP and port
ip = 'smtp.server.com'
port = '587'

#--------------------------

#Path to logfile
filepath = sys.argv[1]

#Name of the logfile
filename = sys.argv[2]

#Subject of the mail
mailsubject = sys.argv[3]

#Combind the SMTP server IP and port
serverip = "{}:{}".format(ip, port)

#Combind the filepath and filename
fullpath = "{}/{}".format(filepath, filename)

#Array with message lines
message = []

#Add base message
message.append("Auto mail about: {}\n".format(mailsubject))
message.append("Log: {}/{}\n\n".format(filepath, filename))
message.append("Log information can be seen bellow.\n\n")
message.append("========================\n")
message.append("	START OF LOG FILE\n")
message.append("========================\n\n")

#Read log file and add to message
file = open(fullpath,'r')
lines = file.readlines()
for line in lines:
    message.append(line)
    file.close()

#Add file end message
message.append("\n========================\n")
message.append("	END OF LOG FILE\n")
message.append("========================\n\n")
message.append("For more information see full and/or other logfiles.\n")
message.append("Logfiles location: {}\n".format(filepath))
message.append("Automatic mail sent by {} at {}.".format(getpass.getuser(), datetime.now().strftime("%d/%m/%Y %H:%M:%S")))

#Make message into a string
message = (str("".join(message)))
#print(message)

#Setup the mail message
msg = MIMEMultipart("alternative")
msg.set_charset("utf-8")

#Create mail header with adresses
msg["Subject"] = "{} - {}".format(mailsubject, filename)
msg["From"] = fromaddress
msg["To"] = toaddress

#Add the log file to the mail body (text)
body = MIMEText(message, "plain", "utf-8")
msg.attach(body)

#Send the mail
server = smtplib.SMTP(serverip)
server.ehlo()
server.starttls()
server.ehlo()
server.login(username,password)
server.sendmail(fromaddress, toaddress, msg.as_string())
server.quit()
