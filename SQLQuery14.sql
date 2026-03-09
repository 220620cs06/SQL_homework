--create database lesson14
--go
--use lesson14

DECLARE @html NVARCHAR(MAX);

SET @html = 
N'<h2>Index Metadata Report</h2>' +
N'<style>
    table { border-collapse: collapse; width: 100%; font-family: Arial; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #4CAF50; color: white; }
    tr:nth-child(even) { background-color: #f2f2f2; }
</style>' +
N'<table>
    <tr>
        <th>Table Name</th>
        <th>Index Name</th>
        <th>Index Type</th>
        <th>Column Name</th>
    </tr>' +
CAST((
    SELECT 
        td = t.name, '',
        td = ind.name, '',
        td = ind.type_desc, '',
        td = col.name
    FROM sys.indexes ind
    INNER JOIN sys.tables t ON ind.object_id = t.object_id
    INNER JOIN sys.index_columns ic ON ind.object_id = ic.object_id AND ind.index_id = ic.index_id
    INNER JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
    WHERE ind.is_hypothetical = 0 AND ind.type > 0
    ORDER BY t.name, ind.name
    FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX)) +
N'</table>';

-- Send email using Database Mail
exec msdb.dbo.sp_send_dbmail
	@profile_name= 'Guljahon',
	@recipients='kamoliddinovaguljahon75@gmai.com',
	@subject='SQL Server Index Metadata Report',
	@body=@html,
	@body_format = 'HTML';


select sent_status,*
from msdb.dbo.sysmail_allitems
order by send_request_date desc

--type2



DECLARE @HtmlBody NVARCHAR(MAX);

/* 1) Collect index metadata */
IF OBJECT_ID('tempdb..#IndexMetadata') IS NOT NULL
    DROP TABLE #IndexMetadata;

SELECT
      s.name       AS SchemaName
    , t.name       AS TableName
    , i.name       AS IndexName
    , i.type_desc  AS IndexType
    , c.name       AS ColumnName
    , ty.name      AS ColumnDataType
    , ic.key_ordinal
INTO #IndexMetadata
FROM sys.tables        AS t
JOIN sys.schemas       AS s  ON t.schema_id = s.schema_id
JOIN sys.indexes       AS i  ON t.object_id = i.object_id
JOIN sys.index_columns AS ic ON i.object_id = ic.object_id
                             AND i.index_id  = ic.index_id
JOIN sys.columns       AS c  ON ic.object_id = c.object_id
                             AND ic.column_id = c.column_id
JOIN sys.types         AS ty ON c.user_type_id = ty.user_type_id
WHERE i.index_id > 0              -- exclude heaps
  AND i.is_hypothetical = 0
  AND t.is_ms_shipped = 0;        -- ignore system tables

/* 2) Build HTML with styling */
SET @HtmlBody =
N'<html>
<head>
<style>
body { font-family: Arial, sans-serif; font-size: 11px; }
table { border-collapse: collapse; width: 100%; }
th, td { border: 1px solid #cccccc; padding: 4px 6px; text-align: left; }
th { background-color: #f2f2f2; }
tr:nth-child(even) { background-color: #fafafa; }
</style>
</head>
<body>
<h2>Index Metadata Report</h2>
<table>
<tr>
    <th>Schema</th>
    <th>Table Name</th>
    <th>Index Name</th>
    <th>Index Type</th>
    <th>Column Name</th>
    <th>Column Type</th>
</tr>';

SELECT @HtmlBody = @HtmlBody +
       N'<tr>' +
       N'<td>' + ISNULL(SchemaName,      N'') + N'</td>' +
       N'<td>' + ISNULL(TableName,       N'') + N'</td>' +
       N'<td>' + ISNULL(IndexName,       N'') + N'</td>' +
       N'<td>' + ISNULL(IndexType,       N'') + N'</td>' +
       N'<td>' + ISNULL(ColumnName,      N'') + N'</td>' +
       N'<td>' + ISNULL(ColumnDataType,  N'') + N'</td>' +
       N'</tr>'
FROM #IndexMetadata
ORDER BY SchemaName, TableName, IndexName, key_ordinal;

SET @HtmlBody = @HtmlBody +
N'</table>
</body>
</html>';

/* 3) Send HTML email via Database Mail */

exec msdb.dbo.sp_send_dbmail
	@profile_name= 'Guljahon',
	@recipients='kamoliddinovaguljahon75@gmai.com',
	@subject='SQL Server Index Metadata Report',
	@body=@HtmlBody,
	@body_format = 'HTML';

	
select sent_status,*
from msdb.dbo.sysmail_allitems
order by send_request_date desc

