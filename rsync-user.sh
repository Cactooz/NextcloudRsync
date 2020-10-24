#!/bin/bash
DATE=$(date +%Y-%m-%d-%H:%M)

#Name of the user
USERNAME=user

#Path to logfile
LOGPATH=/var/log/rsync

#Path to source folder
SOURCEPATH=/media/usb/ncdata/$USERNAME/files

#Path to target folder
TARGETPATH=/media/usb/backup/$USERNAME

#Write Date to logfile
echo '---' $DATE '---' > $LOGPATH/$DATE'Rsync.log'

#Run Rsync backup
sudo rsync -avzhe 'ssh -p 5022' --progress  --del $SOURCEPATH user@random.ip.net:$TARGETPATH >> $LOGPATH/$DATE'Rsync.log'

#Test Rsync result
if test $(echo $?) -eq 0
then
	echo '** Success ** Returncode:' $?  >> $LOGPATH/$DATE'Rsync.log'
	echo 'Done successfully' $DATE
else
	echo '** Failed ** Returncode:' $?  >> $LOGPATH/$DATE'Rsync.log'
fi
