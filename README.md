# Dynon Skyview Loader

Currently supports MacOS - would not be hard to change a few things to make it work on Linux.

The Seattle Avionics Chart Manager client is windows only, and is... well it looks like something from Windows 95 and works about as well as it looks. It was a massive pain to update things on a Mac - you had to install a VM to run Windows and install ChartData Manager or manually down load each item and keep your USB drive formated and structured correctly. Anywho.. I ran across a post about a script to do that - after reviewing the script it didn't really do what I wanted, so I have Forked that repo and changed things to work a bit better, for me at least. 


1. Visit the [Dynon SkyView ChartData page](https://www.seattleavionics.com/ChartData/Default.aspx?TargetDevice=Dynon).
1. Login with your Seattle Avionics Credentials.
1. Visit the [Manual Download](https://www.seattleavionics.com/ChartData/Installation.aspx).
1. Note the password in the table.
   1.  There are two schedules for the updates on this page, some are updated every 28 days and some are updated every 56 days. This means that some times they will   be in synce and have the same password, and sometimes they will be out of sync and will have different passwords. Not a big deal just makes it an extra step to download all of them. 
1. Hover your mouse over one of the download links. It will start with "http://data.seattleavionics.com/OEM/Generic/", followed by a four-digit directory name. Note this four-digit prefix.
   1.  Same as above - because of the 28 day and 56 day cycle - sometimes the directory names will be all the same and sometimes they will have a different name for the 28 day vs 56 day items. Again, not a big deal - just an extra step.   
1. Run ./skyview-loader.sh. Enter the password and prefix when prompted. The updater will download all data and generate a USB drive image.
