---
id: 1725
title: 'Performance Monitoring Part 8 - Analyzing a Performance Monitor Database using Excel'
date: 2009-11-02T09:46:21+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/11/02/performance-monitoring-part-8-analyzing-a-performance-monitor-database-using-excel/
categories:
  - sepago
tags:
  - Excel
  - Performance Monitor
  - Processor
---
In the last post of this [series about performance monitoring](/blog/tags#performance/), I have described how to use Windows Performance Monitor to [log counter values into a SQL database](/blog/2009/11/02/performance-monitoring-part-7-using-performance-monitor-with-a-database/ "Performance Monitoring Part 7 – Using Performance Monitor with a Database"). Now I'll show you that Excel is a tremendous tool to quickly analyze the collected data.

<!--more-->

Excel offers a feature called pivot tables. It allows some data mining either on a local data set contained in an Excel sheet or on a database which Excel is connected to. Therefore, this article describes how to create a connection to the database and create nifty charts using Excel.

## Creating a Database Connection

First, the data needs to be pulled into Excel. Instead of pulling tables or the result of a query into a sheet, we will configure a data connection to display results. Duplicating data into Excel hardly makes sense because it unnecessarily bloats the file.

On the data tab, Excel offers several methods for reading data from different sources. We will use the "From SQL Server" button to create a connection to the Performance Monitor database.

[![Data from SQL server](/media/2009/11/DataFromSQLServer.png)](/media/2009/11/DataFromSQLServer.png)

In the first dialog, enter the server name and click next. The following step of the wizard select the relevant database (in my case, it is called PerfMonDB) and uncheck the option to "Connect to a specific table" because we do not intend to use one of the tables. Then click "Next" and "Finish".

[![Do not connect specific table](/media/2009/11/NoSpecificTable.png)](/media/2009/11/NoSpecificTable.png)

In the next dialog you will be asked to select a table. At this point, it is the selection you make is insignificant because we will use a SQL statement later on.

[![Choose any table](/media/2009/11/SelectTable.png)](/media/2009/11/SelectTable.png)

Before any data is inserted into your Excel sheet, the following dialog allows the data connection to be customized. Select "PivotChart and PivotTable Report" and click "Properties" to insert a custom SQL statement.

[![Add pivot table and chart](/media/2009/11/Properties.png)](/media/2009/11/Properties.png)

On the "Definition" tab of the new dialog, select "SQL" to be the "Command type" and page the following SQL statement into "Command text". Then click "Ok".

[![Add SQL query to definition of data properties](/media/2009/11/CommandType.png)](/media/2009/11/CommandType.png)

```sql
SELECT
    DisplayString, MachineName,
    ObjectName, CounterName, InstanceName,
    CounterDateTime, CounterValue
FROM
    CounterData JOIN
    CounterDetails ON CounterData.CounterID = CounterDetails.CounterID JOIN
    DisplayToID ON CounterData.GUID = DisplayToID.GUID
```

After closing the dialog, Excel may ask you to confirm the change of the connection definition. Please confirm this by clicking "Yes".

[![Confirm changing the definition](/media/2009/11/Dialog.png)](/media/2009/11/Dialog.png)

## Using the PivotChart

You have now created a blank PivotTable and PivotChart report with a direct connection to your Performance Monitor database. All this is achieved without pulling in the actual data from the database. You Excel sheet should look similar to the following screenshot.

[![Empty pivot table and chart](/media/2009/11/Components1.png)](/media/2009/11/Components1.png)

The Excel window now contains several new elements: a PivotTable area on the left, a blank PivotChart accompanied with a filter pane in the middle and a PivotTable field list on the right. I will now expand on the PivotTable stuff but rather demonstrate how to use the PivotChart as a dashboard for analyzing the performance data contained in the database.

First, we will move the PivotChart to a separate sheet to have a well-arranged workspace. Right click on the blank PivotChart, select "Move Chart" and choose "New sheet" in the dialog. After attaching the filter pane to the right side of the window, I configured the PivotChart to analyze the performance database:

  1. Drag the DisplayString and MachineName fields to report filters
  2. Drag the CounterName to the legend fields
  3. Drag the CounterDataTime to the axis fields
  4. Drag the CounterValue to the values box

After some adjustments to the layout, I arrived at the PivotChart displayed in the screenshot below. Without much hassle, I am able to view the counter values from the database and create a nice visual representation.

[![Pivot chart](/media/2009/11/PivotChart.png)](/media/2009/11/PivotChart.png)

Using the filter pane allows you to filter which data is actually displayed in the PivotChart. If your Performance Monitor database contains several series of measurements for different machines, filtering focuses the PivotChart on the exact amount of data you intend to view from the database.

[![Filter data 1](/media/2009/11/DisplayString.png)](/media/2009/11/DisplayString.png)

[![Filter data 2](/media/2009/11/MachineName.png)](/media/2009/11/MachineName.png)

[![Filter data 3](/media/2009/11/CounterName.png)](/media/2009/11/CounterName.png)
