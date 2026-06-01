USE unilap_db;
GO

IF OBJECT_ID(N'dbo.Campaign', N'U') IS NULL
BEGIN
    CREATE TABLE Campaign (
        campaign_id INT PRIMARY KEY IDENTITY(1,1),
        campaign_name NVARCHAR(255) NOT NULL,
        campaign_description NVARCHAR(MAX),
        promo_code NVARCHAR(50) NOT NULL UNIQUE,
        campaign_type NVARCHAR(50) NOT NULL DEFAULT N'percentage',
        discount_value DECIMAL(18,2) NOT NULL DEFAULT 0,
        min_order_value DECIMAL(18,2) NOT NULL DEFAULT 0,
        usage_limit INT NULL,
        used_count INT NOT NULL DEFAULT 0,
        target_group NVARCHAR(100) NOT NULL DEFAULT N'All Customers',
        start_date DATETIME NOT NULL,
        end_date DATETIME NOT NULL,
        status NVARCHAR(50) NOT NULL DEFAULT N'scheduled',
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        voucher_id INT NULL,
        flashsale_id INT NULL,
        CONSTRAINT FK_Campaign_Voucher FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id),
        CONSTRAINT FK_Campaign_FlashSale FOREIGN KEY (flashsale_id) REFERENCES FlashSale(flashsale_id)
    );
END
GO

IF OBJECT_ID(N'dbo.CampaignProduct', N'U') IS NULL
BEGIN
    CREATE TABLE CampaignProduct (
        campaign_id INT NOT NULL,
        variant_id INT NOT NULL,
        sale_price DECIMAL(18,2) NULL,
        quantity_limit INT NULL,
        sold_quantity INT NOT NULL DEFAULT 0,
        purchase_limit_per_user INT NULL,
        CONSTRAINT PK_CampaignProduct PRIMARY KEY (campaign_id, variant_id),
        CONSTRAINT FK_CampaignProduct_Campaign FOREIGN KEY (campaign_id) REFERENCES Campaign(campaign_id) ON DELETE CASCADE,
        CONSTRAINT FK_CampaignProduct_ProductVariant FOREIGN KEY (variant_id) REFERENCES ProductVariant(variant_id)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Campaign_Status' AND object_id = OBJECT_ID(N'dbo.Campaign'))
    CREATE INDEX IX_Campaign_Status ON Campaign(status);
GO

IF NOT EXISTS (SELECT 1 FROM Voucher WHERE voucher_code = N'B2B-VOL-26')
BEGIN
    INSERT INTO Voucher(voucher_code, discount_value, min_order_value, expiry_date)
    VALUES (N'B2B-VOL-26', 500000, 20000000, '2026-12-31');
END
GO

DECLARE @BackVoucher INT = (SELECT TOP 1 voucher_id FROM Voucher WHERE voucher_code = N'BACK2SCHOOL');
DECLARE @B2BVoucher INT = (SELECT TOP 1 voucher_id FROM Voucher WHERE voucher_code = N'B2B-VOL-26');
DECLARE @FlashSaleId INT = (SELECT TOP 1 flashsale_id FROM FlashSale WHERE flashsale_name LIKE N'%6.6%');

IF NOT EXISTS (SELECT 1 FROM Campaign WHERE promo_code = N'BACK2SCHOOL')
BEGIN
    INSERT INTO Campaign(campaign_name, campaign_description, promo_code, campaign_type, discount_value, min_order_value,
                         usage_limit, used_count, target_group, start_date, end_date, status, voucher_id)
    VALUES (N'Q3 Back to School', N'15% off UNILAP Pro Series và các combo học tập', N'BACK2SCHOOL', N'percentage', 15, 1000000,
            5000, 1240, N'Students', '2026-07-15', '2026-09-15 23:59:59', N'active', @BackVoucher);
END

IF NOT EXISTS (SELECT 1 FROM Campaign WHERE promo_code = N'AUTO-APPLY')
BEGIN
    INSERT INTO Campaign(campaign_name, campaign_description, promo_code, campaign_type, discount_value, min_order_value,
                         usage_limit, used_count, target_group, start_date, end_date, status, flashsale_id)
    VALUES (N'Flash Sale - Peripherals', N'Auto apply cho chuột, bàn phím, tai nghe và phụ kiện', N'AUTO-APPLY', N'flash', 0, 200000,
            1000, 0, N'All Customers', '2026-06-06', '2026-06-06 23:59:59', N'scheduled', @FlashSaleId);
END

IF NOT EXISTS (SELECT 1 FROM Campaign WHERE promo_code = N'B2B-VOL-26')
BEGIN
    INSERT INTO Campaign(campaign_name, campaign_description, promo_code, campaign_type, discount_value, min_order_value,
                         usage_limit, used_count, target_group, start_date, end_date, status, voucher_id)
    VALUES (N'Enterprise Volume Discount', N'Tiered discount for B2B laptop purchases', N'B2B-VOL-26', N'fixed', 500000, 20000000,
            NULL, 0, N'B2B Customers', '2026-06-01', '2026-12-31 23:59:59', N'pending_approval', @B2BVoucher);
END
GO

DECLARE @CBack INT = (SELECT campaign_id FROM Campaign WHERE promo_code = N'BACK2SCHOOL');
DECLARE @CFlash INT = (SELECT campaign_id FROM Campaign WHERE promo_code = N'AUTO-APPLY');
DECLARE @CB2B INT = (SELECT campaign_id FROM Campaign WHERE promo_code = N'B2B-VOL-26');

INSERT INTO CampaignProduct(campaign_id, variant_id, sale_price, quantity_limit, sold_quantity, purchase_limit_per_user)
SELECT @CBack, v.variant_id, NULL, 5000, 0, 1
FROM ProductVariant v
WHERE v.variant_id IN (1,2,3,4,5,6,7)
  AND NOT EXISTS (SELECT 1 FROM CampaignProduct cp WHERE cp.campaign_id = @CBack AND cp.variant_id = v.variant_id);

INSERT INTO CampaignProduct(campaign_id, variant_id, sale_price, quantity_limit, sold_quantity, purchase_limit_per_user)
SELECT @CFlash, fsi.variant_id, fsi.sale_price, fsi.quantity_limit, fsi.sold_quantity, fsi.purchase_limit_per_user
FROM FlashSaleItem fsi
WHERE fsi.flashsale_id = (SELECT TOP 1 flashsale_id FROM FlashSale WHERE flashsale_name LIKE N'%6.6%')
  AND NOT EXISTS (SELECT 1 FROM CampaignProduct cp WHERE cp.campaign_id = @CFlash AND cp.variant_id = fsi.variant_id);

INSERT INTO CampaignProduct(campaign_id, variant_id, sale_price, quantity_limit, sold_quantity, purchase_limit_per_user)
SELECT @CB2B, v.variant_id, NULL, NULL, 0, 3
FROM ProductVariant v
WHERE v.variant_id IN (1,2,3,4,5,6)
  AND NOT EXISTS (SELECT 1 FROM CampaignProduct cp WHERE cp.campaign_id = @CB2B AND cp.variant_id = v.variant_id);
GO
