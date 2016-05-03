#! /bin/sh

SERVER_NAME=sinatraboot
sudo ln -s /etc/init.d/$SERVER_NAME /home/denley/work/RubyTest/sinatra_auto_boot.sh
sudo update-rc.d $SERVER_NAME defaults
