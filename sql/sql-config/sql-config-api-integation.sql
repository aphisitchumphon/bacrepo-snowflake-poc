-- 1. ใช้ role + context
USE ROLE ACCOUNTADMIN;
USE DATABASE SANDBOX_DB;
USE SCHEMA SECURITY;

-- 2. สร้าง Secret (เก็บ GitHub PAT)
CREATE OR REPLACE SECRET GITHUB_PAT_SECRET
TYPE = PASSWORD
USERNAME = 'aphisitchumphon'
PASSWORD = 'github_pat_1xx';  -- ⚠️ ใส่ของจริงเฉพาะ runtime

-- 3. สร้าง API Integration
CREATE OR REPLACE API INTEGRATION git_api
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/aphisitchumphon/')
  ALLOWED_AUTHENTICATION_SECRETS = (GITHUB_PAT_SECRET)
  ENABLED = TRUE;

-- 4. กำหนด schema สำหรับ Git object (แนะนำแยก)
CREATE OR REPLACE SCHEMA SANDBOX_DB.GIT;

-- 5. สร้าง Git Repository
USE SCHEMA SANDBOX_DB.GIT;

CREATE OR REPLACE GIT REPOSITORY MY_REPO
  API_INTEGRATION = git_api
  ORIGIN = 'https://github.com/aphisitchumphon/bacrepo-snowflake-poc.git';

-- 6. Fetch repo
ALTER GIT REPOSITORY MY_REPO FETCH;

-- 7. ตรวจสอบ branch
LS @MY_REPO/branches/main;

-- 8. ตรวจสอบ secret (ถูก schema แล้ว)
SHOW SECRETS LIKE 'GITHUB_PAT_SECRET' IN SCHEMA SANDBOX_DB.SECURITY;
