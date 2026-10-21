use RetailDWH;
go

create table dim.DimCustomer
(
	CustomerKey		int identity(1,1) not null constraint PK_DimCustomer primary key,
	CustomerID		int not null constraint UQ_DimCustomer_CustomerID unique,
	CustomerName	nvarchar(100) ,
	City			nvarchar(50),
	Region			nvarchar(50),
	Email			nvarchar(120)

);

create table dim.Dim_Store
(
	StoreKey		int identity(1,1) not null constraint PK_DimStore primary key,
	StoreID			int not null constraint UQ_DimStore_StoreID unique,
	StoreName		nvarchar(100),
	City			nvarchar(50),
	Region			nvarchar(50)
);

create table dim.DimProduct
(
	ProductKey int identity(1,1) not null constraint PK_DimProduct primary key,
	ProductID int not null ,
	SKU nvarchar(30),
	ProductName nvarchar(100),
	Category nvarchar(60),
	Brand nvarchar(60),
	UnitCost decimal(12,2),
	StartDate datetime2(3) not null,
	EndDate datetime2(3) null,
	constraint CK_DimProduct_DateRange check (StartDate < EndDate) 
);


ALTER TABLE dim.DimProduct
ADD CONSTRAINT DF_DimProduct_EndDate
DEFAULT ('9999-12-31 23:59:59.997')
FOR EndDate;
GO

drop table [dim].DimProduct
drop table [fact].[FactSales]

create table dim.DimDate
(
	DateKey int not null primary key,
	FullDate date not null unique,
	DayNumber int not null,
	MonthNumber int not null,
	MonthName nvarchar(20) not null,
	QuarterNumber int not null,
	YearNumber int not null
); with DateCTE as (
	select cast('2020-01-01' as date) as FullDate
	union all

	select dateadd(day , 1 , FullDate)
	from DateCTE
	where FullDate < '2030-12-31'
) insert into  dim.DimDate
(
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber
) SELECT
    cast(convert(varchar(8), FullDate, 112) as int),
    FullDate,
    day(FullDate),
    month(FullDate),
    datename(month, FullDate),
    datepart(quarter, FullDate),
    year(FullDate)
FROM DateCTE
OPTION (MAXRECURSION 0);
go

-- insert data into dim Customers
insert into dim.DimCustomer
(
	CustomerID,
	CustomerName,
	City,
	Region,
	Email
) select
	CustomerID,
	CustomerName,
	City,
	Region,
	Email
from [stg].[Customers];

-- insert data into dim Store
insert into dim.Dim_Store
(
	StoreID,
	StoreName,
	City,
	Region
) select
	StoreID,
	StoreName,
	City,
	Region
from [stg].[Stores];


select * from dim.Dim_Product
-- insert data into dim Product
insert into dim.Dim_Product
(
	ProductID,
	SKU,
	ProductName,
	Category,
	Brand,
	UnitCost
)