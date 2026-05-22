/*
================================================================================
Step: Register Tableau MCP Service as Custom MCP Server
Purpose:
  Register the Tableau MCP service running on Snowpark Container Services as a
  Custom MCP Server so it can be used by Snowflake Intelligence / Cortex Agent.

ใช้ทำอะไร:
  ใช้ register SPCS service ที่รัน Tableau MCP อยู่แล้ว
  ให้กลายเป็น Custom MCP Server ที่ Agent สามารถ add เป็น MCP Connector ได้

Prerequisites:
  - TABLEAU_MCP_SERVICE already exists
  - TABLEAU_MCP_SERVICE status is RUNNING
  - Endpoint name is tableau-mcp
  - Endpoint path is /tableau-mcp
  - Service role ALL_ENDPOINTS_USAGE exists in TABLEAU_MCP_SERVICE
  - Role ACCOUNTADMIN is used for POC

Objects Created:
  - AGENT_AI.AGENT_101.TABLEAU_CUSTOM_MCP_SERVER

Permissions Granted:
  - SERVICE ROLE TABLEAU_MCP_SERVICE!ALL_ENDPOINTS_USAGE to ACCOUNTADMIN
  - USAGE ON CUSTOM MCP SERVER TABLEAU_CUSTOM_MCP_SERVER to ACCOUNTADMIN

Expected Result:
  - TABLEAU_CUSTOM_MCP_SERVER is created successfully
  - ACCOUNTADMIN can use the Custom MCP Server
  - Agent UI can see TABLEAU_CUSTOM_MCP_SERVER in MCP Connectors

================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

CREATE CUSTOM MCP SERVER IF NOT EXISTS TABLEAU_CUSTOM_MCP_SERVER
  SERVICE = TABLEAU_MCP_SERVICE
  ENDPOINT = "tableau-mcp"
  PATH = '/tableau-mcp';

SHOW CUSTOM MCP SERVERS;

DESC CUSTOM MCP SERVER TABLEAU_CUSTOM_MCP_SERVER;


/*
================================================================================
Step: Grant Access to Custom MCP Server and Service Endpoint
Purpose:
  Grant required permissions so the selected role can access the Custom MCP Server
  and the underlying Snowpark Container Services endpoint.

ใช้ทำอะไร:
  ใช้ให้สิทธิ์ role ACCOUNTADMIN สามารถใช้งาน TABLEAU_CUSTOM_MCP_SERVER
  และเข้าถึง endpoint ของ TABLEAU_MCP_SERVICE ได้

Notes:
  - ALL_ENDPOINTS_USAGE is the service role generated for the SPCS service.
  - For production, grant these permissions to a dedicated agent role instead of
    ACCOUNTADMIN.
================================================================================
*/

GRANT SERVICE ROLE TABLEAU_MCP_SERVICE!ALL_ENDPOINTS_USAGE
  TO ROLE ACCOUNTADMIN;

GRANT USAGE ON CUSTOM MCP SERVER TABLEAU_CUSTOM_MCP_SERVER
  TO ROLE ACCOUNTADMIN;

SHOW GRANTS TO ROLE ACCOUNTADMIN;

SHOW GRANTS ON SERVICE TABLEAU_MCP_SERVICE;