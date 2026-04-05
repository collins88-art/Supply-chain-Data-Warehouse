-- ==============================================================
-- SCRIPT PURPOSE: Data Quality Checks (Bronze Layer)
-- ==============================================================
-- This script performs data quality validation on the Bronze layer
-- before loading data into the Silver layer.
--
-- OBJECTIVES:
-- - Identify duplicates and NULLs in primary keys
-- - Detect invalid or inconsistent values
-- - Check for unwanted spaces in text fields
-- - Validate numeric and date fields
-- - Review standardization opportunities
--
-- NOTE:
-- These checks help ensure only clean and reliable data moves
-- into the Silver layer.
-- ==============================================================


-- ==============================================================
-- CRM CUSTOMERS
-- ==============================================================

-- Check for duplicate or NULL customer IDs
SELECT cus_id, COUNT(cus_id)
FROM bronze.crm_customers
GROUP BY cus_id
HAVING COUNT(cus_id) > 1 OR cus_id IS NULL

-- Check for unwanted spaces in country
SELECT cntry
FROM bronze.crm_customers
WHERE cntry != TRIM(cntry)

-- Check for inconsistent country values
SELECT DISTINCT cntry
FROM bronze.crm_customers

-- Check for inconsistent city values
SELECT DISTINCT sity
FROM bronze.crm_customers



-- ==============================================================
-- CRM ORDERS
-- ==============================================================

-- Check for duplicate order IDs
SELECT ord_id, COUNT(*)
FROM bronze.crm_orders
GROUP BY ord_id
HAVING COUNT(*) > 1

-- Check for invalid quantities
SELECT qty
FROM bronze.crm_orders
WHERE qty IS NULL OR qty <= 0

-- Check date range
SELECT 
MIN(order_dat) AS oldest_date,
MAX(order_dat) AS recent_date,
DATEDIFF(day, MIN(order_dat), MAX(order_dat)) AS date_diff
FROM bronze.crm_orders



-- ==============================================================
-- CRM RETURNS
-- ==============================================================

-- Check for duplicate return IDs
SELECT return_id, COUNT(*)
FROM bronze.crm_returns
GROUP BY return_id
HAVING COUNT(*) > 1

-- Check unique return reasons
SELECT DISTINCT reason
FROM bronze.crm_returns

-- Standardized reason preview
SELECT DISTINCT
CASE 
    WHEN TRIM(reason)='WI' THEN 'Wrong Item'
    WHEN TRIM(reason)='defect' THEN 'Defective'
    WHEN TRIM(reason)='ccm' THEN 'Customer Changed Mind'
    WHEN TRIM(reason) IS NULL THEN 'n/a'
    ELSE TRIM(reason)
END AS reason
FROM bronze.crm_returns



-- ==============================================================
-- ERP INVENTORY MANAGEMENT
-- ==============================================================

-- Check for duplicate movement IDs
SELECT mov_id, COUNT(*)
FROM bronze.erp_inventory_management
GROUP BY mov_id
HAVING COUNT(*) > 1

-- Check movement type consistency
SELECT DISTINCT mov_typ
FROM bronze.erp_inventory_management

-- Check invalid quantity values
SELECT qty
FROM bronze.erp_inventory_management
WHERE qty IS NULL OR qty < 0

-- Check date range
SELECT
MIN(mov_date) AS oldest_date,
MAX(mov_date) AS recent_date,
DATEDIFF(YEAR, MIN(mov_date), MAX(mov_date)) AS date_diff
FROM bronze.erp_inventory_management



-- ==============================================================
-- ERP PRODUCTS
-- ==============================================================

-- Check for duplicate product IDs
SELECT pro_id, COUNT(*)
FROM bronze.erp_products
GROUP BY pro_id
HAVING COUNT(*) > 1

-- Preview deduplicated products
SELECT * 
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY pro_id ORDER BY pro_id) AS rn
    FROM bronze.erp_products
) t
WHERE rn = 1 OR pro_id IS NULL

-- Check for unwanted spaces in category
SELECT cat
FROM bronze.erp_products
WHERE TRIM(cat) != cat

-- Check unique product names
SELECT DISTINCT pro_nam
FROM bronze.erp_products

-- Check unique categories
SELECT DISTINCT cat
FROM bronze.erp_products

-- Standardized category preview
SELECT 
CASE 
    WHEN TRIM(cat)='Acess' THEN 'Accessories'
    WHEN TRIM(cat) IN ('elctros','electronics') THEN 'Electronics'
    ELSE TRIM(cat)
END AS cat
FROM bronze.erp_products

-- Check invalid prices
SELECT uni_pri
FROM bronze.erp_products
WHERE uni_pri <= 0



-- ==============================================================
-- ERP SUPPLIERS
-- ==============================================================

-- Check for duplicate supplier IDs
SELECT sup_id, COUNT(*)
FROM bronze.erp_suppliers
GROUP BY sup_id
HAVING COUNT(*) > 1

-- Preview deduplicated suppliers
SELECT *
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY sup_id ORDER BY sup_id) AS rn
    FROM bronze.erp_suppliers
) t
WHERE rn = 1 OR sup_id IS NULL

-- Check country inconsistencies
SELECT DISTINCT cntry
FROM bronze.erp_suppliers

-- Standardized country preview
SELECT DISTINCT
cntry,
CASE 
    WHEN TRIM(cntry) IN ('U.S.A','USA') THEN 'United States'
    WHEN TRIM(cntry)='UK' THEN 'United Kingdom'
    ELSE TRIM(cntry)
END AS standardized_country
FROM bronze.erp_suppliers

-- Check invalid emails
SELECT con_email
FROM bronze.erp_suppliers
WHERE con_email NOT LIKE '%@%'

-- Check invalid rating values
SELECT rating
FROM bronze.erp_suppliers
WHERE rating = 'Null'

-- Preview cleaned rating conversion
SELECT 
rating,
TRY_CAST(ISNULL(NULLIF(TRIM(rating),'Null'),0) AS INT) AS rating_int
FROM bronze.erp_suppliers



-- ==============================================================
-- SILVER LAYER VALIDATION (POST-CLEANING CHECKS)
-- ==============================================================

-- Validate cleaned return reasons
SELECT DISTINCT reason
FROM silver.crm_returns

-- Validate movement type standardization
SELECT DISTINCT mov_typ
FROM silver.erp_inventory_management

-- Validate inventory quantity
SELECT qty
FROM silver.erp_inventory_management
WHERE qty IS NULL OR qty < 0

-- Validate product price
SELECT uni_pri
FROM silver.erp_products
WHERE uni_pri <= 0

-- Check duplicate products in Silver
SELECT pro_id, COUNT(*)
FROM silver.erp_products
GROUP BY pro_id
HAVING COUNT(*) > 1
