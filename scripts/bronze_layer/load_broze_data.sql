-- ==============================================================
-- PROCEDURE: bronze.load_bronze
-- PURPOSE:
-- Loads raw CSV data from CRM and ERP source systems into the
-- Bronze layer tables of the Supply Chain Data Warehouse.
--
-- PROCESS:
-- 1. Truncate existing Bronze tables
-- 2. Load fresh data using BULK INSERT
-- 3. Track load duration for each table
-- 4. Handle errors using TRY...CATCH
--
-- NOTE:
-- File paths reference local source system CSV files.
-- =====================================================

--How to use store procedure
--EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS 
BEGIN

-- Variables used for load duration tracking
DECLARE @start_time DATETIME
DECLARE @end_time DATETIME
DECLARE @bronze_start_time DATETIME
DECLARE @bronze_end_time DATETIME

BEGIN TRY

-- Track total Bronze load start time
SET @bronze_start_time = GETDATE()

PRINT '=========================================';
PRINT 'LOADING FROM SOURCE SYSTEMS TO BRONZE LAYER';
PRINT '=========================================';


-- ==============================================================
-- CRM SOURCE TABLES
-- ==============================================================

PRINT '***************************';
PRINT 'Loading CRM Tables';
PRINT '***************************';


-- ------------------------------
-- Load CRM Customers
-- ------------------------------
SET @start_time = GETDATE()

PRINT '>>> Truncating table: bronze.crm_customers';
TRUNCATE TABLE bronze.crm_customers

PRINT 'Inserting data into bronze.crm_customers'

BULK INSERT bronze.crm_customers
FROM 'C:\Users\COLLINS\Documents\supply-chain-datawarehouse\CRM-Source-system\Customers.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SET @end_time = GETDATE()

PRINT 'Load Duration For bronze.crm_customers: ' 
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
PRINT '-----------NEXT TABLE------';



-- ------------------------------
-- Load CRM Orders
-- ------------------------------
SET @start_time = GETDATE()

PRINT '>>> Truncating table: bronze.crm_orders';
TRUNCATE TABLE bronze.crm_orders

PRINT 'Inserting data into bronze.crm_orders'

BULK INSERT bronze.crm_orders
FROM 'C:\Users\COLLINS\Documents\supply-chain-datawarehouse\CRM-Source-system\Orders.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SET @end_time = GETDATE()

PRINT 'Load Duration For bronze.crm_orders: '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
PRINT '-----------NEXT TABLE------';



-- ------------------------------
-- Load CRM Returns
-- ------------------------------
SET @start_time = GETDATE()

PRINT '>>> Truncating table: bronze.crm_returns';
TRUNCATE TABLE bronze.crm_returns

PRINT 'Inserting data into bronze.crm_returns'

BULK INSERT bronze.crm_returns
FROM 'C:\Users\COLLINS\Documents\supply-chain-datawarehouse\CRM-Source-system\Returns.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SET @end_time = GETDATE()

PRINT 'Load Duration For bronze.crm_returns: '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
PRINT '-----------NEXT TABLE------';



-- ==============================================================
-- ERP SOURCE TABLES
-- ==============================================================

PRINT '***************************';
PRINT 'Loading ERP Tables';
PRINT '***************************';


-- ------------------------------
-- Load Inventory Movements
-- ------------------------------
SET @start_time = GETDATE()

PRINT '>>> Truncating table: bronze.erp_inventory_management';
TRUNCATE TABLE bronze.erp_inventory_management

PRINT 'Inserting data into bronze.erp_inventory_management'

BULK INSERT bronze.erp_inventory_management
FROM 'C:\Users\COLLINS\Documents\supply-chain-datawarehouse\ERP-Source-system\InventoryMovements.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SET @end_time = GETDATE()

PRINT 'Load Duration For bronze.erp_inventory_management: '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
PRINT '-----------NEXT TABLE------';



-- ------------------------------
-- Load ERP Products
-- ------------------------------
SET @start_time = GETDATE()

PRINT '>>> Truncating table: bronze.erp_products';
TRUNCATE TABLE bronze.erp_products

PRINT 'Inserting data into bronze.erp_products'

BULK INSERT bronze.erp_products
FROM 'C:\Users\COLLINS\Documents\supply-chain-datawarehouse\ERP-Source-system\Products.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SET @end_time = GETDATE()

PRINT 'Load Duration For bronze.erp_products: '
+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
PRINT '-----------NEXT TABLE------';



-- ------------------------------
-- Load ERP Suppliers
-- ------------------------------
SET @start_time = GETDATE()

PRINT '>>> Truncating table: bronze.erp_suppliers';
TRUNCATE TABLE bronze.erp_suppliers

PRINT 'Inserting data into bronze.erp_suppliers'

BULK INSERT bronze.erp_suppliers
FROM 'C:\Users\COLLINS\Documents\supply-chain-datawarehouse\ERP-Source-system\Suppliers.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SET @end_time = GETDATE()



-- ==============================================================
-- Bronze Load Completed
-- ==============================================================

SET @bronze_end_time = GETDATE()

PRINT '#########################################'
PRINT 'Bronze Layer Load Completed Successfully'
PRINT 'Total Load Duration: '
+ CAST(DATEDIFF(second,@bronze_start_time,@bronze_end_time) AS NVARCHAR)
+ ' seconds.'


END TRY

-- ==============================================================
-- Error Handling
-- ==============================================================

BEGIN CATCH

PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);

END CATCH

END

-- Execute Bronze Load
EXEC bronze.load_bronze
