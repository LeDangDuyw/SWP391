-- Fixed schema file generated for UNILAP promotions module
IF DB_ID(N'unilap_db') IS NULL
BEGIN
    CREATE DATABASE unilap_db;
END
GO
USE unilap_db;
GO

-- =========================================================================
-- 1. TẠO CÁC BẢNG ĐỘC LẬP (KHÔNG CHỨA KHÓA NGOẠI)
-- =========================================================================
CREATE TABLE Role (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name NVARCHAR(255) NOT NULL
);

CREATE TABLE Brand (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name NVARCHAR(255) NOT NULL
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(255) NOT NULL
);

CREATE TABLE Voucher (
    voucher_id INT PRIMARY KEY IDENTITY(1,1),
    voucher_code NVARCHAR(50) NOT NULL UNIQUE,
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_value DECIMAL(10, 2) NOT NULL,
    expiry_date DATETIME NOT NULL
);

CREATE TABLE Specification (
    specification_id INT PRIMARY KEY IDENTITY(1,1),
    specification_name VARCHAR(255) NOT NULL
);

CREATE TABLE FlashSale (
    flashsale_id INT PRIMARY KEY IDENTITY(1,1),
    flashsale_name NVARCHAR(255) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL
);

-- =========================================================================
-- 2. TẠO CÁC BẢNG PHỤ THUỘC CẤP 1
-- =========================================================================

CREATE TABLE [User] (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    password NVARCHAR(255) NOT NULL,
    status NVARCHAR(50),
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    warranty_period INT,
    thumbnail NVARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (brand_id) REFERENCES Brand(brand_id)
);

-- =========================================================================
-- 3. TẠO CÁC BẢNG PHỤ THUỘC CẤP 2
-- =========================================================================

CREATE TABLE Address (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    detail_address NVARCHAR(MAX) NOT NULL,
    is_default BIT DEFAULT 0,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

CREATE TABLE AIFeedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    rating INT,
    comment NVARCHAR(MAX),
    time DATETIME,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

CREATE TABLE [Order] (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    total_amount DECIMAL(10, 2),
    shipping_fee DECIMAL(10, 2),
    order_status NVARCHAR(50),
    shipping_receiver NVARCHAR(255),
    shipping_phone NVARCHAR(20),
    shipping_address NVARCHAR(MAX),
    order_code NVARCHAR(100) UNIQUE,
    user_id INT,
    voucher_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id)
);

CREATE TABLE ProductImage (
    image_id INT PRIMARY KEY IDENTITY(1,1),
    image_url NVARCHAR(255) NOT NULL,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE ProductVariant (
    variant_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT,
    sku NVARCHAR(100) UNIQUE,
    variant_name NVARCHAR(255),
    import_price DECIMAL(10, 2),
    selling_price DECIMAL(10, 2),
    is_serialized BIT DEFAULT 0,
    status NVARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- =========================================================================
-- 4. TẠO CÁC BẢNG PHỤ THUỘC CẤP 3
-- =========================================================================

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    payment_method NVARCHAR(100),
    amount DECIMAL(10, 2),
    payment_status NVARCHAR(50),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);

CREATE TABLE CartItem (
    cart_item_id INT PRIMARY KEY IDENTITY(1,1),
    quantity INT NOT NULL,
    cart_id INT,
    variant_id INT,
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id)
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY IDENTITY(1,1),
    variant_id INT,
    reserved_quantity INT DEFAULT 0,
    available_quantity INT DEFAULT 0,
    FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id)
);

CREATE TABLE InventoryItem (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    variant_id INT,
    serial_number nVARCHAR(100) UNIQUE,
    imei nVARCHAR(100) UNIQUE,
    barcode nVARCHAR(100),
    status nVARCHAR(50),
    import_date DATETIME,
    sold_date DATETIME,
    warranty_expired_date DATETIME,
    warehouse_location nVARCHAR(255),
    note nVARCHAR(MAX),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id)
);

CREATE TABLE VariantSpecification (
    variant_specification_id INT PRIMARY KEY IDENTITY(1,1),
    variant_id INT,
    value VARCHAR(255),
    specification_id INT,
    FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id),
    FOREIGN KEY (specification_id) REFERENCES Specification(specification_id)
);

CREATE TABLE OrderDetail (
    order_detail_id INT PRIMARY KEY IDENTITY(1,1),
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    order_id INT,
    variant_id INT,
    FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id)
);

CREATE TABLE FlashSaleItem (
    flashsale_item_id INT PRIMARY KEY IDENTITY(1,1),
    sale_price DECIMAL(10, 2) NOT NULL,
    quantity_limit INT,
    flashsale_id INT,
    variant_id INT,
    sold_quantity INT DEFAULT 0,
    purchase_limit_per_user INT,
    FOREIGN KEY (flashsale_id) REFERENCES FlashSale(flashsale_id),
    FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id)
);

-- =========================================================================
-- 5. TẠO CÁC BẢNG PHỤ THUỘC CẤP 4 & 5
-- =========================================================================

CREATE TABLE ProductReview (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    rating INT,
    comment NVARCHAR(MAX),
    time DATETIME,
    order_detail_id INT,
    user_id INT,
    product_id INT,
    FOREIGN KEY (order_detail_id) REFERENCES OrderDetail(order_detail_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE OrderItemSerial (
    order_item_serial_id INT PRIMARY KEY IDENTITY(1,1),
    order_detail_id INT,
    item_id INT,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_detail_id) REFERENCES OrderDetail(order_detail_id),
    FOREIGN KEY (item_id) REFERENCES InventoryItem(item_id)
);

CREATE TABLE Warranty (
    warranty_id INT PRIMARY KEY IDENTITY(1,1),
    warranty_expired_date DATETIME,
    start_date DATETIME,
    warranty_status NVARCHAR(50),
    item_id INT,
    FOREIGN KEY (item_id) REFERENCES InventoryItem(item_id)
);

CREATE TABLE WarrantyHistory (
    history_id INT PRIMARY KEY IDENTITY(1,1),
    warranty_id INT,
    issue_description NVARCHAR(MAX),
    repair_status NVARCHAR(50),
    repair_date DATETIME,
    repair_note NVARCHAR(MAX),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (warranty_id) REFERENCES Warranty(warranty_id)
);
