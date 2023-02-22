
--Script used to delete records from the DataCheckerPersistence.destination.EdFiRuleExecutionLogDetails database

USE DataCheckerPersistence
GO
----------------------------------------------------------------------------------------------------------------------------------------
----Create/Rebuild Indexes
----------------------------------------------------------------------------------------------------------------------------------------
--Index on destination.EdFiRuleExecutionLogDetails
DECLARE @index_name NVARCHAR(50) = N'PK_EdFiRuleExecutionLogDetails';
DECLARE @table_name NVARCHAR(50) = N'destination.EdFiRuleExecutionLogDetails';
DECLARE @column_name NVARCHAR(50) = N'RuleExecutionLogId';

IF EXISTS (
  SELECT * 
  FROM sys.indexes 
  WHERE name = @index_name AND object_id = OBJECT_ID(@table_name)
) 
BEGIN 
  EXEC('ALTER INDEX ' + @index_name + ' ON ' + @table_name + ' REBUILD');
END 
ELSE 
BEGIN 
  EXEC('CREATE INDEX ' + @index_name + ' ON ' + @table_name + ' (' + @column_name + ')');
END;


--Index on destination.RuleExecutionLogs
DECLARE @index_name2 NVARCHAR(50) = N'index_Id_and_ExecutionDate';
DECLARE @table_name2 NVARCHAR(50) = N'destination.RuleExecutionLogs';
DECLARE @column1_name NVARCHAR(50) = N'Id';
DECLARE @column2_name NVARCHAR(50) = N'ExecutionDate';

IF EXISTS (
  SELECT * 
  FROM sys.indexes 
  WHERE name = @index_name2 AND object_id = OBJECT_ID(@table_name2)
) 
BEGIN 
  EXEC('ALTER INDEX ' + @index_name2 + ' ON ' + @table_name2 + ' REBUILD');
END 
ELSE 
BEGIN 
  EXEC('CREATE INDEX ' + @index_name2 + ' ON ' + @table_name2 + ' (' + @column1_name + ', ' + @column2_name + ')');
END;

----------------------------------------------------------------------------------------------------------------------------------------
----Delete from Table
----------------------------------------------------------------------------------------------------------------------------------------
USE DataCheckerPersistence
GO

delete ereld from destination.EdFiRuleExecutionLogDetails ereld
inner join destination.RuleExecutionLogs rel on ereld.RuleExecutionLogId=rel.Id
where CAST(rel.ExecutionDate as date) < CAST(GETDATE() as date)

--select * from destination.EdFiRuleExecutionLogDetails ereld
--inner join destination.RuleExecutionLogs rel on ereld.RuleExecutionLogId=rel.Id
--where CAST(rel.ExecutionDate as date) >= CAST(GETDATE() as date)

DELETE from destination.RuleExecutionLogs where CAST(ExecutionDate as date) < CAST(GETDATE() as date)
--SELECT * from destination.RuleExecutionLogs where CAST(ExecutionDate as date) < CAST(GETDATE() as date)

----------------------------------------------------------------------------------------------------------------------------------------
----Shrink Log File
----------------------------------------------------------------------------------------------------------------------------------------
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE DataCheckerPersistence
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (DataCheckerPersistence_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE DataCheckerPersistence
SET RECOVERY FULL;
GO


----------------------------------------------------------------------------------------------------------------------------------------
--Shrink Database
----------------------------------------------------------------------------------------------------------------------------------------
DBCC SHRINKDATABASE (DataCheckerPersistence, 10);
GO