USE Olist;
GO

CREATE SCHEMA orders;
GO

CREATE SCHEMA sellers;
GO

CREATE SCHEMA products;
GO

-- Orders Schema
ALTER SCHEMA orders TRANSFER dbo.orders;
ALTER SCHEMA orders TRANSFER dbo.order_items;
ALTER SCHEMA orders TRANSFER dbo.order_reviews;
ALTER SCHEMA orders TRANSFER dbo.order_payments;
ALTER SCHEMA orders TRANSFER dbo.customers;


-- Sellers Schema
ALTER SCHEMA sellers TRANSFER dbo.sellers;
ALTER SCHEMA sellers TRANSFER dbo.geolocations;

-- Products Schema
ALTER SCHEMA products TRANSFER dbo.products;