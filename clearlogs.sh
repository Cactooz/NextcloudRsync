#!/bin/bash

#-------DESCRIPTION--------
#Clearing logs that is 30 days or older.

#-----COMMAND LAYOUT-------
#./clearlogs.sh DATE WEEK WEEKLOGFILE LOGPATH

#---------CONFIG-----------
#Current date
DATE=$1

#Current week
WEEK=$2

#Name of the logfile
LOGFILE="w$WEEK-clearlogs-Rsync.log"

#Name of the weekly logfile
WEEKLOGFILE=$3

#Path to logfile
LOGPATH=$4

#--------------------------

#Write Date to logfile
echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

# Remove logfiles older than 30 days
find $LOGPATH -name "*.log" -type f -mtime +30 -delete 2>&1 | tee -a $LOGPATH/$LOGFILE
if [ "$?" -eq "0" ]
	then
		echo "*** Clearing logs Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Clearing of old logfiles done successfully." | tee -a $LOGPATH/$WEEKLOGFILE
	else
		echo "*** Clearing logs Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Clearing of old logfiles failed. (Returncode: $?)" | tee -a $LOGPATH/$WEEKLOGFILE
fi

echo "" >> $LOGPATH/$LOGFILE

#Remove live logfiles
find $LOGPATH -name "*.livelog" -type f -delete 2>&1 | tee -a $LOGPATH/$LOGFILE
if [ "$?" -eq "0" ]
	then
		echo "*** Clearing live logs Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Clearing of live-logfiles done successfully." | tee -a $LOGPATH/$WEEKLOGFILE
	else
		echo "*** Clearing live logs Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Clearing of live-logfiles failed. (Returncode: $?)" | tee -a $LOGPATH/$WEEKLOGFILE
fi

echo "" >> $LOGPATH/$LOGFILE
