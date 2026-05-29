from pprint import pprint
from product_repository import search_laptops, search_accessories

print("=== TEST 1: Laptop dưới 25 triệu, RAM >= 16GB ===")
laptops = search_laptops(
    budget=25000000,
    min_ram=16,
    limit=5
)
pprint(laptops, width=120)

print("\n=== TEST 2: Laptop gaming / cần GPU, dưới 30 triệu ===")
gaming_laptops = search_laptops(
    budget=30000000,
    need_gpu=True,
    min_ram=16,
    limit=5
)
pprint(gaming_laptops, width=120)

print("\n=== TEST 3: Phụ kiện chuột ===")
mouses = search_accessories(
    category_keyword="Chuột",
    limit=5
)
pprint(mouses, width=120)

print("\n=== TEST 4: Phụ kiện bàn phím ===")
keyboards = search_accessories(
    category_keyword="Bàn Phím",
    limit=5
)
pprint(keyboards, width=120)