use RetailDWH;
go


-- 1. Customers
create table stg.Customers
(
    CustomerID        int,
    CustomerName      nvarchar(100),
    City              nvarchar(50),
    Region            nvarchar(50),
    Email             nvarchar(120),
    LastModifiedAt    datetime2(3)
);
go

-- 2. Stores
create table stg.Stores
(
    StoreID            int,
    StoreName          nvarchar(100),
    City               nvarchar(50),
    Region             nvarchar(50),
    LastModifiedAt     datetime2(3)
);
go

-- 3. Orders
create table stg.Orders
(
    OrderID           int,
    CustomerID        int,
    StoreID           int,
    OrderDate         datetime2(0),
    OrderStatus       varchar(20),
    LastModifiedAt    datetime2(3)
);
go

-- 4. OrderLines
create table stg.OrderLines
(
    OrderLineID      int,
    OrderID          int,
    ProductID        int,
    Quantity         int,
    UnitPrice        decimal(12,2),
    DiscountAmount   decimal(12,2),
    LastModifiedAt   datetime2(3) 
);
go

-- 5. ProductCatalog
create table stg.ProductCatalog
(
    ProductID        int,
    SKU              nvarchar(30),
    ProductName      nvarchar(100),
    Category         nvarchar(60),
    Brand            nvarchar(60),
    UnitCost         decimal(12,2),
    IsActive         char(1),
    LastModifiedAt   datetime2(3)
);
go

-- insert data into stg Customers
insert into stg.Customers
(
    CustomerID,
    CustomerName,
    City,
    Region,
    Email,
    LastModifiedAt
) select 
    CustomerID,
    CustomerName,
    City,
    Region,
    Email,
    LastModifiedAt
from RetailOLTP.[dbo].[Customers];

-- insert data into stg Store
insert into stg.Stores
(
    StoreID,
    StoreName,
    City,
    Region,
    LastModifiedAt
) select 
    StoreID,
    StoreName,
    City,
    Region,
    LastModifiedAt
from RetailOLTP.[dbo].[Stores];

-- insert data into stg Orders
insert into stg.Orders
(
    OrderID,
    CustomerID,
    StoreID,
    OrderDate,
    OrderStatus,
    LastModifiedAt
) select 
    OrderID,
    CustomerID,
    StoreID,
    OrderDate,
    OrderStatus,
    LastModifiedAt
from RetailOLTP.[dbo].[Orders];

-- insert data into stg Orders Lines
insert into stg.OrderLines
(
    OrderLineID,
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    DiscountAmount,
    LastModifiedAt
) select
    OrderLineID,
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    DiscountAmount,
    LastModifiedAt
from RetailOLTP.[dbo].[OrderLines];

-- insert data into stg Product Catalog
bulk insert  stg.ProductCatalog
from 'E:\task\day1\sources\ProductCatalog_Batch1.csv'
with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
	)



SELECT *
FROM stg.OrderLines
WHERE OrderLineID IS NULL
   OR OrderID IS NULL
   OR ProductID IS NULL
   OR Quantity IS NULL
   OR UnitPrice IS NULL;


-- 1. Customers
SELECT 'stg.Customers' AS TableName,
       COUNT(*) AS TotalRows,
       SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
       SUM(CASE WHEN CustomerName IS NULL THEN 1 ELSE 0 END) AS NullCustomerName,
       SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS NullEmail
FROM stg.Customers;

SELECT
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM stg.Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- 2. Stores
SELECT 'stg.Stores' AS TableName,
       COUNT(*) AS TotalRows,
       SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS NullStoreID,
       SUM(CASE WHEN StoreName IS NULL THEN 1 ELSE 0 END) AS NullStoreName
FROM stg.Stores;


SELECT
    StoreID,
    COUNT(*) AS DuplicateCount
FROM stg.Stores
GROUP BY StoreID
HAVING COUNT(*) > 1;

-- 3. Orders
SELECT 'stg.Orders' AS TableName,
       COUNT(*) AS TotalRows,
       SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS NullOrderID,
       SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
       SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS NullStoreID,
       SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS NullOrderDate,
       SUM(CASE WHEN OrderStatus IS NULL THEN 1 ELSE 0 END) AS NullOrderStatus
FROM stg.Orders;


SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM stg.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;




-- 5. ProductCatalog
SELECT 'stg.ProductCatalog' AS TableName,
       COUNT(*) AS TotalRows,
       SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS NullProductID,
       SUM(CASE WHEN ProductName IS NULL THEN 1 ELSE 0 END) AS NullProductName,
       SUM(CASE WHEN SKU IS NULL THEN 1 ELSE 0 END) AS NullSKU
FROM stg.ProductCatalog;


SELECT
    OrderLineID,
    COUNT(*) AS DuplicateCount
FROM stg.OrderLines
GROUP BY OrderLineID
HAVING COUNT(*) > 1;

go



SELECT
    ol.OrderLineID,
    ol.OrderID,
    ol.ProductID,
    ol.Quantity,
    ol.UnitPrice
FROM stg.OrderLines AS ol
LEFT JOIN stg.ProductCatalog AS p
    ON ol.ProductID = p.ProductID
WHERE ol.ProductID IS NOT NULL
  AND p.ProductID IS NULL
ORDER BY ol.ProductID;

select * from stg.ProductCatalog


USE RetailDWH;
GO

IF SCHEMA_ID('dim') IS NULL
    EXEC('CREATE SCHEMA dim');
GO

CREATE TABLE dim.DimDate
(
    DateKey INT NOT NULL PRIMARY KEY,
    FullDate DATE NOT NULL UNIQUE,
    DayNumber INT NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    QuarterNumber INT NOT NULL,
    YearNumber INT NOT NULL
);
GO
;WITH DateCTE AS
(
    SELECT CAST('2020-01-01' AS DATE) AS FullDate

    UNION ALL

    SELECT DATEADD(DAY, 1, FullDate)
    FROM DateCTE
    WHERE FullDate < '2030-12-31'
)

INSERT INTO dim.DimDate
(
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber
)
SELECT
    CAST(CONVERT(VARCHAR(8), FullDate, 112) AS INT),
    FullDate,
    DAY(FullDate),
    MONTH(FullDate),
    DATENAME(MONTH, FullDate),
    DATEPART(QUARTER, FullDate),
    YEAR(FullDate)
FROM DateCTE
OPTION (MAXRECURSION 0);
GO

select * from [stg].[ProductCatalog][dim].[Dim_Product] 