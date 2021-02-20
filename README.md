# R-Testing
 
## Prerequisites

- SQL Server 2019 (I used Developer edition)
    - I limited SQL to 4GB RAM so it can't hog *ALL* my PC's resources, just food for thought
    - SSMS (SQL Server Management Studio)
- Visual Studio 2019 (I used Community edition)
    - Data storage and processing
    - .NET desktop development
    - GitHub Extension for Visual Studio (if you want to push your project to GitHub)
    - *I have a lot of stuff installed, so I'm not 100% sure what the minimum is for this*
- R (do ***NOT*** use Microsoft's version of R; you won't be able to use the latest version of Shiny)
- RStudio (the free desktop version)
- R Packages (I've tried to limit these as much as possible, and they're only ones available through CRAN)
    - shiny (obviously)
    - shinydashboard
    - DT (for the nicer looking datatable outputs)
    - DBI (SQL Server interactions)
    - odbc (works alongside DBI to connect to SQL Server)
    - lubridate (date manipulation)
    - stringr (string manipulation)

## Setup

Once everything is installed and configured, open SSMS, connect to your database, and run the "Reset RTesting - SQL.sql" script. This will delete the database if it exists (helpful when you make changes in VS and want to republish), delete the user if it exists, and then create the database.

When you're ready to publish the VS SQL project, check the RTesting login. Make sure it's the login name and password you want. The default here is RTesting and SomePassword. Super secure, I know, so change it. If you change the login name, make sure you also check out the RTesting user script and make any necessary changes there as well. Don't worry, VS will yell if you get this wrong.

Another thing you're going to want to check in VS is file IndexData. This script assumes you want your IndexData file created in directory C:\SQL\Indexes. If that's not where you want it, change the directory value. Or let VS yell at you; I'm not trying to tell you how to live your life.

From here, everything is pretty simple. Right click the SQL project in VS and publish it to your environment. If you haven't already created a connection, it'll ask you to do that. If there are any issues, VS will not hesitate to let you know about them.

## Launch

If you have a database and a user, you're good to go with SQL & VS! All permissions for the SQL user have been handled within the VS project, but you can double-check everything using SSMS. If anything looks wonky or doesn't seem to work quite right, run that Reset script and start over. If you changed the SQL user, just change the script to delete the new user name. Same if you changed the database name.

Launch RStudio and open the RTestingShiny project. If you changed the database name or login user, open file RCommon.R and make the appropriate changes. This file assumes you're using server (local), so if you aren't, change that, too.

Pull up file ui.R, server.R, or global.R and click that "Run App" button where the "run" and "source" buttons usually are.

And there you have it! It worked on my PC, so it ***MUST*** work everywhere.

If you have any questions, comments, suggestions, or constructive criticism (don't be rude), you can find me on Twitch (Nitenghale) M-F @ 5:15-6:15 AM CST and S-U @ 7:15-9:15 AM CST or Twitter (@Nitenghale).

*For reference, this was developed in Windows 10 Enterprise on a virtual machine. The specs I gave it are 4GB RAM (variable up to 8GB) and 4 virtual processors.*
