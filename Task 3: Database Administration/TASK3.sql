--a) SQL Command for Full Backup of "ShopDB" Database:
--To perform a full backup of a SQL Server database and store a compressed backup file, you can use the following SQL command:
 
BACKUP DATABASE [YOURDATABASENAME]
TO DISK = 'C:\Backups\YOURDATABASENAME.bak'
WITH COMPRESSION;


--Explanation:
--BACKUP DATABASE [ShopDB]: This command specifies that the "YOURDATABASENAME" database is being backed up.
--TO DISK = 'C:\Backups\ShopDB.bak': Specifies the file path where the backup will be saved.
--WITH COMPRESSION: Compresses the backup file to save space.

---------------------------------------------------------------------
--b) Find Long-Running Queries:
--To find the most long-running queries in SQL Server, you can use the following query:


SELECT
    q.text AS QueryText,
    s.execution_count,
    s.total_elapsed_time / 1000 AS TotalElapsedTime_ms,
    s.total_logical_reads,
    s.total_logical_writes
FROM
    sys.dm_exec_query_stats s
CROSS APPLY
    sys.dm_exec_sql_text(s.sql_handle) AS q
ORDER BY
    s.total_elapsed_time DESC;

Explanation:
sys.dm_exec_query_stats: This DMV (Dynamic Management View) contains execution statistics for queries.
sys.dm_exec_sql_text: This function retrieves the SQL text of the queries.
total_elapsed_time: The total time taken by the query in microseconds (converted to milliseconds)
-----
--c) Common Performance Tuning Techniques in SQL Server:

--Indexing:
--Ensure that appropriate indexes are in place to reduce full table scans and improve query performance.

--Query Optimization:
--Review queries for inefficiencies such as unnecessary joins, subqueries, or non-SARGable conditions (e.g., using LIKE with wildcards at the start).

--Statistics:
--Regularly update statistics using the following command to ensure the query optimizer has accurate data:
 
UPDATE STATISTICS [YourTableName];


--Monitoring and Identifying Bottlenecks:
--Use Dynamic Management Views (DMVs) such as sys.dm_os_wait_stats and sys.dm_exec_requests to identify performance bottlenecks like CPU, memory, or IO-related waits.

--Execution Plans:
--Analyze execution plans to identify issues like table scans or missing indexes.
--By applying these techniques, you can systematically identify and address performance issues in SQL Server. ​