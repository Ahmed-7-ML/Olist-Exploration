USE Olist;
GO

-- Products
CREATE TABLE proucts (
    product_id NVARCHAR(50) PRIMARY KEY,
    product_category_name NVARCHAR(100) NULL,
    product_name_lenght INT NULL,
    product_description_lenght INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,          -- NULL عشان فيه منتجات بدون وزن مسجل
    product_length_cm INT NULL,
    product_height_cm INT NULL,
    product_width_cm INT NULL
);
GO


-- Orders
CREATE TABLE orders (
    order_id NVARCHAR(50) PRIMARY KEY,
    customer_id NVARCHAR(50) NOT NULL,
    order_status NVARCHAR(20) NULL,
    order_purchase_timestamp DATETIME NULL,
    order_approved_at DATETIME NULL,             -- NULL ممكن (أوردر ملغي مثلاً)
    order_delivered_carrier_date DATETIME NULL,  -- NULL ممكن (لسه مشحونش)
    order_delivered_customer_date DATETIME NULL, -- NULL ممكن (لسه مستلمش)
    order_estimated_delivery_date DATETIME NULL,
);
GO

-- Geolocation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT NULL,
    geolocation_lat DECIMAL(10,6) NULL,   -- NULL احتياطًا لأي سطر ناقص
    geolocation_lng DECIMAL(10,6) NULL,
    geolocation_city NVARCHAR(100) NULL,
    geolocation_state CHAR(2) NULL
);
GO

PRINT 'The [Products, Geolocation, Orders] Tables were created';