#!/bin/bash

DATE=$(date +%Y-%m-%d-%H-%M)
DAY=$(date +%A)
WEEK=$(date +%V)

#-------DESCRIPTION--------
#Script to Rsync folders to a remote server folder.
#Compabitble with multiple users as long as they use the same path layout.
#Makes a simple weekly log and a more in depth log for each Rsync job.
#sendmail.py needs to be configured with your own emails and email server.
#weeklymail.sh needs to be configured with path to the weekly log

#-----NEEDED SCRIPTS-------
#rsync-user.sh to Rsync
#sendmail.py to send an error email
#clearlogs.sh to clear old .log files
#weeklymail.sh to send a weekly mail with rsync statuses

#---------CONFIG-----------
#Name of the weekly logfile (default: "week-$WEEK-Rsync.log")
LOGFILE="week-$WEEK-Rsync.log"

#Path to logfile (default: /var/log/rsync)
LOGPATH=/var/log/rsync

#Path to source folder to sync (username will be added last)
SOURCEPATH=/media/usb/ncdata

#Path to target folder to sync to (username will be added last)
TARGETPATH=/media/usb/backup

#Target IP to sync to
TARGETIP=ip.ip

#Port that SSH should use
SSHPORT=22

#The users that should Rsync
USERNAMES=( admin user user2 )

#--------------------------

echo "--- $DAY, week $WEEK ---" | tee -a $LOGPATH/$LOGFILE

#Start Nextcloud maintenance mode
echo "" | tee -a $LOGPATH/$LOGFILE
sudo -u www-data php /var/www/nextcloud/occ maintenance:mode --on | tee -a $LOGPATH/$LOGFILE
echo "" | tee -a $LOGPATH/$LOGFILE

#Loop through all users
for USERNAME in "${USERNAMES[@]}"
do
	#Set user paths
	USERSOURCEPATH=$SOURCEPATH/$USERNAME/files
	USERTARGETPATH=$TARGETPATH/$USERNAME
	
	#Start the Rsync job for the user
	echo "$DATE - Starting Rsync job for $USERNAME" | tee -a $LOGPATH/$LOGFILE
	./rsync-job.sh $USERNAME $DATE $LOGPATH $USERSOURCEPATH $USERTARGETPATH $LOGFILE $TARGETIP $SSHPORT
	echo "" | tee -a $LOGPATH/$LOGFILE
done

#Clear old logs
echo "$DATE - Clearing old logfiles" | tee -a $LOGPATH/$LOGFILE
./clearlogs.sh $LOGFILE $LOGPATH
echo "$DATE - Clearing of old logfiles done" | tee -a $LOGPATH/$LOGFILE
echo "" | tee -a $LOGPATH/$LOGFILE

#Stop Nextcloud maintenance mode
sudo -u www-data php /var/www/nextcloud/occ maintenance:mode --off | tee -a $LOGPATH/$LOGFILE
echo "" | tee -a $LOGPATH/$LOGFILE

echo "** For more information, see specific logfiles (logpath: $LOGPATH) **" | tee -a $LOGPATH/$LOGFILE
echo "" | tee -a $LOGPATH/$LOGFILE
