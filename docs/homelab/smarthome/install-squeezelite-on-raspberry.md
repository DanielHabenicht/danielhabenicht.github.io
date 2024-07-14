# Add Squeezelite to an existing Raspberry installation

```bash
# Install required dependencies
sudo apt-get update
sudo apt-get install libasound2-dev libflac-dev libmad0-dev libvorbis-dev libfaad-dev libmpg123-dev liblircclient-dev libncurses5-dev

# Download the latest squeezlite version
# https://sourceforge.net/projects/lmsclients/files/squeezelite/
cd /home/pi
mkdir squeezelite
cd squeezelite
wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/squeezelite-2.0.0.1486-armhf.tar.gz
tar -xzf squeezelite-2.0.0.1486-armhf.tar.gz

sudo mv squeezelite /usr/bin/squeezelite
```

Installed!

## Connect Bluetooth Speaker

```bash
sudo apt-get install pulseaudio-module-bluetooth

user@raspi$ bluetoothctl 
[NEW] Controller XX:XX:XX:XX:XX:XX raspi [default]
[bluetooth]# agent on
Agent registered
[bluetooth]# scan on
[bluetooth]# scan off
[bluetooth]# pairable on
Changing pairable on succeeded
[bluetooth]# pair XX:XX:XX:XX:XX:XX
Attempting to pair with XX:XX:XX:XX:XX:XX
[CHG] Device XX:XX:XX:XX:XX:XX Paired: yes
Pairing successful
[bluetooth]# trust XX:XX:XX:XX:XX:XX
Changing XX:XX:XX:XX:XX:XX trust succeeded
[bluetooth]# connect XX:XX:XX:XX:XX:XX
Attempting to connect to XX:XX:XX:XX:XX:XX
[CHG] Device XX:XX:XX:XX:XX:XX Connected: yes
Connection successful
[CHG] Device XX:XX:XX:XX:XX:XX ServicesResolved: yes
[bluetooth]# exit

pactl list sinks short
pactl set-default-sink 3
```


## Configuration

Try out if the command works by executing `squeezelite` on the command line with all parameter beforehand. 

```
sudo bash -c 'cat >/etc/systemd/system/squeezelite.service <<EOL
[Unit]
Requires=bluetooth.service
After=network.target bluetooth.service
Description=Squeezelite Client

[Service]
# Workaround as it does not seem to work with the systemd User= config
# https://github.com/ralph-irving/squeezelite/issues/130
ExecStart=runuser -l  pi -c '/usr/bin/squeezelite -o default'

[Install]
WantedBy=multi-user.target

EOL'

sudo systemctl enable squeezelite
sudo systemctl start squeezelite
```



References:
https://hagensieker.com/2018/06/12/302/
http://www.winko-erades.nl/installing-squeezelite-player-on-a-raspberry-pi-running-jessie/
https://forums.raspberrypi.com/viewtopic.php?t=204808
