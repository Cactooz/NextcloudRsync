#Import libraries
import smtplib
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#Get the first argument
filename = sys.argv[1]

#Read mail.txt
file = open(filename,'r')
log = []
lines = file.readlines()
for line in lines:
	log.append(line)
	file.close()

log = (str("".join(log)))
#print(log)

#Adresses
fromaddr = 'mail@mail.net'
toaddr = 'mail@mail.com'

msg = MIMEMultipart("alternative")
msg.set_charset("utf-8")

#Create mail header with adresses
msg["Subject"] = filename
msg["From"] = fromaddr
msg["To"] = toaddr

#Add mail body (text)
body = MIMEText(logfile, "plain", "utf-8")
msg.attach(body)

#Login to server and send the mail
username = 'mail@mail.se'
password = 'mail-password'
server = smtplib.SMTP('smtp.mailserver.se:587')
server.ehlo()
server.starttls()
server.ehlo()
server.login(username,password)
server.sendmail(fromaddr, toaddr, msg.as_string())
server.quit()