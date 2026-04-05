-- ==============================================================
-- SCRIPT PURPOSE: Create Silver Layer Tables
-- ==============================================================
-- This script creates the tables for the SILVER layer of the
-- Supply Chain Data Warehouse.
--
-- The Silver layer stores CLEANED and TRANSFORMED data from the
-- Bronze layer. Data quality issues such as duplicates, invalid
-- values, and inconsistent formats are resolved here.

-- WARNING:
-- Existing tables will be dropped and recreated.
-- This will result in DATA LOSS if data already exists.
-- ==============================================================


-- ==============================================================
-- CRM SOURCE TABLES 
-- ==============================================================

-- Drop table if it exists
IF OBJECT_ID('silver.crm_customers','U') IS NOT NULL
DROP TABLE silver.crm_customers

-- Create cleaned CRM customers table
CREATE TABLE silver.crm_customers(
cus_id NVARCHAR(20),        
cust_nam NVARCHAR(50),      
sity NVARCHAR(50),         
cntry NVARCHAR(50),         
signup_date DATE,           
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);


-- Drop table if it exists
IF OBJECT_ID('silver.crm_orders','U') IS NOT NULL
DROP TABLE silver.crm_orders

-- Create cleaned CRM orders table
CREATE TABLE silver.crm_orders(
ord_id NVARCHAR(20),        
cust_id NVARCHAR(50),       
pro_id NVARCHAR(50),      
order_dat DATE,            
qty INT,                    
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


-- Drop table if it exists
IF OBJECT_ID('silver.crm_returns','U') IS NOT NULL
DROP TABLE silver.crm_returns

-- Create cleaned CRM returns table
CREATE TABLE silver.crm_returns(
return_id NVARCHAR(20),     
ord_id NVARCHAR(50),      
pro_id NVARCHAR(50),        
return_date DATE,           
reason NVARCHAR(50),       
dwh_create_date DATETIME2 DEFAULT GETDATE()
);



-- ==============================================================
-- ERP SOURCE TABLES 
-- ==============================================================

-- Drop table if it exists
IF OBJECT_ID('silver.erp_inventory_management','U') IS NOT NULL
DROP TABLE silver.erp_inventory_management

-- Create cleaned inventory movement table
CREATE TABLE silver.erp_inventory_management(
mov_id NVARCHAR(20),        
pro_id NVARCHAR(50),        
mov_typ NVARCHAR(50),       
qty INT,                   
mov_date DATE,              
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


-- Drop table if it exists
IF OBJECT_ID('silver.erp_products','U') IS NOT NULL
DROP TABLE silver.erp_products

-- Create cleaned products table
CREATE TABLE silver.erp_products(
pro_id NVARCHAR(20),       
pro_nam NVARCHAR(50),       
cat NVARCHAR(50),          
sup_id NVARCHAR(50),        
uni_pri INT,                
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


-- Drop table if it exists
IF OBJECT_ID('silver.erp_suppliers','U') IS NOT NULL
DROP TABLE silver.erp_suppliers

-- Create cleaned suppliers table
CREATE TABLE silver.erp_suppliers(
sup_id NVARCHAR(20),        
sup_nam NVARCHAR(50),       
cntry NVARCHAR(50),         
con_email NVARCHAR(100),   
rating INT,                 
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

