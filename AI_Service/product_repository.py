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
    limit=5
):
    conn = get_connection()
    cursor = conn.cursor()

    sql = """
    SELECT TOP (?)
        p.ProductID,
        p.ProductName,
        p.Price,
        p.StockQuantity,
        c.CategoryName,
        b.BrandName,
        ls.CPU,
        ls.RAM,
        ls.Storage,
        ls.GPU,
        ls.Screen,
        ls.Battery,
        ls.OS,
        ls.Weight
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
    JOIN Brands b ON p.BrandID = b.BrandID
    JOIN Laptop_Specs ls ON p.ProductID = ls.ProductID
    WHERE p.StockQuantity > 0
    """

    params = [limit]

    if budget is not None:
        sql += " AND p.Price <= ?"
        params.append(budget)

    if brand is not None:
        sql += " AND LOWER(b.BrandName) = LOWER(?)"
        params.append(brand)

    if need_gpu:
        sql += """
        AND (
            ls.GPU LIKE ?
            OR ls.GPU LIKE ?
            OR ls.GPU LIKE ?
            OR ls.GPU LIKE ?
        )
        """
        params.extend(["%RTX%", "%GTX%", "%NVIDIA%", "%GPU%"])

    if min_ram is not None:
        if min_ram >= 32:
            sql += """
            AND (
                ls.RAM LIKE ?
                OR ls.RAM LIKE ?
                OR ls.RAM LIKE ?
            )
            """
            params.extend(["%32GB%", "%48GB%", "%64GB%"])
        elif min_ram >= 16:
            sql += """
            AND (
                ls.RAM LIKE ?
                OR ls.RAM LIKE ?
                OR ls.RAM LIKE ?
                OR ls.RAM LIKE ?
                OR ls.RAM LIKE ?
            )
            """
            params.extend(["%16GB%", "%18GB%", "%32GB%", "%48GB%", "%64GB%"])

    sql += " ORDER BY p.Price ASC"

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
        p.ProductID,
        p.ProductName,
        p.Price,
        p.StockQuantity,
        c.CategoryName,
        b.BrandName,
        ac.Type,
        ac.Connection_Type,
        ac.Color
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
    JOIN Brands b ON p.BrandID = b.BrandID
    JOIN Accessory_Specs ac ON p.ProductID = ac.ProductID
    WHERE p.StockQuantity > 0
    """

    params = [limit]

    if category_keyword is not None:
        sql += " AND LOWER(c.CategoryName) LIKE LOWER(?)"
        params.append(f"%{category_keyword}%")

    if brand is not None:
        sql += " AND LOWER(b.BrandName) = LOWER(?)"
        params.append(brand)

    if budget is not None:
        sql += " AND p.Price <= ?"
        params.append(budget)

    sql += " ORDER BY p.Price ASC"

    cursor.execute(sql, params)
    rows = cursor.fetchall()

    result = [row_to_dict(cursor, row) for row in rows]

    conn.close()
    return result