#!/bin/bash

#Name of the user
USERNAME=$1

#Current date
DATE=$2

#Name of the logfile
LOGFILE="$DATE-$USERNAME-Rsync.log"

#Path to logfile
LOGPATH=$3

#Path to source folder
SOURCEPATH=$4

#Path to target folder
TARGETPATH=$5

#Name of the weekly logfile
WEEKLOGFILE=$6

#Target IP to sync to
TARGETIP=$7

#Port that SSH uses
SSHPORT=$8

#--------------------------

#Write Date to logfile
echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

#Run Rsync backup using ssh on port 5022
sudo rsync -avzhe "ssh -p $SSHPORT" --progress --del $SOURCEPATH root@$TARGETIP:$TARGETPATH >> $LOGPATH/$LOGFILE

#Test Rsync result
if test $(echo $?) -eq 0
	then
		echo "** Success ** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$DATE - Rsync done successfully" | tee -a $LOGPATH/$WEEKLOGFILE
	else
		echo "** Fail ** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$DATE - Rsync failed" | tee -a $LOGPATH/$WEEKLOGFILE
		python3 ./sendmail.py "$LOGPATH" "$LOGFILE" "Rsync fail" | tee -a $LOGPATH/$WEEKLOGFILE
		echo "Sent mail with error log" | tee -a $LOGPATH/$WEEKLOGFILE
		exit 1
fi
