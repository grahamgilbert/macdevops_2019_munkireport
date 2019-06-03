cat <<"EOF" > /home/ubuntu/update_ssh_authorized_keys.sh
#!/usr/bin/env bash
set -e
SSH_USER=ubuntu
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_SCRIPT"
KEYS_FILE=/home/$SSH_USER/.ssh/authorized_keys
TEMP_KEYS_FILE=$(mktemp /tmp/authorized_keys.XXXXXX)
GIT_REPO=/tmp/macdevops_2019_munkireport
PUB_KEYS_DIR=$GIT_REPO/pub_keys
PATH=/usr/local/bin:$PATH

/bin/rm -rf $GIT_REPO
/usr/bin/git clone https://github.com/grahamgilbert/macdevops_2019_munkireport /tmp/macdevops_2019_munkireport

# Add marker, if not present, and copy static content.
grep -Fxq "$MARKER" $KEYS_FILE || echo -e "\n$MARKER" >> $KEYS_FILE
line=$(grep -n "$MARKER" $KEYS_FILE | cut -d ":" -f 1)
head -n $line $KEYS_FILE > $TEMP_KEYS_FILE

for filename in $PUB_KEYS_DIR/*; do
    sed 's/\n\?$/\n/' < $filename >> $TEMP_KEYS_FILE
done
# Move the new authorized keys in place.
chown $SSH_USER:$SSH_USER $KEYS_FILE
chmod 600 $KEYS_FILE
mv $TEMP_KEYS_FILE $KEYS_FILE
# if [[ $(command -v "selinuxenabled") ]]; then
#     restorecon -R -v $KEYS_FILE
# fi
EOF
# cat <<"EOF" > /home/ubuntu/.ssh/config
# Host *
#     StrictHostKeyChecking no
# EOF
chmod 600 /home/ubuntu/.ssh/config
chown ubuntu:ubuntu /home/ubuntu/.ssh/config
chown ubuntu:ubuntu /home/ubuntu/update_ssh_authorized_keys.sh
chmod 755 /home/ubuntu/update_ssh_authorized_keys.sh
# Execute now
su ubuntu -c /home/ubuntu/update_ssh_authorized_keys.sh
keys_update_frequency="5,20,35,50 * * * *"
# Add to cron
if [ -n "$keys_update_frequency" ]; then
  croncmd="/home/ubuntu/update_ssh_authorized_keys.sh"
  cronjob="$keys_update_frequency $croncmd"
  ( crontab -u ubuntu -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ubuntu -
fi