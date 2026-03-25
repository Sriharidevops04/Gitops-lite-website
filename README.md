# GitOps-Lite: Automated Web Deployment Pipeline

This project is a lightweight, fully automated Continuous Deployment (CD) pipeline built entirely with foundational Linux tools. It watches a GitHub repository for changes and automatically pulls and deploys updates to a local Nginx web server.

It serves as a practical demonstration of GitOps principles, using version control as the single source of truth for infrastructure and content, without relying on heavier CI/CD platforms like Jenkins or GitHub Actions.

## 🛠️ Tech Stack
* **Operating System:** Linux (Ubuntu)
* **Web Server:** Nginx
* **Version Control:** Git & GitHub
* **Automation:** Bash Scripting & Cron

## ⚙️ How It Works
1. Code changes (HTML/CSS) are pushed to the `main` branch of this GitHub repository.
2. A local Linux `cron` job executes a deployment script (`deploy.sh`) every minute.
3. The script compares the local Git hash with the remote Git hash.
4. If changes are detected, the script pulls the latest code, copies it to the Nginx web directory, and logs the deployment.
5. If no changes are detected, the script exits silently.

## 🚀 Setup Instructions

### 1. Web Server Setup
Install Nginx and create the target web directory:
```bash
sudo apt update && sudo apt install nginx -y
sudo mkdir -p /var/www/gitops-lite
sudo chown -R ubuntu:ubuntu /var/www/gitops-lite


Create a deploy.sh script on the host server:
#!/bin/bash

# Define variables (Use absolute paths, see Troubleshooting below)
REPO_DIR="/home/ubuntu/devops-projects/Gitops-lite-website"
WEB_DIR="/var/www/gitops-lite"
LOG_FILE="/home/ubuntu/devops-projects/deploy.log"

cd $REPO_DIR || exit
git fetch origin main

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


Add the following job to your crontab (crontab -e) to run the script every minute:
* * * * * /home/ubuntu/devops-projects/deploy.sh
