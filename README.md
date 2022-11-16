# log2screen

A simple block which disables the plymouth service on boot, and prints device and application info and the journal logs to any attached HDMI display.

Add the `bh.cr/balenalabs/fbcp` block if you are using a RaspberryPi and have a PiDisplay or TFT attached.

Add it to your application by adding the following service to your `docker-compose.yml` file:

```yaml
logging:
  image: bh.cr/balenalabs/log2screen
  privileged: true
  restart: always
  network_mode: host
  environment:
    - 'DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket'
  labels:
    io.balena.features.dbus: 1
    io.balena.features.supervisor-api: 1
```
