from db import get_connection

conn = get_connection()
cursor = conn.cursor()

cursor.execute("""
SELECT TOP 5 
    ProductID, 
    ProductName, 
    Price, 
    StockQuantity 
FROM Products
""")

rows = cursor.fetchall()

for row in rows:
    print(row.ProductID, row.ProductName, row.Price, row.StockQuantity)

conn.close()