-- ============================================================
-- STEP 1: Setup Permissions (ทำครั้งเดียว)
-- ============================================================
USE ROLE SYSADMIN;

GRANT CREATE NOTEBOOK ON SCHEMA DEMO_DEV.GOLD TO ROLE DEV_ROLE;
GRANT CREATE NOTEBOOK ON SCHEMA DEMO_PRD.GOLD TO ROLE PRD_ROLE;


-- ============================================================
-- STEP 2: Create Notebooks from Git (ทำครั้งเดียว)
-- ============================================================
CREATE OR REPLACE NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER
    FROM '@SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO/branches/main/notebook/'
    MAIN_FILE = 'S01 - Raw to Silver.ipynb'
    QUERY_WAREHOUSE = DEV_WH;

CREATE OR REPLACE NOTEBOOK DEMO_PRD.GOLD.RAW_TO_SILVER
    FROM '@SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO/branches/main/notebook/'
    MAIN_FILE = 'S01 - Raw to Silver.ipynb'
    QUERY_WAREHOUSE = PRD_WH;


-- ============================================================
-- STEP 3: Publish Live Version (ทำครั้งเดียวหลัง CREATE)
-- ============================================================
ALTER NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER ADD LIVE VERSION FROM LAST;
ALTER NOTEBOOK DEMO_PRD.GOLD.RAW_TO_SILVER ADD LIVE VERSION FROM LAST;


-- ============================================================
-- STEP 4: ทุกครั้งที่ต้องการรัน (Daily / Scheduled)
-- ============================================================
-- Sync โค้ดล่าสุดจาก Git
ALTER GIT REPOSITORY SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO FETCH;

-- Execute ทั้ง DEV และ PRD
EXECUTE NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER();
EXECUTE NOTEBOOK DEMO_PRD.GOLD.RAW_TO_SILVER();



-- 1. Sync โค้ดล่าสุดจาก Git
ALTER GIT REPOSITORY SANDBOX_DB.SECURITY.SNOWFLAKE_GIT_REPO FETCH;

-- 2. Commit Live Version ก่อน แล้ว Publish ใหม่จาก LAST
ALTER NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER COMMIT;
ALTER NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER ADD LIVE VERSION FROM LAST;

-- 3. รัน
EXECUTE NOTEBOOK DEMO_DEV.GOLD.RAW_TO_SILVER();