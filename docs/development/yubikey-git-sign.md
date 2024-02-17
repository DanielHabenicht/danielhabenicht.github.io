"%APPDATA%\gnupg\scdaemon.conf" reader port

https://support.yubico.com/hc/en-us/articles/360013714479-Troubleshooting-Issues-with-GPG

```.gitconfig
[alias]
	c = commit -m
	aa = add --all
	s = status
	slog = log -n 10 --date-order --abbrev-commit --graph --pretty=format:"%h|%an|%ar|%s"
	glog = log --graph --pretty=oneline --abbrev-commit --decorate --branches --all
[user]
	name = Daniel Habenicht
	email = <email>
	signingkey = FE2557476A8E78C76168FA01D74C64CA74C4E1F0
[commit]
	# gpgsign = true
[gpg]
	program = C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe
```
