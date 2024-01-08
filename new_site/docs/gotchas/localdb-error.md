---
title: "Fix various localdb errors"
tags: [windows, localdb, sql, sqlserver]
---

Sometimes LocalDB just does not work. 

``` bash
/> SqlLocalDB.exe start
Start of LocalDB instance "mssqllocaldb" failed because of the following error:
Error occurred during LocalDB instance startup: SQL Server process failed to start.
```

This is what fixed it for me, most of the time:

```bash
/> SqlLocalDB.exe delete
LocalDB instance "mssqllocaldb" deleted.
/> SqlLocalDB.exe create
LocalDB instance "mssqllocaldb" created with version 15.0.4153.1.
/> SqlLocalDB.exe start
LocalDB instance "mssqllocaldb" started.
```

When working with DotNet theses errors can also occur:


```
Microsoft.Data.SqlClient.SqlException : A network-related or instance-specific error occurred while establishing a connection to SQL 
Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: SNI_PN11, error: 50 - Local Database Runtime error occurred. Fehler beim Start der LocalDB-Instanz: Der SQL Server-Prozess konnte nicht gestartet werden.)
```

```
Microsoft.Data.SqlClient.SqlException : The log scan number (36:16:3) passed to log scan in database 'model' is not valid. This error may indicate data corruption or that the log file (.ldf) does not match the data file (.mdf). If this error occurred during replication, re-create the publication. Otherwise, restore from backup if the problem results in a failure during startup.
One or more recovery units belonging to database 'model' failed to generate a checkpoint. This is typically caused by lack of system resources such as disk or memory, or in some cases due to database corruption. Examine previous entries in the error log for more detailed information on this failure.
```


```
