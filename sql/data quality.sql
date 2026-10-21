-- CHECK NULL VALUES IN STAGING

-- Customers
select * 
from stg.Customers
where CustomerID is null
	or CustomerName is null;

-- Stores
select * 
from stg.Stores
where StoreID is null
	or StoreName is null;

-- Orders
select *
from stg.Orders
where OrderID is null
	or CustomerID is null
	or StoreID is null
	or OrderStatus is null;

-- OrderLines
select * 
from stg.OrderLines
where OrderLineID is null
	or OrderID is null
	or ProductID is null
	or Quantity is null
	or UnitPrice is null
	or DiscountAmount is null;

-- ProductCatalog
select *
from stg.ProductCatalog
where ProductID is null
	or ProductName is null
	or SKU is null
	or UnitCost is null;

go


-- CHECK DUPLICATE BUSINESS IDS IN STAGING

select CustomerID , count(*) as DuplicateCount
from stg.Customers
group by CustomerID
having count(*) > 1;

select StoreID , count(*) as DuplicateCount
from stg.Stores
group by StoreID
having count(*) > 1;

select OrderID , count(*) as DuplicateCount
from stg.Orders
group by OrderID
having count(*) > 1;

select OrderLineID , count(*) as DuplicateCount
from stg.OrderLines
group by OrderLineID
having count(*) > 1;


select ProductID , count(*) as DuplicateCount
from stg.ProductCatalog
group by ProductID
having count(*) > 1;

go