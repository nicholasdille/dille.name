---
id: 1596
title: New Example SQL Query for Custom EdgeSight Reports
date: 2011-04-29T16:13:54+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/04/29/new-example-sql-query-for-custom-edgesight-reports/
categories:
  - sepago
tags:
  - Citrix
  - EdgeSight
  - Performance
  - SQL
  - SQL Server
---
In [my series about custom report](/blog/2010/07/06/building-custom-edgesight-reports-part-1-kick-off/ "Building Custom EdgeSight Reports Part 1 – Kick Off") for [Citrix EdgeSight](/blog/tags#edgesight/), I [introduced a lengthy example query](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query/ "Building Custom EdgeSight Reports Part 3 – The Query") for system performance including standard constructs for filtering by time and department as well as machine groups. Now that we know about [additional parameters](/blog/2011/04/27/inside-edgesight-report-parameters/ "Inside EdgeSight Report Parameters") for process categories and user groups, let’s have a look at an example SQL query.

<!--more-->

## The Vanilla Query

The following query pulls process performance data from the view `vw_image_perf` which is based on the table `image_perf`. By joining the data to the tables `image` and `vendor` detailed information about the name, version and the vendor is added to the query.

Unfortunately, it is rather tricky figuring out which categories a process belongs to: Although the table `image_package` contains data about all process categories, the name is stored in `image_package_locale` to provide localized names for users outside the English speaking countries. But joining with the table `image_package_locale` is required for all queries because it also holds the English names for process categories. The variable `@Locale` defines the desired language. If this is included in the report parameters, the language of the EdgeSight console is automatically used for the category names in the report.

Sometimes it makes sense to retrieve the name of the user running the individual processes, so we join the table `principal` to get our hands on domain and user name. As usual we also pull in department and machine information by joining the tables `instance`, `machine` and `dept`.
  
```sql
DECLARE @Locale AS CHAR(2)
SET @Locale = 'en'
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
    image.imid,
    image.filename AS Process,
    image.file_version AS Version,
    image.filename + ' (' + image.file_version + ')' AS ProcessUnique,
    vendor.name AS Vendor,
    SUM(vw_image_perf.working_set_sum / vw_image_perf.working_set_cnt) AS SumWorkingSet,
    AVG(vw_image_perf.working_set_sum / vw_image_perf.working_set_cnt) AS AvgWorkingSet
FROM
    vw_image_perf JOIN
    image ON vw_image_perf.imid = image.imid JOIN
    vendor ON image.vendid = vendor.vendid JOIN
    image_package_map ON image.imid = image_package_map.imid JOIN
    image_package ON image_package_map.pkgid = image_package.pkgid JOIN
    image_package_locale ON (
        image_package.pkgid = image_package_locale.pkgid AND
        image_package_locale.two_letter_code = @Locale
    ) JOIN
    instance ON vw_image_perf.instid = instance.instid JOIN
    dept ON instance.deptid = dept.deptid JOIN
    machine ON instance.machid = instance.machid JOIN
    principal ON vw_image_perf.principal_id = principal.prid
WHERE
    vw_image_perf.dtperiod BETWEEN @UTCStartDate AND @UTCEndDate AND
    vw_image_perf.instid IN (SELECT * FROM dbo.udf_core_sub_inst(@Filter))
GROUP BY
    image.imid,
    image.filename,
    image.file_version,
    vendor.name
ORDER BY
    SumWorkingSet
```
  
The query already contains the filters for the UTC-converted time intervalls as well as the filter for departments and machine groups.

## Filtering by Process Category

**Important note:** EdgeSight uses different terms internally and on the web-based console. When a process is concerned, the term "image" is used in the database schema. A process category is stored in table prefixed by `image_package`.

Including the parameter `@Category` into the query is rather straight forward because the process category is passed as the ID of the selected package (`pkgid`) from the table `image_package`. By using a similar construct as for `@Filter` (see vanilla query above), we filter our image IDs (`imid`) against selecting all processes contained in the process category (table `image_package_map`) corresponding to `@Category`.
  
```sql
...
WHERE
... AND
(@Category = 0 OR image.imid IN (SELECT imid FROM image_package_map WHERE pkgid = @Category))
```
  
When no process category is selected, the parameter `@Category` is set to zero. This special case is checked for in the `WHERE` clause to include all process categories.

## Filtering by User Group

**Important note:** EdgeSight uses different terms internally and on the web-based console. When an user or service account is concerned, the term "principal" is used in the database schema.

Adding the filter for a user group is a bit more tricky than the case above because I have not been able to find a nifty stored procedure similar to `udf_core_sub_inst()` which resolves a user group ID into a list of members (`prid` from table `principal`). Therefore, we need to store the membership information in a temporary table to access it in the main query.

Instead of creating a temporary table, I have declared a table variable called `@temptable` which is filled by an `INSERT` statement from the stored procedure `es_usergroup_get_member_users()`. This temporary table is used in the main query to filter the `principal_id` of processes in the table `vw_image_perf` against it.
  
```sql
DECLARE @temptable TABLE (user_name NVARCHAR(256), domain_name NVARCHAR(15), prid int)
INSERT INTO @temptable EXEC dbo.es_usergroup_get_member_users @UserGroup
...
WHERE
... AND
(@UserGroup = 0 OR vw_image_perf.principal_id IN (SELECT prid FROM @temptable))
```
  
Just like above the `WHERE` clause also includes a check for a zero user group indicating no filtering is required.

## The Entire Query

Below is the entire query containing filters for process categories as well as for user groups.
  
```sql
DECLARE @Locale AS CHAR(2)
SET @Locale = 'en'
DECLARE @temptable TABLE (user_name NVARCHAR(256), domain_name NVARCHAR(15), prid int)
INSERT INTO @temptable EXEC dbo.es_usergroup_get_member_users @UserGroup
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
    image.imid,
    image.filename AS Process,
    image.file_version AS Version,
    image.filename + ' (' + image.file_version + ')' AS ProcessUnique,
    vendor.name AS Vendor,
    SUM(vw_image_perf.working_set_sum / vw_image_perf.working_set_cnt) AS SumWorkingSet,
    AVG(vw_image_perf.working_set_sum / vw_image_perf.working_set_cnt) AS AvgWorkingSet
FROM
    vw_image_perf JOIN
    image ON vw_image_perf.imid = image.imid JOIN
    vendor ON image.vendid = vendor.vendid JOIN
    image_package_map ON image.imid = image_package_map.imid JOIN
    image_package ON image_package_map.pkgid = image_package.pkgid JOIN
    image_package_locale ON (
        image_package.pkgid = image_package_locale.pkgid AND
        image_package_locale.two_letter_code = @Locale
    ) JOIN
    instance ON vw_image_perf.instid = instance.instid JOIN
    dept ON instance.deptid = dept.deptid JOIN
    machine ON instance.machid = instance.machid JOIN
    principal ON vw_image_perf.principal_id = principal.prid
WHERE
    vw_image_perf.dtperiod BETWEEN @UTCStartDate AND @UTCEndDate AND
    vw_image_perf.instid IN (SELECT * FROM dbo.udf_core_sub_inst(@Filter)) AND
    (@Category = 0 OR image.imid IN (SELECT imid FROM image_package_map WHERE pkgid = @Category)) AND
    (@UserGroup = 0 OR vw_image_perf.principal_id IN (SELECT prid FROM @temptable))
GROUP BY
    image.imid,
    image.filename,
    image.file_version,
    vendor.name
ORDER BY
    SumWorkingSet
```
