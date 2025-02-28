#!/bin/bash
#    ___                    
#   / _ \___ _    _____ ____
#  / ___/ _ \ |/|/ / -_) __/
# /_/   \___/__,__/\__/_/   
#                           

terminate_clients() {
  TIMEOUT=5
  # Get a list of all client PIDs in the current Hyprland session
  client_pids=$(hyprctl clients -j | jq -r '.[] | .pid')

  # Send SIGTERM (kill -15) to each client PID and wait for termination
  for pid in $client_pids; do
    echo ":: Sending SIGTERM to PID $pid"
    kill -15 $pid
  done

  start_time=$(date +%s)
  for pid in $client_pids; do
    # Wait for the process to terminate
    while kill -0 $pid 2>/dev/null; do
      current_time=$(date +%s)
      elapsed_time=$((current_time - start_time))

      if [ $elapsed_time -ge $TIMEOUT ]; then
        echo ":: Timeout reached."
        return 0
      fi

      echo ":: Waiting for PID $pid to terminate..."
      sleep 1
    done

    echo ":: PID $pid has terminated."
  done
}

if [[ "$1" == "exit" ]]; then
  echo ":: Exit"
  terminate_clients
  sleep 0.5
  hyprctl dispatch exit
  sleep 2
fi

if [[ "$1" == "lock" ]]; then
  echo ":: Lock"
  sleep 0.5
  hyprlock
fi

if [[ "$1" == "reboot" ]]; then
  echo ":: Reboot"
  terminate_clients
  sleep 0.5
  systemctl reboot
fi

if [[ "$1" == "shutdown" ]]; then
  echo ":: Shutdown"
  terminate_clients
  sleep 0.5
  systemctl poweroff
fi

if [[ "$1" == "suspend" ]]; then
  echo ":: Suspend"
  sleep 0.5
  systemctl suspend
fi

if [[ "$1" == "hibernate" ]]; then
  echo ":: Hibernate"
  sleep 1
  systemctl hibernate
fi
