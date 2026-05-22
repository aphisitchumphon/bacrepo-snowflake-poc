-- =========================
-- 1. ENV
-- =========================
SET ENV = 'DEV';

-- =========================
-- 2. Variables
-- =========================
SET DB_NAME   = 'DEMO_' || $ENV;
SET ROLE_NAME = $ENV || '_ROLE';
SET WH_NAME   = $ENV || '_WH';

-- =========================
-- 3. Context
-- =========================
USE ROLE      IDENTIFIER($ROLE_NAME);
USE WAREHOUSE IDENTIFIER($WH_NAME);
USE DATABASE  IDENTIFIER($DB_NAME);

-- =========================
-- 4. Execute
-- =========================
EXECUTE IMMEDIATE $$
DECLARE
    db_name   STRING;
    src_table STRING;
    tgt_table STRING;
    sql_stmt  STRING;
BEGIN
    -- อ่าน session variable ผ่าน SELECT
    db_name   := (SELECT $DB_NAME);
    src_table := db_name || '.RAW.SUPERSTORE_RAW';
    tgt_table := db_name || '.SILVER.SALES_BY_PROVINCE';

    sql_stmt  :=
        'CREATE OR REPLACE TABLE ' || tgt_table || ' AS
        SELECT
            PROVINCE,
            ROUND(SUM(SALES),  2)                                AS TOTAL_SALES,
            ROUND(SUM(PROFIT), 2)                                AS TOTAL_PROFIT,
            ROUND(AVG(SALES),  2)                                AS AVG_SALES_PER_ORDER,
            COUNT(ORDER_ID)                                      AS TOTAL_ORDERS,
            COUNT(DISTINCT CUSTOMER_NAME)                        AS UNIQUE_CUSTOMERS,
            ROUND(SUM(PROFIT) / NULLIF(SUM(SALES), 0) * 100, 2) AS PROFIT_MARGIN_PCT
        FROM ' || src_table || '
        WHERE SALES > 0
          AND PROVINCE IS NOT NULL
        GROUP BY PROVINCE
        ORDER BY TOTAL_SALES DESC';

    EXECUTE IMMEDIATE sql_stmt;
    RETURN 'SUCCESS: ' || tgt_table;
END;
$$;