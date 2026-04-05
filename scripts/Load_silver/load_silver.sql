-- ==============================================================
-- PROCEDURE: silver.load_silver
-- ==============================================================
-- PURPOSE:
-- Loads cleaned and transformed data from the Bronze layer
-- into the Silver layer tables.

--
-- PROCESS:
-- 1. Truncate Silver tables
-- 2. Transform Bronze data
-- 3. Load into Silver tables
-- 4. Track execution time
--
-- WARNING:
-- This procedure deletes existing data in Silver tables.
-- ==============================================================

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

-- Prevent extra result messages
SET NOCOUNT ON;

-- Time tracking variables
DECLARE @start_time DATETIME
DECLARE @end_time DATETIME
DECLARE @silver_start_time DATETIME
DECLARE @silver_end_time DATETIME

BEGIN TRY

-- Start overall timer
SET @silver_start_time = GETDATE()

PRINT '========================================='
PRINT 'LOADING CLEAN DATA INTO SILVER LAYER'
PRINT '========================================='


-- =====================================================
-- CRM CUSTOMERS
-- =====================================================
PRINT 'Loading CRM Customers'

SET @start_time = GETDATE()

TRUNCATE TABLE silver.crm_customers

INSERT INTO silver.crm_customers(
cus_id,
cust_nam,
sity,
cntry,
signup_date
)
SELECT 
cus_id,
cust_nam,
UPPER(TRIM(sity)),
CASE 
    WHEN UPPER(TRIM(cntry))='USA' THEN 'UNITED STATES'
    WHEN UPPER(TRIM(cntry))='UK' THEN 'UNITED KINGDOM'
    ELSE UPPER(TRIM(cntry))
END,
signup_date
FROM bronze.crm_customers

SET @end_time = GETDATE()

PRINT 'crm_customers loaded in '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' sec'


-- =====================================================
-- CRM ORDERS
-- =====================================================
PRINT 'Loading CRM Orders'

SET @start_time = GETDATE()

TRUNCATE TABLE silver.crm_orders

INSERT INTO silver.crm_orders(
ord_id,
cust_id,
pro_id,
order_dat,
qty
)
SELECT
ord_id,
cust_id,
pro_id,
order_dat,
ABS(qty)
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY ord_id ORDER BY order_dat) AS rn
    FROM bronze.crm_orders
) t
WHERE rn = 1

SET @end_time = GETDATE()

PRINT 'crm_orders loaded in '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' sec'


-- =====================================================
-- CRM RETURNS
-- =====================================================
PRINT 'Loading CRM Returns'

SET @start_time = GETDATE()

TRUNCATE TABLE silver.crm_returns

INSERT INTO silver.crm_returns(
return_id,
ord_id,
pro_id,
return_date,
reason
)
SELECT 
return_id,
ord_id,
pro_id,
return_date,
CASE 
    WHEN TRIM(reason)='WI' THEN 'Wrong Item'
    WHEN TRIM(reason)='defect' THEN 'Defective'
    WHEN TRIM(reason)='ccm' THEN 'Customer Changed Mind'
    WHEN TRIM(reason) IS NULL THEN 'n/a'
    ELSE TRIM(reason)
END
FROM bronze.crm_returns

SET @end_time = GETDATE()

PRINT 'crm_returns loaded in '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' sec'


-- =====================================================
-- ERP INVENTORY MOVEMENTS
-- =====================================================
PRINT 'Loading ERP Inventory Movements'

SET @start_time = GETDATE()

TRUNCATE TABLE silver.erp_inventory_management

INSERT INTO silver.erp_inventory_management(
mov_id,
pro_id,
mov_typ,
qty,
mov_date
)
SELECT 
mov_id,
pro_id,
UPPER(TRIM(mov_typ)),
ABS(qty),
mov_date
FROM bronze.erp_inventory_management

SET @end_time = GETDATE()

PRINT 'inventory_management loaded in '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' sec'


-- =====================================================
-- ERP PRODUCTS
-- =====================================================
PRINT 'Loading ERP Products'

SET @start_time = GETDATE()

TRUNCATE TABLE silver.erp_products

INSERT INTO silver.erp_products(
pro_id,
pro_nam,
cat,
sup_id,
uni_pri
)
SELECT 
pro_id,
TRIM(pro_nam),
CASE 
    WHEN TRIM(cat)='Acess' THEN 'Accessories'
    WHEN TRIM(cat) IN ('elctros','electronics') THEN 'Electronics'
    ELSE TRIM(cat)
END,
sup_id,
ABS(uni_pri)
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY pro_id ORDER BY pro_id) AS rn
    FROM bronze.erp_products
) t
WHERE rn = 1 OR pro_id IS NULL

SET @end_time = GETDATE()

PRINT 'erp_products loaded in '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' sec'


-- =====================================================
-- ERP SUPPLIERS
-- =====================================================
PRINT 'Loading ERP Suppliers'

SET @start_time = GETDATE()

TRUNCATE TABLE silver.erp_suppliers

INSERT INTO silver.erp_suppliers(
sup_id,
sup_nam,
cntry,
con_email,
rating
)
SELECT 
sup_id,
sup_nam,
CASE 
    WHEN TRIM(cntry) IN ('U.S.A','USA') THEN 'United States'
    WHEN TRIM(cntry)='UK' THEN 'United Kingdom'
    ELSE TRIM(cntry)
END,
con_email,
TRY_CAST(NULLIF(TRIM(rating),'Null') AS INT)
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY sup_id ORDER BY sup_id) AS rn
    FROM bronze.erp_suppliers
) t
WHERE rn = 1

SET @end_time = GETDATE()

PRINT 'erp_suppliers loaded in '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' sec'


-- =====================================================
-- FINAL LOG
-- =====================================================
SET @silver_end_time = GETDATE()

PRINT '========================================='
PRINT 'SILVER LAYER LOAD COMPLETED SUCCESSFULLY'
PRINT 'Total Duration: '
+ CAST(DATEDIFF(second,@silver_start_time,@silver_end_time) AS NVARCHAR)
+ ' sec'
PRINT '========================================='


END TRY

BEGIN CATCH

PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR)

END CATCH

END


-- Execute procedure
EXEC silver.load_silver
