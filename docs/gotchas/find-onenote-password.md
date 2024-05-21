# OneNote Passwort Finder script

```
DetectHiddenWindows on
DetectHiddenText on

#k::
SetKeyDelay 30
Loop, read, C:\password_combos.txt
{
  TrayTip Now trying:, %A_LoopReadLine%, 1 ;Creates tooltip so we can monitor the progress through wordlist.
  SendRaw %A_LoopReadLine% ;Type the current line into box
  Send {enter} ;Submit this password
  Sleep 300 ;Wait while the password is tried
  WinGetActiveTitle, varRespondingWindow ;Check resulting dialogue (look for 'invalid passphrase' error)
  
  if ( varRespondingWindow != "Protected Section" ) {
    ;DEBUG - We found the password. (If the window DOESN'T contain the words Protected Section then we cracked it).
	MsgBox % "Password Found: " . A_LoopReadLine
	return
  } else {
    ;DEBUG - It was wrong 
  }
}
return

#q::
	;This is to exit the script
	Exit
return
```

From: https://blackwoodit.co.uk/knowledge-base/how-to-crack-onenote-sharepoint-online-password/
