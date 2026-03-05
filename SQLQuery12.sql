--create database lesson12
--go
--use lesson12

--task1

DECLARE @sql NVARCHAR(MAX) = N'';

-- Build dynamic SQL across all user databases
SELECT @sql = STRING_AGG(
    CAST(
        'SELECT ''' + d.name + ''' AS DatabaseName,
                s.name AS SchemaName,
                t.name AS TableName,
                c.name AS ColumnName,
                ty.name AS DataType
         FROM ' + QUOTENAME(d.name) + '.sys.tables t
         INNER JOIN ' + QUOTENAME(d.name) + '.sys.schemas s ON t.schema_id = s.schema_id
         INNER JOIN ' + QUOTENAME(d.name) + '.sys.columns c ON t.object_id = c.object_id
         INNER JOIN ' + QUOTENAME(d.name) + '.sys.types ty ON c.user_type_id = ty.user_type_id'
        AS NVARCHAR(MAX)
    )
, ' UNION ALL ')
FROM sys.databases d
WHERE d.name NOT IN ('master','tempdb','model','msdb');

EXEC sp_executesql @sql;

--task2

CREATE OR ALTER PROCEDURE usp_GetProceduresAndFunctions
    @DatabaseName SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    IF @DatabaseName IS NOT NULL
    BEGIN
        -- Single database case
        SET @sql = '
        SELECT ''' + @DatabaseName + ''' AS DatabaseName,
               s.name AS SchemaName,
               o.name AS ObjectName,
               o.type_desc AS ObjectType,
               p.name AS ParameterName,
               t.name AS DataType,
               p.max_length AS MaxLength
        FROM ' + QUOTENAME(@DatabaseName) + '.sys.objects o
        INNER JOIN ' + QUOTENAME(@DatabaseName) + '.sys.schemas s ON o.schema_id = s.schema_id
        LEFT JOIN ' + QUOTENAME(@DatabaseName) + '.sys.parameters p ON o.object_id = p.object_id
        LEFT JOIN ' + QUOTENAME(@DatabaseName) + '.sys.types t ON p.user_type_id = t.user_type_id
        WHERE o.type IN (''P'',''FN'',''IF'',''TF'');';

        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        DECLARE db_cursor CURSOR FOR
        SELECT name
        FROM sys.databases
        WHERE name NOT IN ('master','tempdb','model','msdb');

        DECLARE @dbname SYSNAME;

        OPEN db_cursor;
        FETCH NEXT FROM db_cursor INTO @dbname;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @sql = '
            SELECT ''' + @dbname + ''' AS DatabaseName,
                   s.name AS SchemaName,
                   o.name AS ObjectName,
                   o.type_desc AS ObjectType,
                   p.name AS ParameterName,
                   t.name AS DataType,
                   p.max_length AS MaxLength
            FROM ' + QUOTENAME(@dbname) + '.sys.objects o
            INNER JOIN ' + QUOTENAME(@dbname) + '.sys.schemas s ON o.schema_id = s.schema_id
            LEFT JOIN ' + QUOTENAME(@dbname) + '.sys.parameters p ON o.object_id = p.object_id
            LEFT JOIN ' + QUOTENAME(@dbname) + '.sys.types t ON p.user_type_id = t.user_type_id
            WHERE o.type IN (''P'',''FN'',''IF'',''TF'');';

            EXEC sp_executesql @sql;

            FETCH NEXT FROM db_cursor INTO @dbname;
        END

        CLOSE db_cursor;
        DEALLOCATE db_cursor;
    END
END;