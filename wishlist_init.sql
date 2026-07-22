-- Script khoi tao bang Wishlist (San pham yeu thich) cho he thong UniLap
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Wishlist')
BEGIN
    CREATE TABLE [Wishlist] (
        [wishlist_id] INT IDENTITY(1,1) PRIMARY KEY,
        [user_id] INT NOT NULL FOREIGN KEY REFERENCES [User]([user_id]) ON DELETE CASCADE,
        [product_id] INT NOT NULL FOREIGN KEY REFERENCES [Product]([product_id]) ON DELETE CASCADE,
        [created_at] DATETIME DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT UQ_User_Product UNIQUE ([user_id], [product_id])
    );
END
