##Create encryption password in env variable
# eg. export DB_ENCRYPTION_PASSWORD="QATksh_2lkfDBjx"

####Starting DB backup######

NOW=$(date +"%Y%m%d")
FILE="fasp-Prod-db-$NOW.sql.gz"
ARCHIVE="fasp-Prod-db-$NOW.sql.gz.7z"
rm /home/altius/devops/fasp-Prod-db*
mysql --login-path=prod fasp < /home/altius/devops/cleanUpTmpTables.txt
mysqldump --login-path=prod fasp --routines --triggers --events --no-tablespaces --set-gtid-purged=OFF --ignore-table=fasp.ct_commit_request | gzip -9 > /home/altius/devops/fasp-Prod-db-$NOW.sql.gz
mysqldump --login-path=prod fasp ct_commit_request --skip-triggers --no-data --no-tablespaces --set-gtid-purged=OFF | gzip -9 >> /home/altius/devops/fasp-Prod-db-$NOW.sql.gz
#cp /home/altius/devops/fasp-Prod-db-$NOW.sql.gz /home/ubuntu/QAT/DB/
#lftp -e "cd QAT;put -c /home/altius/devops/fasp-Prod-db-$NOW.sql.gz; bye"  -u backup,Alt@321@us ftp.altius.cc
#sleep 10
curl -X POST "http://sairaj:11ae4f477a83f3a00d5e1a18b8f0c13341@122.187.208.2:31280/view/Alerting/job/QATDB_backup_on_server15/build"
# Check if 7z is installed
if ! command -v 7z &> /dev/null; then
    echo "7z is not installed. Installing now..."
    sudo apt update && sudo apt install p7zip-full -y
fi
# Encrypt the file using 7z with AES-256 and environment variable password
7z a -p"$DB_ENCRYPTION_PASSWORD" -mhe=on -t7z "$ARCHIVE" "$FILE"

# Check if encryption was successful
if [ -f "$ARCHIVE" ]; then
    echo "Encryption successful: $ARCHIVE"
    echo "Deleting original file..."
    rm -f "$FILE"
else
    echo "Encryption failed!"
fi
cp /home/altius/devops/fasp-Prod-db-$NOW.sql.gz.7z /home/ubuntu/QAT/DB/
