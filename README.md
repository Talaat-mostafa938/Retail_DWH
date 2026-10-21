# Retail Data Warehouse
---
A complete data engineering project that builds a data warehouse for a small online store. Data is extracted from source files/tables, transformed and loaded with **SSIS** packages into a **Star Schema** (fact and dimension tables) on **SQL Server**, ready for reporting and analytics.  

```
Retail (OLTP)  →  SSIS ETL  →  Retail (Star Schema)  →  SQL Reports
```

## Tech stack

- SQL Server (T-SQL)
- SQL Server Management Studio (SSMS)
- SQL Server Integration Services (SSIS) in Visual Studio
- Dimensional modeling (Star Schema)

## Architecture

| Layer | What it contains |
|---|---|
| **Source** (`RetailSource`) | `Customers`, `Products`, `Stores`,`Orders`, `OrderItems` |
| **Warehouse** (`RetailDW`) | `DimCustomer`, `DimProduct`, `DimStore`,`DimDate`, `FactSales` (schema `dwh`) |

## Star Schema

```
                 dwh.DimDate
                      |
 dwh.DimCustomer — dwh.FactSales — dwh.DimProduct
                      |
                dwh.DimStore
```
