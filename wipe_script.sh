#!/bin/bash

# Version 1.0 by Deviant.
# Script for automated wipe on a Rust server, with a Telegram announcement.

#=======================Explanation==========================

# Logs are saved in /PATH_TO_DIRECTORY/wipe_script.log
# Then script start doing this:
# 1. Stop the Rust server service
# 2. Start an update for the server
# 3. Download a new version of Oxide
# 4. Unzip Oxide to the server directory RustDedicated_Data/Managed/*. The archive needs to be in the same directory as your Rust server, i.e., ~/server directory
# 5. Add permissions to RustDedicated_Data/Managed/* for the server admin user
# 6. Every first week, remove map files
# 7. Every second week, remove map and player files (blueprints)
# 8. Remove Oxide files after downloading.
# 9. Run the server. If successful, notify via the Telegram bot.
# 10. Sleep for 600 seconds while server starting
# 11. Send status of rust service via Telegram bot.

LOGFILE="/PATH_TO_DIRECTORY/wipe_script.log"
> $LOGFILE

commands=("sudo systemctl stop RUST_SERVER.service"
"sudo /usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /PATH_TO_SERVERFILES +login anonymous +app_update 258550 validate +quit"
"sudo wget -P /PATH_TO_DOWNLOAD_DIRECTORY https://umod.org/games/rust/download/develop"
"sudo 7z x -y /PATH_TO_OXIDE_ARCHIVE"
"sudo chown -R USER:USER /PATH_TO_SERVER_FILES/server/RustDedicated_Data/Managed/*"
"sudo rm /PATH_TO_SERVER_FILES/server/SERVER_IDENTITY/proceduralmap*"
"sudo rm /PATH_TO_OXIDE_ARCHIVE"
"sudo systemctl start your_rust_server_service"
"curl -s -X POST https://api.telegram.org/bot"Bot API key here without quotes"/sendMessage -d chat_id="your chat id" -d text='Wipe successful!'"
)

for command in "${commands[@]}"; do
  echo "Running: $command" >> $LOGFILE
  eval "$command" >> $LOGFILE 2>&1

  # Check the exit status of the last command
  if [ $? -eq 0 ]; then
    echo "Success" >> $LOGFILE
  else
    echo "Error" >> $LOGFILE
    curl -s -X POST https://api.telegram.org/bot"Bot API key here without quotes"/sendMessage -d chat_id="your chat id" -d text="The script encountered errors while running"
    exit 1
  fi
done

echo "Script exited successfully" >> $LOGFILE

sleep 600

rustserverstatus=$(systemctl status RUST_SERVER.service)

curl -s -X POST https://api.telegram.org/bot"Bot API key here without quotes"/sendMessage -d chat_id="your chat id" -d text="$rustserverstatus"
