use RetailDWH;
go

create table fact.FactSales
(
	SalesKey bigint identity(1,1) not null constraint PK_FactSales primary key,
	SourceOrderLineID int not null,
	OrderID int,

	DateKey int not null,
	CustomerKey int not null,
	StoreKey int not null,
	ProductKey int not null,

	Quantity int not null,
	UnitPrice decimal(12,2) not null,
	GrossSales decimal(18,2) not null,
	DiscountAmount decimal(18,2) not null,
	NetSales decimal(18,2) not null,
	LoadedAt datetime2(3) not null constraint DF_FactSales_LoadAt default sysdatetime(),


	constraint UQ_FactSales_SourceOrderLineID unique (SourceOrderLineID),

	constraint FK_FactSales_DimDate
	foreign key (DateKey)
	references dim.DimDate(DateKey),

	constraint FK_FactSales_Dim_Customer
	foreign key (CustomerKey)
	references dim.DimCustomer,

	constraint FK_FactSales_Dim_Store
	foreign key (StoreKey)
	references dim.DimStore,

	constraint FK_FactSales_Dim_Product
	foreign key (ProductKey)
	references dim.DimProduct,

);
go

