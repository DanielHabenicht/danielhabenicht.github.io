# Integrate LEDVANCE SUN@HOME in Homeassistant

1. Get local keys: 

```bash
git clone https://github.com/FlagX/ha-ledvance-tuya-resync-localkey
cd ha-ledvance-tuya-resync-localkey
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python print-local-keys.py
```

2. Integrate in Homeassistant with: [Local Tuya](https://github.com/rospogrigio/localtuya/)


> You can check the values with [Tinytuya](https://github.com/jasonacox/tinytuya):
> 
> ```python
> from time import sleep
> import tinytuya
> 
> # tinytuya.set_debug(True)
> d = tinytuya.Device('your_device_id', 'your_device_ip', 'your_device_key', version=3.3)
> data = d.status() 
> print('Device status: %r' % data)
> ```

For the lamp `LEDVANCE SUN@HOME FRA 30X30` I used the following values: 

```
ID: 20
Brightness: 22
Color Temperature: 23 
Brightness lower Value: 0 
Brightness upper Value: 1000
Color Mode: 21
Color: Do not fill in, as it is not supported
min color temp: 2200
max color temp: 5000
```

> From: https://knx-user-forum.de/forum/%C3%B6ffentlicher-bereich/geb%C3%A4udetechnik-ohne-knx-eib/1898515-guide-ledvance-sun-home-in-homeassistant-mittels-localtuya


3. Use [Adaptive Lighting](https://github.com/basnijholt/adaptive-lighting) to adjust the color or temperature of the lamp according to the time of day.