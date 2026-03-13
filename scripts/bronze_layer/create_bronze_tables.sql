-- ==============================================================
-- SCRIPT PURPOSE: Create Bronze Layer Tables
-- ==============================================================
-- This script creates the tables for the BRONZE layer of the Supply-chain data warehouse

-- WARNING:
-- If the tables already exist, they will be dropped and recreated.
-- This may result in DATA LOSS if tables contain data.
-- ==============================================================


-- ==========================================
-- CRM SOURCE TABLES
-- =========================================

-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_customers','U') IS NOT NULL
DROP TABLE bronze.crm_customers

-- Create table for raw CRM customer data
CREATE TABLE bronze.crm_customers(
cus_id NVARCHAR(20),     
cust_nam NVARCHAR(50),    
sity NVARCHAR(50),        
cntry NVARCHAR(50),      
signup_date DATE          
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_orders','U') IS NOT NULL
DROP TABLE bronze.crm_orders

-- Create table for raw CRM order data
CREATE TABLE bronze.crm_orders(
ord_id NVARCHAR(20),      
cust_id NVARCHAR(50),    
pro_id NVARCHAR(50),      
order_dat DATE,           
qty INT                   
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_returns','U') IS NOT NULL
DROP TABLE bronze.crm_returns

-- Create table for raw CRM return data
CREATE TABLE bronze.crm_returns(
return_id NVARCHAR(20),   
ord_id NVARCHAR(50),     
pro_id NVARCHAR(50),      
return_date DATE,         
reason NVARCHAR(50)       
);

-- ==============================
-- ERP SOURCE TABLES
-- =============================

-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_inventory_management','U') IS NOT NULL
DROP TABLE bronze.erp_inventory_management

-- Create table for raw ERP inventory movement data
CREATE TABLE bronze.erp_inventory_management(
mov_id NVARCHAR(20),      
pro_id NVARCHAR(50),     
mov_typ NVARCHAR(50),     
qty INT,                  
mov_date DATE             
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_products','U') IS NOT NULL
DROP TABLE bronze.erp_products

-- Create table for raw ERP product data
CREATE TABLE bronze.erp_products(
pro_id NVARCHAR(20),      
pro_nam NVARCHAR(50),    
cat NVARCHAR(50),        
sup_id NVARCHAR(50),      
uni_pri INT               
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_suppliers','U') IS NOT NULL
DROP TABLE bronze.erp_suppliers

-- Create table for raw ERP supplier data
CREATE TABLE bronze.erp_suppliers(
sup_id NVARCHAR(20),      
sup_nam NVARCHAR(50),     
cntry NVARCHAR(50),       
con_email NVARCHAR(100),  
rating NVARCHAR(10)       
);
