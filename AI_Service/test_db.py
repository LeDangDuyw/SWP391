from db import get_connection

conn = get_connection()
cursor = conn.cursor()

cursor.execute("""
SELECT TOP 10
    p.product_id AS ProductID,
    p.product_name AS ProductName,
    c.category_name AS CategoryName,
    b.brand_name AS BrandName
FROM Product p
LEFT JOIN Category c ON p.category_id = c.category_id
LEFT JOIN Brand b ON p.brand_id = b.brand_id
""")

rows = cursor.fetchall()

for row in rows:
    print(row.ProductID, row.ProductName, row.CategoryName, row.BrandName)

conn.close()