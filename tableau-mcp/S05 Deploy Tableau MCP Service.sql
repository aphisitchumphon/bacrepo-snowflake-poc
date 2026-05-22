/*
================================================================================
Step: Recreate Tableau MCP Service without Readiness Probe
Purpose:
  Deploy the Tableau MCP Docker image as a Snowpark Container Services service
  without readinessProbe because the MCP endpoint requires MCP/JSON-RPC session
  semantics and may not respond successfully to a simple HTTP GET health check.

ใช้ทำอะไร:
  ใช้สร้าง SPCS service ใหม่สำหรับ Tableau MCP
  โดยเอา readinessProbe ออกเพื่อไม่ให้ service ค้าง PENDING

Prerequisites:
  - Image exists in Snowflake Image Repository
  - Compute Pool TABLEAU_MCP_POOL is IDLE or ACTIVE
  - External Access Integration TABLEAU_MCP_EAI is ENABLED
  - Network Rule allows egress to www.bac.co.th:8000

Objects Created:
  - AGENT_AI.AGENT_101.TABLEAU_MCP_SERVICE

Important:
  - PAT_VALUE is passed as environment variable for POC only.
  - For production, move PAT_VALUE to Snowflake SECRET.
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

CREATE SERVICE TABLEAU_MCP_SERVICE
  IN COMPUTE POOL TABLEAU_MCP_POOL
  FROM SPECIFICATION $$
spec:
  containers:
    - name: tableau-mcp
      image: /agent_ai/agent_101/tableau_mcp_repo/tableau-mcp:latest
      env:
        TRANSPORT: "http"
        PORT: "3927"
        SERVER: "https://www.bac.co.th:8000"
        SITE_NAME: "JeansOnly"
        PAT_NAME: "agent_ai_101"
        PAT_VALUE: "hoa8e9gZRTKmYxeTIBlQYg==:tSv8LWLja5HE59VHgma7f29yuWN9EotY"
        DANGEROUSLY_DISABLE_OAUTH: "true"
        DEFAULT_LOG_LEVEL: "debug"
  endpoints:
    - name: tableau-mcp
      port: 3927
      public: true
      protocol: HTTP
$$
  EXTERNAL_ACCESS_INTEGRATIONS = (TABLEAU_MCP_EAI)
  MIN_INSTANCES = 1
  MAX_INSTANCES = 1;

SHOW SERVICES LIKE 'TABLEAU_MCP_SERVICE' IN SCHEMA AGENT_AI.AGENT_101;

/*
================================================================================
Step: Check Tableau MCP Service Logs
Purpose:
  Inspect logs from the Tableau MCP container if the service remains PENDING
  or fails to become ready.

ใช้ทำอะไร:
  ใช้ดู log ของ container เพื่อหา error เช่น env ผิด, PAT ผิด, port ไม่เปิด,
  readiness probe fail, หรือ container start ไม่สำเร็จ
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA AGENT_101;

CALL SYSTEM$GET_SERVICE_LOGS(
  'AGENT_AI.AGENT_101.TABLEAU_MCP_SERVICE',
  '0',
  'tableau-mcp'
);

DROP SERVICE IF EXISTS TABLEAU_MCP_SERVICE;