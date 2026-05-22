/*
================================================================================
Step: Describe Tableau MCP Service Endpoint
Purpose:
  Verify the service endpoint configuration before creating an MCP connector
  for Snowflake Intelligence.

ใช้ทำอะไร:
  ใช้ดูรายละเอียดของ TABLEAU_MCP_SERVICE และ endpoint ว่า public endpoint
  ถูกสร้างเรียบร้อยแล้ว และ port/protocol ตรงกับ MCP server หรือไม่

Expected Result:
  - endpoint name: tableau-mcp
  - port: 3927
  - protocol: HTTP
  - public: true
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

DESCRIBE SERVICE TABLEAU_MCP_SERVICE;

SHOW ENDPOINTS IN SERVICE TABLEAU_MCP_SERVICE;

