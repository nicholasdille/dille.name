---
id: 1594
title: Inside EdgeSight Report Parameters
date: 2011-04-27T16:13:45+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/04/27/inside-edgesight-report-parameters/
categories:
  - sepago
tags:
  - EdgeSight
  - RDL
  - Reporting Services
  - SQL
  - SQL Server
  - Visual Studio
---
In [part 3 of my series about custom reports for Citrix EdgeSight](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query), I have listed some parameters that are automagically recognized by EdgeSight. Those parameters cause EdgeSight to display specialized picker or pre-populated dropdown lists. But Citrix does not provide a current documentation for report parameters processed by EdgeSight. Therefore, it's back to reading existing reports to discover those parameters. In this article, I will introduce some more parameters for EdgeSight reports and publish a report to examing values passed from the EdgeSight web-based console to the report.

<!--more-->

## EdgeSight Report Parameters

Whenever a report is loaded in the EdgeSight console, it is parsed for report parameters. When a magic parameter name is encountered, EdgeSight displays pre-defined UI elements. In [part 3 of my series about custom EdgeSight reports](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query), I have elready listed the four mosted important parameters:

  * `@CompId` specifies the company from which data is pulled. Companies are numbered using increasing integers beginning with 1.
  * `@Filter` determines the machines to be analyzed by either naming a department or a group of machines. This parameter is special because it can express two different types of machine collections. Therefore, departments are expressed by positive numbers and group by negative numbers.
  * `@Start` sets the first day of the report as an offset in days. So, it is a negative integer.
  * `@End` specifies the last day of the report and is also an offset in days (negative integer as well).

But there are more parameters. In general, whenever EdgeSight displays a special UI element, a special parameter is used in the report. So far, I am aware of the following parameters:

  * `@UserGroup` is used to filter by a user group. This is very useful to limit a report to a special project team or a customer expressed by a group.
  * `@Category` allows filtering by process groups. EdgeSight comes with a long list of pre-defined process groups, e.g. Microsoft Office or OS Programs.

Both parameters can be set to zero to indicate that no filter is required through this parameter.

The following screenshots visualize which input fields control which parameters:

[![EdgeSight report parameters 1](/assets/2011/04/parameters1.png)](/assets/2011/04/parameters1.png)

[![EdgeSight report parameters 2](/assets/2011/04/parameters2.png)](/assets/2011/04/parameters2.png)

Yet, there are certainly more parameters for selecting individual devices, users and processes. But so far, I have not had the need to use them.

## Writing and Testing Queries

The tricky thing about a custom EdgeSight report is writing the query to pull pieces of information from the database. This requires a thorough understanding of the database schema. Business Intelligence Development Studio (BIDS) is a nice tool for creating the graphical layout required for the report but does not qualify for writing an SQL query with the necessary facilities for exploring the database and autocompletion of tables and fields. Therefore, it is more likely that a tool like the SQL Server Management Studio (SSMS) suites our needs concerning the mentioned capabilities.

But SSMS does not handle parameters for EdgeSight reports properly so that we will have to manually declare those variables usually provided automagically by EdgeSight. This only poses a problem for more complex parameters like `@Filter` which cannot be easily deduced from the database or by common sense. In my article about [SQL queries for EdgeSight reports](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query), I stated that some values are save presets for the four most important parameters.

Unfortunately, these values are far from realistic. Because proper values for all report parameters can only be pulled from the EdgeSight console, I have created a report that displays the values for all report parameters currently known to me and resolves them to human readable values.

[![Example report to visualize EdgeSight report parameters](/assets/2011/04/edgesight_parameters.jpg)](/assets/2011/04/edgesight_parameters.jpg)

So, if you are working on new reports, [grab my report](/assets/2011/04/sepago_-_edgesight_parameters.zip) and explore those parameter values. Afterwards build a proper header (like the one below) and use it in SSMS for testing your SQL queries.
  
```sql
DECLARE @CompId INT
DECLARE @Filter INT
DECLARE @Start INT
DECLARE @End INT
DECLARE @Category INT
DECLARE @UserGroup INT
SET @CompId = 1 /* first company */
SET @Filter = 1 /* filtered by department */
SET @Start = -7 /* report starts 7 days before today */
SET @End = -1 /* report end yesterday */
SET @Category = 0 /* no process category */
SET @UserGroup = 0 /* no user group */
```

I hope it helps you as much as it helped me.
