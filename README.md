# Supply Chain Data Warehouse 

## Project Overview

This project demonstrates the design and implementation of a **data warehouse** using SQL Server, focusing on building a structured ETL pipeline from raw data to clean, reliable datasets.

The project integrates data from multiple source systems (ERP & CRM) and applies data cleaning, transformation, and validation techniques to prepare the data for analysis.

---


## Data Sources

### CRM System

* Customers
* Orders
* Returns

### ERP System

* Products
* Suppliers
* Inventory Movements

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

---


## 👤 Author

**Asante Collins**

Self-taught data professional passionate about data engineering, analytics, and building real-world data solutions through hands-on projects. Focused on developing practical skills in SQL, Python, Power BI, and modern data architecture while continuously learning industry best practices 

## 📄 License

This project is licensed under the MIT License 

