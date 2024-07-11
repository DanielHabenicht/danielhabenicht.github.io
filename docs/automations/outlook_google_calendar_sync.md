# Sync Work and Private Calendars

The [OutlookGoogleCalendarSync App](https://www.outlookgooglecalendarsync.com/) lets you synchronize calendars while still retaining private data (be it work data at work or private events in your own calendar).



## Windows Setup 

1. Download the app and place it in a Folder `OutlookGoogleCalendarSync` on your Desktop.
2. Start the application and make any changes necessary to your configuration and save it.
4. Create a `.bat` file in  `C:\Users\<Username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`: 
If you need to sync multiple calendars create multiple configurations and start them via: 
`"C:\Users\<Username>\Desktop\OutlookGoogleCalendarSync\OutlookGoogleCalendarSync.exe" /s:"C:\Users\<Username>\Desktop\OutlookGoogleCalendarSync\personal\settings.xml" /l:"C:\Users\<Username>\Desktop\OutlookGoogleCalendarSync\personal\calendar.log" /t:"Personal Calendar Sync" /d:60`

