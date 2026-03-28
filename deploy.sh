#!/bin/bash

REPO_DIR="/home/$USER/devops-projects/gitops-lite-website"
WEB_DIR="/var/www/gitops-lite"
LOG_FILE="/home/$USER/devops-projects/deploy.log"

cd $REPO_DIR || exit

LOCAL_HASH=$(git rev-parse main)
REMOTE_HASH=$(git rev-parse origin/main)

if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo "$(date): Changes detected. Pulling new code..." >> $LOG_FILE
    
    git pull origin main
    
    cp -r * $WEB_DIR/
    
    echo "$(date): Deployment successful." >> $LOG_FILE
else
    exit 0
fi
