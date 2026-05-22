-- =========================
-- 1. ENV
-- =========================
SET ENV = 'DEV';  -- เปลี่ยนเป็น PRD ได้

-- =========================
-- 2. Variables
-- =========================
SET DB_NAME         = 'DEMO_' || $ENV;
SET ROLE_NAME       = $ENV || '_ROLE';
SET WH_NAME         = $ENV || '_WH';
SET STAGE_NAME      = $ENV || '_STAGE';
SET FILE_NAME       = 'SuperStore_Simple.csv';
SET FULL_STAGE_PATH = '@' || $DB_NAME || '.RAW.' || $STAGE_NAME || '/' || $FILE_NAME;

-- =========================
-- 3. Context
-- =========================
USE ROLE      IDENTIFIER($ROLE_NAME);
USE WAREHOUSE IDENTIFIER($WH_NAME);
USE DATABASE  IDENTIFIER($DB_NAME);
USE SCHEMA RAW;

-- =========================
-- 4. Table
-- =========================
CREATE OR REPLACE TABLE SUPERSTORE_RAW (
    ORDER_ID             INT,
    ORDER_DATE           DATE,
    SHIP_DATE            DATE,
    ORDER_PRIORITY       STRING,
    CUSTOMER_SEGMENT     STRING,
    CUSTOMER_NAME        STRING,
    SALES                FLOAT,
    QUANTITY             INT,
    PROFIT               FLOAT,
    PROVINCE             STRING,
    PRODUCT_CATEGORY     STRING,
    PRODUCT_SUB_CATEGORY STRING,
    PRODUCT_NAME         STRING
);

-- =========================
-- 5. Build SQL String ก่อน แล้วค่อย EXECUTE
-- =========================
SET COPY_SQL = 
    'COPY INTO SUPERSTORE_RAW FROM ' || $FULL_STAGE_PATH ||
    ' FILE_FORMAT = (TYPE = ''CSV'' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = ''"'') ON_ERROR = ''CONTINUE''';

EXECUTE IMMEDIATE $COPY_SQL;