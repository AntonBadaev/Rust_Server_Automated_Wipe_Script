This script has been tested only on Ubuntu 22.04 selfhosted server, and is designed for modded Rust servers requiring weekly wipes.

**Here's how the script operates on Linux systems:**

1. stops the Rust server service.
2. initiates an update for the server.
3. downloads a new version of Oxide.
4. extracts Oxide into the server's RustDedicated_Data/Managed directory. Note, the archive should be located in the same directory as your Rust server, typically at ~/server.
5. adds necessary permissions for the server admin user on RustDedicated_Data/Managed/*.
6. removes map files during the first week.
7. removes both map and player files (blueprints) during the second week.
8. deletes Oxide files after they've been downloaded.
9. starts the server, sending a notification through the Telegram bot upon successful launch.
10. pauses for 600 seconds to allow for server startup.
11. sends the status of the Rust server service via the Telegram bot.

**Prerequishes.**

**Important!** Prior to running this script, ensure you have set up a personal Telegram bot and configured your Rust server with a service for management.

To run this script, ensure you have a rustserver.service file for starting the Rust server, and place this script in the /etc/systemd/system/ directory. An example of such a service is stored in the rustserver.service file in this repository, which you need to configure for your specific server.

Upon successful execution or failure, the Telegram bot will send you messages. Alternatively, you may modify the script to monitor it with any monitoring system such as Zabbix or Grafana.

**Installation.**

Place the wipe_script.sh file in your server folder. add execute permission to file with chmod +x /path/to/wipe_script.sh

You can manually run it by executing ./wipe_script.sh.

An example of a message when the script completes its task:

![image](https://github.com/user-attachments/assets/9bd8ccff-6756-45cc-81e4-7429c9309ce0)

If you wish to automate the script's execution, simply add it to crontab:

For instance: 0 10 * * 6 /usr/bin/sudo /home/rustserver/server/wipe_script.sh, which launches the script every Saturday at 10AM.

Cosider that you need to save last_map_only_wipe.txt and last_map_and_players_wipe.txt files if u don't want to miss full wipe or map wipe.

Feel free to modify this script and adapt it to suit your requirements.
