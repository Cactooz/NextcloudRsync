#!/bin/bash

DATE=$(date +%a-%d-%b-%H-%M)
WEEK=$(date +%V)

#-------DESCRIPTION--------
#Sends a weekly mail with the weeks log.

#---------CONFIG-----------
#Name of the weekly logfile (default: "week-$WEEK-Rsync.log")
WEEKLOGFILE="w$WEEK-Rsync.log"

#Path to logfile (default: /var/log/rsync)
LOGPATH=/var/log/rsync

#Name of the logfile
LOGFILE="w$WEEK-mail-Rsync.log"

#--------------------------

echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

echo "$(date +%T) - Sending mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
python3 ./sendmail.py "$LOGPATH" "$WEEKLOGFILE" "Weekly Rsync" 2>&1 | tee -a $LOGPATH/$LOGFILE
if [ "$?" -eq "0" ]
	then
		echo "*** Mail Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Sent mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
		echo "$(date +%T) - Sent mail with this weeks Rsync log" >> $LOGPATH/$WEEKLOGFILE
	else
		echo "*** Mail Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Failed sending mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
		echo "$(date +%T) - Failed sending mail with this weeks Rsync log" >> $LOGPATH/$WEEKLOGFILE
fi

echo "" >> $LOGPATH/$LOGFILE
echo "" >> $LOGPATH/$WEEKLOGFILE
