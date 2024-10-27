# Read Techem Heat Cost Allocator

> My Setup consists of a Rasperry Pi 3 and a `RTL2832U+ FC0012` Stick. 

## Installation

Install:
- [rtl_433](https://github.com/merbanan/rtl_433/) by following the [installation guide](https://github.com/merbanan/rtl_433/blob/master/docs/BUILDING.md). 
- [rtl-wmbus](https://github.com/xaelsouth/rtl-wmbus) with `make install`
- [wmbusmeters](https://github.com/weetmuts/wmbusmeters)

```
wmbusmeters --logtelegrams rtlwmbus:434.47M
```

Create a `/etc/wmbusmeters.conf`
```conf
loglevel=normal
device=rtlwmbus
logtelegrams=true
format=json
# Log Meter Reading locally (uncomment for longer use)
meterfiles=/var/lib/wmbusmeters/meter_readings
meterfilesaction=append
meterfilesnaming=id
logfile=/var/log/wmbusmeters/wmbusmeters.log

# Publish Reading to MQTT to integrate with Home Assistant
shell=/usr/bin/mosquitto_pub -h <ip> -u <username> -P <password> -t wmbusmeters/$METER_ID -m "$METER_JSON"
```

Add it as a service: 


```conf
[Unit]
Description="wmbusmeters service"
Documentation=https://github.com/weetmuts/wmbusmeters
Documentation=man:wmbusmeters(1)
After=network.target
StopWhenUnneeded=false
StartLimitIntervalSec=10
StartLimitInterval=10
StartLimitBurst=3

[Service]
Type=forking
PrivateTmp=yes
User=wmbusmeters
Group=wmbusmeters
Restart=always
RestartSec=1

# Run ExecStartPre with root-permissions
PermissionsStartOnly=true
ExecStartPre=-/bin/mkdir -p /var/lib/wmbusmeters/meter_readings
ExecStartPre=/bin/chown -R wmbusmeters:wmbusmeters /var/lib/wmbusmeters/meter_readings
ExecStartPre=-/bin/mkdir -p /var/log/wmbusmeters
ExecStartPre=/bin/chown -R wmbusmeters:wmbusmeters /var/log/wmbusmeters
ExecStartPre=-/bin/mkdir -p /run/wmbusmeters
ExecStartPre=/bin/chown -R wmbusmeters:wmbusmeters /run/wmbusmeters

ExecStart=/usr/sbin/wmbusmetersd /run/wmbusmeters/wmbusmeters.pid
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/wmbusmeters/wmbusmeters.pid

[Install]
WantedBy=multi-user.target
```

## Integrate with Home Assistant

```yaml
mqtt:
  sensor:
    # Durchgangszimmer
    - state_topic: "wmbusmeters/55252983"
      json_attributes_topic: "wmbusmeters/55252983"
      unit_of_measurement: units
      value_template: "{{ value_json.current_hca }}"
      name: HCA Current
      state_class: total_increasing
      unique_id: hca_55252983_hca_current
      object_id: hca_55252983_hca_current
      device:
        identifiers: "55252983"
        manufacturer: "Techem"
        model: "III"
        name: "Techem HCA Livingroom"
    - state_topic: "wmbusmeters/55252983"
      json_attributes_topic: "wmbusmeters/55252983"
      unit_of_measurement: units
      value_template: "{{ value_json.previous_hca }}"
      name: HCA Previous
      unique_id: hca_55252983_hca_previous
      object_id: hca_55252983_hca_previous
      state_class: total_increasing
      device:
        identifiers: "55252983"
    - state_topic: "wmbusmeters/55252983"
      json_attributes_topic: "wmbusmeters/55252983"
      unit_of_measurement: °C
      value_template: "{{ value_json.temp_room_c }}"
      name: Temperature Room
      unique_id: hca_55252983_temp_room
      object_id: hca_55252983_temp_room
      device:
        identifiers: "55252983"
    - state_topic: "wmbusmeters/55252983"
      json_attributes_topic: "wmbusmeters/55252983"
      unit_of_measurement: °C
      value_template: "{{ value_json.temp_radiator_c }}"
      name: Temperature Radiator
      unique_id: hca_55252983_temp_radiator
      object_id: hca_55252983_temp_radiator
      device:
        identifiers: "55252983"
```

Add Statistic: 

```yaml
sensor:
- platform: statistics
  name: ""
  unique_id: hca_55252983_hca_current_usage_24h
  entity_id: sensor.hca_55252983_hca_current
  state_characteristic: change
  max_age:
    hours: 24
  sampling_size: 3500
```


## Manually capturing unknown wmbusmeter devices

```bash
# Use Specific Range and capture all packets for later analysis
rtl_sdr -f 433M -s 1600000 - | rtl_wmbus | tee test.log

# Decode known packages
cat test.log | wmbusmeters stdin:rtlwmbus
```