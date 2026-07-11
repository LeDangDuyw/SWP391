-- Migration: Add show_in_footer and footer_order to Policy table
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[Policy]') AND name = 'show_in_footer'
)
BEGIN
    ALTER TABLE Policy ADD show_in_footer BIT NOT NULL DEFAULT 0;
END

IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[Policy]') AND name = 'footer_order'
)
BEGIN
    ALTER TABLE Policy ADD footer_order INT NOT NULL DEFAULT 0;
END

-- Seed/Update static policies to show in footer
UPDATE Policy SET show_in_footer = 1, footer_order = 1 WHERE policy_type = 'about_us';
UPDATE Policy SET show_in_footer = 1, footer_order = 2 WHERE policy_type = 'privacy_policy';
UPDATE Policy SET show_in_footer = 1, footer_order = 3 WHERE policy_type = 'terms_of_use';
UPDATE Policy SET show_in_footer = 1, footer_order = 4 WHERE policy_type = 'shopping_guide';
