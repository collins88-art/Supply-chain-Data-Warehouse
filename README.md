# 🚀 Supply Chain Data Warehouse (SQL Server Project)

## 📌 Project Overview

This project demonstrates the design and implementation of a **data warehouse** using SQL Server, focusing on building a structured ETL pipeline from raw data to clean, reliable datasets.

The project integrates data from multiple source systems (ERP & CRM) and applies data cleaning, transformation, and validation techniques to prepare the data for analysis.

---

## 🏗️ Architecture

The project follows a layered approach:

### 🥉 Bronze Layer (Raw Data)

* Data loaded directly from CSV files
* No transformations applied
* Stores raw data as received from source systems

### 🥈 Silver Layer (Cleaned Data)

* Data is cleaned and standardized
* Duplicate records removed
* Inconsistent values corrected
* Data types converted (e.g., text → numeric)
* Ready for analytical use

---

## 📂 Data Sources

### CRM System

* Customers
* Orders
* Returns

### ERP System

* Products
* Suppliers
* Inventory Movements

---

##  Data Generation

Data for this project is generated using Python and the Faker library to simulate realistic ERP and CRM systems.

* Synthetic data mimics real-world scenarios
* Includes messy data (nulls, duplicates, inconsistent values)
* Helps practice real data cleaning and transformation tasks

---

## ⚙️ ETL Pipeline

### 🔹 Bronze Load

* Data loaded using `BULK INSERT`
* Stored procedure: `bronze.load_bronze`
* Includes execution time tracking

### 🔹 Silver Load

* Data cleaned and transformed using SQL
* Stored procedure: `silver.load_silver`
* Key transformations include:

  * Deduplication using `ROW_NUMBER()`
  * Standardization (`TRIM`, `UPPER`)
  * Handling invalid values
  * Safe type conversion (`TRY_CAST`)

---

## 🔍 Data Quality Checks

Data quality checks are performed before loading into the Silver layer:

* Detection of duplicates and NULL primary keys
* Identification of invalid numeric values
* Validation of text consistency (e.g., country names)
* Date range verification

---

## 🧰 Technologies Used

* SQL Server
* T-SQL (Stored Procedures, Window Functions)
* CSV Files (Source Data)
* Python (Faker for data generation)

---

## 📊 Key Features

* Structured ETL pipeline (Bronze → Silver)
* Realistic messy data simulation
* Data cleaning and transformation logic
* Execution time tracking

---

## 👤 Author

**Asante Collins**

Self-taught data professional passionate about data engineering, analytics, and building real-world data solutions through hands-on projects. Focused on developing practical skills in SQL, Python, Power BI, and modern data architecture while continuously learning industry best practices 

## 📄 License

This project is licensed under the MIT License 

