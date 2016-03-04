---
id: 1639
title: 'Building Custom EdgeSight Reports Part 4 - The Wedding'
date: 2010-09-27T19:58:36+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/09/27/building-custom-edgesight-reports-part-4-the-wedding/
categories:
  - sepago
tags:
  - EdgeSight
  - SQL
  - SQL Server
---
After the last two articles have demonstrated the [schema of the EdgeSight database](/blog/2010/07/16/building-custom-edgesight-reports-part-2-the-database/ "Building Custom EdgeSight Reports Part 2 – The Database") and the [layout of a query](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query/ "Building Custom EdgeSight Reports Part 3 – The Query"), this posting brings together all the pieces to create a report for EdgeSight. A report is based on the query which pulls data from the EdgeSight database. Through the use of special variables, the EdgeSight user interfaces passes parameters to the query to customize the resulting output. This requires special methods to work with.

<!--more-->

As EdgeSight is based on Microsoft SQL Server Reporting Services, a report is expressed in the Report Definition Language (RDL) which is based on XML. Fortunately, it is not necessary to write RDL directly because Microsoft offers the Business Intelligence Development Studio which is a variant of Visual Studio containing special project templates. Using this integrated development environment, reports can be created without the hassle of knowing the gory details of RDL.

Before you give it all a shake, note that the results may be very disappointing unless your EdgeSight database contains ample data for display. I usually run a simple script created with EdgeSight for Load Testing to cause the EdgeSight agent to collect non-baseline performance data.

The [previous article](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query/ "Building Custom EdgeSight Reports Part 3 – The Query") contained a step-by-step introduction to an example query just like it is used by Citrix in the official reports. The following statement resembles this final query and will be used later in this article.

```sql
DECLARE @CompId INTEGER
DECLARE @Filter INTEGER
DECLARE @Start INTEGER
DECLARE @End INTEGER

SET @CompId = 1
SET @Filter = 1
SET @Start = -33
SET @End = -32

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
    vw_system_perf.instid IN (SELECT * FROM dbo.udf_core_sub_inst(@Filter)) AND
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

Before you start off with the Business Intelligence Development Studio, please make sure that the statement produces valid data. Otherwise, your reports are bound to look rather boring making designing and testing unnecessarily difficult. After you have designed a query in the SQL Server Management Studio scroll down the results to confirm there are non-null values present (see screenshot below). Running queries against an EdgeSight database maintained for regularly used systems will implicitly offer ample data.

[![SQL Server Management Studio](/media/2010/09/001.png)](/media/2010/09/001.png)

Note that you will have to remove the declaration and assignment of the variables `@CompId`, `@Filter`, `@Start` and `@End` at the beginning of the query to make the report work in Business Intelligence Development Studio.

After launching the Business Intelligence Development Studio, create a new project (first screenshot below), select the template called "Report Server Project" and name it (second screenshot below).

[![New project](/media/2010/09/002.png)](/media/2010/09/002.png)

[![Select Report Server project](/media/2010/09/003.png)](/media/2010/09/003.png)

Just like in Visual Studio, the Solution Explorer (on the right-hand side) displays the resources contained in the project. As this is a new project, there are no resources present. But we do notice two categories of resource:

  * **Shared Data Source:** A data source defines against which database the report is executed. A data source is stores in an RDS file.
  * **Reports:** All reports created in a project will reside under his node. As reports are expressed in the Report Definition Language, the corresponding files receive the extension RDL.

[![Solution Explorer](/media/2010/09/004.png)](/media/2010/09/004.png)

Before creating a report, you absolutely need to create a shared data source and it needs to be called “edgesight” because the name is embedded as a reference in the report. When the report is later uploaded to the EdgeSight server, the shared data source is not included but the EdgeSight server provides the connection to the database. If the names do not match, the upload to the EdgeSight server will fail.

[![Shared Data Source Properties](/media/2010/09/005.png)](/media/2010/09/005.png)

Either enter the connection string or click “Edit” to use the graphical user interface to create the connection string (see screenshot below). You will be required to enter a database server and a database name but depending on your environment, a set of valid credentials may be necessary to access the database.

[![Connection Properties](/media/2010/09/006.png)](/media/2010/09/006.png)

Confirm that the data source was created in the Solution Explorer under the node “Shared Data Sources” with the name “edgesight” (see screenshot below).

[![Select shared data source in Report Wizard](/media/2010/09/008.png)](/media/2010/09/008.png)

Now, we can finally create the first report by right-clicking on the node “Reports” and selecting “Add new report”. In the following wizard, select the data source called “edgesight” from the dropdown list (see screenshot below). To be honest, this dialog also allows new data sources to be created before continuing with the next step. Both methods to create a data source are equally valid and produce the same shared data source (provided you used the same connection string).

In the next step of the wizard, you will have to paste the query (see screenshot below). In this example I have used the statement, presented at the beginning of this article. Remember to remove the declaration and assignment of the parameters (`@CompId`, `@Filter`, `@Start` and `@End`).

[![Design the query](/media/2010/09/009.png)](/media/2010/09/009.png)

After continuing to the next step, the wizard asks you to provide example values for the aforementioned parameters (see screenshot below). To integrate the query into the report, the wizard attempts to analyze the statement by executing it against the defined data source but requires valid values for all parameters. In my example, the entered values produce only a small amount of data to reduce the execution time.

[![Provide example values for query parameters](/media/2010/09/010.png)](/media/2010/09/010.png)

Unfortunately, the wizard does not offer a chart to be added to the report automatically. Therefore, you will have to select the tabular or the matrix layout in the next step. This is somewhat annoying because the representation seldom makes the data easier to read. After selecting either layout, continue to the next step and jump to the end of the wizard by clicking “Finish”. The final dialog lists all the values you have entered and after clicking “Finish” yet again, the report is finally created.

In the center pane, Visual Studio displays the current design of the report. It does not contain any data from the defined data source but helps adjusting the design to match your requirements. In the Solution Explorer (right-hand pane), the node “Reports” contains a new element representing you report (with the extension RDL). The left-hand pane called “Report Data” displays the details of the report. The node “Parameters” lists the parameters contained in the report. You will recognize the variables used in the SQL statements. The second important node in the pane “Report Data” is named after the data source and (in this case) contains a single element called “DataSet1” which represents the query entered in the wizard above. Below the data set you see the fields produced by the query which will later be used to populate a chart.

[![Layout of the Visual Studio project](/media/2010/09/011.png)](/media/2010/09/011.png)

Before we modify the report, let’s have a look at the preview. By switching to the tab “Preview” of the center pane, the report is rendered using the defined shared data source. But before the report is displayed, you will have to enter values for the parameters defined in the report. Unfortunately, Visual Studio provides a very crude interface for this.

[![Report preview 1](/media/2010/09/012.png)](/media/2010/09/012.png)

This very simple report presents the data in the layout you chose in the wizard above. In the following screenshot, I have scrolled down to show rows containing data (see screenshot below).

[![Report preview 2](/media/2010/09/013.png)](/media/2010/09/013.png)

After making sure that the report rendered just fine, we can step forward and begin to modify the report. First, switch back to the tab “Design” and delete the tabular or matrix layout. Now you can either add a chart to the report by using the toolbox at the left-hand side of the window – it unfolds as soon as the mouse hovers above it – or use the context menu of the report page (see screenshot below).

[![Adding a chart](/media/2010/09/014.png)](/media/2010/09/014.png)

As I have used the performance metric called “Disk Time” in the statement, I now choose to add a line chart (see screenshot below) because it produces the most fitting representation of the data.

[![Select chart type](/media/2010/09/015.png)](/media/2010/09/015.png)

After the line chart has been added to the report, it does not contain any data fields and fails to preview at this point. Similar to [PivotCharts in Excel](/blog/2009/11/02/performance-monitoring-part-8-analyzing-a-performance-monitor-database-using-excel/ "Performance Monitoring Part 8 – Analyzing a Performance Monitor Database using Excel"), you can drag data fields from the pane “Report Data” to the chart to use it as a category field, a series field or a data field. When populating the data field note that – depending on the choice of fields – the data field may contain an aggregation function like the sum or the average. This can be adjusted by right-clicking on the data field in the line chart and opening the properties window.

[![Adding data to a line chart](/media/2010/09/016.png)](/media/2010/09/016.png)

No matter what changes you make, you can always check the resulting report by switching to the preview tab. I recommend you use it often ;-)

Unfortunately, designing reports is not as comfortable as designing charts in Excel. Therefore, you will have to use the context menu for most modifications. As shown in the screenshot below, the context menu of the chart provides dialogs for changing the chart type, the chart itself, the chart area, the data series and the legend.

[![Chart properties](/media/2010/09/017.png)](/media/2010/09/017.png)

When you are content with your report, it is time to upload it to EdgeSight. But first, it must be exported from Business Intelligence Development Studio. There are two ways to achieve this:

1.       Use Windows Explorer to browse to the project folder to access your report.

2.       Open the report in in Business Intelligence Development Studio and select "Save <report name> As ..." from the file menu.

Both methods give you access to the RDL file of your report which is required for the upload to EdgeSight.

To integrate your report in the EdgeSight console, you need to go to the Configure tab an select “Costum Reports” on the right-hand side. The content pane shows a list of reports previously uploaded to the server. New reports are added by clicking the button labeled “Upload A Report” (as displayed in the following screenshot).

[![Upload a custom report to EdgeSight](/media/2010/09/018.png)](/media/2010/09/018.png)

In the following dialog, you will have to provide details about the new report. After choosing the location of the new report, it requires a name to be identified in the console. You can configure the report to be publicly visible to all users or to remain private for yourself only. The permissions at the bottom of the dialog control who will be able to access a public report. Access is granted through five predefined user roles.

[![Configuring a custom report](/media/2010/09/019.png)](/media/2010/09/019.png)

After the report was successfully uploaded, it is available through the list of custom reports or through the browse tab just like other reports.

This concludes the series about creating custom reports for EdgeSight. Most of the information contained herein comes from Citrix' article about the [anatomy of an EdgeSight report (CTX116452)](http://support.citrix.com/static/oldkc/CTX116452.html) as well as many experiments with SQL statements and layouts for reports. Let me know if there are topics which you'd like me to expand on.
