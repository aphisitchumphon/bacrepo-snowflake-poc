/*
================================================================================
Step: Check available MCP related commands / objects
Purpose:
  Verify whether this Snowflake account supports MCP connector objects for
  Snowflake Intelligence / Cortex Agents.

ใช้ทำอะไร:
  ใช้ตรวจสอบเบื้องต้นก่อนสร้าง MCP Connector
  เพราะ syntax ของ MCP connector อาจขึ้นกับ account feature/preview version

Expected Result:
  - If supported, the following MCP related SQL syntax should work in the account.
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

SHOW MCP SERVERS;