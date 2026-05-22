/*
================================================================================
Step: Get Public Endpoint URL for Tableau MCP Service
Purpose:
  Retrieve the public endpoint URL of the Tableau MCP service running on
  Snowpark Container Services.

ใช้ทำอะไร:
  ใช้ดึง URL ของ Tableau MCP service ที่ deploy บน Snowflake
  เพื่อนำไป test และเชื่อมต่อกับ MCP Connector / Snowflake Intelligence

Expected Result:
  - Get endpoint name: tableau-mcp
  - Get public URL for the service endpoint

Prerequisites:
  - TABLEAU_MCP_SERVICE status is RUNNING
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

SHOW ENDPOINTS IN SERVICE TABLEAU_MCP_SERVICE;