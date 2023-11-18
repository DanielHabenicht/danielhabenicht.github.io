# 

Needed: 
- Pi Zero
- Scanner (e.g. Canon Lide 210)

Flash headless with Raspberry Imager. 

```bash
sudo apt update
sudo apt upgrade

sudo apt install sane scanbd imagemagick


# As per https://wiki.ubuntuusers.de/scanbd/
echo "net" > /etc/sane.d/dll.conf
# Only works because I use a canon scanner! TODO: just remove "net"
echo "canon_lide70" > /etc/scanbd/dll.conf

echo "
# saned lokal, langer timeout unnoetig
connect_timeout = 3
# scanbm lauscht an localhost
localhost" >> /etc/sane.d/net.conf

sudo systemctl stop inetd.service
sudo systemctl disable inetd.service

sudo systemctl stop saned.socket
sudo systemctl disable saned.socket 

sudo systemctl enable scanbd.service # zur automatischen Ausführung beim Systemstart nötig
sudo systemctl start scanbd.service
sudo systemctl enable scanbm.socket # zur automatischen Ausführung beim Systemstart nötig
sudo systemctl start scanbm.socket

mkdir /etc/scanbd/scripts

cat <<EOT >> /etc/scanbd/scripts/scan.sh
#!/bin/sh
TMPDIR="$HOME"
DATE=$(date '+%Y_%m_%d_%H_%M_%S')
TMPFILE="$TMPDIR/scan_$DATE"

echo "Scanning to $TMPFILE.pdf"

scanimage --resolution 300 --mode Color --format jpeg -l 0mm -t 0mm -x 210mm -y 297mm > "$TMPFILE.jpg"
convert "$TMPFILE.jpg" "$TMPFILE.pdf"
rm "$TMPFILE.jpg"

curl -F "file=@localfile;filename=nameinpost" url.com

EOT
chmod +x /etc/scanbd/scripts/scan.sh


sed -i 's/user    = saned/user    = pi/' /etc/scanbd/scanbd.conf
sed -i 's/test.script/scan.sh/' /etc/scanbd/scanbd.conf 

# Fix imagemagick (convert) security policy
sed '/PDF/d' policy.xml > policy.xml





# Power Saving
sed -i '11s/^/\/usr\/bin\/tvservice -o/' /etc/rc.local # Add line at 1th line

```
