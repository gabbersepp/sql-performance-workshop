SELECT    s.creation_time,
  s.last_execution_time,
  s.execution_count,
  sql_text.text,
  sql_plan.query_plan,
  s.plan_handle
FROM sys.dm_exec_query_stats as s 
CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) as sql_text
CROSS APPLY sys.dm_exec_query_plan(s.plan_handle) as sql_plan
WHERE query_hash = 0x573D0EC08904E94D