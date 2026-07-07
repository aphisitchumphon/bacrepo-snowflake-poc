-- ============================================================
-- STEP 1: Setup Permissions (ทำครั้งเดียว)
-- ============================================================
USE ROLE SYSADMIN;

GRANT CREATE NOTEBOOK ON SCHEMA DEMO_DEV.GOLD TO ROLE DEV_ROLE;
GRANT CREATE NOTEBOOK ON SCHEMA DEMO_PRD.GOLD TO ROLE PRD_ROLE;


-- ============================================================
-- STEP 2: Deploy & Run (ทำทุกครั้งที่ต้องการ sync โค้ดใหม่จาก Git)
-- ============================================================

-- Sync โค้ดล่าสุดจาก Git
ALTER GIT REPOSITORY SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO FETCH;

-- Recreate Notebooks จาก Git
CREATE OR REPLACE NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER
    FROM '@SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO/branches/main/notebook/'
    MAIN_FILE = 'S01 - Raw to Silver.ipynb'
    QUERY_WAREHOUSE = DEV_WH;

CREATE OR REPLACE NOTEBOOK DEMO_PRD.GOLD.RAW_TO_SILVER
    FROM '@SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO/branches/main/notebook/'
    MAIN_FILE = 'S01 - Raw to Silver.ipynb'
    QUERY_WAREHOUSE = PRD_WH;

-- Publish Live Version
ALTER NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER ADD LIVE VERSION FROM LAST;
ALTER NOTEBOOK DEMO_PRD.GOLD.RAW_TO_SILVER ADD LIVE VERSION FROM LAST;

-- Execute
EXECUTE NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER();
EXECUTE NOTEBOOK DEMO_PRD.GOLD.RAW_TO_SILVER();