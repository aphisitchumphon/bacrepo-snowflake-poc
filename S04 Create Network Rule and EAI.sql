/*
================================================================================
Step: Create Network Rule and External Access Integration for Tableau Server
Purpose:
  Allow the Tableau MCP container running on Snowpark Container Services to make
  outbound HTTPS requests to the Tableau Server endpoint.

ใช้ทำอะไร:
  ใช้อนุญาตให้ SPCS service ที่รัน Tableau MCP ออกไปเรียก Tableau Server
  ที่ www.bac.co.th:8000 ได้

Prerequisites:
  - Role ACCOUNTADMIN
  - Compute Pool TABLEAU_MCP_POOL already exists and is IDLE/ACTIVE
  - Tableau Server endpoint is https://www.bac.co.th:8000

Objects Created:
  - Network Rule: AGENT_AI.AGENT_101.TABLEAU_SERVER_EGRESS_RULE
  - External Access Integration: TABLEAU_MCP_EAI

Notes:
  - Network rule TYPE = HOST_PORT and MODE = EGRESS
  - VALUE_LIST includes the Tableau Server hostname and port
  - For POC, ENABLED = TRUE
================================================================================
*/

USE ROLE ACCOUNTADMIN;

USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

CREATE OR REPLACE NETWORK RULE TABLEAU_SERVER_EGRESS_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('www.bac.co.th:8000');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION TABLEAU_MCP_EAI
  ALLOWED_NETWORK_RULES = (TABLEAU_SERVER_EGRESS_RULE)
  ENABLED = TRUE;

SHOW NETWORK RULES LIKE 'TABLEAU_SERVER_EGRESS_RULE' IN SCHEMA AGENT_AI.AGENT_101;

SHOW INTEGRATIONS LIKE 'TABLEAU_MCP_EAI';