---
id: 1643
title: 'Building Custom EdgeSight Reports Part 3 - The Query'
date: 2010-07-26T19:58:56+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query/
categories:
  - sepago
tags:
  - EdgeSight
  - SQL
  - SQL Server
---
After explaining the [schema of the EdgeSight database](/blog/2010/07/16/building-custom-edgesight-reports-part-2-the-database) in the previous article in this series, I will now show you how to formulate SQL queries to retrieve data from the EdgeSight database by starting out slowly and building typical example just like it is used by Citrix for many reports in the product.

<!--more-->

Please accept that I cannot provide you with a general introduction to [SQL](http://en.wikipedia.org/wiki/SQL). There are some valuable resources on the web. It is not that hard to learn the basics to understand the queries presented herein.

## How to Test Queries

For obvious reasons you will need an environment running EdgeSight. But that’s not enough as you will need at least one agent installed on an endpoint, XenApp server or virtual desktop. After uploading performance data, the queries unveil the data from the database.

I recommend that you use the Microsoft SQL Server Management Studio that comes with Microsoft SQL Server 2005 and above. It is quite handy to design and test SQL queries.

## A Very Basic Query for Departments

Let’s get started with a very basic query to retrieve a list of departments defined in the EdgeSight server. For this we will need the table `dept`:
  
```sql
SELECT
    deptid,
    name,
    path
FROM
    dept
```
  
The result is a table with three columns for the department’s unique id, the human-readable name and the path in a tree of departments:

deptid | name           | path
-------|----------------|-----------------------------
1      | All            | All
2      | XenApp Farms   | All\XenApp Farms
3      | Endpoints      | All\Endpoints
4      | Infrastructure | All\Endpoints\Infrastructure
5      | XA50           | All\XenApp Farms\XA50

As EdgeSight supports several companies per EdgeSight server, it is important to list the company corresponding with a department. Simply adding the field `compid` to the query above fails to tell us the name of the company which a department belongs to. There is some more work to be done.

We will have to extend the query to grab data from `dept` as well as `company`. This is achieved by using the `JOIN` construct to connect two tables using one or more fields that are used for references between the tables. In this case the field `compid` is responsible for referencing the corresponding company for a department.
  
```sql
SELECT
    dept.deptid,
    company.name AS company,
    dept.name AS department,
    dept.path
FROM
    dept [JOIN](http://www.w3schools.com/sql/sql_join.asp)
    company ON dept.compid = company.compid
```
  
The resulting table provides a thorough overview of all departments and the corresponding company:

deptid | company  | Department     | path
-------|----------|----------------|-----------------------------
1      | sepagoND | All            | All
2      | sepagoND | XenApp Farms   | All\XenApp Farms
3      | sepagoND | Endpoints      | All\Endpoints
4      | sepagoND | Infrastructure | All\Endpoints\Infrastructure
5      | sepagoND | XA50           | All\XenApp Farms\XA50

We will be using the `JOIN` construct throughout the remaining article. It is an integral element of queries across multiple tables. As EdgeSight uses a proper relational database schema, references are used to refer to data from other tables instead of storing redundant information.

## How to List Agents and Machines

The same concept can be applied to agents and machines. As explained in the last article of this series, [EdgeSight differentiates between installed agents and the underlying machine](/blog/2010/07/16/building-custom-edgesight-reports-part-2-the-database/). The following statement generates a list of agents from the table `instance` and the corresponding machines from the table `machine`. In addition, the table `timezone` is used to resolve the time zone a server is located in:
  
```sql
SELECT
instance.instid,
machine.name,
machine.mem_physical,
timezone.standard_bias
FROM
instance JOIN
machine ON instance.machid = machine.machid JOIN
timezone ON instance.tzid = timezone.tzid
```
  
In the following example output, two machines are listed. Apparently, both are located in the time zone UTC+1 and have a physical memory limit of 1GB and 512MB respectively.

instid | name | mem_physical | standard_bias
-------|------|--------------|--------------
1      | SRV1 | 1047376      | 60
3      | XA50 | 523088       | 60

I’m leaving it to you to combine these two queries and retrieve a list of devices with the corresponding department and company information. Hint: All agent instance reference the company they belong to.

## Looking at Machine Performance Data

So far, we have only looked at organizational data. Now, let’s see how performance data is grabbed from the EdgeSight database. In the last article of this series, I introduced the database view for system performance data called `vw_system_perf`. The following query retrieves the disk activity (`disk_time`) and calculates the mean value. In addition, the statement limits the query to machines beginning with ‘SRV’ (`WHERE` clause). The result is grouped by timestamp (`dtperiod`) to calculate a single value per timestamp (`GROUP BY` clause).
  
```sql
SELECT
    dtperiod,
    [AVG](http://www.w3schools.com/sql/sql_func_avg.asp)(disk_time_sum / disk_time_cnt) [AS](http://www.w3schools.com/sql/sql_quickref.asp) disk_time
FROM
    vw_system_perf JOIN
    instance ON vw_system_perf.instid = instance.instid JOIN
    machine ON instance.machid = machine.machid
[WHERE](http://www.w3schools.com/sql/sql_where.asp)
    machine.name [LIKE](http://www.w3schools.com/sql/sql_like.asp) 'SRV%'
[GROUP BY](http://www.w3schools.com/sql/sql_groupby.asp)
    dtperiod
[ORDER BY](http://www.w3schools.com/sql/sql_orderby.asp)
    dtperiod
```
  
The output shows the mean disk time for a timestamp:

dtperiod            | disk_time
--------------------|------------------
2010-07-15 09:00:00 | 1,68624293132296
2010-07-15 10:00:00 | 0,743554720971578
2010-07-15 11:00:00 | 0,352666361578579
2010-07-16 06:00:00 | 12,4244130902586

Note that you cannot resolve the name of a machine directly (for output or filtering) but you need to  use the agent instance table to connect performance data to machine information.

In this chapter, you have learned about two very important constructs: the `WHERE` clause allows the results to be filtered and the GROUP BY clause abstract from unnecessary information.

## Retrieving Process Performance Data

For process data, the query has a similar structure as above using the table `vw_image_perf`. But processes are expressed by a unique ID (`imid`) which can be resolved by using the image table as shown in the statement below.
  
```sql
SELECT
    image.filename,
    image.file_version,
    machine.name
FROM
    vw_image_perf JOIN
    image ON vw_image_perf.imid = image.imid JOIN
    instance ON vw_image_perf.instid = instance.instid JOIN
    machine ON instance.machid = machine.machid
WHERE
    vw_image_perf.dtperiod [BETWEEN](http://www.w3schools.com/sql/sql_between.asp) '2010-07-01' AND '2010-07-15' AND
    image.filename LIKE 'sql%'
GROUP BY
    image.filename,
    image.file_version,
    machine.name
ORDER BY
    name
```
  
The resulting data is filtered to show only processes of Microsoft SQL Server that where recorded between the specified dates.

filename      | version          | name   
--------------|------------------|------
Sqlagent.exe  | 2007.100.2531.0  | SRV1
Sqlps.exe     | 10.0.1600.22     | SRV1
Sqlservr.exe  | 2007.100.2531.0  | SRV1
Sqlwriter.exe | 2007.100.1600.22 | SRV1

This chapter introduced the `BETWEEN` construct allowing for easy filtering when using a starting and ending date.

## Resolving UTC Timestamps

As I have explained in the previous article in this series, timestamps are expressed in UTC. This allows for servers to be monitored although they are located in different time zones. By storing timestamps in UTC format, data from such servers is synchronized and can easily be converted to the time zone of the user querying the database.

The following statement consists of two `SELECT` construct. The inner statements is used for grabbing data from the database similar to the statements presented above and converting the UTC timestamp to a local time using two stored procedures of EdgeSight: `udf_getlocatime_nohour()` and `udf_getlocaltime()`. These functions are used to convert the timestamps and separate the date from the hour of day. This separation makes building reports slightly easier. As a consequence, the `JOIN` clause requires both fields from the inner statement to join the inner and outer statement.

The outer statements works against the table `rs_calendar` as well as the inner statement. It is necessary to obtain an uninterrupted list of timestamps as the tables containing performance data only store information as it is supplied by the agents and may be missing some dates. Such missing timestamp could otherwise disrupt the presentation of the retrieved data in a report and make it harder to read.
  
```sql
SELECT
    rs_calendar.dtperiod,
    rs_calendar.hourid,
    [COUNT](http://www.w3schools.com/sql/sql_func_count.asp)(name) AS count,
    AVG(disk_time) AS disk_time
FROM
    rs_calendar LEFT JOIN (

        SELECT
            dbo.udf_getlocaltime_nohour(vw_system_perf.dtperiod, timezone.daylight_bias, timezone.standard_bias, use_daylight) as dtperiod,
            DATEPART(hh, dbo.udf_getlocaltime(vw_system_perf.dtperiod, timezone.daylight_bias, timezone.standard_bias, use_daylight)) as hour,
            machine.name,
            disk_time_sum / disk_time_cnt AS disk_time
        FROM
            vw_system_perf JOIN
            instance ON vw_system_perf.instid = instance.instid JOIN
            machine ON instance.machid = machine.machid JOIN
            timezone ON instance.tzid = timezone.tzid
        WHERE
            machine.name LIKE 'SRV%'

    ) performance ON (rs_calendar.dtperiod = performance.dtperiod AND rs_calendar.hourid = performance.hour)
WHERE
    rs_calendar.dtperiod BETWEEN '2010-07-01' AND '2010-07-15'
GROUP BY
    rs_calendar.dtperiod,
    hourid
ORDER BY
    dtperiod,
    hourid
```

The resulting output displays the mean value for the disk time of all filtered machine for timestamps in the specified interval as well as the number of values that have been used to calculate the mean value.

dtperiod            | hourid | count | disk_time
--------------------|--------|-------|----------
...                 | ...    | ...   | ...
2010-07-15 00:00:00 | 9      |       | NULL
2010-07-15 00:00:00 | 10     | 1     | 1,68624293132296
2010-07-15 00:00:00 | 11     | 1     | 0,743554720971578
2010-07-15 00:00:00 | 12     | 1     | 0,352666361578579
2010-07-15 00:00:00 | 13     |       | NULL
...                 | ...    | ...   | ...

Be sure to understand the concept of using inner and outer statements in SQL as this will help you immensely in designing statements like the one above.

## Adding Parameters

In this last section, we will add parameters that enable us to integrate the statement into a report definition (explained in the next article). EdgeSight provides four dominating parameters which are passed to a report henever present in the report definition:

  * `@CompId` – This parameter specifies the company against which the report is executed. It is important to limit the context of departments and groups to the proper company as the names can be ambiguous.
  * `@Filter` – This parameter contains a group or department filter encoded as a number. It does not correspond to a group ID or a department ID and must be decoded by the stored procedure called `udf_core_sub_inst()`.
  * `@Start` – This parameter sets the starting date of the report by specifying an offset of days relative to the current date. For example, the value -3 means that the report is to begin three days in the past. The value is resolved to a timestamp by the stored procedure called `udf_core_get_offset_date()`.
  * `@End` – Similar to the parameter `@Start`, `@End` contains an offset of days relative to the current date. It is also resolved by using the stored procedure `udf_core_get_offset_date()`.

Unfortunately, the design of EdgeSight makes it rather hard to test any statements that use the above parameters. `@Start` and `@End` are very intuitive to fill and `@CompId` is usually 1 representing the first company on the EdgeSight server. But `@Filter` causes major pains as it is rather hard to determine the value used for a specific department or group due to the encoding. Often it is a safe guess to use 1 or any other number up to 10. This usually selects one of the existing departments. I usually use the following values for queries in SQL Server Management Studio:

```sql
@CompId = 1
@Filter = 1
@Start = -3
@End = -1
```

The following statement represents the full statement for retrieving performance data from the EdgeSight database including all the tricks explained above. The `DECLARE` clauses at the beginning of the statement are used to declare local variables. They are initialized in the SET clauses by using the SQL function `GETUTCDATE()` and the stored procedure `udf_core_get_offset_date(` introduced above. These local variables are used in the WHERE clauses to filter by date. The inner statement uses the UTC timestamps for the starting and ending date because the performance data is stored in UTC. In the outer statement, the `WHERE` clause filters using the local timestamps to relate to the user’s time zone.
  
```sql
DECLARE @UTCNow DATETIME
DECLARE @UTCStartDate SMALLDATETIME
DECLARE @UTCEndDate SMALLDATETIME
DECLARE @LocalStartDate SMALLDATETIME
DECLARE @LocalEndDate SMALLDATETIME
SET @UTCNow = GETUTCDATE()
SET @UTCStartDate = dbo.udf_core_get_offset_date(@CompId, @Start, 1, 1, @UTCNow)
SET @UTCEndDate = dbo.udf_core_get_offset_date(@CompId, @End, 0, 1, @UTCNow)
SET @LocalStartDate = dbo.udf_core_get_offset_date(@CompId, @Start, 1, 0, @UTCNow)
SET @LocalEndDate = dbo.udf_core_get_offset_date(@CompId, @End, 0, 0, @UTCNow)
SELECT
    rs_calendar.dtperiod,
    rs_calendar.hourid,
    COUNT(name) AS count,
    AVG(committed_kbytes) AS committed_kbytes
FROM
    rs_calendar LEFT JOIN (

        SELECT
        dbo.udf_getlocaltime_nohour(vw_system_perf.dtperiod, timezone.daylight_bias, timezone.standard_bias, use_daylight) as dtperiod,
        DATEPART(hh, dbo.udf_getlocaltime(vw_system_perf.dtperiod, timezone.daylight_bias, timezone.standard_bias, use_daylight)) as hour,
        machine.name,
        committed_kbytes_sum / committed_kbytes_cnt AS committed_kbytes
        FROM
        vw_system_perf JOIN
        instance ON vw_system_perf.instid = instance.instid JOIN
        machine ON instance.machid = machine.machid JOIN
        timezone ON instance.tzid = timezone.tzid
        WHERE
        vw_system_perf.instid [IN](http://www.w3schools.com/sql/sql_in.asp) (SELECT * FROM dbo.udf_core_sub_inst(@Filter)) AND
        vw_system_perf.dtperiod BETWEEN @UTCStartDate AND @UTCEndDate

    ) performance ON (rs_calendar.dtperiod = performance.dtperiod AND rs_calendar.hourid = performance.hour)
WHERE
    rs_calendar.dtperiod BETWEEN @LocalStartDate AND @LocalEndDate
GROUP BY
    rs_calendar.dtperiod,
    hourid
ORDER BY
    dtperiod,
    hourid
```

The result set contains four fields, two of them representing the timestamp separated into a date and an hour field. The other two are specific to the report:

dtperiod            | hourid | count | committed_kbytes
--------------------|--------|-------|-----------------
...                 | ...    | ...   | ...
2010-07-15 00:00:00 | 9      |       | NULL
2010-07-15 00:00:00 | 10     | 1     | 886012
2010-07-15 00:00:00 | 11     | 1     | 993776
2010-07-15 00:00:00 | 12     | 1     | 996296
2010-07-15 00:00:00 | 13     |       | NULL
...                 | ...    | ...   | ...

## Next Steps

When you are testing your new skills against other tables of the EdgeSight database, you may stumble across empty results. Depending on your licensing, this can be expected behavior. EdgeSight comes in two flavours called EdgeSight Basic and Advanced, the former being free to use for XenApp and XenDesktop customers. The basic edition is limited in the amount of data collected by the agents. A full list of available data is documented in the appendix of the [administrator’s guide](http://support.citrix.com/article/CTX124091).

If you are struggling with large result sets, you can use the [TOP](http://www.w3schools.com/sql/sql_top.asp) clause to limit the result to a specified number of rows. Note that this only works for the above examples if applied to the inner statement. Usually, the inner statement generates a large amount of data. If the `TOP` clause is only applied to the outer statement, the execution time is hardly affected as the database engine still needs to process a large amount of data. Furthermore, the `TOP` clause hardly affects a statement containing a `GROUP BY` construct because all the data must be fetched from the database before it is grouped. The row limitation is only applied after the resulting data is generated.

At this point, you have learned about all the peculiarities of SQL statements against the EdgeSight database. Unfortunately, the above statements do not integrate directly into EdgeSight because the definition of a report not only requires a statement but also a layout definition. In the next article in this series, I will demonstrate how to create a report definition using Microsoft Business Intelligence Development Studio.
