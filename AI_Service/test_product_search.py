from pprint import pprint
from product_repository import search_laptops, search_accessories

print("=== TEST 1: Laptop dưới 25 triệu ===")
laptops = search_laptops(
    budget=25000000,
    limit=10
)
pprint(laptops, width=140)

print("\n=== TEST 2: Laptop dưới 40 triệu ===")
laptops = search_laptops(
    budget=40000000,
    limit=10
)
pprint(laptops, width=140)

print("\n=== TEST 3: Chuột ===")
mouses = search_accessories(
    category_keyword="Chuột",
    limit=10
)
pprint(mouses, width=140)

print("\n=== TEST san pham theo ten ===")
laptops = search_laptops(
    brand="Dell",
    limit=10
)
pprint(laptops, width=140)

print("\n=== TEST 4: Bàn phím ===")
keyboards = search_accessories(
    category_keyword="Bàn phím",
    limit=10
)
pprint(keyboards, width=140)

print("\n=== TEST 5: Tất cả phụ kiện ===")
accessories = search_accessories(
    limit=10
)
pprint(accessories, width=140)