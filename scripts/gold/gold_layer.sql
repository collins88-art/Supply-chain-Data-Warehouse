-- ==============================================================
-- SCRIPT PURPOSE: Create Gold Layer Analytical Views
-- ==============================================================
-- This script creates business-ready dimension and fact views
-- in the Gold layer of the Supply Chain Data Warehouse.
--
-- OBJECTIVE:
-- Transform cleaned Silver layer data into analytical models
-- optimized for reporting, dashboarding, and business intelligence.

-- GOLD LAYER COMPONENTS:
-- - Dimension Views:
--     • dim_suppliers
--     • dim_returns
--     • inventory_movement
--
-- - Fact View:
--     • fact_orders




-- ==============================================================
-- DIMENSION: SUPPLIERS
-- ==============================================================
IF OBJECT_ID('gold.dim_suppliers','V') IS NOT NULL
  DROP VIEW gold.dim_suppliers
GO 
CREATE VIEW gold.dim_suppliers AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY sup_id) AS supplier_key,  
    sup_id AS supplier_id,                               
    sup_nam AS supplier_name,                            
    cntry AS country,                                    
    CASE 
        WHEN rating IS NULL THEN COALESCE(rating,0)     
        ELSE rating
    END AS ratings,
    con_email AS email                                   
FROM silver.erp_suppliers;



-- ==============================================================
-- DIMENSION: RETURNS
-- ==============================================================
-- Stores return transaction details for analysis
IF OBJECT_ID('gold.dim_returns','V') IS NOT NULL
  DROP VIEW gold.dim_returns
GO 
CREATE VIEW gold.dim_returns AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY return_id) AS return_key, -- Surrogate key
    return_id,
    ord_id AS order_id,
    pro_id AS product_id,
    return_date,
    reason
FROM silver.crm_returns;



-- ==============================================================
-- DIMENSION: INVENTORY MOVEMENT
-- ==============================================================
-- Tracks inventory inflow and outflow movements
IF OBJECT_ID('gold.inventory_movement','V') IS NOT NULL
  DROP VIEW gold.inventory_movement
GO 
CREATE VIEW gold.inventory_movement AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY mov_id) AS movement_key, -- Surrogate key
    mov_id AS movement_id,
    pro_id AS product_id,
    mov_typ AS movement_type,
    qty AS quantity,
    mov_date AS movement_date
FROM silver.erp_inventory_management;



-- ==============================================================
-- FACT TABLE: ORDERS
-- =============================================
IF OBJECT_ID('gold.fact_orders','V') IS NOT NULL
  DROP VIEW gold.fact_orders
GO 
CREATE VIEW gold.fact_orders AS
SELECT 
    ord.ord_id AS order_id,                             
    
    -- Customer attributes
    cus.cus_id AS customer_id,
    cus.cust_nam AS customer_name,
    cus.sity AS city,
    cus.cntry AS country,
    
    -- Product attributes
    pro.pro_id AS product_id,
    pro.pro_nam AS product_name,
    pro.cat AS product_category,
    ord.qty AS quantity,
    pro.uni_pri AS unit_price,
    (ord.qty * pro.uni_pri) AS total_revenue,
    cus.signup_date,
    ord.order_dat AS order_date

FROM silver.crm_orders AS ord

    -- Join products from ERP system
    LEFT JOIN silver.erp_products AS pro
        ON ord.pro_id = pro.pro_id

    -- Join customers from CRM system
    LEFT JOIN silver.crm_customers AS cus
        ON ord.cust_id = cus.cus_id;

