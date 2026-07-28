from decimal import Decimal
from db import get_connection


def convert_value(value):
    if isinstance(value, Decimal):
        return float(value)
    return value


def row_to_dict(cursor, row):
    columns = [column[0] for column in cursor.description]
    return {
        columns[index]: convert_value(row[index])
        for index in range(len(columns))
    }


def search_laptops(
    budget=None,
    brand=None,
    need_gpu=False,
    min_ram=None,
    cpu_keyword=None,
    limit=5
):
    conn = get_connection()
    cursor = conn.cursor()

    sql = """
    SELECT TOP (?)
        p.product_id AS ProductID,
        pv.variant_id AS VariantID,
        p.product_name AS ProductName,
        pv.variant_name AS VariantName,
        pv.sku AS SKU,
        pv.selling_price AS Price,
        ISNULL(i.available_quantity, 0) AS StockQuantity,
        c.category_name AS CategoryName,
        b.brand_name AS BrandName,
        p.description AS Description,
        p.warranty_period AS WarrantyMonths,
        (SELECT TOP 1 image_url FROM ProductImage WHERE product_id = p.product_id) AS ImageURL
    FROM Product p
    JOIN Category c ON p.category_id = c.category_id
    JOIN Brand b ON p.brand_id = b.brand_id
    JOIN ProductVariant pv ON p.product_id = pv.product_id
    LEFT JOIN Inventory i ON pv.variant_id = i.variant_id
    WHERE
        LOWER(c.category_name) LIKE LOWER(N'%Laptop%')
        AND pv.status = N'active'
        AND ISNULL(i.available_quantity, 0) > 0
    """

    params = [limit]

    if budget is not None:
        sql += " AND pv.selling_price <= ?"
        params.append(budget)

    if brand is not None:
        sql += " AND LOWER(b.brand_name) = LOWER(?)"
        params.append(brand)

    if cpu_keyword is not None:
        sql += " AND (LOWER(p.product_name) LIKE LOWER(?) OR LOWER(p.description) LIKE LOWER(?) OR LOWER(pv.variant_name) LIKE LOWER(?))"
        params.append(f"%{cpu_keyword}%")
        params.append(f"%{cpu_keyword}%")
        params.append(f"%{cpu_keyword}%")

    sql += " ORDER BY pv.selling_price ASC"

    cursor.execute(sql, params)
    rows = cursor.fetchall()

    result = [row_to_dict(cursor, row) for row in rows]

    conn.close()
    return result


def search_accessories(
    category_keyword=None,
    brand=None,
    budget=None,
    limit=5
):
    conn = get_connection()
    cursor = conn.cursor()

    sql = """
    SELECT TOP (?)
        p.product_id AS ProductID,
        pv.variant_id AS VariantID,
        p.product_name AS ProductName,
        pv.variant_name AS VariantName,
        pv.sku AS SKU,
        pv.selling_price AS Price,
        ISNULL(i.available_quantity, 0) AS StockQuantity,
        c.category_name AS CategoryName,
        b.brand_name AS BrandName,
        p.description AS Description,
        p.warranty_period AS WarrantyMonths,
        (SELECT TOP 1 image_url FROM ProductImage WHERE product_id = p.product_id) AS ImageURL
    FROM Product p
    JOIN Category c ON p.category_id = c.category_id
    JOIN Brand b ON p.brand_id = b.brand_id
    JOIN ProductVariant pv ON p.product_id = pv.product_id
    LEFT JOIN Inventory i ON pv.variant_id = i.variant_id
    WHERE
        LOWER(c.category_name) NOT LIKE LOWER(N'%Laptop%')
        AND pv.status = N'active'
        AND ISNULL(i.available_quantity, 0) > 0
    """

    params = [limit]

    if category_keyword is not None and category_keyword != "phụ kiện":
        sql += " AND LOWER(c.category_name) LIKE LOWER(?)"
        params.append(f"%{category_keyword}%")

    if brand is not None:
        sql += " AND LOWER(b.brand_name) = LOWER(?)"
        params.append(brand)

    if budget is not None:
        sql += " AND pv.selling_price <= ?"
        params.append(budget)

    sql += " ORDER BY pv.selling_price ASC"

    cursor.execute(sql, params)
    rows = cursor.fetchall()

    result = [row_to_dict(cursor, row) for row in rows]

    conn.close()
    return result


def find_products_by_name(keyword: str, limit: int = 5):
    if keyword is None or keyword.strip() == "":
        return []
    conn = get_connection()
    cursor = conn.cursor()

    sql = """
    SELECT TOP (?)
        p.product_id AS ProductID,
        pv.variant_id AS VariantID,
        p.product_name AS ProductName,
        pv.variant_name AS VariantName,
        pv.sku AS SKU,

        pv.selling_price AS OriginalPrice,

        CASE
            WHEN cam.campaign_id IS NOT NULL
                 AND LOWER(cam.campaign_type) IN ('percentage', 'percent')
            THEN pv.selling_price - (pv.selling_price * cam.discount_value / 100.0)

            WHEN cam.campaign_id IS NOT NULL
                 AND LOWER(cam.campaign_type) IN ('fixed', 'amount')
            THEN pv.selling_price - cam.discount_value

            ELSE pv.selling_price
        END AS FinalPrice,

        CASE 
            WHEN cam.campaign_id IS NOT NULL THEN 1
            ELSE 0
        END AS IsOnSale,

        cam.promo_code AS PromoCode,
        cam.campaign_type AS CampaignType,
        cam.discount_value AS DiscountValue,
        cam.min_order_value AS MinOrderValue,

        ISNULL(i.available_quantity, 0) AS StockQuantity,
        c.category_name AS CategoryName,
        b.brand_name AS BrandName,
        p.description AS Description,
        p.warranty_period AS WarrantyMonths,
        pv.status AS VariantStatus,
        (SELECT TOP 1 image_url FROM ProductImage WHERE product_id = p.product_id) AS ImageURL

    FROM Product p
    JOIN ProductVariant pv ON p.product_id = pv.product_id
    LEFT JOIN Inventory i ON pv.variant_id = i.variant_id
    LEFT JOIN Category c ON p.category_id = c.category_id
    LEFT JOIN Brand b ON p.brand_id = b.brand_id

    LEFT JOIN CampaignProduct cp ON pv.variant_id = cp.variant_id
    LEFT JOIN Campaign cam ON cp.campaign_id = cam.campaign_id
        AND LOWER(cam.status) = 'active'
        AND GETDATE() BETWEEN cam.start_date AND cam.end_date

    WHERE
        pv.status = N'active'
        AND ISNULL(i.available_quantity, 0) > 0
        AND (
            LOWER(p.product_name) LIKE LOWER(?)
            OR LOWER(pv.variant_name) LIKE LOWER(?)
            OR LOWER(b.brand_name) LIKE LOWER(?)
            OR LOWER(pv.sku) LIKE LOWER(?)
        )

    ORDER BY
        IsOnSale DESC,
        FinalPrice ASC
    """

    like_keyword = f"%{keyword.strip()}%"

    params = [
        limit,
        like_keyword,
        like_keyword,
        like_keyword,
        like_keyword
    ]

    cursor.execute(sql, params)
    rows = cursor.fetchall()

    result = [row_to_dict(cursor, row) for row in rows]

    conn.close()
    return result