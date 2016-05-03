#!/bin/bash
### BEGIN INIT INFO
# Provides:          hsiao
# Required-Start:    $remote_fs $syslog $network
# Required-Stop:     $remote_fs $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: sinatra auto-boot
# Description:       sinatra auto-boot after start OS.
### END INIT INFO


PATH=/sbin:/bin:/usr/bin:/usr/sbin

# change theses values (default values)
PROG_USER=denley
PROG=sinatra_main
PROG_FILE=$PROG.rb
PROG_PATH=/home/$PROG_USER/work/RubyTest
PROG_PID=$PROG_PATH/$PROG.pid
PROG_ARGS="-o 0.0.0.0"

RETVAL=0

case "$1" in
  start)
    if [ -f $PROG_PATH/$PROG_FILE ];
      then
      echo $"Starting $PROG server"
      start-stop-daemon --start --quiet --background --oknodo --make-pidfile --pidfile $PROG_PID --exec $PROG_PATH/$PROG_FILE -- $PROG_ARGS
      exit $RETVAL
    fi
  ;;

  stop)
    if [ -f $PROG_PATH/$PROG_FILE ];
      then
      echo $"Stopping $PROG server"
      start-stop-daemon --stop --quiet --oknodo --pidfile $PROG_PID
      exit $RETVAL
    fi
  ;;
  
  force-reload|restart)
      $0 stop
      sleep 5
      $0 start
  ;;

  *)
    echo $"Usage: /etc/init.d/$PROG {start|stop|restart|force-reload}"
    exit 1
  ;;
esac

exit $RETVAL
