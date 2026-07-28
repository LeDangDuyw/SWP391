import os
import json
import re
from typing import Any, Optional

from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
from langgraph.graph import StateGraph, START, END, MessagesState

from security_guard import (
    is_dangerous_request,
    get_security_refusal,
    sanitize_ai_output,
)
from spacy_nlu import analyze_with_spacy, is_allowed_domain
from product_repository import (
    find_products_by_name,
    search_laptops,
    search_accessories,
)

# Nếu chat_memory.py chưa có 2 hàm này thì vẫn không làm app bị lỗi.
try:
    from chat_memory import get_last_products, set_last_products
except Exception:
    _LAST_PRODUCTS_STORE = {}

    def get_last_products(session_id: str):
        return _LAST_PRODUCTS_STORE.get(session_id, [])

    def set_last_products(session_id: str, products: list):
        _LAST_PRODUCTS_STORE[session_id] = products or []


load_dotenv()

# LLM chính để sinh câu trả lời tư vấn
llm = ChatOpenAI(
    model=os.getenv("LMSTUDIO_MODEL"),
    base_url=os.getenv("LMSTUDIO_BASE_URL"),
    api_key="lm-studio",
    temperature=0.1,
    max_tokens=1024,
)

# LLM phụ tối ưu hóa riêng cho phân tích NLU (Cách 1)
# Sử dụng temperature=0.0 và response_format json để nhanh và chính xác nhất
llm_nlu = ChatOpenAI(
    model=os.getenv("LMSTUDIO_MODEL"),
    base_url=os.getenv("LMSTUDIO_BASE_URL"),
    api_key="lm-studio",
    temperature=0.0,
    max_tokens=150,
)

class AgentState(MessagesState):
    session_id: str


SHOP_POLICIES = {
    "greeting": (
        "Dạ em chào anh/chị ạ! Em là trợ lý ảo tư vấn của shop laptop. "
        "Em có thể giúp gì cho anh/chị trong việc tìm mua laptop, phụ kiện, hoặc giải đáp các thông tin về trả góp, bảo hành, giao hàng không ạ?"
    ),
    "installment_policy": (
        "Shop có hỗ trợ trả góp laptop và phụ kiện. "
        "Thông tin chi tiết như mức trả trước, kỳ hạn, lãi suất và đơn vị hỗ trợ trả góp "
        "cần kiểm tra theo từng sản phẩm và chương trình hiện tại của shop. "
        "Bạn cho mình biết mẫu sản phẩm hoặc ngân sách dự kiến để shop tư vấn phương án phù hợp hơn nhé."
    ),
    "warranty_policy": (
        "Sản phẩm tại shop có chính sách bảo hành tùy theo từng loại sản phẩm và hãng. "
        "Laptop thường có bảo hành theo hãng hoặc chính sách riêng của shop, còn phụ kiện sẽ tùy danh mục. "
        "Bạn cho mình biết sản phẩm đang quan tâm để kiểm tra thời gian bảo hành cụ thể nhé."
    ),
    "delivery_policy": (
        "Shop có hỗ trợ giao hàng. "
        "Thời gian và phí giao hàng sẽ tùy khu vực, sản phẩm và chương trình hiện tại. "
        "Bạn cho mình biết khu vực nhận hàng để shop kiểm tra chính xác hơn nhé."
    ),
}


# =========================================================
# Helper chung
# =========================================================

def get_shop_policy_answer(intent: str) -> Optional[str]:
    return SHOP_POLICIES.get(intent)


def get_value(data: dict, *keys: str, default=None):
    for key in keys:
        if key in data and data.get(key) is not None:
            return data.get(key)
    return default


def to_float(value, default: float = 0.0) -> float:
    try:
        if value is None:
            return default
        return float(value)
    except Exception:
        return default


def format_money(value) -> str:
    try:
        if value is None:
            return "chưa có giá"
        return f"{float(value):,.0f} VNĐ"
    except Exception:
        return str(value)


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", (text or "").lower()).strip()


def is_on_sale_product(product: dict) -> bool:
    is_on_sale = get_value(product, "IsOnSale", "is_on_sale", default=0)
    original_price = get_original_price(product)
    final_price = get_final_price(product)

    if str(is_on_sale).lower() in ["1", "true", "yes"]:
        return True

    if original_price is not None and final_price is not None:
        return to_float(final_price) < to_float(original_price)

    return False


def get_original_price(product: dict):
    return get_value(
        product,
        "OriginalPrice",
        "Price",
        "price",
        "selling_price",
        "SellingPrice",
    )


def get_final_price(product: dict):
    original_price = get_original_price(product)
    return get_value(
        product,
        "FinalPrice",
        "SalePrice",
        "DiscountedPrice",
        "final_price",
        default=original_price,
    )


def build_sale_text(product: dict) -> str:
    if not is_on_sale_product(product):
        return "Không có khuyến mãi đang áp dụng"

    promo_code = get_value(product, "PromoCode", "promo_code")
    campaign_name = get_value(product, "CampaignName", "campaign_name")
    campaign_type = str(get_value(product, "CampaignType", "campaign_type", default="")).lower()
    discount_value = get_value(product, "DiscountValue", "discount_value")
    min_order_value = get_value(product, "MinOrderValue", "min_order_value")

    if campaign_type in ["percentage", "percent"]:
        discount_part = f"Đang giảm {to_float(discount_value):.0f}%"
    elif campaign_type in ["fixed", "amount"]:
        discount_part = f"Đang giảm {format_money(discount_value)}"
    else:
        discount_part = "Đang có khuyến mãi"

    extra = []

    if campaign_name:
        extra.append(f"chương trình: {campaign_name}")

    if promo_code:
        extra.append(f"mã: {promo_code}")

    if min_order_value and to_float(min_order_value) > 0:
        extra.append(f"đơn tối thiểu: {format_money(min_order_value)}")

    if extra:
        return discount_part + " (" + ", ".join(extra) + ")"

    return discount_part


def build_price_block(product: dict) -> str:
    original_price = get_original_price(product)
    final_price = get_final_price(product)

    if is_on_sale_product(product):
        return (
            f"   Giá gốc: {format_money(original_price)}\n"
            f"   Giá sau giảm: {format_money(final_price)}\n"
            f"   Khuyến mãi: {build_sale_text(product)}\n"
        )

    return f"   Giá: {format_money(original_price)}\n"


def build_product_line(index: int, product: dict) -> str:
    product_name = get_value(product, "ProductName", "product_name", default="Không rõ tên sản phẩm")
    variant_name = get_value(product, "VariantName", "variant_name", default="")
    brand_name = get_value(product, "BrandName", "brand_name", default="Không rõ hãng")
    category_name = get_value(product, "CategoryName", "category_name", default="Không rõ danh mục")
    stock = get_value(product, "StockQuantity", "Stock", "available_quantity", default=0)
    warranty = get_value(product, "WarrantyMonths", "warranty_period", default="chưa rõ")
    status = str(get_value(product, "VariantStatus", "status", default="active")).lower()

    stock_num = to_float(stock)
    stock_text = "còn hàng" if stock_num > 0 else "hết hàng hoặc chưa có tồn kho"
    status_text = "đang bán" if status == "active" else "không ở trạng thái bán"

    display_name = product_name
    if variant_name and variant_name.lower() not in product_name.lower():
        display_name = f"{product_name} - {variant_name}"

    return (
        f"\n{index}. {display_name}\n"
        f"   Hãng: {brand_name}\n"
        f"   Danh mục: {category_name}\n"
        + build_price_block(product)
        + f"   Tồn kho: {int(stock_num) if stock_num.is_integer() else stock} - {stock_text}\n"
        f"   Trạng thái: {status_text}\n"
        f"   Bảo hành: {warranty} tháng"
    )


def build_product_context_for_follow_up(products: list) -> str:
    if not products:
        return "Không có sản phẩm nào được lưu từ lượt tư vấn trước."

    lines = []

    for idx, product in enumerate(products, start=1):
        product_name = get_value(product, "ProductName", "product_name", default="")
        variant_name = get_value(product, "VariantName", "variant_name", default="")
        brand_name = get_value(product, "BrandName", "brand_name", default="")
        category_name = get_value(product, "CategoryName", "category_name", default="")
        stock = get_value(product, "StockQuantity", "Stock", "available_quantity", default=0)
        warranty = get_value(product, "WarrantyMonths", "warranty_period", default="chưa rõ")

        lines.append(
            f"{idx}. {product_name} - {variant_name}\n"
            f"   Hãng: {brand_name}\n"
            f"   Danh mục: {category_name}\n"
            f"   Giá gốc: {format_money(get_original_price(product))}\n"
            f"   Giá sau giảm: {format_money(get_final_price(product))}\n"
            f"   Khuyến mãi: {build_sale_text(product)}\n"
            f"   Tồn kho: {stock}\n"
            f"   Bảo hành: {warranty} tháng\n"
        )

    return "\n".join(lines)


# =========================================================
# Nhận diện câu hỏi tìm sản phẩm / hỏi tên sản phẩm
# =========================================================

def is_product_lookup_question(user_message: str) -> bool:
    text = normalize_text(user_message)

    lookup_keywords = [
        "có bán",
        "shop có",
        "cửa hàng có",
        "bên mình có",
        "bên shop có",
        "còn hàng",
        "có hàng",
        "tồn tại",
        "còn không",
        "có không",
        "kiểm tra",
        "tìm sản phẩm",
        "sản phẩm này",
        "mẫu này",
    ]

    return any(keyword in text for keyword in lookup_keywords)


def extract_product_keyword(user_message: str) -> str:
    text = normalize_text(user_message)

    patterns = [
        r"có bán\s+(.+?)(?:\s+không|\s+ko|\s+k|\?|$)",
        r"shop có\s+(.+?)(?:\s+không|\s+ko|\s+k|\?|$)",
        r"cửa hàng có\s+(.+?)(?:\s+không|\s+ko|\s+k|\?|$)",
        r"bên mình có\s+(.+?)(?:\s+không|\s+ko|\s+k|\?|$)",
        r"bên shop có\s+(.+?)(?:\s+không|\s+ko|\s+k|\?|$)",
        r"(.+?)\s+còn hàng",
        r"(.+?)\s+có hàng",
        r"kiểm tra\s+(.+)",
        r"tìm sản phẩm\s+(.+)",
    ]

    for pattern in patterns:
        match = re.search(pattern, text)
        if match:
            return clean_product_keyword(match.group(1).strip())

    return clean_product_keyword(text)


def clean_product_keyword(keyword: str) -> str:
    remove_words = [
        "shop",
        "cửa hàng",
        "bên mình",
        "bên shop",
        "có bán",
        "có",
        "không",
        "ko",
        "k",
        "ạ",
        "không ạ",
        "còn hàng",
        "có hàng",
        "tồn tại",
        "sản phẩm",
        "mẫu",
        "giúp em",
        "cho em hỏi",
        "mình hỏi",
        "kiểm tra",
        "tìm",
    ]

    result = normalize_text(keyword)

    for word in remove_words:
        result = result.replace(word, " ")

    return re.sub(r"\s+", " ", result).strip()


# Giữ alias để không lỗi nếu file khác đang gọi tên cũ.
def extract_product_keywords(user_message: str) -> str:
    return extract_product_keyword(user_message)


# =========================================================
# Phụ kiện / nhu cầu laptop
# =========================================================

def detect_accessory_category(user_message: str):
    text = normalize_text(user_message)

    accessory_keywords = {
        "chuột": ["chuột", "mouse"],
        "bàn phím": ["bàn phím", "keyboard", "phím cơ"],
        "tai nghe": ["tai nghe", "headphone", "headset"],
        "balo": ["balo", "ba lô", "túi laptop"],
        "màn hình": ["màn hình rời", "monitor"],
        "đế tản nhiệt": ["đế tản nhiệt", "tản nhiệt"],
        "ssd": ["ssd", "ổ cứng"],
        "ram": ["ram"],
        "hub": ["hub", "usb c", "type c", "dock"],
        "webcam": ["webcam", "camera"],
        "sạc": ["sạc", "adapter", "charger"],
    }

    for category, keywords in accessory_keywords.items():
        if any(keyword in text for keyword in keywords):
            return category

    if "phụ kiện" in text:
        return "phụ kiện"

    return None


def should_need_gpu(nlu_result: dict) -> bool:
    constraints = nlu_result.get("constraints") or {}

    if constraints.get("need_gpu"):
        return True

    gpu_majors = [
        "design_multimedia",
        "architecture_construction",
        "engineering",
        "gaming",
        "ai_data_heavy",
    ]

    majors = nlu_result.get("majors_or_needs") or []
    return any(major in gpu_majors for major in majors)


def get_min_ram(nlu_result: dict):
    if nlu_result.get("ram"):
        return nlu_result["ram"]

    majors = nlu_result.get("majors_or_needs") or []

    if "ai_data_heavy" in majors:
        return 32

    if any(
        major in majors
        for major in [
            "it_programming",
            "design_multimedia",
            "architecture_construction",
            "engineering",
            "gaming",
            "accounting_finance",
            "marketing_content",
            "office",
        ]
    ):
        return 16

    return 16


# =========================================================
# Follow-up có hỗ trợ discount
# =========================================================

def analyze_follow_up(user_message: str, messages: list, last_products: list) -> dict:
    history_text = ""

    for msg in messages[-8:]:
        role = "Khách" if isinstance(msg, HumanMessage) else "AI"
        history_text += f"{role}: {msg.content}\n"

    products_text = build_product_context_for_follow_up(last_products)

    prompt = f"""
Bạn là AI hỗ trợ phân tích hội thoại cho hệ thống tư vấn bán laptop.

LỊCH SỬ HỘI THOẠI GẦN ĐÂY:
{history_text}

DANH SÁCH SẢN PHẨM ĐÃ ĐỀ XUẤT Ở LƯỢT TRƯỚC:
{products_text}

TIN NHẮN MỚI NHẤT CỦA KHÁCH:
"{user_message}"

Nhiệm vụ:
1. Viết lại tin nhắn mới nhất thành một câu hỏi độc lập, đầy đủ ngữ cảnh bằng tiếng Việt.
2. Nếu khách đang hỏi tiếp về sản phẩm trong danh sách trên, hãy xác định số thứ tự sản phẩm đó.
3. Nếu khách hỏi về giá, giảm giá, mã khuyến mãi, giá sau giảm, tồn kho hoặc bảo hành của sản phẩm được nhắc tới, contextualized_query phải giữ rõ các thông tin đó.
4. Nếu khách nói "cái thứ 1", "máy thứ 2", "con thứ ba", "mẫu Dell", "mẫu Akko", "con rẻ hơn", "máy đang giảm giá" thì phải cố gắng ánh xạ về sản phẩm trong danh sách.
5. Nếu không xác định được sản phẩm cụ thể, referred_index là null.

Chỉ trả về JSON duy nhất, không viết thêm giải thích.

Format:
{{
  "contextualized_query": "câu hỏi đã viết lại đầy đủ ngữ cảnh",
  "referred_index": 1 hoặc null
}}
"""

    try:
        response = llm.invoke(prompt)
        content = response.content.strip()

        if "{" in content and "}" in content:
            start = content.find("{")
            end = content.rfind("}") + 1
            json_str = content[start:end]

            res = json.loads(json_str)

            return {
                "contextualized_query": res.get("contextualized_query", user_message),
                "referred_index": res.get("referred_index"),
            }

    except Exception as e:
        print(f"Error in analyze_follow_up: {e}")

    return {
        "contextualized_query": user_message,
        "referred_index": None,
    }


def answer_specific_product_question(product: dict, user_message: str) -> str:
    text = normalize_text(user_message)
    product_name = get_value(product, "ProductName", "product_name", default="sản phẩm này")
    variant_name = get_value(product, "VariantName", "variant_name", default="")
    display_name = product_name

    if variant_name and variant_name.lower() not in product_name.lower():
        display_name = f"{product_name} - {variant_name}"

    stock = get_value(product, "StockQuantity", "Stock", "available_quantity", default=0)
    warranty = get_value(product, "WarrantyMonths", "warranty_period", default="chưa rõ")

    wants_discount = any(word in text for word in ["giảm", "khuyến mãi", "sale", "mã", "voucher"])
    wants_price = any(word in text for word in ["giá", "bao nhiêu", "nhiêu tiền"])
    wants_stock = any(word in text for word in ["còn hàng", "tồn kho", "còn không", "có hàng"])
    wants_warranty = any(word in text for word in ["bảo hành", "warranty"])

    if wants_discount or wants_price:
        if is_on_sale_product(product):
            return (
                f"{display_name} hiện đang có khuyến mãi.\n"
                f"Giá gốc: {format_money(get_original_price(product))}\n"
                f"Giá sau giảm: {format_money(get_final_price(product))}\n"
                f"Ưu đãi: {build_sale_text(product)}"
            )

        return (
            f"{display_name} hiện chưa có khuyến mãi đang áp dụng.\n"
            f"Giá hiện tại: {format_money(get_original_price(product))}"
        )

    if wants_stock:
        stock_num = to_float(stock)
        stock_text = "còn hàng" if stock_num > 0 else "hết hàng hoặc chưa có tồn kho"
        return f"{display_name} hiện {stock_text}. Số lượng tồn kho: {int(stock_num) if stock_num.is_integer() else stock}."

    if wants_warranty:
        return f"{display_name} có thời gian bảo hành: {warranty} tháng."

    return build_product_line(1, product).strip()


# =========================================================
# Cách 1: Phân tích NLU bằng Local LLM tối ưu (JSON Mode)
# =========================================================

def analyze_with_llm_optimized(text: str) -> dict:
    prompt = f"""
Bạn là một AI phân tích NLU tiếng Việt cho hệ thống chatbot tư vấn cửa hàng laptop.
Nhiệm vụ của bạn là trích xuất intent (ý định) và các thực thể (entities) từ câu hỏi của khách hàng.

Hãy trả về duy nhất một đối tượng JSON có cấu trúc sau:
{{
  "intent": "laptop_advice" | "compare_laptop" | "warranty_policy" | "installment_policy" | "delivery_policy" | "greeting" | "out_of_scope" | "unknown" (Dùng 'greeting' cho các câu chào xã giao ngắn như: alo, chào shop, hi, hello, ad ơi...),
  "budget": con số ngân sách bằng VNĐ (kiểu số nguyên, ví dụ 30000000) hoặc null nếu không nhắc tới,
  "brand": tên hãng laptop (chữ thường, ví dụ: "dell", "asus", "hp") hoặc null nếu không có,
  "majors_or_needs": danh sách các nhu cầu học tập/làm việc (ví dụ: ["it_programming", "gaming", "design_multimedia"]) hoặc mảng rỗng [],
  "ram": dung lượng RAM yêu cầu (ví dụ: 16, 32) hoặc null,
  "storage_gb": dung lượng ổ cứng yêu cầu (ví dụ: 512, 1024) hoặc null,
  "constraints": {{
    "need_lightweight": true/false (nếu khách cần máy mỏng nhẹ hoặc dễ mang đi học/đi làm),
    "need_battery": true/false (nếu khách cần pin lâu, pin tốt),
    "need_screen_quality": true/false (nếu khách cần màn hình đẹp, OLED, IPS, chuẩn màu),
    "need_gpu": true/false (nếu khách cần card rời, thiết kế đồ họa, game nặng hoặc học AI)
  }}
}}

CÂU HỎI CỦA KHÁCH:
"{text}"

Chỉ trả về JSON hợp lệ, không giải thích gì thêm ngoài JSON.
"""
    try:
        response = llm_nlu.invoke([HumanMessage(content=prompt)])
        content = response.content.strip()

        if "{" in content and "}" in content:
            start = content.find("{")
            end = content.rfind("}") + 1
            json_str = content[start:end]
            res = json.loads(json_str)
            res["raw_text"] = text

            if "constraints" not in res:
                res["constraints"] = {
                    "need_lightweight": False,
                    "need_battery": False,
                    "need_screen_quality": False,
                    "need_gpu": False
                }
            return res
    except Exception as e:
        print(f"Lỗi khi phân tích NLU bằng LLM: {e}")

    # Fallback mặc định
    return {
        "raw_text": text,
        "intent": "unknown",
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
        }
    }


# =========================================================
# Node chính
# =========================================================

def laptop_advisor_node(state: AgentState):
    session_id = state.get("session_id", "default_session")
    user_message = state["messages"][-1].content

    # 0. Chặn prompt injection / secret request trước khi làm bất cứ việc gì
    if is_dangerous_request(user_message):
        return {
            "messages": [AIMessage(content=get_security_refusal())]
        }

    # 1. Giải quyết câu hỏi nối tiếp nếu có lịch sử
    has_history = len(state["messages"]) > 1

    if has_history:
        last_products = get_last_products(session_id)
        follow_up = analyze_follow_up(user_message, state["messages"][:-1], last_products)
        query_to_analyze = follow_up.get("contextualized_query") or user_message
        referred_index = follow_up.get("referred_index")
    else:
        last_products = get_last_products(session_id)
        query_to_analyze = user_message
        referred_index = None

    if is_dangerous_request(query_to_analyze):
        return {
            "messages": [AIMessage(content=get_security_refusal())]
        }

    # 2. Nếu khách hỏi tiếp về sản phẩm đã tư vấn trước đó
    if referred_index is not None and last_products:
        try:
            referred_index_int = int(referred_index)
        except Exception:
            referred_index_int = None

        if referred_index_int is not None and 1 <= referred_index_int <= len(last_products):
            product = last_products[referred_index_int - 1]
            answer = answer_specific_product_question(product, query_to_analyze)
            return {
                "messages": [AIMessage(content=answer)]
            }

    # 3. Nếu khách hỏi tên sản phẩm cụ thể: "Shop có bán Akko không?"
    if is_product_lookup_question(query_to_analyze):
        keyword = extract_product_keyword(query_to_analyze)

        if len(keyword) >= 2:
            matched_products = find_products_by_name(keyword, limit=5)
        else:
            matched_products = []

        if not matched_products:
            return {
                "messages": [
                    AIMessage(
                        content=(
                            f"Shop chưa tìm thấy sản phẩm phù hợp với từ khóa \"{keyword}\". "
                            "Bạn có thể gửi tên sản phẩm cụ thể hơn, mã máy, hãng hoặc một phần tên sản phẩm để mình kiểm tra lại nhé."
                        )
                    )
                ]
            }

        set_last_products(session_id, matched_products)

        lines = [
            f"Shop tìm thấy {len(matched_products)} sản phẩm liên quan đến \"{keyword}\":"
        ]

        for idx, product in enumerate(matched_products, start=1):
            lines.append(build_product_line(idx, product))

        return {
            "messages": [AIMessage(content="\n".join(lines))]
        }

    # 4. spaCy NLU bóc tách câu hỏi tư vấn
    nlu_result = analyze_with_spacy(query_to_analyze)

    # =========================================================
    # ÁP DỤNG CÁCH 1: FALLBACK ROUTER
    # Nếu SpaCy trả về intent "unknown", gọi Local LLM để trích xuất thay thế
    # =========================================================
    if nlu_result.get("intent") == "unknown":
        print(f"\n[FALLBACK TRIGGERED] SpaCy không nhận diện được. Gọi Local LLM NLU cho câu hỏi: '{query_to_analyze}'")
        llm_nlu_result = analyze_with_llm_optimized(query_to_analyze)
        if llm_nlu_result and llm_nlu_result.get("intent") != "unknown":
            print(f"[FALLBACK SUCCESS] Local LLM nhận diện Intent: {llm_nlu_result.get('intent')}")
            nlu_result = llm_nlu_result

    # 5. Câu hỏi chính sách shop thì trả lời bằng rule, không gọi Qwen
    policy_answer = get_shop_policy_answer(nlu_result.get("intent"))
    if policy_answer:
        return {
            "messages": [AIMessage(content=policy_answer)]
        }

    # 6. Chặn câu hỏi ngoài phạm vi
    if not is_allowed_domain(nlu_result):
        return {
            "messages": [
                AIMessage(
                    content=(
                        "Xin lỗi, tôi chỉ hỗ trợ các câu hỏi liên quan đến shop bán laptop, "
                        "tư vấn mua laptop, phụ kiện, cấu hình máy, bảo hành, trả góp và giao hàng."
                    )
                )
            ]
        }

    # 7. Tìm sản phẩm laptop hoặc phụ kiện
    products = []
    product_type = "laptop"

    accessory_category = detect_accessory_category(query_to_analyze)

    if accessory_category:
        product_type = "accessory"
        products = search_accessories(
            category_keyword=accessory_category,
            brand=nlu_result.get("brand"),
            budget=nlu_result.get("budget"),
            limit=3,
        )
    else:
        products = search_laptops(
            budget=nlu_result.get("budget"),
            brand=nlu_result.get("brand"),
            need_gpu=should_need_gpu(nlu_result),
            min_ram=get_min_ram(nlu_result),
            limit=3,
        )

    set_last_products(session_id, products)

    # 8. Không tìm thấy sản phẩm
    if not products:
        return {
            "messages": [
                AIMessage(
                    content=(
                        "Hiện tại shop chưa tìm thấy sản phẩm phù hợp với yêu cầu này. "
                        "Bạn có thể cho mình biết thêm ngân sách, hãng mong muốn hoặc nhu cầu sử dụng cụ thể hơn không?"
                    )
                )
            ]
        }

    # 9. Đưa NLU + sản phẩm từ database cho Qwen diễn đạt
    nlu_text = json.dumps(nlu_result, ensure_ascii=False, indent=2, default=str)
    products_text = json.dumps(products, ensure_ascii=False, indent=2, default=str)

    system_prompt = SystemMessage(
        content=f"""
Bạn là AI tư vấn laptop và phụ kiện cho shop bán laptop tại Việt Nam.

DỮ LIỆU NLU:
{nlu_text}

LOẠI SẢN PHẨM:
{product_type}

DỮ LIỆU SẢN PHẨM TỪ CỬA HÀNG:
{products_text}

QUY TẮC BẮT BUỘC:
- Chỉ trả lời các câu hỏi liên quan đến laptop, phụ kiện và dịch vụ của shop.
- Chỉ được đề xuất sản phẩm có trong dữ liệu sản phẩm ở trên.
- Không được bịa thêm tên sản phẩm, giá, tồn kho, bảo hành hoặc khuyến mãi ngoài dữ liệu.
- Nếu sản phẩm có OriginalPrice, FinalPrice, IsOnSale, PromoCode, CampaignName, CampaignType, DiscountValue thì phải nêu rõ giá gốc, giá sau giảm và ưu đãi.
- Nếu không có khuyến mãi thì không được tự nói là đang giảm giá.
- Đề xuất tối đa 3 sản phẩm tốt nhất.
- Giải thích ngắn gọn vì sao phù hợp với nhu cầu khách.
- Trả lời bằng tiếng Việt, thân thiện, dễ hiểu.
- Không nhắc tới JSON, SQL, database nội bộ hay hệ thống backend.

GỢI Ý TƯ VẤN:
- Kế toán/tài chính/ngân hàng: ưu tiên Excel, RAM 16GB, SSD 512GB, không cần card rời.
- Marketing/content: ưu tiên RAM 16GB, màn hình đẹp; nếu edit video thì cân nhắc GPU rời.
- Luật/nhân văn/ngoại ngữ/y dược/sư phạm: ưu tiên máy nhẹ, pin tốt, màn hình dễ nhìn, bàn phím tốt.
- CNTT/lập trình: ưu tiên CPU khỏe, RAM 16GB hoặc 32GB nếu chạy Docker/máy ảo.
- Thiết kế/kiến trúc/kỹ thuật: ưu tiên RAM 16GB/32GB, SSD lớn, GPU rời nếu dùng phần mềm nặng.
- Gaming: ưu tiên GPU rời, RAM 16GB, màn hình tần số quét cao.
- AI local/data/lập trình nặng: ưu tiên RAM 32GB, SSD 1TB, GPU NVIDIA RTX nếu chạy AI local.
"""
    )

    response = llm.invoke([
        system_prompt,
        *state["messages"][-6:],
    ])

    safe_answer = sanitize_ai_output(response.content)

    return {
        "messages": [AIMessage(content=safe_answer)]
    }


# =========================================================
# Build LangGraph
# =========================================================

graph_builder = StateGraph(AgentState)

graph_builder.add_node("laptop_advisor", laptop_advisor_node)

graph_builder.add_edge(START, "laptop_advisor")
graph_builder.add_edge("laptop_advisor", END)

agent = graph_builder.compile()


# =========================================================
# Public functions cho app.py / test_agent.py
# =========================================================

def ask_ai(user_message: str) -> str:
    result = agent.invoke({
        "messages": [HumanMessage(content=user_message)],
        "session_id": "default_session",
    })

    return result["messages"][-1].content


def ask_ai_with_history(
    user_message: str = None,
    history=None,
    session_id: str = "default_session",
    **kwargs,
) -> str:
    # Cho phép app.py cũ gọi nhầm user_messages vẫn chạy.
    if user_message is None:
        user_message = kwargs.get("user_messages") or kwargs.get("message") or ""

    messages = []

    if history:
        for item in history[-9:]:
            role = item.get("role")
            content = item.get("content")

            if not content:
                continue

            if role == "user":
                messages.append(HumanMessage(content=content))
            elif role == "assistant":
                messages.append(AIMessage(content=content))

    messages.append(HumanMessage(content=user_message))

    result = agent.invoke({
        "messages": messages,
        "session_id": session_id,
    })

    return result["messages"][-1].content
