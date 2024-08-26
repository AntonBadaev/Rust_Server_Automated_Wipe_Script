This script tested only on Ubuntu 22.04. Created for modded servers with wipe time every week. 

The script proceeds as follows for Linux systems:

1. Stops the Rust server service
2. Starts an update for the server
3. Downloads a new version of Oxide
4. Unzips Oxide into the server's RustDedicated_Data/Managed directory. Note that the archive must be placed in the same directory as your Rust server, i.e., ~/server.
5. Adds necessary permissions for the server admin user on RustDedicated_Data/Managed/*
6. Removes map files every first week
7. Removes both map and player files (blueprints) every second week
8. Deletes Oxide files after they've been downloaded
9. Starts the server, sending a notification through the Telegram bot upon successful launch.
10. Pauses for 600 seconds to allow for server startup
11. Sends the status of the Rust server service via the Telegram bot.

Important! Before run this script you need to make sure you have personal Telegram bot and configurated Rust server with service to manage startup.

To running this script, make sure you have rustserver.service for starting Rust server, and place this file into /etc/systemd/system/ directory.  Example of service stored in file rustserver.service in this repo and you need to configurate this for your server. 

If script succesful or failed Telegram bot will send you massages. Or u can modify script and just monitor it with any Monitoring system like Zabbix or Grafana.

Example of message:
![image](https://github.com/user-attachments/assets/7f51221a-6c77-4f6c-9d52-2a06463e640a)

If u want to start it automaticly just add this to crontab:

example: 0 10 * * 6 /usr/bin/sudo /home/rustserver/server/wipe_script.sh this launch script every 6 day of week at 10AM 

You can change this script, and use it for any purpose. 
