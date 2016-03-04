---
id: 1641
title: 'Building Custom EdgeSight Reports Part 2 - The Database'
date: 2010-07-16T19:58:46+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/07/16/building-custom-edgesight-reports-part-2-the-database/
categories:
  - sepago
tags:
  - EdgeSight
  - SQL Server
---
Understanding the database schema is the key to building a custom report for EdgeSight. In this article you will learn about important tables and views as well as the relationship between them. This article explains the purpose and layout key tables in the EdgeSight database schema as well as the relationships between them.

<!--more-->

## Organizational Tables

As you may know, EdgeSight manages devices in companies and departments to represent an organizational structure. The corresponding tables are called company and dept. Every company is represented (among others) by a unique id (`compid`) and a name (`name`) contained in the corresponding fields. Departments are stored in the table dept where a unique id (`compid`), the name (`name`), the parent department (`path`) and the id if the corresponding company (`compid`) are the most important fields.

EdgeSight differentiates between the instance of an agent and the machine which the agent is installed on. The former is stored in the table called instance and the latter is found in the table called `machine`. The machine is mainly represented by a unique id (`machid`), the name (`name`) and the physical memory (`mem_physical`). Every agent instance is referenced by a unique id (`instid`) and lists the corresponding department (`deptid`), the hosting machine (`machid`) and the timezone (`tzid`). The table `timezone` contains all timezones expressed by a unique id (`tzid`) and an offset relative to the universal time convention (UTC). The handling of timezones will become a very important piece in the creation of queries as timestamps are stored in UTC and need to be converted to the local timezone.

The following image displays the relationship between the tables introduced above:

[![Relationship between organizational tables](/media/2010/07/Bild1.png)](/media/2010/07/Bild1.png)

Details about the organizational tables called `image` and `vendor` will be explained in the next section as the relationship will become more obvious.

## Performance Data

Performance data is stored in several tables depending on the type of data:

  * `system_perf` stores performance data about the machine which the agent is installed on.
  * `image_perf` contains process performance data.
  * `ctrx_system_perf` adds several important performance values about the remote desktop services.
  * `ctrx_session_perf` stores performance data about user sessions.

Unfortunately, these tables are not suited for analysis as fields have cryptic names. Therefore, the corresponding views should be used instead (prefixed with "vw_").

The views for retrieving performance data have a very similar structure. They all contain a timestamp (field `dtperiod`) expressed in UTC, a reference to the corresponding agent instance (field `instid`) and a set of data items expressed by several fields:

  * *_sum – the sum of all individual values aggregated by the specific value.
  * *_cnt – the number of values aggregated by the sum above.
  * *_peak – the peak value aggregated in the sum above.

Storing this information separately is necessary for proper statistical analysis. Don’t calculate the mean of several mean values but rather add the sums and divide it by the added number of values.

The following views follow the general schema described above:

  * `vw_system_perf` - This table stores general performance data about the machine which the agent is installed on like processor usage and available memory.
  * `vw_image_perf` – This table contains process performance data.
  * `vw_ctrx_system_perf` – This table adds several important performance values about the remote desktop services.
  * `vw_ctrx_session_perf` – This table stores performance data about user sessions.

The following image displays the relationship between the tables containing performance data.

[![Relationship between tables with performance data](/media/2010/07/Bild2.png)](/media/2010/07/Bild2.png)

Process performance data from `vw_image_perf` requires two additional tables to resolve the data contained therein: `image` and `vendor`. Detailed information about processes and vendors are separated from the performance data to prevent redundant data to be stored. A process is represented by an entry in the table `image` encompassing a unique id (`imid`), the executable name (`filename`), the version of the file (`file_version`) and a reference to the vendor (`vendid`). A vendor is stored in the table `vendor` by a unique id (`vendid`) and a name (`name`). The following image displays the relationship between the tables `vw_image_perf`, `image` and `vendor`.

[![Relationship between tables with process information](/media/2010/07/Bild3.png)](/media/2010/07/Bild3.png)

Apart from relating performance data through the agent instance (table `instance`), tables like `vw_ctrx_session_perf` contain information about individual user sessions. The following image displays the relationship between tables based on user sessions.

[![Relationship between tables with session information](/media/2010/07/Bild4_0.png)](/media/2010/07/Bild4_0.png)

The tables `session` and `principal` are used to resolve the session if (`sessid`) found in `vw_ctrx_system_perf` and `vw_ctrx_session_perf`. The table `session` contains a list of all sessions perceived by the agents. The account information for a session is stored in the table `principal` being referenced by `prid` from the table `session`.

Process performance data can also be accredited to user sessions by resolving the field `sessid` in `vw_image_perf` and `vw_ctrx_session_perf`.

## Date and Time Conversion

As all data items stored in the EdgeSight database are expressed in UTC, the table `rs_calendar` supports handling date and time values. It contains a list of all years, months, days and hours nearly since the beginning of time ;-) Although all data found in this table can be calculated on-the-fly, it is way faster to read it from a table.

## Wrapping It Up

In the next article, I will demonstrate building a query based on these tables.
