/*
=============================================================
Create Database and Schemas - Olist E-Commerce
=============================================================
Script Purpose:
    This script creates a new database named 'Olist' after checking if it already exists. 
    If the database exists, it is dropped and recreated. 
    It also creates three schemas following the Medallion Architecture:
        - bronze : Raw data
        - silver : Cleaned & standardized data
        - gold   : Business-ready dimensional model

WARNING:
    Running this script will drop the entire 'Olist' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'Olist' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Olist')
BEGIN
    ALTER DATABASE Olist SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Olist;
END;
GO

-- Create the 'Olist' database
CREATE DATABASE Olist;
GO

USE Olist;
GO

USE Olist;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

-- Drop existing bronze tables
DROP TABLE IF EXISTS bronze.customers;
DROP TABLE IF EXISTS bronze.geolocation;
DROP TABLE IF EXISTS bronze.orders;
DROP TABLE IF EXISTS bronze.order_items;
DROP TABLE IF EXISTS bronze.order_payments;
DROP TABLE IF EXISTS bronze.order_reviews;
DROP TABLE IF EXISTS bronze.products;
DROP TABLE IF EXISTS bronze.sellers;
DROP TABLE IF EXISTS bronze.category_translation;
GO

-- =============================================================
-- BRONZE LAYER - All columns as NVARCHAR (Safe loading)
-- =============================================================

CREATE TABLE bronze.customers (
    customer_id                 NVARCHAR(100),
    customer_unique_id          NVARCHAR(100),
    customer_zip_code_prefix    NVARCHAR(20),
    customer_city               NVARCHAR(150),
    customer_state              NVARCHAR(10)
);
GO

CREATE TABLE bronze.geolocation (
    geolocation_zip_code_prefix NVARCHAR(20),
    geolocation_lat             NVARCHAR(50),
    geolocation_lng             NVARCHAR(50),
    geolocation_city            NVARCHAR(150),
    geolocation_state           NVARCHAR(10)
);
GO

CREATE TABLE bronze.orders (
    order_id                        NVARCHAR(100),
    customer_id                     NVARCHAR(100),
    order_status                    NVARCHAR(50),
    order_purchase_timestamp        NVARCHAR(50),
    order_approved_at               NVARCHAR(50),
    order_delivered_carrier_date    NVARCHAR(50),
    order_delivered_customer_date   NVARCHAR(50),
    order_estimated_delivery_date   NVARCHAR(50)
);
GO

CREATE TABLE bronze.order_items (
    order_id            NVARCHAR(100),
    order_item_id       NVARCHAR(20),
    product_id          NVARCHAR(100),
    seller_id           NVARCHAR(100),
    shipping_limit_date NVARCHAR(50),
    price               NVARCHAR(30),
    freight_value       NVARCHAR(30)
);
GO

CREATE TABLE bronze.order_payments (
    order_id             NVARCHAR(100),
    payment_sequential   NVARCHAR(20),
    payment_type         NVARCHAR(50),
    payment_installments NVARCHAR(20),
    payment_value        NVARCHAR(30)
);
GO

CREATE TABLE bronze.order_reviews (
    review_id               NVARCHAR(100),
    order_id                NVARCHAR(100),
    review_score            NVARCHAR(10),
    review_comment_title    NVARCHAR(500),
    review_comment_message  NVARCHAR(MAX),
    review_creation_date    NVARCHAR(50),
    review_answer_timestamp NVARCHAR(50)
);
GO

CREATE TABLE bronze.products (
    product_id                  NVARCHAR(100),
    product_category_name       NVARCHAR(150),
    product_name_lenght         NVARCHAR(20),
    product_description_lenght  NVARCHAR(20),
    product_photos_qty          NVARCHAR(20),
    product_weight_g            NVARCHAR(20),
    product_length_cm           NVARCHAR(20),
    product_height_cm           NVARCHAR(20),
    product_width_cm            NVARCHAR(20)
);
GO

CREATE TABLE bronze.sellers (
    seller_id               NVARCHAR(100),
    seller_zip_code_prefix  NVARCHAR(20),
    seller_city             NVARCHAR(150),
    seller_state            NVARCHAR(10)
);
GO

CREATE TABLE bronze.category_translation (
    product_category_name           NVARCHAR(150),
    product_category_name_english   NVARCHAR(150)
);
GO

-- =============================================================
-- BULK INSERT - Bronze Layer
-- =============================================================

TRUNCATE TABLE bronze.customers;
GO
BULK INSERT bronze.customers
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_customers_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.geolocation;
GO
BULK INSERT bronze.geolocation
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_geolocation_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.orders;
GO
BULK INSERT bronze.orders
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_orders_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.order_items;
GO
BULK INSERT bronze.order_items
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_order_items_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.order_payments;
GO
BULK INSERT bronze.order_payments
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_order_payments_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.order_reviews;
GO
BULK INSERT bronze.order_reviews
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_order_reviews_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.products;
GO
BULK INSERT bronze.products
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_products_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.sellers;
GO
BULK INSERT bronze.sellers
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\olist_sellers_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO

TRUNCATE TABLE bronze.category_translation;
GO
BULK INSERT bronze.category_translation
FROM 'E:\DataScience Bootcamp\Different Platforms\Flyrank.AI\HVIA-AI\Task-1\data\product_category_name_translation.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    KEEPNULLS
);
GO