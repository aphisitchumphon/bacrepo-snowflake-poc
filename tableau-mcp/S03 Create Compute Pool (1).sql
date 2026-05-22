/*
================================================================================
Step: Create Compute Pool for Tableau MCP Service
Purpose:
  Create a Snowpark Container Services compute pool that will run the Tableau MCP
  Docker container image already pushed to Snowflake Image Repository.

ใช้ทำอะไร:
  ใช้สร้าง compute pool สำหรับรัน container service ของ Tableau MCP
  โดย service นี้จะถูกใช้เป็น MCP endpoint ให้ Snowflake Intelligence เรียกใช้งานต่อไป

Prerequisites:
  - Docker image has already been pushed to Snowflake Image Repository
  - Role ACCOUNTADMIN is being used for POC
  - Database AGENT_AI and schema AGENT_101 already exist
  - Image repository AGENT_AI.AGENT_101.TABLEAU_MCP_REPO already exists

Objects Created:
  - Compute Pool: TABLEAU_MCP_POOL

Notes:
  - MIN_NODES = 1 and MAX_NODES = 1 are enough for POC
  - INSTANCE_FAMILY = CPU_X64_XS is the smallest practical CPU option for POC
  - AUTO_SUSPEND_SECS = 300 helps reduce cost when idle

================================================================================
*/

USE ROLE ACCOUNTADMIN;

CREATE COMPUTE POOL IF NOT EXISTS TABLEAU_MCP_POOL
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS
  AUTO_RESUME = TRUE
  AUTO_SUSPEND_SECS = 300;

SHOW COMPUTE POOLS LIKE 'TABLEAU_MCP_POOL';