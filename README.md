This script tested only on Ubuntu 22.04.

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

To running this script, make sure you have rustserver.service for starting Rust server. Example of service stored in file rustserver.service you need to configurate this for your server. 
And you need to have Telegram bot if u want to send notifications like this.
![image](https://github.com/user-attachments/assets/7f51221a-6c77-4f6c-9d52-2a06463e640a)

You can change this script, and use it for any purpose. 
