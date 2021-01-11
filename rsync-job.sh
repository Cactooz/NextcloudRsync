#!/bin/bash

#-------DESCRIPTION--------
#Executes a Rsync job for a folder/file.
#If the job fails it sends an error mail.

#-----NEEDED SCRIPTS-------
#sendmail.py to send an error email

#-----COMMAND LAYOUT-------
#./rsync-job.sh JOBNAME DATE LOGPATH SOURCEPATH TARGETPATH WEEKLOGFILE TARGETIP SSHPORT

#---------CONFIG-----------
#Name of the job (recived from command arguments, recomended to leave untouched)
JOBNAME=$1

#Current date (recived from command arguments, recomended to leave untouched)
DATE=$2

#Name of the logfile (recomended to leave untouched)
LOGFILE="$DATE-$JOBNAME-Rsync.log"

#Name of the logfile that gets the live data (recomended to leave untouched)
LIVELOGFILE="$DATE-$JOBNAME-Rsync.livelog"

#Path to logfile (recived from command arguments, recomended to leave untouched)
LOGPATH=$3

#Path to source folder (recived from command arguments, recomended to leave untouched)
SOURCEPATH=$4

#Path to target folder (recived from command arguments, recomended to leave untouched)
TARGETPATH=$5

#Name of the weekly logfile (recived from command arguments, recomended to leave untouched)
WEEKLOGFILE=$6

#Target IP to sync to (recived from command arguments, recomended to leave untouched)
TARGETIP=$7

#Port that SSH uses (recived from command arguments, recomended to leave untouched)
SSHPORT=$8

#--------------------------

#Sending help command
if [ "$1" = "-h" ]
then
	echo "DESCRIPTION"
	echo "Executes a Rsync job for a folder/file."
	echo "If the job fails it sends an error mail."
	echo ""
	echo "COMMAND LAYOUT"
	echo "./rsync-job.sh JOBNAME DATE LOGPATH SOURCEPATH TARGETPATH WEEKLOGFILE TARGETIP SSHPORT"
	echo ""
	echo "NEEDED SCRIPTS"
	echo "sendmail.py to send an error email"
	
	exit 0
fi
	
#Write Date to logfile
echo "--- $DATE ---" >> $LOGPATH/$LOGFILE

#Run Rsync backup using ssh on port 5022
sudo rsync -avzhe "ssh -p $SSHPORT" --progress --del $SOURCEPATH root@$TARGETIP:$TARGETPATH --log-file=$LOGPATH/$LOGFILE 2>&1 | tee -a $LOGPATH/$LIVELOGFILE

ERRORCODE=${PIPESTATUS[0]}

#Test Rsync result
if [ "$ERRORCODE" -eq "0" ]
then
	echo "*** Rsync Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
	echo "$(date +%T) - Rsync for $JOBNAME done successfully" | tee -a $LOGPATH/$WEEKLOGFILE
else
	echo "*** Rsync Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
	echo "$(date +%T) - Rsync for $JOBNAME failed" | tee -a $LOGPATH/$WEEKLOGFILE
	python3 ./sendmail.py "$LOGPATH" "$LOGFILE" "Rsync fail" 2>&1 | tee -a $LOGPATH/$LOGFILE

	MAILERRORCODE=${PIPESTATUS[0]}

	if [ "$MAILERRORCODE" -eq "0" ]
		then
			echo "*** Mail Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
			echo "$(date +%T) - Sent mail with error log" | tee -a $LOGPATH/$WEEKLOGFILE
		else
			echo "*** Mail Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
			echo "$(date +%T) - Could not send mail with error log" | tee -a $LOGPATH/$WEEKLOGFILE
			
			exit $MAILERRORCODE
	fi

	python3 ./webhook.py $LOGPATH $LOGFILE "Rsync Error" 16711680

	WEBHOOKERRORCODE=${PIPESTATUS[0]}

	if [ "$WEBHOOKERRORCODE" -eq "0" ]
		then
			echo "*** Webhook Success *** Returncode: $?" >> $LOGPATH/$LOGFILE
			echo "$(date +%T) - Sent webhook with error log" | tee -a $LOGPATH/$WEEKLOGFILE
		else
			echo "*** Webhook Fail *** Returncode: $?" >> $LOGPATH/$LOGFILE
			echo "$(date +%T) - Could not send webhook with error log" | tee -a $LOGPATH/$WEEKLOGFILE
			
			exit $WEBHOOKERRORCODE
	fi

	exit $ERRORCODE
fi

exit 0
