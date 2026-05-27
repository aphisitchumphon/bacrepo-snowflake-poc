-- 1. ใช้ role + เลือก context
USE ROLE ACCOUNTADMIN;
USE DATABASE AGENT_AI;
USE SCHEMA GIT;

-- 2. สร้าง Secret (เก็บ GitHub PAT)
CREATE OR REPLACE SECRET github_pat_secret
TYPE = PASSWORD
USERNAME = 'aphisitchumphon'
PASSWORD = 'github_pat_xxxxx';  -- ⚠️ อย่า push ของจริงลง Git

-- 3. สร้าง API Integration (รวม secret เข้าไปเลย)
CREATE OR REPLACE API INTEGRATION git_api
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/aphisitchumphon/')
  ALLOWED_AUTHENTICATION_SECRETS = (github_pat_secret)
  ENABLED = TRUE;

-- 4. สร้าง Git Repository
CREATE OR REPLACE GIT REPOSITORY my_repo
  API_INTEGRATION = git_api
  ORIGIN = 'https://github.com/aphisitchumphon/bacrepo-snowflake-poc.git';

-- 5. Fetch repo
ALTER GIT REPOSITORY my_repo FETCH;

-- 6. ตรวจสอบ branch
LS @my_repo/branches/main;

-- 7. Grant permission
GRANT USAGE ON DATABASE AGENT_AI TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA AGENT_AI.GIT TO ROLE ACCOUNTADMIN;
GRANT READ ON SECRET AGENT_AI.GIT.GITHUB_PAT_SECRET TO ROLE ACCOUNTADMIN;

-- 8. ตรวจสอบ secret
SHOW SECRETS LIKE 'GITHUB_PAT_SECRET' IN SCHEMA AGENT_AI.GIT;
``