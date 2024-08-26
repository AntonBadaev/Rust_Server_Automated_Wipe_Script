#!/bin/bash

# Version 2.0 by Deviant.
# Script for automated wipe on a Rust server, with a Telegram announcement.

#=======================Explanation==========================

# Logs are saved in /PATH_TO_DIRECTORY/wipe_script.log
# The script proceeds as follows:
# 1. Stops the Rust server service
# 2. Starts an update for the server
# 3. Downloads a new version of Oxide
# 4. Unzips Oxide into the server's RustDedicated_Data/Managed directory. Note that the archive must be placed in the same directory as your Rust server, i.e., ~/server.
# 5. Adds necessary permissions for the server admin user on RustDedicated_Data/Managed/*
# 6. Removes map files every first week
# 7. Removes both map and player files (blueprints) every second week
# 8. Deletes Oxide files after they've been downloaded
# 9. Starts the server, sending a notification through the Telegram bot upon successful launch.
# 10. Pauses for 600 seconds to allow for server startup
# 11. Sends the status of the Rust server service via the Telegram bot.

# Log path
LOGFILE="/path/to/wipe_script.log"
> $LOGFILE

# Store information like Telegram API key and chat id
api_key=""
chat_id=""
server_path=/path/to/server

# Define paths to the files storing the last wipe dates
last_map_only_wipe_file="/path/to/last_map_only_wipe.txt"
last_map_and_players_wipe_file="/path/to/last_map_and_players_wipe.txt"

# Retrieve the current week
current_week=$(date +%V)

# Read the last wipe dates from file
last_map_only_wipe=$(cat $last_map_only_wipe_file 2>/dev/null || echo "0")
last_map_and_players_wipe=$(cat $last_map_and_players_wipe_file 2>/dev/null || echo "0")

# List of commands to be executed
commands=("sudo systemctl stop rustserver.service"
          "sudo /usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir $server_path +login anonymous +app_update 258550 validate +quit"
          "sudo wget -P $server_path https://umod.org/games/rust/download/develop"
          "sudo 7z x -y $server_path/develop"
          "sudo chown -R user:user $server_path/RustDedicated_Data/Managed/*"
          "sudo rm $server_path/develop"
          "sudo rm $server_path/SERVER_IDENTITY/proceduralmap*"
          "sudo systemctl start rustserver.service"
          "curl -s -X POST https://api.telegram.org/bot$api_key/sendMessage -d chat_id=$chat_id -d text='Wipe successful!'"
)

# Cycle to alternate full wipes every two weeks
for command in "${commands[@]}"; do
  if [[ $command =~ ^sudo\ rm\ $server_path/my_server_identity/proceduralmap* ]]; then
    if [[ $((current_week - last_map_and_players_wipe)) -gt $((current_week - last_map_only_wipe)) ]]; then
      echo "Removing both map and player files..." >> $LOGFILE
      command="sudo rm $server_path/my_server_identity/proceduralmap*; sudo rm $server_path/my_server_identity/player*"
      echo $current_week > $last_map_and_players_wipe_file
    else
      echo "Removing only map files..." >> $LOGFILE
      echo $current_week > $last_map_only_wipe_file
    fi
  fi

  echo "Running: $command" >> $LOGFILE
  eval "$command" >> $LOGFILE 2>&1

  # Check status of the last command
  if [ $? -eq 0 ]; then
    echo "Success" >> $LOGFILE
  else
    echo "Error" >> $LOGFILE
    curl -s -X POST https://api.telegram.org/bot$api_key/sendMessage -d chat_id=$chat_id -d text="The script encountered errors while running"
    exit 1
  fi
done

echo "Script exited successfully" >> $LOGFILE

# Pause for 10 minutes to allow for full server startup.
sleep 600
rustserverstatus=$(systemctl status rustserver.service)

# Send the service status via Telegram
curl -s -X POST https://api.telegram.org/bot$api_key/sendMessage -d chat_id=$chat_id -d text="$rustserverstatus"
