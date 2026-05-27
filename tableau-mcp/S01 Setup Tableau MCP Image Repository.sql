/*
================================================================================
Step: Create Snowflake Image Repository for Tableau MCP
Purpose:
  Create an image repository in Snowflake to store the Docker image for Tableau MCP
  before deploying it to Snowpark Container Services.

ใช้ทำอะไร:
  ใช้สร้าง Image Repository สำหรับเก็บ Docker image ของ Tableau MCP
  เพื่อเอาไป deploy เป็น Snowpark Container Services

Prerequisites:
  - Role ต้องมีสิทธิ์สร้าง IMAGE REPOSITORY
  - ใช้ Database: AGENT_AI
  - ใช้ Schema: AGENT_101

Objects Created:
  - AGENT_AI.AGENT_101.TABLEAU_MCP_REPO

Author:
  Aphisit / POC Snowflake Intelligence + Tableau MCP

================================================================================
*/

USE ROLE ACCOUNTADMIN;

USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

CREATE IMAGE REPOSITORY IF NOT EXISTS TABLEAU_MCP_REPO;

SHOW IMAGE REPOSITORIES IN SCHEMA AGENT_AI.AGENT_101;

-- :: =============================================================================
-- :: Step: Tag local Tableau MCP Docker image for Snowflake Image Repository
-- :: Purpose:
-- ::   Tag the local Docker image "tableau-mcp:latest" so it can be pushed to
-- ::   Snowflake Image Repository for Snowpark Container Services deployment.
-- ::
-- :: ใช้ทำอะไร:
-- ::   ใช้เปลี่ยนชื่อ/tag ของ Docker image ที่ build ไว้ในเครื่อง
-- ::   ให้ตรงกับ path ของ Snowflake Image Repository
-- ::
-- :: Prerequisites:
-- ::   - Docker Desktop is running
-- ::   - Local image "tableau-mcp:latest" exists
-- ::   - Snowflake Image Repository "TABLEAU_MCP_REPO" already exists
-- ::
-- :: Source Image:
-- ::   tableau-mcp:latest
-- ::
-- :: Target Image:
-- ::   bflszia-lk77308.registry.snowflakecomputing.com/agent_ai/agent_101/tableau_mcp_repo/tableau-mcp:latest
-- :: =============================================================================

docker tag tableau-mcp:latest bflszia-lk77308.registry.snowflakecomputing.com/agent_ai/agent_101/tableau_mcp_repo/tableau-mcp:latest