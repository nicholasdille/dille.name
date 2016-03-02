---
id: 1598
title: Reading EdgeSight Reports
date: 2011-06-22T16:14:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/06/22/reading-edgesight-reports/
categories:
  - sepago
tags:
  - EdgeSight
  - RDL
  - Reporting Services
  - SQL
  - SQL Server
  - XML
---
In my series about custom reports for EdgeSight, you have learned about the database schema and the overall layout of a query against it as well as how the query is embedded in a report that can be displayed through the EdgeSight user interface. In all articles I have mentioned several times that reports are expressed in RDL – the report definition language which is based on the Extensible Markus Language (XML). In this posting, I’d like to take a closer look at a RDL file and provide some insight how a report is structured and what those tags mean.

<!--more-->

## Why Would I Do That?

There are several good reasons to peak into an RDL file. First of all, you might be curious what it looks like – that was my initial reason. Next you might want to modify an existing report, e.g. one shipped with EdgeSight. The Business Intelligence Development Studio (BIDS) is a very handy tool for creating and modifying reports but sometimes it’s simply not available. I have even encountered situations when the BIDS breaks an existing report the moment it is loaded. Knowing your way around the RDL file helps in all mentioned scenarios.

## Where to Start?

Below you will find an extract of a typical RDL file. It is reduced to simple chunks and boiled down to the important constructs. As a report is expressed in XML, it contains the appropriate header specifying the encoding and the document element (called Report) including two schemas defining the structure of the RDL file.
  
```xml
<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition">
```

The definition of the data source (see below) is a very special part of an EdgeSight report sa it defines the database from which data is pulled for the report. Although this section can be a lot more complex in a typical RDL file, EdgeSight requires you to use a reference to a data source called “edgesight” which is provided by the EdgeSight server.
  
```xml
<DataSources>
<DataSource Name="edgesight">
<DataSourceReference>edgesight</DataSourceReference>
</DataSource>
</DataSources>
```

Report parameters define which pieces of information are required to execute and display the report. They also enale the user to influence how the report processes data and what the outcome looks like. They are usually represented by input fields presented to the user. [EdgeSight recognizes several parameters](/blog/2011/04/27/inside-edgesight-report-parameters/) and displays specialized fields to filter by department, data, user groups or process categories. All parameters are specified by a name and a data type. Optionally, parameters can be given a default value as well as a value list for the user to choose from.
  
```xml
<ReportParameters>
<ReportParameter Name="Filter">
<DataType>Integer</DataType>
<Prompt>Filter</Prompt>
</ReportParameter>
```

There are usually several report parameters.
  
```xml
</ReportParameters>
```
  
A report contains one or more data sets (see below) defining a result set to be used in the graphical part of the report. A data set can be thought of like a table in a database consisting of rows and fields.
  
```xml
<DataSets>
<DataSet Name="DataSet">
```

The most important section of a data set is the query. It is specified by a data source and the command text. In EdgeSight reports, the report data source is referenced in the query because this is the only valid database connection. When a query is added in BIDS, it automatically determines the parameters required to execute the query and retrieves the data types of fields returned by the query. You will find more about both below.
  
```xml
<Query>
<DataSourceName>edgesight</DataSourceName>
<CommandText>
```

This is where you will find the query for the enclosing data set.
  
```xml
</CommandText>
```

The next section specifies which fields are returned by the data set. It essentially reproduces the data types of the fields selected in the query.
  
```xml
<Fields>
<Field Name="dtperiod">
<DataField>dtperiod</DataField>
<rd:TypeName>System.DateTime</rd:TypeName>
</Field>
```

Usually, more than one field is defined for a data set.
  
```xml
</Fields>
```

Most queries cannot work without parameters. They can be silently passed on the EdgeSight server or specified by the user to achieve a certain result. RDL as well as BIDS express parameters as they are defined by SQL (with a proceeding @). The Value-tag contains an expression for retrieving the value from a report parameter.
  
```xml
<QueryParameters>
<QueryParameter Name="@Filter">
<Value>=Parameters!Filter.Value</Value>
<rd:UserDefined>true</rd:UserDefined>
</QueryParameter>
```

Usually, more than one query parameter is used in a data set.
  
```xml
<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
</Query>
</DataSet>
</DataSets>
```

So far, you have read about the data required for the reports (produced by the query and its parameters) but the report also consists of a layout how to display the data. The following to sections called “Body” and “Page” contain definitions for all graphical elements like shape, position, foreground and background color and size. But it may also specify active code to define complex behavior based on user actions.
  
```xml
<Body>
</Body>
<Page>
</Page>
```

If a report contains images or pictures, they are Base64-encoded and included in the RDL file.
  
```xml
<EmbeddedImages>
<EmbeddedImage Name="sepagoBalken">
<MIMEType>image/png</MIMEType>
<ImageData>
```

This is where the image data goes.
  
```xml
</ImageData>
</EmbeddedImage>
</EmbeddedImages>
</Report>
```

Hopefully, this article has helped you to a better understanding of the report definition language and EdgeSight reports.
