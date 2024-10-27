# Use the weatherstation of your neighbour

> My Setup consists of a Rasperry Pi 3 and a `RTL2832U+ FC0012` Stick. 

Install:
- [rtl_433](https://github.com/merbanan/rtl_433/) by following the [installation guide](https://github.com/merbanan/rtl_433/blob/master/docs/BUILDING.md). 


Capture all devices in your vicinity. Maybe you have luck and somebody already uses a weatherstation. 
```bash
rtl_433 -f 868M
rtl_433 version 22.11-75-gcc6f4521 branch master at 202301311232 inputs file rtl_tcp RTL-SDR
Use -h for usage help and see https://triq.org/ for documentation.
Trying conf file at "rtl_433.conf"...
Trying conf file at "/home/pi/.config/rtl_433/rtl_433.conf"...
Trying conf file at "/usr/local/etc/rtl_433/rtl_433.conf"...
Trying conf file at "/etc/rtl_433/rtl_433.conf"...

New defaults active, use "-Y classic -s 250k" for the old defaults!

[Protocols] Registered 201 out of 234 device decoding protocols [ 1-4 8 11-12 15-17 19-23 25-26 29-36 38-60 63 67-71 73-100 102-105 108-116 119-121 124-128 130-149 151-161 163-168 170-175 177-197 199 201-215 217-228 230-232 234 ]
[SDR] Found 1 device(s)
[SDR] trying device  0:  Realtek, RTL2838UHIDIR, SN: 00000001
Detached kernel driver
Found Rafael Micro R828D tuner
[SDR] Using device 0: Generic RTL2832U OEM
Exact sample rate is: 1000000.026491 Hz
[R82XX] PLL not locked!
Allocating 15 zero-copy buffers
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
time      : 2024-10-27 12:58:58
model     : Bresser-6in1 id        : 13010656
channel   : 0            Battery   : 0             Temperature: 13.0 C       Humidity  : 94            Sensor type: 1            Wind Gust : 0.0 m/s
Wind Speed: 0.0 m/s      Direction : 202           UV        : 0.0           Startup   : 1             Flags     : 0             Integrity : CRC
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
time      : 2024-10-27 12:59:22
model     : Bresser-6in1 id        : 13010656
channel   : 0            Battery   : 0             Temperature: 13.0 C       Humidity  : 94            Sensor type: 1            Wind Gust : 0.5 m/s
Wind Speed: 0.5 m/s      Direction : 202           UV        : 0.0           Startup   : 1             Flags     : 0             Integrity : CRC
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
```

Configure rtl_443 by creating a `home/pi/rlt_443.conf`:
```
gain          0
frequency     868M
ppm_error     0
report_meta   time:tz
output mqtt://<ip>,user=<username>,pass=<password>,devices=rtl_433/9b13b3f4-rtl433/devices[/type][/model][/subtype][/channel][/id],events=rtl_433/9b13b3f4-rtl433/events,states=rtl_433/9b13b3f4-rtl433/states
output log
```

Setup a service (`/etc/systemd/system/rtl_433.service`): 

```
[Unit]
Description=RTL_433
Documentation=man:rtl_433
StartLimitIntervalSec=10
After=syslog.target network.target

[Service]
Type=exec
ExecStart=/usr/local/bin/rtl_433 -c /home/pi/rtl_433.conf
Restart=always
RestartSec=30s

# View with: sudo journalctl -f -u rtl_433 -o cat
SyslogIdentifier=rtl_433

[Install]
WantedBy=multi-user.target
```


## Integration with Home Assistant

> There are [Add-Ons](https://github.com/pbkhrv/rtl_433-hass-addons/tree/main/rtl_433_mqtt_autodiscovery) to do the same but I simply used manual mqtt configuration.

```
mqtt:
  sensor:
    # Neigbhours Weather Station
    - name: Temperature
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/temperature_C
      unique_id: bresser_temperature_C
      value_template: "{{ value | float }}"
      unit_of_measurement: "°C"
      device_class: temperature
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"

    - name: Humidity
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/humidity
      unique_id: bresser_humidity
      value_template: "{{ value | int }}"
      unit_of_measurement: "%"
      device_class: humidity
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"

    - name: Wind Gust
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/wind_max_m_s
      unique_id: bresser_wind_max_m_s
      value_template: "{{ value | float }}"
      unit_of_measurement: "m/s"
      device_class: "wind_speed"
      icon: mdi:weather-windy
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"

    - name: Wind Speed
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/wind_avg_m_s
      unique_id: bresser_wind_avg_m_s
      value_template: "{{ value | float }}"
      unit_of_measurement: "m/s"
      device_class: "wind_speed"
      icon: mdi:weather-windy
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"

    - name: Wind Direction Unadjusted
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/wind_dir_deg
      unique_id: bresser_wind_dir_deg_unadj
      value_template: "{{ value | int }}"
      unit_of_measurement: "°"
      icon: mdi:compass-rose
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"

    - name: Rain
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/rain_mm
      unique_id: bresser_rain_mm
      value_template: "{{ value | float }}"
      unit_of_measurement: "mm"
      device_class: "precipitation"
      icon: mdi:weather-rainy
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"

    - name: Last Updated
      state_topic: rtl_433/9b13b3f4-rtl433/devices/Bresser-6in1/0/318834262/time
      unique_id: bresser_time
      device_class: "timestamp"
      icon: mdi:clock-outline
      device:
        name: "Bresser Weather Station"
        identifiers:
          - "bresser"
```

Parts from: 
- https://www.vromans.org/johan/articles/hass_bresser51/index.html
- https://techbotch.org/blog/rtl433-autodiscovery/index.html