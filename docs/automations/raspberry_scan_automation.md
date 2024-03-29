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

# Find scanner
sane-find-scanner


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
TMPDIR="/home/pi"  #"$HOME"
DATE=$(date '+%Y_%m_%d_%H_%M_%S')
TMPFILE="$TMPDIR/scan_$DATE"

echo "Scanning to $TMPFILE"

scanimage --resolution 300 --mode Color --format jpeg -l 0mm -t 0mm -x 210mm -y 297mm > "$TMPFILE.jpg"

# Retry
if [ -s "$TMPFILE.jpg" ]
then
    echo "worked the first time"
else
    echo "retrying scanning"
    rm "$TMPFILE.jpg"
    scanimage --resolution 300 --mode Color --format jpeg -l 0mm -t 0mm -x 210mm -y 297mm > "$TMPFILE.jpg"
fi



if [ -s "$TMPFILE.jpg" ]
then
    # pdf-web-edit
    echo "Uploading to pdf-web-edit"
    curl --retry 5 --retry-delay 10 -i -k -F "file=@$TMPFILE.jpg" http://192.168.178.169:8080/api/documents/upload

    # ngx-paperless
    #curl -F "document=@$TMPFILE.jpg" -u "import:<password>" http://192.168.178.169:8000/api/documents/post_document/
else
    echo "File scanning did not work?!"
fi

#rm "$TMPFILE.jpg"

#convert "$TMPFILE.jpg" "$TMPFILE.pdf"

EOT
chmod +x /etc/scanbd/scripts/scan.sh


sed -i 's/user    = saned/user    = pi/' /etc/scanbd/scanbd.conf
sed -i 's/test.script/scan.sh/' /etc/scanbd/scanbd.conf

# Fix imagemagick (convert) security policy
sed '/PDF/d' policy.xml > policy.xml





# Power Saving
sed -i '11s/^/\/usr\/bin\/tvservice -o/' /etc/rc.local # Add line at 1th line

```


```
ls | xargs  -I % curl -i -o - -k -F "file=@%" https://localhost:7114/api/documents/upload
```