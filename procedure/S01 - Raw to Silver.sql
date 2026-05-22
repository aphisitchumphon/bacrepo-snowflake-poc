USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE DEMO_DEV.RAW.RAW_TO_SILVER(ENV STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    db_name   STRING;
    src_table STRING;
    tgt_table STRING;
    sql_stmt  STRING;
BEGIN
    db_name   := 'DEMO_' || ENV;
    src_table := db_name || '.RAW.SUPERSTORE_RAW';
    tgt_table := db_name || '.SILVER.SALES_BY_PROVINCE';

    sql_stmt :=
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

GRANT USAGE ON PROCEDURE DEMO_DEV.RAW.RAW_TO_SILVER(STRING) TO ROLE DEV_ROLE;
GRANT USAGE ON PROCEDURE DEMO_DEV.RAW.RAW_TO_SILVER(STRING) TO ROLE PRD_ROLE;

-- Test
CALL DEMO_DEV.RAW.RAW_TO_SILVER('PRD');
