#!/bin/bash

DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket dbus-send --system --dest=org.freedesktop.systemd1 --type=method_call --print-reply /org/freedesktop/systemd1   org.freedesktop.systemd1.Manager.StartUnit string:"plymouth-quit.service" string:"replace"

curl -X PATCH --header "Content-Type:application/json" --data '{"network": {"hostname": "balena"}}' "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY"

curl -X POST -H "Content-Type: application/json" --data '{"follow":true,"all":true,"format":"short","unit":"balena"}' "$BALENA_SUPERVISOR_ADDRESS/v2/journal-logs?apikey=$BALENA_SUPERVISOR_API_KEY" > /dev/tty0