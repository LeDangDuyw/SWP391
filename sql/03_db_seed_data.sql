USE unilap_db;
GO

-- ============================================================
-- SEED DATA - ĐÃ SỬA ĐỂ HIỂN THỊ TIẾNG VIỆT ĐÚNG
-- Tất cả chuỗi tiếng Việt đều có prefix N'' (NVARCHAR/Unicode)
-- ============================================================

-- ============================================================
-- XÓA DATA CŨ (thứ tự: bảng con → bảng cha để tránh lỗi FK)
-- ============================================================
DELETE FROM FlashSaleItem;
DELETE FROM FlashSale;
DELETE FROM ProductReview;
DELETE FROM AIFeedback;
DELETE FROM Payment;
DELETE FROM OrderItemSerial;
DELETE FROM OrderDetail;
DELETE FROM [Order];
DELETE FROM Voucher;
DELETE FROM CartItem;
DELETE FROM Cart;
DELETE FROM WarrantyHistory;
DELETE FROM Warranty;
DELETE FROM InventoryItem;
DELETE FROM Inventory;
DELETE FROM VariantSpecification;
DELETE FROM ProductVariant;
DELETE FROM ProductImage;
DELETE FROM Product;
DELETE FROM Specification;
DELETE FROM Brand;
DELETE FROM Category;
DELETE FROM Address;
DELETE FROM [User];
DELETE FROM Role;
-- ============================================================

-- ============================================================
-- ROLE
-- ============================================================
SET IDENTITY_INSERT Role ON;
INSERT INTO Role (role_id, role_name) VALUES
(1, N'admin'),
(2, N'staff'),
(3, N'customer');
SET IDENTITY_INSERT Role OFF;

-- ============================================================
-- USER
-- ============================================================
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (user_id, full_name, email, phone, password, status, role_id) VALUES
(1,  N'Nguyễn Văn Admin',    N'admin@techshop.vn',         N'0901000001', N'$2b$10$hashedpw001', N'active', 1),
(2,  N'Trần Thị Staff',      N'staff1@techshop.vn',        N'0901000002', N'$2b$10$hashedpw002', N'active', 2),
(3,  N'Lê Minh Staff',       N'staff2@techshop.vn',        N'0901000003', N'$2b$10$hashedpw003', N'active', 2),
(4,  N'Phạm Văn An',         N'phamvanan@gmail.com',       N'0912111001', N'$2b$10$hashedpw004', N'active', 3),
(5,  N'Nguyễn Thị Bình',     N'nguyenbinhh@gmail.com',     N'0912111002', N'$2b$10$hashedpw005', N'active', 3),
(6,  N'Trần Quốc Cường',     N'tranquoccuong@gmail.com',   N'0912111003', N'$2b$10$hashedpw006', N'active', 3),
(7,  N'Lê Thị Dung',         N'lethidung@gmail.com',       N'0912111004', N'$2b$10$hashedpw007', N'active', 3),
(8,  N'Hoàng Văn Em',        N'hoangvanem@gmail.com',      N'0912111005', N'$2b$10$hashedpw008', N'active', 3),
(9,  N'Vũ Thị Phương',       N'vuthiphuong@gmail.com',     N'0912111006', N'$2b$10$hashedpw009', N'active', 3),
(10, N'Đặng Minh Quân',      N'dangminhquan@gmail.com',    N'0912111007', N'$2b$10$hashedpw010', N'active', 3),
(11, N'Bùi Thị Hồng',        N'buithihong@gmail.com',      N'0912111008', N'$2b$10$hashedpw011', N'active', 3),
(12, N'Ngô Văn Khoa',        N'ngokhoa@gmail.com',         N'0912111009', N'$2b$10$hashedpw012', N'active', 3),
(13, N'Phan Thị Lan',        N'phanthilan@gmail.com',      N'0912111010', N'$2b$10$hashedpw013', N'active', 3),
(14, N'Đinh Công Mạnh',      N'dinhcongmanh@gmail.com',    N'0912111011', N'$2b$10$hashedpw014', N'active', 3),
(15, N'Lý Thị Ngọc',         N'lythingoc@gmail.com',       N'0912111012', N'$2b$10$hashedpw015', N'inactive', 3);
SET IDENTITY_INSERT [User] OFF;

-- ============================================================
-- ADDRESS
-- ============================================================
SET IDENTITY_INSERT Address ON;
INSERT INTO Address (address_id, detail_address, is_default, user_id) VALUES
(1,  N'45 Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP.HCM',                     1,  4),
(2,  N'12 Lê Lợi, Phường Bến Thành, Quận 1, TP.HCM',                        0,  4),
(3,  N'88 Trần Phú, P. Hải Châu 1, Q. Hải Châu, Đà Nẵng',                   1,  5),
(4,  N'210 Hoàn Kiếm, P. Hàng Bạc, Q. Hoàn Kiếm, Hà Nội',                   1,  6),
(5,  N'33 Lý Thường Kiệt, P. 14, Q. 10, TP.HCM',                             1,  7),
(6,  N'77 Đinh Tiên Hoàng, P. Đa Kao, Q. 1, TP.HCM',                         1,  8),
(7,  N'156 Nguyễn Thị Minh Khai, P. 6, Q. 3, TP.HCM',                        1,  9),
(8,  N'29 Cách Mạng Tháng 8, P. 11, Q. 3, TP.HCM',                           1,  10),
(9,  N'91 Võ Văn Tần, P. 6, Q. 3, TP.HCM',                                   1,  11),
(10, N'4 Nam Kỳ Khởi Nghĩa, P. Nguyễn Thái Bình, Q. 1, TP.HCM',              1,  12),
(11, N'67 Hai Bà Trưng, P. Tân Định, Q. 1, TP.HCM',                          1,  13),
(12, N'302 Lê Văn Sỹ, P. 13, Q. 3, TP.HCM',                                  1,  14),
(13, N'18 Bà Triệu, P. Nguyễn Du, Q. Hai Bà Trưng, Hà Nội',                  1,  15),
(14, N'5 Hoàng Diệu, P. Mỹ An, Q. Ngũ Hành Sơn, Đà Nẵng',                   0,  5);
SET IDENTITY_INSERT Address OFF;

-- ============================================================
-- 1. CATEGORY
-- ============================================================
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (category_id, category_name) VALUES
(1, N'Laptop'),
(2, N'Màn hình máy tính'),
(3, N'Bàn phím'),
(4, N'Chuột máy tính'),
(5, N'Tai nghe'),
(6, N'Loa'),
(7, N'Pad chuột');
SET IDENTITY_INSERT Category OFF;

-- ============================================================
-- 2. BRAND
-- ============================================================
SET IDENTITY_INSERT Brand ON;
INSERT INTO Brand (brand_id, brand_name) VALUES
(1,  N'ASUS'),
(2,  N'Acer'),
(3,  N'Dell'),
(4,  N'HP'),
(5,  N'Lenovo'),
(6,  N'MSI'),
(7,  N'Apple'),
(8,  N'Samsung'),
(9,  N'LG'),
(10, N'Sony'),
(11, N'Logitech'),
(12, N'Razer'),
(13, N'SteelSeries'),
(14, N'Corsair'),
(15, N'Akko'),
(16, N'Keychron'),
(17, N'Marshall'),
(18, N'JBL');
SET IDENTITY_INSERT Brand OFF;

-- ============================================================
-- 3. SPECIFICATION
-- ============================================================
SET IDENTITY_INSERT Specification ON;
INSERT INTO Specification (specification_id, specification_name) VALUES
(1,  N'CPU'),
(2,  N'RAM'),
(3,  N'Màn hình'),
(4,  N'Card đồ họa'),
(5,  N'Ổ cứng'),
(6,  N'Hệ điều hành'),
(7,  N'Pin'),
(8,  N'Trọng lượng'),
(9,  N'Màu sắc'),
(10, N'Switch'),
(11, N'Layout'),
(12, N'Backlight'),
(13, N'DPI'),
(14, N'Số nút'),
(15, N'Tần số quét'),
(16, N'Độ phân giải'),
(17, N'Thời gian phản hồi'),
(18, N'Kiểu kết nối'),
(19, N'Công suất');
SET IDENTITY_INSERT Specification OFF;

-- ============================================================
-- 4. PRODUCT
-- ============================================================
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (product_id, product_name, description, warranty_period, thumbnail, category_id, brand_id) VALUES
-- Laptop
(1,  N'ASUS ROG Strix G16 2024',        N'Laptop gaming cao cấp với vi xử lý Intel Core i9-14900HX, màn hình 16" 240Hz, thiết kế tản nhiệt ROG vượt trội.',          24, N'asus_rog_strix_g16.jpg',       1, 1),
(2,  N'Acer Nitro 16 AN16-41',           N'Laptop gaming tầm trung AMD Ryzen 7 7745HX, RTX 4060, màn hình 16" 165Hz, giá cạnh tranh.',                                24, N'acer_nitro_16.jpg',             1, 2),
(3,  N'Dell XPS 15 9530',                N'Laptop doanh nhân cao cấp, màn hình OLED 15.6" 3.5K, Intel Core i7-13700H, thiết kế siêu mỏng.',                          12, N'dell_xps15.jpg',                1, 3),
(4,  N'MacBook Air M3 2024',             N'Laptop siêu mỏng nhẹ chip Apple M3 mạnh mẽ, màn hình Liquid Retina sắc nét, pin lên tới 18 tiếng.',                       12, N'macbook_air_m3.jpg',            1, 7),
-- Màn hình máy tính
(5,  N'ASUS ROG Swift PG279QM',          N'Màn hình gaming 27" IPS 2K 240Hz, G-Sync compatible, DisplayHDR 400, thiết kế không viền 3 cạnh.',                        36, N'asus_rog_swift_pg279qm.jpg',   2, 1),
(6,  N'LG UltraGear 27GP850-B',          N'Màn hình gaming 27" Nano IPS 2K 180Hz, 1ms GtG, AMD FreeSync Premium, sBox HDR 400.',                                     36, N'lg_27gp850.jpg',                2, 9),
(7,  N'Samsung Odyssey G5 Curved',       N'Màn hình chơi game độ cong 1000R tối ưu, độ phân giải 2K WQHD, tần số quét 144Hz mượt mà.',                              24, N'samsung_odyssey_g5.jpg',        2, 8),
-- Bàn phím
(8,  N'Keychron K2 Pro',                 N'Bàn phím cơ 75% layout, kết nối Bluetooth 5.1 & USB-C, hot-swap switch, đèn RGB.',                                        12, N'keychron_k2pro.jpg',            3, 16),
(9,  N'Razer BlackWidow V4 Pro',         N'Bàn phím cơ fullsize, Razer Yellow Switch, đèn Chroma RGB, kết nối không dây 2.4GHz.',                                    24, N'razer_blackwidow_v4pro.jpg',    3, 12),
(10, N'Akko 3087 DS Ocean Star',         N'Bàn phím cơ TKL, switch Akko CS Jelly Blue, PBT doubleshot keycap, đèn RGB.',                                             12, N'akko_3087_ocean.jpg',           3, 15),
-- Chuột máy tính
(11, N'Logitech G502 X Plus',            N'Chuột gaming không dây, cảm biến HERO 25K DPI, 13 nút lập trình, đèn RGB LIGHTFORCE.',                                    24, N'logitech_g502x.jpg',            4, 11),
(12, N'Razer DeathAdder V3 Pro',         N'Chuột gaming không dây siêu nhẹ 64g, cảm biến Focus Pro 30K, kết nối HyperSpeed 2.4GHz.',                                 24, N'razer_deathadder_v3pro.jpg',    4, 12),
(13, N'Logitech G Pro X Superlight 2',   N'Chuột gaming siêu nhẹ dành cho game thủ FPS chuyên nghiệp, cảm biến HERO 2, switch lai LIGHTFORCE.',                     24, N'logitech_gpro_superlight2.jpg', 4, 11),
-- Tai nghe
(14, N'Sony WH-1000XM5',                 N'Tai nghe over-ear không dây chống ồn ANC hàng đầu, âm thanh Hi-Res 30h pin, thoải mái đeo cả ngày.',                     12, N'sony_wh1000xm5.jpg',            5, 10),
(15, N'Razer BlackShark V2 Pro 2023',    N'Tai nghe gaming không dây, driver TriForce Titanium 50mm, micro HyperClear Super Cardioid, 70h pin.',                     24, N'razer_blackshark_v2pro.jpg',    5, 12),
-- Loa
(16, N'Marshall Acton III Bluetooth',    N'Loa bluetooth nghe nhạc trong nhà công suất 60W, thiết kế vintage sang trọng, chất âm chi tiết.',                         12, N'marshall_acton_3.jpg',          6, 17),
(17, N'JBL Charge 5',                    N'Loa di động kháng nước chống bụi IP67, thời lượng pin 20 giờ, âm thanh JBL Pro Sound mạnh mẽ.',                          12, N'jbl_charge_5.jpg',              6, 18),
-- Pad chuột
(18, N'Razer Goliathus Extended Chroma', N'Pad chuột XXL 940x294mm có đèn RGB viền, bề mặt vải tối ưu cho độ chính xác cao.',                                        12, N'razer_goliathus_extended.jpg',  7, 12),
(19, N'SteelSeries QcK Heavy XXL',       N'Pad chuột XXL 900x300mm, đế cao su chống trượt, bề mặt vi dệt mịn, không đèn.',                                           12, N'steelseries_qck_heavy_xxl.jpg', 7, 13);
SET IDENTITY_INSERT Product OFF;

-- ============================================================
-- 5. PRODUCT VARIANT
-- ============================================================
SET IDENTITY_INSERT ProductVariant ON;
INSERT INTO ProductVariant (variant_id, product_id, sku, variant_name, import_price, selling_price, is_serialized, status) VALUES
-- ASUS ROG Strix G16
(1,  1, N'ROG-G16-I9-RTX4080',  N'Core i9 / RTX 4080 / 32GB / 1TB',        38000000, 49990000, 1, N'active'),
(2,  1, N'ROG-G16-I7-RTX4070',  N'Core i7 / RTX 4070 / 16GB / 512GB',      28000000, 37990000, 1, N'active'),
-- Acer Nitro 16
(3,  2, N'NITRO16-R7-RTX4060',  N'R7 7745HX / RTX 4060 / 16GB / 512GB',    20000000, 27990000, 1, N'active'),
-- Dell XPS 15
(4,  3, N'XPS15-I7-RTX4060',    N'Core i7 / RTX 4060 / 16GB / 512GB',      30000000, 42990000, 1, N'active'),
-- MacBook Air M3
(5,  4, N'MBAIR-M3-8-256-SLV',  N'M3 / 8GB RAM / 256GB SSD / Bạc',         22000000, 27490000, 1, N'active'),
(6,  4, N'MBAIR-M3-16-512-GRY', N'M3 / 16GB RAM / 512GB SSD / Xám',        29000000, 34990000, 1, N'active'),
-- ASUS ROG Swift Monitor
(7,  5, N'PG279QM-BLK',         N'27 inch / Đen / 240Hz',                   9000000, 13990000, 0, N'active'),
-- LG UltraGear Monitor
(8,  6, N'LG27GP850-BLK',       N'27 inch / Đen / 180Hz',                   6500000,  9490000, 0, N'active'),
-- Samsung Odyssey G5
(9,  7, N'G5-CURVED-32',        N'32 inch / Cong 1000R / 144Hz',             5800000,  7690000, 0, N'active'),
-- Keychron K2 Pro
(10, 8, N'K2PRO-BROWN-GRY',     N'Nâu / Aluminum Gray',                     1200000,  1990000, 0, N'active'),
(11, 8, N'K2PRO-RED-BLK',       N'Đỏ / Space Gray',                         1200000,  1990000, 0, N'active'),
-- Razer BlackWidow V4 Pro
(12, 9, N'BWV4PRO-BLACK',       N'Đen / Yellow Switch',                      3500000,  4990000, 0, N'active'),
-- Akko 3087
(13,10, N'AKKO3087-OCEAN',      N'Ocean Star / Jelly Blue Switch',            800000,  1290000, 0, N'active'),
-- Logitech G502 X Plus
(14,11, N'G502X-BLACK',         N'Đen / RGB',                                2000000,  2990000, 0, N'active'),
(15,11, N'G502X-WHITE',         N'Trắng / RGB',                              2000000,  3090000, 0, N'active'),
-- Razer DeathAdder V3 Pro
(16,12, N'DAV3PRO-BLACK',       N'Đen / Siêu nhẹ',                           2800000,  3890000, 0, N'active'),
-- Logitech G Pro X Superlight 2
(17,13, N'GPRO-SL2-WHITE',      N'Trắng / 60g',                              2700000,  3690000, 0, N'active'),
-- Sony WH-1000XM5
(18,14, N'XM5-BLACK',           N'Đen / Chống ồn ANC',                       5500000,  7990000, 0, N'active'),
-- Razer BlackShark V2 Pro
(19,15, N'BSV2PRO-BLACK',       N'Đen / Gaming',                             3200000,  4490000, 0, N'active'),
-- Marshall Acton III
(20,16, N'MARSHALL-A3-BRWN',    N'Nâu Vintage / 60W',                        5200000,  6990000, 0, N'active'),
-- JBL Charge 5
(21,17, N'JBL-CHARGE5-BLK',     N'Đen / Chống nước IP67',                    2600000,  3490000, 0, N'active'),
-- Pad Razer
(22,18, N'GOLIATHUS-EXT-RGB',   N'Bề mặt vải / Đèn RGB',                      700000,  1090000, 0, N'active'),
-- Pad SteelSeries
(23,19, N'QCK-HEAVY-XXL',       N'Đen / Size XXL',                            600000,   890000, 0, N'active');
SET IDENTITY_INSERT ProductVariant OFF;

-- ============================================================
-- 7. PRODUCT IMAGE
-- ============================================================
SET IDENTITY_INSERT ProductImage ON;
INSERT INTO ProductImage (image_id, image_url, product_id) VALUES
(1,  N'products/laptop/asus_rog_g16_1.jpg',          1),
(2,  N'products/laptop/acer_nitro16_1.jpg',          2),
(3,  N'products/laptop/dell_xps15_1.jpg',            3),
(4,  N'products/laptop/macbook_air_m3.jpg',          4),
(5,  N'products/monitor/asus_pg279qm_1.jpg',         5),
(6,  N'products/monitor/lg_27gp850_1.jpg',           6),
(7,  N'products/monitor/samsung_g5_1.jpg',           7),
(8,  N'products/keyboard/keychron_k2pro_1.jpg',      8),
(9,  N'products/keyboard/razer_bwv4pro_1.jpg',       9),
(10, N'products/keyboard/akko_3087_1.jpg',           10),
(11, N'products/mouse/logitech_g502x_1.jpg',         11),
(12, N'products/mouse/razer_dav3pro_1.jpg',          12),
(13, N'products/mouse/logitech_gpro_sl2.jpg',        13),
(14, N'products/headphone/sony_xm5_1.jpg',           14),
(15, N'products/headphone/razer_bsv2pro_1.jpg',      15),
(16, N'products/speaker/marshall_acton3.jpg',        16),
(17, N'products/speaker/jbl_charge5.jpg',            17),
(18, N'products/mousepad/razer_goliathus_1.jpg',     18),
(19, N'products/mousepad/steelseries_qck_xxl_1.jpg', 19);
SET IDENTITY_INSERT ProductImage OFF;

-- ============================================================
-- 6. VARIANT SPECIFICATION
-- ============================================================
SET IDENTITY_INSERT VariantSpecification ON;
INSERT INTO VariantSpecification (variant_specification_id, variant_id, specification_id, value) VALUES
-- ASUS ROG G16 variant 1
(1,  1, 1,  N'Intel Core i9-14900HX'),
(2,  1, 2,  N'32GB DDR5 5600MHz'),
(3,  1, 3,  N'16" QHD+ 240Hz IPS'),
(4,  1, 4,  N'NVIDIA RTX 4080 12GB'),
(5,  1, 5,  N'1TB NVMe PCIe 4.0'),
-- MacBook Air M3 variant 6
(6,  6, 1,  N'Apple M3 (8-core CPU)'),
(7,  6, 2,  N'16GB Unified Memory'),
(8,  6, 3,  N'13.6 inch Liquid Retina'),
(9,  6, 5,  N'512GB SSD'),
-- ASUS ROG Swift Monitor variant 7
(10, 7, 16, N'2560x1440 (QHD)'),
(11, 7, 15, N'240Hz'),
(12, 7, 17, N'1ms GtG'),
-- Keychron K2 Pro variant 10
(13, 10, 10, N'Gateron G Pro Brown'),
(14, 10, 11, N'75% (84 phím)'),
(15, 10, 12, N'RGB Backlight'),
-- Logitech G502 X Plus variant 14
(16, 14, 13, N'100 - 25600 DPI'),
(17, 14, 14, N'13 nút'),
(18, 14, 18, N'USB Receiver 2.4GHz / Bluetooth'),
-- Sony XM5 variant 18
(19, 18, 18, N'Bluetooth 5.2 / Jack 3.5mm'),
(20, 18, 7,  N'30 giờ (ANC bật)'),
-- Marshall Acton III variant 20
(21, 20, 19, N'60W'),
(22, 20, 18, N'Bluetooth 5.2 / AUX');
SET IDENTITY_INSERT VariantSpecification OFF;

-- ============================================================
-- INVENTORY
-- ============================================================
SET IDENTITY_INSERT Inventory ON;
INSERT INTO Inventory (inventory_id, variant_id, reserved_quantity, available_quantity) VALUES
(1,  1,  1, 12),
(2,  2,  0, 18),
(3,  3,  2, 25),
(4,  4,  0,  9),
(5,  5,  1, 14),
(6,  6,  0, 10),
(7,  7,  0, 20),
(8,  8,  0, 28),
(9,  9,  1, 15),
(10, 10, 3, 50),
(11, 11, 2, 42),
(12, 12, 0, 17),
(13, 13, 4, 65),
(14, 14, 2, 38),
(15, 15, 0, 30),
(16, 16, 1, 35),
(17, 17, 2, 28),
(18, 18, 1, 22),
(19, 19, 0, 19),
(20, 20, 0, 13),
(21, 21, 3, 45),
(22, 22, 2, 60),
(23, 23, 1, 55);
SET IDENTITY_INSERT Inventory OFF;

-- ============================================================
-- INVENTORY ITEM (is_serialized = 1: chỉ laptop)
-- ============================================================
SET IDENTITY_INSERT InventoryItem ON;
INSERT INTO InventoryItem (item_id, variant_id, serial_number, imei, barcode, status, import_date, sold_date, warranty_expired_date, note, warehouse_location, created_at, updated_at) VALUES
-- ROG G16 i9 (variant 1)
(1,  1, N'SN-ROGG16I9-001', N'IMEI-001-G16I9', N'BC-ROGG16I9-001', N'in_stock', '2025-09-01', NULL,         '2027-09-01', NULL, N'A1-01', GETDATE(), GETDATE()),
(2,  1, N'SN-ROGG16I9-002', N'IMEI-002-G16I9', N'BC-ROGG16I9-002', N'in_stock', '2025-09-01', NULL,         '2027-09-01', NULL, N'A1-01', GETDATE(), GETDATE()),
(3,  1, N'SN-ROGG16I9-003', N'IMEI-003-G16I9', N'BC-ROGG16I9-003', N'sold',     '2025-09-01', '2025-11-05', '2027-09-01', NULL, N'A1-01', GETDATE(), GETDATE()),
(4,  1, N'SN-ROGG16I9-004', N'IMEI-004-G16I9', N'BC-ROGG16I9-004', N'sold',     '2025-09-15', '2025-12-10', '2027-09-15', NULL, N'A1-01', GETDATE(), GETDATE()),
-- ROG G16 i7 (variant 2)
(5,  2, N'SN-ROGG16I7-001', N'IMEI-005-G16I7', N'BC-ROGG16I7-001', N'in_stock', '2025-09-01', NULL,         '2027-09-01', NULL, N'A1-02', GETDATE(), GETDATE()),
(6,  2, N'SN-ROGG16I7-002', N'IMEI-006-G16I7', N'BC-ROGG16I7-002', N'in_stock', '2025-09-01', NULL,         '2027-09-01', NULL, N'A1-02', GETDATE(), GETDATE()),
(7,  2, N'SN-ROGG16I7-003', N'IMEI-007-G16I7', N'BC-ROGG16I7-003', N'sold',     '2025-09-01', '2025-11-20', '2027-09-01', NULL, N'A1-02', GETDATE(), GETDATE()),
-- Nitro 16 (variant 3)
(8,  3, N'SN-NITRO16-001',  N'IMEI-008-NIT16', N'BC-NITRO16-001',  N'in_stock', '2025-10-01', NULL,         '2027-10-01', NULL, N'A2-01', GETDATE(), GETDATE()),
(9,  3, N'SN-NITRO16-002',  N'IMEI-009-NIT16', N'BC-NITRO16-002',  N'in_stock', '2025-10-01', NULL,         '2027-10-01', NULL, N'A2-01', GETDATE(), GETDATE()),
(10, 3, N'SN-NITRO16-003',  N'IMEI-010-NIT16', N'BC-NITRO16-003',  N'sold',     '2025-10-01', '2025-12-03', '2027-10-01', NULL, N'A2-01', GETDATE(), GETDATE()),
(11, 3, N'SN-NITRO16-004',  N'IMEI-011-NIT16', N'BC-NITRO16-004',  N'sold',     '2025-10-15', '2026-01-07', '2027-10-15', NULL, N'A2-01', GETDATE(), GETDATE()),
-- Dell XPS 15 (variant 4)
(12, 4, N'SN-XPS15-001',    N'IMEI-012-XPS15', N'BC-XPS15-001',    N'in_stock', '2025-08-20', NULL,         '2026-08-20', NULL, N'A3-01', GETDATE(), GETDATE()),
(13, 4, N'SN-XPS15-002',    N'IMEI-013-XPS15', N'BC-XPS15-002',    N'sold',     '2025-08-20', '2025-11-15', '2026-08-20', NULL, N'A3-01', GETDATE(), GETDATE()),
-- MacBook Air M3 8/256 (variant 5)
(14, 5, N'SN-MBAIRM3S-001', N'IMEI-014-M3S',   N'BC-MBAIRM3S-001', N'in_stock', '2025-10-10', NULL,         '2026-10-10', NULL, N'A4-01', GETDATE(), GETDATE()),
(15, 5, N'SN-MBAIRM3S-002', N'IMEI-015-M3S',   N'BC-MBAIRM3S-002', N'in_stock', '2025-10-10', NULL,         '2026-10-10', NULL, N'A4-01', GETDATE(), GETDATE()),
(16, 5, N'SN-MBAIRM3S-003', N'IMEI-016-M3S',   N'BC-MBAIRM3S-003', N'sold',     '2025-10-10', '2025-12-20', '2026-10-10', NULL, N'A4-01', GETDATE(), GETDATE()),
-- MacBook Air M3 16/512 (variant 6)
(17, 6, N'SN-MBAIRM3L-001', N'IMEI-017-M3L',   N'BC-MBAIRM3L-001', N'in_stock', '2025-10-10', NULL,         '2026-10-10', NULL, N'A4-02', GETDATE(), GETDATE()),
(18, 6, N'SN-MBAIRM3L-002', N'IMEI-018-M3L',   N'BC-MBAIRM3L-002', N'sold',     '2025-10-10', '2026-01-14', '2026-10-10', NULL, N'A4-02', GETDATE(), GETDATE());
SET IDENTITY_INSERT InventoryItem OFF;

-- ============================================================
-- WARRANTY
-- ============================================================
SET IDENTITY_INSERT Warranty ON;
INSERT INTO Warranty (warranty_id, warranty_expired_date, start_date, warranty_status, item_id) VALUES
(1, '2027-09-01', '2025-11-05', N'active',  3),
(2, '2027-09-15', '2025-12-10', N'active',  4),
(3, '2027-09-01', '2025-11-20', N'active',  7),
(4, '2027-10-01', '2025-12-03', N'active',  10),
(5, '2027-10-15', '2026-01-07', N'active',  11),
(6, '2026-08-20', '2025-11-15', N'active',  13),
(7, '2026-10-10', '2025-12-20', N'active',  16),
(8, '2026-10-10', '2026-01-14', N'active',  18);
SET IDENTITY_INSERT Warranty OFF;

-- ============================================================
-- WARRANTY HISTORY
-- ============================================================
SET IDENTITY_INSERT WarrantyHistory ON;
INSERT INTO WarrantyHistory (history_id, warranty_id, issue_description, repair_status, repair_date, repair_note, created_at) VALUES
(1, 1, N'Bàn phím một số phím bị liệt sau 2 tháng sử dụng', N'completed', '2026-02-10', N'Đã thay bàn phím mới, kiểm tra OK',             GETDATE()),
(2, 4, N'Pin sụt nhanh, sạc không đầy 100%',                N'completed', '2026-03-01', N'Đã thay pin, kiểm tra chu kỳ sạc bình thường',  GETDATE()),
(3, 6, N'Màn hình xuất hiện đường sọc ngang khi khởi động', N'pending',   NULL,          N'Đang chờ linh kiện thay thế',                   GETDATE()),
(4, 7, N'Loa phát tiếng rè ở âm lượng cao',                 N'processing','2026-04-20', N'Đang kiểm tra module loa',                       GETDATE());
SET IDENTITY_INSERT WarrantyHistory OFF;

-- ============================================================
-- CART
-- ============================================================
SET IDENTITY_INSERT Cart ON;
INSERT INTO Cart (cart_id, user_id) VALUES
(1,  4),
(2,  5),
(3,  6),
(4,  7),
(5,  8),
(6,  9),
(7,  10),
(8,  11),
(9,  12),
(10, 13),
(11, 14),
(12, 15);
SET IDENTITY_INSERT Cart OFF;

-- ============================================================
-- CART ITEM
-- ============================================================
SET IDENTITY_INSERT CartItem ON;
INSERT INTO CartItem (cart_item_id, quantity, cart_id, variant_id) VALUES
-- User 4 (Phạm Văn An): muốn mua ROG G16 i9 + Pad Razer
(1,  1, 1,  1),
(2,  1, 1,  22),
-- User 5 (Nguyễn Thị Bình): MacBook Air M3 16/512
(3,  1, 2,  6),
-- User 6 (Trần Quốc Cường): Samsung G5 + Keychron K2 Pro Brown + G502X Black
(4,  1, 3,  9),
(5,  1, 3,  10),
(6,  1, 3,  14),
-- User 7 (Lê Thị Dung): DeathAdder V3 + SteelSeries Pad
(7,  1, 4,  16),
(8,  1, 4,  23),
-- User 8 (Hoàng Văn Em): Sony XM5
(9,  1, 5,  18),
-- User 9: Marshall Acton III
(10, 1, 6,  20),
-- User 10: Akko 3087 x2
(11, 2, 7,  13),
-- User 11: G Pro X Superlight 2
(12, 1, 8,  17),
-- User 12: Razer BlackShark V2 Pro + JBL Charge 5
(13, 1, 9,  19),
(14, 1, 9,  21);
SET IDENTITY_INSERT CartItem OFF;

-- ============================================================
-- VOUCHER
-- ============================================================
SET IDENTITY_INSERT Voucher ON;
INSERT INTO Voucher (voucher_id, voucher_code, discount_value, min_order_value, expiry_date) VALUES
(1, N'WELCOME10',   10,     300000,   '2026-12-31'),
(2, N'SUMMER20',    20,     2000000,  '2026-07-31'),
(3, N'GAMING500',   500000, 15000000, '2026-08-31'),
(4, N'BACK2SCHOOL', 15,     1000000,  '2026-09-15'),
(5, N'NEWUSER5',    5,      100000,   '2026-12-31'),
(6, N'FLASH30',     30,     5000000,  '2026-06-30'),
(7, N'TECHTHANKS',  200000, 3000000,  '2026-10-31');
SET IDENTITY_INSERT Voucher OFF;

-- ============================================================
-- ORDER
-- ============================================================
SET IDENTITY_INSERT [Order] ON;
INSERT INTO [Order] (order_id, total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, order_code, user_id, voucher_id) VALUES
-- Đơn đã giao (delivered)
(1,  49990000, 30000, N'delivered', N'Phạm Văn An',      N'0912111001', N'45 Nguyễn Huệ, Q.1, TP.HCM',                    N'ORD-20251105-0001', 4,  NULL),
(2,  27990000, 30000, N'delivered', N'Trần Quốc Cường',  N'0912111003', N'210 Hoàn Kiếm, Q. Hoàn Kiếm, Hà Nội',           N'ORD-20251120-0002', 6,  2),
(3,  42990000, 30000, N'delivered', N'Lê Thị Dung',      N'0912111004', N'33 Lý Thường Kiệt, Q.10, TP.HCM',               N'ORD-20251115-0003', 7,  NULL),
(4,  34990000, 25000, N'delivered', N'Nguyễn Thị Bình',  N'0912111002', N'88 Trần Phú, Q. Hải Châu, Đà Nẵng',             N'ORD-20251210-0004', 5,  1),
(5,  37990000, 30000, N'delivered', N'Vũ Thị Phương',    N'0912111006', N'156 Nguyễn Thị Minh Khai, Q.3, TP.HCM',         N'ORD-20251220-0005', 9,  NULL),
(6,   4490000, 25000, N'delivered', N'Đặng Minh Quân',   N'0912111007', N'29 CMT8, Q.3, TP.HCM',                          N'ORD-20260107-0006', 10, 5),
(7,   1290000, 20000, N'delivered', N'Bùi Thị Hồng',     N'0912111008', N'91 Võ Văn Tần, Q.3, TP.HCM',                    N'ORD-20260110-0007', 11, NULL),
-- Đơn đang giao (shipped)
(8,  27490000, 30000, N'shipped',   N'Ngô Văn Khoa',     N'0912111009', N'4 Nam Kỳ Khởi Nghĩa, Q.1, TP.HCM',              N'ORD-20260401-0008', 12, 4),
(9,   7990000, 25000, N'shipped',   N'Hoàng Văn Em',     N'0912111005', N'77 Đinh Tiên Hoàng, Q.1, TP.HCM',               N'ORD-20260410-0009', 8,  NULL),
(10,  6990000, 25000, N'shipped',   N'Phạm Văn An',      N'0912111001', N'45 Nguyễn Huệ, Q.1, TP.HCM',                    N'ORD-20260415-0010', 4,  7),
-- Đơn đang xử lý (processing)
(11,  3690000, 25000, N'processing',N'Phan Thị Lan',     N'0912111010', N'67 Hai Bà Trưng, Q.1, TP.HCM',                  N'ORD-20260501-0011', 13, NULL),
(12, 13990000, 30000, N'processing',N'Lý Thị Ngọc',      N'0912111012', N'18 Bà Triệu, Q. Hai Bà Trưng, Hà Nội',          N'ORD-20260502-0012', 15, 3),
-- Đơn chờ xác nhận (pending)
(13,  4990000, 25000, N'pending',   N'Đinh Công Mạnh',   N'0912111011', N'302 Lê Văn Sỹ, Q.3, TP.HCM',                    N'ORD-20260510-0013', 14, NULL),
(14,  3490000, 20000, N'pending',   N'Bùi Thị Hồng',     N'0912111008', N'91 Võ Văn Tần, Q.3, TP.HCM',                    N'ORD-20260512-0014', 11, NULL),
-- Đơn đã huỷ (cancelled)
(15,  9490000, 25000, N'cancelled', N'Vũ Thị Phương',    N'0912111006', N'156 Nguyễn Thị Minh Khai, Q.3, TP.HCM',         N'ORD-20260301-0015', 9,  NULL);
SET IDENTITY_INSERT [Order] OFF;

-- ============================================================
-- ORDER DETAIL
-- ============================================================
SET IDENTITY_INSERT OrderDetail ON;
INSERT INTO OrderDetail (order_detail_id, quantity, unit_price, order_id, variant_id) VALUES
(1,  1, 49990000, 1,  1),
(2,  1, 27990000, 2,  3),
(3,  1, 42990000, 3,  4),
(4,  1, 34990000, 4,  5),
(5,  1, 37990000, 5,  2),
(6,  1,  4490000, 6,  19),
(7,  1,  1290000, 7,  13),
(8,  1, 27490000, 8,  5),
(9,  1,  7990000, 9,  18),
(10, 1,  6990000, 10, 20),
(11, 1,  3490000, 10, 21),
(12, 1,  3690000, 11, 17),
(13, 1, 13990000, 12, 7),
(14, 1,  4990000, 13, 12),
(15, 1,  3490000, 14, 21),
(16, 1,  9490000, 15, 8);
SET IDENTITY_INSERT OrderDetail OFF;

-- ============================================================
-- ORDER ITEM SERIAL
-- ============================================================
SET IDENTITY_INSERT OrderItemSerial ON;
INSERT INTO OrderItemSerial (order_item_serial_id, order_detail_id, item_id, assigned_at) VALUES
(1, 1,  3,  '2025-11-05 09:15:00'),
(2, 2,  10, '2025-11-20 10:00:00'),
(3, 3,  13, '2025-11-15 14:30:00'),
(4, 4,  16, '2025-12-20 11:00:00'),
(5, 5,  7,  '2025-11-20 09:45:00'),
(6, 8,  14, '2026-04-01 08:30:00');
SET IDENTITY_INSERT OrderItemSerial OFF;

-- ============================================================
-- PAYMENT
-- ============================================================
SET IDENTITY_INSERT Payment ON;
INSERT INTO Payment (payment_id, payment_method, amount, payment_status, order_id) VALUES
(1,  N'credit_card',   49990000, N'paid',     1),
(2,  N'bank_transfer', 27990000, N'paid',     2),
(3,  N'credit_card',   42990000, N'paid',     3),
(4,  N'momo',          34990000, N'paid',     4),
(5,  N'bank_transfer', 37990000, N'paid',     5),
(6,  N'cod',            4490000, N'paid',     6),
(7,  N'momo',           1290000, N'paid',     7),
(8,  N'bank_transfer', 27490000, N'paid',     8),
(9,  N'momo',           7990000, N'paid',     9),
(10, N'credit_card',    6990000, N'paid',     10),
(11, N'cod',            3690000, N'pending',  11),
(12, N'bank_transfer', 13990000, N'pending',  12),
(13, N'cod',            4990000, N'pending',  13),
(14, N'momo',           3490000, N'pending',  14),
(15, N'credit_card',    9490000, N'refunded', 15);
SET IDENTITY_INSERT Payment OFF;

-- ============================================================
-- AI FEEDBACK
-- ============================================================
SET IDENTITY_INSERT AIFeedback ON;
INSERT INTO AIFeedback (feedback_id, rating, comment, time, user_id) VALUES
(1, 5, N'Website rất dễ dùng, tìm kiếm nhanh, giao hàng đúng hạn. Sẽ giới thiệu cho bạn bè!',      GETDATE(), 4),
(2, 5, N'Hàng chính hãng, đóng gói cẩn thận, nhân viên tư vấn nhiệt tình.',                         GETDATE(), 5),
(3, 4, N'Sản phẩm tốt, giá cạnh tranh. Giao hàng hơi chậm hơn dự kiến 1 ngày.',                    GETDATE(), 6),
(4, 4, N'Laptop đúng như mô tả. Hỗ trợ kỹ thuật tốt khi tôi cần cài đặt.',                         GETDATE(), 7),
(5, 3, N'Sản phẩm ổn nhưng hotline khó gọi vào giờ cao điểm.',                                      GETDATE(), 9),
(6, 5, N'Mua lần 2 rồi, lần nào cũng hài lòng. Deal Flash Sale rất ngon!',                          GETDATE(), 10),
(7, 4, N'Bàn phím đẹp, gõ sướng, ship nhanh. Chỉ cần thêm nhiều voucher hơn cho khách cũ.',        GETDATE(), 11);
SET IDENTITY_INSERT AIFeedback OFF;

-- ============================================================
-- PRODUCT REVIEW
-- ============================================================
SET IDENTITY_INSERT ProductReview ON;
INSERT INTO ProductReview (review_id, rating, comment, time, order_detail_id, user_id, product_id) VALUES
(1, 5, N'Máy cực mạnh, chiến game 4K mượt mà hoàn toàn. Tản nhiệt tốt, không bị nóng dù chạy load nặng. Rất xứng đáng!', GETDATE(), 1,  4,  1),
(2, 4, N'Máy chạy tốt, màn đẹp. Riêng cái quạt hơi ồn khi load nặng, nhưng tổng thể vẫn rất ổn với giá tầm trung.',      GETDATE(), 2,  6,  2),
(3, 5, N'Dell XPS 15 màn hình OLED đẹp xuất sắc, mỏng nhẹ sang trọng. Đúng là laptop doanh nhân đẳng cấp.',               GETDATE(), 3,  7,  3),
(4, 5, N'MacBook Air M3 pin trâu thật sự, làm việc cả ngày không cần sạc. Chip M3 mượt mà tuyệt vời.',                     GETDATE(), 4,  5,  4),
(5, 4, N'ROG G16 i7 hiệu năng rất tốt với tầm giá. Bàn phím gõ thích, màn hình sắc nét 165Hz.',                            GETDATE(), 5,  9,  1),
(6, 5, N'Tai nghe Razer gaming cực đỉnh, âm thanh vòm rõ ràng, mic trong hơn hẳn tai nghe cũ. 70 giờ pin dùng cả tháng!', GETDATE(), 6,  10, 15),
(7, 4, N'Akko 3087 gõ sướng tay, keycap đẹp, giá hợp lý cho người mới bắt đầu custom keyboard.',                          GETDATE(), 7,  11, 10);
SET IDENTITY_INSERT ProductReview OFF;

-- ============================================================
-- FLASH SALE
-- ============================================================
SET IDENTITY_INSERT FlashSale ON;
INSERT INTO FlashSale (flashsale_id, flashsale_name, start_time, end_time) VALUES
(1, N'Flash Sale Hè 2026 - Ngày 1',        '2026-06-01 10:00:00', '2026-06-01 14:00:00'),
(2, N'Siêu Sale 6.6 - Ngày Hội Công Nghệ', '2026-06-06 00:00:00', '2026-06-06 23:59:59'),
(3, N'Flash Sale Cuối Tháng 5',             '2026-05-31 20:00:00', '2026-05-31 23:59:59'),
(4, N'Flash Deal Nửa Đêm',                  '2026-06-15 00:00:00', '2026-06-15 02:00:00');
SET IDENTITY_INSERT FlashSale OFF;

-- ============================================================
-- FLASH SALE ITEM
-- ============================================================
SET IDENTITY_INSERT FlashSaleItem ON;
INSERT INTO FlashSaleItem (flashsale_item_id, sale_price, quantity_limit, flashsale_id, variant_id, sold_quantity, purchase_limit_per_user) VALUES
-- Flash Sale 1 - Hè
(1,  44990000,  5,  1,  1,  0, 1),
(2,  24990000, 10,  1,  3,  0, 1),
(3,   7190000, 20,  1,  18, 0, 2),
(4,   2590000, 30,  1,  14, 5, 2),
(5,   1690000, 50,  1,  13, 12,3),
-- Flash Sale 2 - 6.6
(6,  32990000,  3,  2,  6,  0, 1),
(7,  12990000,  8,  2,  7,  0, 1),
(8,   3990000, 15,  2,  12, 3, 2),
(9,   3290000, 20,  2,  16, 7, 2),
(10,  6490000, 10,  2,  20, 2, 1),
-- Flash Sale 3 - Cuối tháng
(11,  8490000,  6,  3,  8,  4, 1),
(12,  6990000, 10,  3,  9,  6, 1),
(13,  1790000, 40,  3,  10, 18,2),
(14,   890000, 60,  3,  23, 25,3),
-- Flash Sale 4 - Nửa đêm
(15, 49490000,  2,  4,  1,  0, 1),
(16,  3490000, 15,  4,  17, 0, 2),
(17,  4190000, 10,  4,  19, 0, 2);
SET IDENTITY_INSERT FlashSaleItem OFF;