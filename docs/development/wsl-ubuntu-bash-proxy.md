Möchte man die Bash mit Ubuntu unter Windows 10 innerhalb einer Firma mit Proxy nutzen wird man Probleme haben Zugriffe in das Internet ausführen zu können. Die Ursache dafür ist dann unter Umständen, dass das Ubuntu Subsystem keine Kenntnisse von unserem Proxy hat.

Im Folgenden wird Beispielhaft gezeigt wie man diese Einstellungen setzen kann.

Es gilt zu beachten, dass verschiedene Programme unterschiedliche Einstellungen benötigen können

## Manuell

Für die meisten Programme reicht es entsprechende Umgebungsvariablen zu setzen.

### Setzen

```
export {http,https,ftp}_proxy="http://proxy.domain.de:8080"
export {HTTP,HTTPS,FTP}_PROXY="http://proxy.domain.de:8080"
export {no_proxy,NO_PROXY}="localhost,127.0.0.1,.domain.de,.company.de"
```

### Löschen

```
unset {http,https,ftp}_proxy
unset {HTTP,HTTPS,FTP}_PROXY
unset {no_proxy,NO_PROXY}
```

## Automatisch

Möchte man diese Einstellungen persistent haben kann man die Befehle auch in die .bashrc eintragen. Die Einträge sollten ganz am Ende eingefügt werden.

`sudo vi ~/.bashrc`

> Tipp: Aus VI kommt man wieder raus in dem man folgendes drückt: ESC > : > wq > Enter

Nachdem diese Datei angepasst wurde muss man das System veranlassen diese neu zu verarbeiten:

`source ~/.bashrc`

### Nach Bedarf

Möchte man den Proxy nach Bedarf ein und aus schalten kann man sich diesen Code Block in die .bashrc einfügen (mit nano ~/.bashrc):

```
# Set Proxy
function proxyon() {
    export {http,https,ftp}_proxy="http://proxy.domain.de:8080"
    export {HTTP,HTTPS,FTP}_PROXY="http://proxy.domain.de:8080"
    export {no_proxy,NO_PROXY}="localhost,127.0.0.1,.domain.de,.company.de"
    echo Proxy is on
}

# Unset Proxy
function proxyoff() {
    unset {http,https,ftp}_proxy
    unset {HTTP,HTTPS,FTP}_PROXY
    unset {no_proxy,NO_PROXY}
    echo Proxy is off
}
```

### sudo mit Proxy

Mit sudo visudo öffnet man den Editor für die sudo Einstellungen. Darin wird folgendes eingetragen:

```
Defaults        env_keep += "http_proxy HTTP_PROXY"
Defaults        env_keep += "https_proxy HTTPS_PROXY"
Defaults        env_keep += "ftp_proxy FTP_PROXY"
Defaults        env_keep += "no_proxy NO_PROXY"
```
