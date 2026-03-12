/*
-- ==============================================================
-- SCRIPT PURPOSE: Create Supply Chain Data Warehouse
-- ==============================================================
-- This script will:
-- 1. Drop the existing database named 'Supply_Chain_Datawarehouse' if it exists.
-- 2. Create a fresh database named 'Supply_Chain_Datawarehouse'.
-- 3. Create the three schemas used for the Medallion Architecture: bronze, silver and gold

-- WARNING:
-- Running this script will **delete the existing database** and all its data permenately
-- Make sure you have backed up any important data before executing this script
-- ==============================================================
*/

USE master;
GO

-- ==========================================
-- Drop the database if it already exists
-- ==========================================
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='Supply_Chain_Datawarehouse')
BEGIN
    
    ALTER DATABASE Supply_Chain_Datawarehouse 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Drop the existing database
    DROP DATABASE Supply_Chain_Datawarehouse;
END
GO

-- ==========================================
-- Create the Supply_Chain_Datawarehouse database
-- ==========================================
CREATE DATABASE Supply_Chain_Datawarehouse;
GO

-- ==========================================
-- Switch to new database
-- ==========================================
USE Supply_Chain_Datawarehouse;
GO

-- ==========================================
-- Create schemas for each layer
-- bronze: raw data ingestion
-- silver: cleaned and standardized data
-- gold: business-ready analytics tables
-- ==========================================
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
