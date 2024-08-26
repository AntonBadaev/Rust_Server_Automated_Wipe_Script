#!/bin/bash

#Версия 1.0 by Deviant.
#Скрипт для автоматическорго вайпа сервера, с оповещением в телеграмм.

#=======================что делает скрипт==========================

#Пишет логи в /home/rustserver/wipe_script.log

#1. остановка сервиса
#2. запуск обновления сервера
#3. скачивание новой версии oxide
#4. распаковка oxide сразу в директорию RustDedicated_Data/Managed/
#5. задает права для папки и подпапок RustDedicated_Data/Managed/* пользователю rustserver
#6. удаляет файлы карт
#7. (раз в 2 недели) Для полного вайпа удаляет и карту и блюпринты.
#8. удаляет скачанные файлы oxide
#9. запускает сервер и проверяет что моды работают.

LOGFILE="/home/rustserver/wipe_script.log"
> $LOGFILE

commands=("sudo systemctl stop rustserver.service"
"sudo /usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /home/rustserver/server +login anonymous +app_update 258550 validate +quit"
"sudo wget -P /home/rustserver/ https://umod.org/games/rust/download/develop"
"sudo 7z x -y /home/rustserver/develop"
"sudo chown -R rustserver:rustserver /home/rustserver/server/RustDedicated_Data/Managed/*"
"sudo rm /home/rustserver/server/server/my_server_identity/proceduralmap*"
"sudo rm /home/rustserver/develop"
"sudo systemctl start rustserver.service"
"curl -s -X POST https://api.telegram.org/bot7497623677:AAGLfhilJtpJbwOlD41iEGSDS-7R4JWnBO8/sendMessage -d chat_id=1075510365 -d text='Вайп прошел успешно!'"
)

for command in "${commands[@]}"; do
  echo "Выполняется: $command" >> $LOGFILE
  eval $command >> $LOGFILE 2>&1

  # Проверяем статус выхода последней команды
  if [ $? -eq 0 ]; then
    echo "Успешно" >> $LOGFILE
  else
    echo "Ошибка " >> $LOGFILE
    curl -s -X POST https://api.telegram.org/bot7497623677:AAGLfhilJtpJbwOlD41iEGSDS-7R4JWnBO8/sendMessage -d chat_id=1075510365 -d text="Вайп пошел по пизде!"
    exit 1
  fi
done

echo "Скрипт выполнен успешно" >> $LOGFILE

sleep 600
rustserverstatus=$(systemctl status rustserver)
curl -s -X POST https://api.telegram.org/bot7497623677:AAGLfhilJtpJbwOlD41iEGSDS-7R4JWnBO8/sendMessage -d chat_id=1075510365 -d text="echo '$rustserverstatus'"

