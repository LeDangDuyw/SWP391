import unicodedata
import spacy
from spacy.matcher import PhraseMatcher, Matcher

# --- 1. HÀM BỔ TRỢ CHUỖI (THUẦN PYTHON STRING METHODS) ---

def remove_accents(text: str) -> str:
    text = unicodedata.normalize("NFD", text)
    text = "".join(ch for ch in text if unicodedata.category(ch) != "Mn")
    return text.replace("đ", "d").replace("Đ", "D")

def separate_num_chars(text: str) -> str:
    """
    Tự động chèn khoảng trắng giữa chữ và số dính liền (vd: '16gb' -> '16 gb', '15tr' -> '15 tr').
    Giúp SpaCy Tokenizer không bị nhận diện sai cụm từ phần cứng mà hoàn toàn tránh Regex.
    """
    if not text:
        return ""
    result = []
    for i, char in enumerate(text):
        if i > 0:
            prev = text[i-1]
            # Nếu ký tự trước là số, ký tự sau là chữ (hoặc ngược lại) thì chèn khoảng trắng
            if (prev.isdigit() and char.isalpha()) or (prev.isalpha() and char.isdigit()):
                result.append(" ")
        result.append(char)
    return "".join(result)

def normalize_text(text: str) -> str:
    """Làm sạch văn bản bằng string methods thay thế re.sub"""
    text = remove_accents(text.lower().strip())
    text = separate_num_chars(text)
    # Loại bỏ ký tự đặc biệt, chỉ giữ lại chữ cái, số và khoảng trắng
    chars = [c if c.isalnum() or c.isspace() else " " for c in text]
    return " ".join("".join(chars).split())

def extract_digits(text: str) -> int:
    """Lọc lấy các ký tự số trong một chuỗi"""
    nums = "".join([c for c in text if c.isdigit()])
    return int(nums) if nums else 0

# --- 2. CẤU HÌNH BỘ KHỚP DỮ LIỆU (SPACY CONFIG) ---

nlp = spacy.blank("vi")
# Tắt pyvi nếu bạn không cài đặt, cho phép SpaCy tách từ bằng khoảng trắng cơ bản
nlp.tokenizer.use_pyvi = False 

phrase_matcher = PhraseMatcher(nlp.vocab, attr="LOWER")
token_matcher = Matcher(nlp.vocab)

ENTITY_PATTERNS = {
    "MAJOR_ACCOUNTING": ["kế toán", "tai chinh", "tài chính", "ngân hàng", "ngan hang", "kiểm toán", "kiem toan"],
    "MAJOR_MARKETING": ["marketing", "truyền thông", "truyen thong", "content", "social media", "chạy quảng cáo", "chay quang cao", "facebook ads", "google ads", "canva"],
    "MAJOR_LAW": ["luật", "luat", "pháp lý", "phap ly", "luật kinh tế", "luat kinh te"],
    "MAJOR_IT": ["công nghệ thông tin", "cong nghe thong tin", "lập trình", "lap trinh", "code", "it", "java", "python", "android studio", "sql server", "netbeans"],
    "MAJOR_DESIGN": ["thiết kế", "thiet ke", "đồ họa", "do hoa", "multimedia", "photoshop", "illustrator", "premiere", "after effects", "dựng video", "dung video"],
    "MAJOR_ARCHITECTURE": ["kiến trúc", "kien truc", "xây dựng", "xay dung", "autocad", "revit", "sketchup", "lumion"],
    "MAJOR_ENGINEERING": ["cơ khí", "co khi", "điện điện tử", "dien dien tu", "tự động hóa", "tu dong hoa", "kỹ thuật", "ky thuat", "solidworks", "matlab", "arduino"],
    "MAJOR_MEDICAL": ["y", "dược", "duoc", "điều dưỡng", "dieu duong", "y khoa"],
    "MAJOR_EDUCATION": ["sư phạm", "su pham", "giáo viên", "giao vien", "dạy online", "day online"],
    "MAJOR_OFFICE": ["văn phòng", "van phong", "nhân sự", "nhan su", "sale", "kinh doanh", "excel", "word", "powerpoint"],
    "MAJOR_GAMING": ["gaming", "chơi game", "choi game", "liên minh", "lien minh", "valorant", "pubg"],
    "MAJOR_AI_DATA": ["ai local", "machine learning", "data science", "data analyst", "docker", "máy ảo", "may ao", "llm local", "stable diffusion", "power bi"],
    "BRAND": ["asus", "acer", "lenovo", "dell", "hp", "msi", "gigabyte", "apple", "macbook", "thinkpad", "legion", "loq", "vivobook", "zenbook", "rog", "tuf", "inspiron", "xps", "victus"],
    "NEED_LIGHTWEIGHT": ["mỏng nhẹ", "mong nhe", "nhẹ", "nhe", "dễ mang", "de mang", "di chuyển", "di chuyen"],
    "NEED_BATTERY": ["pin tốt", "pin tot", "pin lâu", "pin lau", "lâu hết pin", "lau het pin"],
    "NEED_SCREEN": ["màn hình đẹp", "man hinh dep", "chuẩn màu", "chuan mau", "ips", "oled"],
    "NEED_GPU": ["card rời", "card roi", "gpu", "rtx", "gtx"]
}

MAJOR_MAP = {
    "MAJOR_ACCOUNTING": "accounting_finance", "MAJOR_MARKETING": "marketing_content", "MAJOR_LAW": "law",
    "MAJOR_IT": "it_programming", "MAJOR_DESIGN": "design_multimedia", "MAJOR_ARCHITECTURE": "architecture_construction",
    "MAJOR_ENGINEERING": "engineering", "MAJOR_MEDICAL": "medical", "MAJOR_EDUCATION": "education",
    "MAJOR_OFFICE": "office", "MAJOR_GAMING": "gaming", "MAJOR_AI_DATA": "ai_data_heavy"
}

# Đăng ký các cụm từ tĩnh
for label, phrases in ENTITY_PATTERNS.items():
    patterns = [nlp.make_doc(p) for p in phrases]
    phrase_matcher.add(label, patterns)

# Quy định Token Matcher cho các biến phần cứng (Đã cấu trúc lại để khớp văn bản sau khi tách số/chữ)
token_matcher.add("BUDGET", [[{"LIKE_NUM": True}, {"LOWER": {"IN": ["triệu", "trieu", "tr", "m"]}}]])
token_matcher.add("RAM", [
    [{"LOWER": "ram"}, {"LIKE_NUM": True}, {"LOWER": {"IN": ["gb", "g"]}, "OP": "?"}],
    [{"LIKE_NUM": True}, {"LOWER": {"IN": ["gb", "g"]}}, {"LOWER": "ram"}]
])
token_matcher.add("STORAGE", [
    [{"LOWER": "ssd"}, {"LIKE_NUM": True}, {"LOWER": {"IN": ["gb", "tb"]}}],
    [{"LIKE_NUM": True}, {"LOWER": {"IN": ["gb", "tb"]}}, {"LOWER": "ssd"}]
])

# --- 3. LOGIC XỬ LÝ ĐẦU RA ---

def parse_budget_v2(span):
    for token in span:
        if token.like_num:
            return extract_digits(token.text) * 1_000_000
    return None

def parse_ram_v2(span):
    for token in span:
        if token.like_num:
            return extract_digits(token.text)
    return None

def parse_storage_v2(span):
    is_tb = any(t.lower_ == "tb" for t in span)
    for token in span:
        if token.like_num:
            val = extract_digits(token.text)
            return val * 1024 if is_tb else val
    return None

def classify_intent(text: str, entities: dict):
    text_norm = normalize_text(text)
    
    # Kiểm tra ngoài phạm vi (Out of scope)
    out_scope = ["thoi tiet", "bong da", "nau an", "lich su", "chinh tri", "tinh yeu", "ke chuyen", "lam tho"]
    if any(x in text_norm for x in out_scope):
        return "out_of_scope"
        
    # Phân loại dựa trên keyword tĩnh
    check_map = {
        "warranty_policy": ["bao hanh", "doi tra", "loi may"],
        "installment_policy": ["tra gop", "gop", "the tin dung"],
        "delivery_policy": ["giao hang", "ship", "van chuyen"],
        "compare_laptop": ["so sanh", "hon", "khac giua"]
    }
    
    for intent, keywords in check_map.items():
        if any(kw in text_norm for kw in keywords):
            return intent

    # Phân loại tư vấn laptop
    if (
        entities["majors_or_needs"]
        or entities["budget"]
        or entities["brand"]
        or any(entities["constraints"].values())
        or any(x in text_norm for x in ["mua", "tu van", "chon", "nen mua", "cau hinh", "laptop", "may tinh"])
    ):
        return "laptop_advice"

    return "unknown"

def analyze_with_spacy(text: str):
    # CHỐT CHẶN BẮT BUỘC: Tách chữ và số dính liền trước khi đưa vào SpaCy
    processed_text = separate_num_chars(text)
    doc = nlp(processed_text)

    entities = {
        "budget": None,
        "brand": None,
        "majors_or_needs": [],
        "ram": None,
        "storage_gb": None,
        "constraints": {
            "need_lightweight": False,
            "need_battery": False,
            "need_screen_quality": False,
            "need_gpu": False
        },
        "raw_matches": []
    }

    # Tổng hợp các lượt khớp từ cả 2 Matchers
    matches = phrase_matcher(doc) + token_matcher(doc)

    for match_id, start, end in matches:
        label = nlp.vocab.strings[match_id]
        span = doc[start:end]

        entities["raw_matches"].append({
            "label": label,
            "text": span.text
        })

        if label in MAJOR_MAP:
            major = MAJOR_MAP[label]
            if major not in entities["majors_or_needs"]:
                entities["majors_or_needs"].append(major)
        elif label == "BRAND":
            entities["brand"] = span.text.lower()
        elif label == "NEED_LIGHTWEIGHT":
            entities["constraints"]["need_lightweight"] = True
        elif label == "NEED_BATTERY":
            entities["constraints"]["need_battery"] = True
        elif label == "NEED_SCREEN":
            entities["constraints"]["need_screen_quality"] = True
        elif label == "NEED_GPU":
            entities["constraints"]["need_gpu"] = True
        elif label == "BUDGET":
            entities["budget"] = parse_budget_v2(span)
        elif label == "RAM":
            entities["ram"] = parse_ram_v2(span)
        elif label == "STORAGE":
            entities["storage_gb"] = parse_storage_v2(span)
            

    return {
        "raw_text": text,
        "intent": classify_intent(text, entities),
        "budget": entities["budget"],
        "brand": entities["brand"],
        "majors_or_needs": entities["majors_or_needs"],
        "ram": entities["ram"],
        "storage_gb": entities["storage_gb"],
        "constraints": entities["constraints"],
        "raw_matches": entities["raw_matches"]
    }
def is_allowed_domain(nlu_result: dict) -> bool:
    allowed_intents = [
        "laptop_advice",
        "compare_laptop",
        "warranty_policy",
        "installment_policy",
        "delivery_policy"
    ]

    return nlu_result.get("intent") in allowed_intents