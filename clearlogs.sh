#!/bin/bash

#-------DESCRIPTION--------
#Clearing logs that is X days or older.

#-----COMMAND LAYOUT-------
#./clearlogs.sh DATE WEEK WEEKLOGFILE LOGPATH DAYS

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

#After how many days logfiles should be deleted
DAYS=$5

#--------------------------

#Sending help command
if [ "$1" = "-h" ]
then
	echo "DESCRIPTION"
	echo "Clearing logs that is X days or older."
	echo ""
	echo "COMMAND LAYOUT"
	echo "./clearlogs.sh DATE WEEK WEEKLOGFILE LOGPATH DAYS"
	
	exit 0
fi

#Write Date to logfile
echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

#Getting amount of logfiles
FOUNDLOGS=$(find $LOGPATH -name "*.log" -type f -mtime +$DAYS | wc -l)
echo "$(date +%T) - Removing $FOUNDLOGS logfile(s)." | tee -a $LOGPATH/$WEEKLOGFILE

#Remove logfiles older than X days
find $LOGPATH -name "*.log" -type f -mtime +$DAYS -exec rm -v {} \; 2>&1 | tee -a $LOGPATH/$LOGFILE
if [ "$?" -eq "0" ]
	then
		echo "*** Removing logs Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Removed $FOUNDLOGS old logfiles successfully." | tee -a $LOGPATH/$WEEKLOGFILE
	else
		echo "*** Removing logs Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Removal of old logfiles failed. (Returncode: $?)" | tee -a $LOGPATH/$WEEKLOGFILE
fi

echo "" | tee -a $LOGPATH/$LOGFILE

#Getting amount of temp-logfiles
FOUNDLIVELOGS=$(find $LOGPATH -name "*.livelog" -type f | wc -l)
echo "$(date +%T) - Removing $FOUNDLIVELOGS live-logfile(s)." | tee -a $LOGPATH/$WEEKLOGFILE

#Remove live logfiles
find $LOGPATH -name "*.livelog" -type f -exec rm -v {} \; 2>&1 | tee -a $LOGPATH/$LOGFILE
if [ "$?" -eq "0" ]
	then
		echo "*** Removing live-logs Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Removed $FOUNDLIVELOGS live-logfiles successfully." | tee -a $LOGPATH/$WEEKLOGFILE
	else
		echo "*** Removing live-logs Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$(date +%T) - Removal of live-logfiles failed. (Returncode: $?)" | tee -a $LOGPATH/$WEEKLOGFILE
fi

echo "" >> $LOGPATH/$LOGFILE
