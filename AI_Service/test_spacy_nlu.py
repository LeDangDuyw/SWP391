from pprint import pprint
from spacy_nlu import analyze_with_spacy

tests = [
    "Em học kế toán tầm 15 triệu muốn laptop Asus mỏng nhẹ pin tốt",
    "Marketing dùng Canva và Photoshop nhẹ thì cần laptop gì",
    "Em học IT chạy Docker SQL Server NetBeans, RAM 16GB SSD 512GB",
    "Học kiến trúc dùng Revit Lumion cần RTX không",
    "Shop có trả góp laptop không",
    "Hôm nay thời tiết Hà Nội thế nào"
]

for text in tests:
    print("=" * 80)
    print(text)
    pprint(analyze_with_spacy(text), width=120)