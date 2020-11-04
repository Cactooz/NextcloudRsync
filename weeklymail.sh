#!/bin/bash

DATE=$(date +%a-%d-%b-%H-%M)
WEEK=$(date +%V)

#-------DESCRIPTION--------
#Sends a weekly mail with the weeks log.

#-----NEEDED SCRIPTS-------
#sendmail.py to send weekly mail

#---------CONFIG-----------
#Name of the weekly logfile (default: "week-$WEEK-Rsync.log")
WEEKLOGFILE="w$WEEK-Rsync.log"

#Path to logfile (default: /var/log/rsync)
LOGPATH=/var/log/rsync

#Name of the logfile
LOGFILE="w$WEEK-mail-Rsync.log"

#--------------------------

#Sending help command
if [ "$1" = "-h" ]
then
	echo "DESCRIPTION"
	echo "Sends a weekly mail with the weeks log."
	echo ""
	echo "COMMAND LAYOUT"
	echo "./weeklymail.sh"
	echo ""
	echo "NEEDED SCRIPTS"
	echo "sendmail.py to send weekly mail"
	
	exit 0
fi

echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

echo "$(date +%T) - Sending mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
python3 ./sendmail.py "$LOGPATH" "$WEEKLOGFILE" "Weekly Rsync" 2>&1 | tee -a $LOGPATH/$LOGFILE
if [ "$?" -eq "0" ]
	then
		echo "*** Mail Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Sent mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
		echo "$(date +%T) - Sent mail with this weeks Rsync log" >> $LOGPATH/$WEEKLOGFILE
	else
		ERRORCODE=$?
		
		echo "*** Mail Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Failed sending mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
		echo "$(date +%T) - Failed sending mail with this weeks Rsync log" >> $LOGPATH/$WEEKLOGFILE
		
		exit $ERRORCODE
fi

echo "" >> $LOGPATH/$LOGFILE
echo "" >> $LOGPATH/$WEEKLOGFILE

exit 0
