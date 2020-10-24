#Import libraries
import smtplib
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

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

#Read logfile
file = open(fullpath,'r')
log = []
lines = file.readlines()
for line in lines:
    log.append(line)
    file.close()

log = (str("".join(log)))
#print(log)

msg = MIMEMultipart("alternative")
msg.set_charset("utf-8")

#Create mail header with adresses
msg["Subject"] = "{} - {}".format(mailsubject, filename)
msg["From"] = fromaddress
msg["To"] = toaddress

#Add the logfile to the mail body (text)
body = MIMEText(log, "plain", "utf-8")
msg.attach(body)

#Send the mail
server = smtplib.SMTP(serverip)
server.ehlo()
server.starttls()
server.ehlo()
server.login(username,password)
server.sendmail(fromaddress, toaddress, msg.as_string())
server.quit()
