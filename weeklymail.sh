#!/bin/bash

DATE=$(date +%Y-%m-%d-%H-%M)
WEEK=$(date +%V)

#---------CONFIG-----------
#Name of the weekly logfile (default: "week-$WEEK-Rsync.log")
WEEKLOGFILE="week-$WEEK-Rsync.log"

#Path to logfile (default: /var/log/rsync)
LOGPATH=/var/log/rsync

#Name of the logfile
LOGFILE="$WEEK-mail-Rsync.log"

#--------------------------

echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

echo "Sending mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
python3 ./sendmail.py "$LOGPATH" "$WEEKLOGFILE" "Weekly Rsync" | tee -a $LOGPATH/$LOGFILE
echo "Sent mail with this weeks Rsync log" | tee -a $LOGPATH/$LOGFILE
