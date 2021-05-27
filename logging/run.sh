#!/bin/bash

# quit the plymouth (balena logo) service so that we can see the TTY
DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket dbus-send --system --dest=org.freedesktop.systemd1 --type=method_call --print-reply /org/freedesktop/systemd1   org.freedesktop.systemd1.Manager.StartUnit string:"plymouth-quit.service" string:"replace" > /dev/null
# try and set the hostname to 'balena'
curl -X -s PATCH --header "Content-Type:application/json" --data '{"network": {"hostname": "balena"}}' "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY" > /dev/null

while true
do
    clear > /dev/tty0
    # print the application name
    echo -e "\033[0;34mApplication name: \033[0;33m $BALENA_APP_NAME \033[0m" > /dev/tty0

    #Get the IP address from the supervisor
    IP=$(curl -X GET -s --header "Content-Type:application/json"     "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq '.ip_address' | sed 's/"//g') 
    echo -e "\033[0;34mLocal IP address: \033[0;33m $IP \033[0m" > /dev/tty0
    echo -e "\033[0;34mHostname: \033[0;33m $HOSTNAME \033[0m" > /dev/tty0
    echo -e "\033[0;36mPoint your browser at \033[0;32mhttp://$HOSTNAME \033[0;36mor \033[0;32mhttp://$IP \033[0;36mto get started! \033[0m" > /dev/tty0

    # print the status of the services in json pretty-print
    echo "Services:" > dev/tty0
    curl -s "$BALENA_SUPERVISOR_ADDRESS/v2/applications/state?apikey=$BALENA_SUPERVISOR_API_KEY" | jq > /dev/tty0
    
    # Log the journal to the TTY for 20 seconds
    curl -X POST -m 20 -s -H "Content-Type: application/json" --data '{"follow":true,"all":true,"format":"short","unit":"balena"}' "$BALENA_SUPERVISOR_ADDRESS/v2/journal-logs?apikey=$BALENA_SUPERVISOR_API_KEY" | grep -v 'journal' > /dev/tty0
done

balena-idle