-- ============================================================================
-- SCRIPT BỔ SUNG QUẢN LÝ THÔNG SỐ KỸ THUẬT THEO DANH MỤC (UNILAP)
-- Chạy script này trên SQL Server Management Studio (SSMS) cho unilap_db
-- ============================================================================

USE [unilap_db];
GO

-- 1. Tạo bảng liên kết CategorySpecification nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CategorySpecification')
BEGIN
    CREATE TABLE [dbo].[CategorySpecification](
        [category_id] [int] NOT NULL,
        [specification_id] [int] NOT NULL,
        [display_order] [int] NOT NULL DEFAULT 0,
        CONSTRAINT [PK_CategorySpecification] PRIMARY KEY CLUSTERED 
        (
            [category_id] ASC,
            [specification_id] ASC
        )
    );

    ALTER TABLE [dbo].[CategorySpecification] WITH CHECK ADD CONSTRAINT [FK_CategorySpec_Category] FOREIGN KEY([category_id])
    REFERENCES [dbo].[Category] ([category_id]) ON DELETE CASCADE;

    ALTER TABLE [dbo].[CategorySpecification] WITH CHECK ADD CONSTRAINT [FK_CategorySpec_Specification] FOREIGN KEY([specification_id])
    REFERENCES [dbo].[Specification] ([specification_id]) ON DELETE CASCADE;

    PRINT N'Đã tạo thành công bảng CategorySpecification!';
END
ELSE
BEGIN
    PRINT N'Bảng CategorySpecification đã tồn tại.';
END
GO

-- 2. Đảm bảo dữ liệu các thuộc tính phổ biến có sẵn trong bảng master Specification
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'CPU')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'CPU');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'RAM')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'RAM');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Màn hình')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Màn hình');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Card đồ họa')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Card đồ họa');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Ổ cứng')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Ổ cứng');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Hệ điều hành')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Hệ điều hành');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Pin')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Pin');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Trọng lượng')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Trọng lượng');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Switch')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Switch');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Layout')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Layout');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Backlight')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Backlight');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'DPI')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'DPI');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Số nút')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Số nút');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Tần số quét')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Tần số quét');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Độ phân giải')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Độ phân giải');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Thời gian phản hồi')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Thời gian phản hồi');
IF NOT EXISTS (SELECT * FROM [dbo].[Specification] WHERE [specification_name] = N'Kiểu kết nối')
    INSERT INTO [dbo].[Specification] ([specification_name]) VALUES (N'Kiểu kết nối');
GO

-- 3. Gán ánh xạ thông số kỹ thuật mặc định cho từng danh mục
-- Danh mục Laptop (category_id = 1) -> CPU(1), RAM(2), Màn hình(3), Card đồ họa(4), Ổ cứng(5), Hệ điều hành(6), Pin(7), Trọng lượng(8)
INSERT INTO [dbo].[CategorySpecification] (category_id, specification_id, display_order)
SELECT 1, spec_id, ord FROM (VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8)) AS T(spec_id, ord)
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CategorySpecification] WHERE category_id = 1 AND specification_id = spec_id);

-- Danh mục Màn hình máy tính (category_id = 2) -> Màn hình(3), Tần số quét(15), Độ phân giải(16), Thời gian phản hồi(17), Kiểu kết nối(18)
INSERT INTO [dbo].[CategorySpecification] (category_id, specification_id, display_order)
SELECT 2, spec_id, ord FROM (VALUES (3, 1), (15, 2), (16, 3), (17, 4), (18, 5)) AS T(spec_id, ord)
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CategorySpecification] WHERE category_id = 2 AND specification_id = spec_id);

-- Danh mục Bàn phím (category_id = 3) -> Switch(10), Layout(11), Backlight(12), Kiểu kết nối(18)
INSERT INTO [dbo].[CategorySpecification] (category_id, specification_id, display_order)
SELECT 3, spec_id, ord FROM (VALUES (10, 1), (11, 2), (12, 3), (18, 4)) AS T(spec_id, ord)
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CategorySpecification] WHERE category_id = 3 AND specification_id = spec_id);

-- Danh mục Chuột máy tính (category_id = 4) -> DPI(13), Số nút(14), Tần số quét(15), Kiểu kết nối(18)
INSERT INTO [dbo].[CategorySpecification] (category_id, specification_id, display_order)
SELECT 4, spec_id, ord FROM (VALUES (13, 1), (14, 2), (15, 3), (18, 4)) AS T(spec_id, ord)
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[CategorySpecification] WHERE category_id = 4 AND specification_id = spec_id);

PRINT N'Hoàn tất cập nhật CSDL thành công!';
GO
