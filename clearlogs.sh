#!/bin/bash

#Name of the logfile
LOGFILE=$1

#Path to logfile
LOGPATH=$2

#--------------------------

# Remove logfiles older than 30 days
rm $(find $LOGPATH -name "*.log" -type f -mtime +30) | tee -a "$LOGPATH/$LOGFILE"
