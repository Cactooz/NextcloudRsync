#!/bin/bash

#Name of the file/folder
NAME=$1

#Path to source folder
SOURCEPATH=$2

#Path to target folder
TARGETPATH=$3

#Current date
DATE=$4

#Name of the logfile
LOGFILE="$DATE-$NAME-Rsync.log"

#Path to logfile
LOGPATH=$5

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
echo "$DATE - Starting Rsync job for $NAME" | tee -a "$LOGPATH/$LOGFILE"
sudo rsync -avzhe "ssh -p $SSHPORT" --progress --del $SOURCEPATH root@$TARGETIP:$TARGETPATH >> $LOGPATH/$LOGFILE

#Test Rsync result
if test $(echo $?) -eq 0
	then
		echo "** Success ** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$DATE - Rsync done successfully" | tee -a $LOGPATH/$WEEKLOGFILE
	else
		echo "** Fail ** Returncode: $?" >> $LOGPATH/$LOGFILE
		echo "$DATE - Rsync failed" | tee -a $LOGPATH/$WEEKLOGFILE
		python3 ./sendmail.py "$LOGPATH" "$LOGFILE"
		echo "Sent mail with error log"
		exit 1
fi

echo "" | tee -a "$LOGPATH/$LOGFILE"