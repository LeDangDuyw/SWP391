-- Script hợp nhất Voucher vào bảng Campaign & Bổ sung New User check cho UniLap
-- Vui lòng chạy script này trong SQL Server của bạn (Cơ sở dữ liệu unilap_db)

USE [unilap_db];
GO

-- 1. Xóa các bảng cũ UserVoucher và Voucher nếu đã lỡ tạo ở các phiên bản trước để làm sạch database
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'UserVoucher')
BEGIN
    DROP TABLE [UserVoucher];
END
GO

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Voucher')
BEGIN
    DROP TABLE [Voucher];
END
GO

-- 2. Thêm cột user_id trực tiếp vào bảng Campaign nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Campaign]') AND name = 'user_id')
BEGIN
    ALTER TABLE [dbo].[Campaign] 
    ADD [user_id] INT NULL FOREIGN KEY REFERENCES [User]([user_id]) ON DELETE SET NULL;
END
GO

-- 3. Thêm cột is_new_user_only trực tiếp vào bảng Campaign nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Campaign]') AND name = 'is_new_user_only')
BEGIN
    ALTER TABLE [dbo].[Campaign] 
    ADD [is_new_user_only] BIT NOT NULL DEFAULT 0;
END
GO

-- 4. Tạo dữ liệu khuyến mãi/voucher mẫu trực tiếp trong bảng Campaign để kiểm thử
IF NOT EXISTS (SELECT * FROM [Campaign] WHERE [promo_code] IN (N'LAPTOP100', N'GIAM50K', N'UNILAPPERCENT', N'WELCOME50'))
BEGIN
    INSERT INTO [Campaign] 
    ([campaign_name], [promo_code], [discount_value], [min_order_value], [start_date], [end_date], [status], [campaign_type], [created_at], [updated_at], [user_id], [is_new_user_only])
    VALUES 
    (N'Khuyến mãi Laptop 100k', N'LAPTOP100', 100000.00, 15000000.00, GETDATE(), DATEADD(day, 30, GETDATE()), 'active', 'fixed', GETDATE(), GETDATE(), NULL, 0),
    (N'Giảm ngay 50k cho đơn hàng', N'GIAM50K', 50000.00, 1000000.00, GETDATE(), DATEADD(day, 15, GETDATE()), 'active', 'fixed', GETDATE(), GETDATE(), NULL, 0),
    (N'Ưu đãi phần trăm UniLap', N'UNILAPPERCENT', 10.00, 20000000.00, GETDATE(), DATEADD(day, 45, GETDATE()), 'active', 'percentage', GETDATE(), GETDATE(), NULL, 0),
    (N'Quà chào mừng khách hàng mới', N'WELCOME50', 50000.00, 500000.00, GETDATE(), DATEADD(day, 30, GETDATE()), 'active', 'fixed', GETDATE(), GETDATE(), NULL, 1); -- Dành riêng cho khách hàng mới
END
GO

-- 5. Ví dụ cá nhân hóa ưu đãi: Gán mã 'LAPTOP100' cho một User cụ thể để test quyền sở hữu
DECLARE @TestUserId INT;
SELECT TOP 1 @TestUserId = [user_id] FROM [User] WHERE [role_id] = 3 ORDER BY [user_id] ASC;

IF @TestUserId IS NOT NULL
BEGIN
    UPDATE [Campaign]
    SET [user_id] = @TestUserId
    WHERE [promo_code] = N'LAPTOP100';

    PRINT N'Da gan campaign LAPTOP100 lam uu dai ca nhan cho User ID: ' + CAST(@TestUserId AS NVARCHAR(10));
END
ELSE
BEGIN
    PRINT N'Khong tim thay user co role_id = 3 (Customer) de gan uu dai mau.';
END
GO

-- 6. Thêm cột user_usage_limit trực tiếp vào bảng Campaign nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Campaign]') AND name = 'user_usage_limit')
BEGIN
    ALTER TABLE [dbo].[Campaign] 
    ADD [user_usage_limit] INT NULL;
END
GO
