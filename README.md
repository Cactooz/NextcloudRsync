# Nextcloud Rsync
Rsync scripts to backup your Nextcloud data to another machine.

The repository also includes mail scripts that sends mails with error logs and weekly logfiles to a specified receiver.

## Compatibility
These scripts are made in Shell for Linux.

Tested using Nextcloud versions 18-20 and Ubuntu.

## Installation
* Install Nextcloud and configure it
* Download this script (`git clone https://github.com/Cactooz/NextcloudRsync`)
* Configure all variables (in `rsync.sh` and `sendmail.py`)
* Configure automatic executions (using crontab or similar)

## Rsync scripts
Scripts that backups you Nextcloud using Rsync over SSH.

### Features
Supports both user folders and other files and folders.

Users are added in the `USERNAMES` array in `rsync.sh`.

Special jobs are added in the `SPECIALJOBS` array in `rsync.sh`.

### Configuration
Before use make sure to configure the following variables in `rsync.sh`.
More information can be found in the file itself.

#### Normal Config
* `LOGFILE` - The file name of the logfile used (Recomended to leave untouched)
* `LOGPATH` - The file path to the logfile used (Recomended to leave untouched)
* `SOURCEPATH` - Path where the backup data is located
* `TARGETPATH` - Path where the backuped date should be sent
* `TARGETIP` - IP to the server/computer that should recive the data
* `SSHPORT` - Port for SSH that Rsync should use
* `USERNAMES` - Array of users folder that should be backed up, specified with spaces in-between
* `DAYS` - After how many days the logs should be removed

#### Special Config
* `SPECIALJOBS` - Array of special files and folders

## Mail scripts
These scripts sends a mail with errorlogs and weeklylog files.

### Compatibility
Currently supporting TLS email servers.

SSL is not tested.

### Configuration
To use mail scripts you need to configure the following variables in `sendmail.py`.
More information can be found in the file itself.

* `fromaddress` - The adress the mail will be sent from
* `toaddress` - The adress that will receive the email
* `username` - Username of the `fromadress`
* `password` - Password for the `fromadress`
* `ip` - IP to the server for the `fromadress`
* `port` - Port to the server for the `fromadress`

Examples are pre-filled in the `sendmail.py` file.

### Disable error log mails
To disable error logs emails, remove this line
[`python3 ./sendmail.py "$LOGPATH" "$LOGFILE" "Rsync fail" 2>&1 | tee -a $LOGPATH/$LOGFILE`](https://github.com/Cactooz/NextcloudRsync/blob/0e87681c298fad22b9c887cd9d42425c03f5c36e/rsync-job.sh#L78-L90)
and the following if error checks in `rsync-job.sh`
(Click the link to get it highlighted)

### Weekly mails
To get weekly mails the `weeklymails.sh` script needs to be executed once a week, preferably at Sundays or Mondays.

#### Using Cron
The script can be executed using cron jobs.
The following into your crontab jobs file:
```
#Send a weekly mail about the weeks Rsync jobs (Sunday at 18:00)
0 18 * * 0 <USER> cd <DIRECTORY> && ./weeklymail.sh
```
##### Configuration
Configure the variables before saving.
* `<USER>` - The Linux user that should execute the job
* `<DIRECTORY>` - The directory that all the scripts are located inside

## Coming features

### Being worked on
* Discord Webhook integration

### Likley
* Large backup size difference check
* Send mail for SSL mail servers

### Possibly
* Config file
* Setup command for automatic setup
