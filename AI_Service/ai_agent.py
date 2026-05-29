import os
import json
from dotenv import load_dotenv

from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
from langgraph.graph import StateGraph, START, END, MessagesState
from security_guard import is_dangerous_request, get_security_refusal, sanitize_ai_output
from spacy_nlu import analyze_with_spacy, is_allowed_domain
from product_repository import search_laptops, search_accessories

load_dotenv()

llm = ChatOpenAI(
    model=os.getenv("LMSTUDIO_MODEL"),
    base_url=os.getenv("LMSTUDIO_BASE_URL"),
    api_key="lm-studio",
    temperature=0.1,
)


SHOP_POLICIES = {
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
    )
}


def get_shop_policy_answer(intent: str):
    return SHOP_POLICIES.get(intent)


def detect_accessory_category(user_message: str):
    text = user_message.lower()

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
        "sạc": ["sạc", "adapter", "charger"]
    }

    for category, keywords in accessory_keywords.items():
        if any(keyword in text for keyword in keywords):
            return category

    if "phụ kiện" in text:
        return "phụ kiện"

    return None


def should_need_gpu(nlu_result: dict) -> bool:
    if nlu_result["constraints"].get("need_gpu"):
        return True

    gpu_majors = [
        "design_multimedia",
        "architecture_construction",
        "engineering",
        "gaming",
        "ai_data_heavy"
    ]

    return any(major in gpu_majors for major in nlu_result["majors_or_needs"])


def get_min_ram(nlu_result: dict):
    if nlu_result.get("ram"):
        return nlu_result["ram"]

    majors = nlu_result["majors_or_needs"]

    if "ai_data_heavy" in majors:
        return 32

    if any(major in majors for major in [
        "it_programming",
        "design_multimedia",
        "architecture_construction",
        "engineering",
        "gaming",
        "accounting_finance",
        "marketing_content",
        "office"
    ]):
        return 16

    return 16


def laptop_advisor_node(state: MessagesState):
    user_message = state["messages"][-1].content
    if is_dangerous_request(user_message):
        return {
            "messages": [
                AIMessage(content=get_security_refusal())
            ]
        }

    # 1. spaCy NLU bóc tách câu hỏi
    nlu_result = analyze_with_spacy(user_message)

    # 2. Nếu là câu hỏi chính sách shop thì trả lời bằng rule, không gọi database
    policy_answer = get_shop_policy_answer(nlu_result["intent"])
    if policy_answer:
        return {
            "messages": [
                AIMessage(content=policy_answer)
            ]
        }

    # 3. Chặn câu hỏi ngoài phạm vi
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

    # 4. Xác định khách đang hỏi laptop hay phụ kiện
    accessory_category = detect_accessory_category(user_message)

    products = []
    product_type = "laptop"

    if accessory_category:
        product_type = "accessory"

        products = search_accessories(
            category_keyword=accessory_category,
            brand=nlu_result["brand"],
            budget=nlu_result["budget"],
            limit=5
        )

    else:
        products = search_laptops(
            budget=nlu_result["budget"],
            brand=nlu_result["brand"],
            need_gpu=should_need_gpu(nlu_result),
            min_ram=get_min_ram(nlu_result),
            limit=5
        )

    # 5. Nếu không tìm thấy sản phẩm thì trả lời an toàn
    if not products:
        return {
            "messages": [
                AIMessage(
                    content=(
                        "Hiện tại shop chưa tìm thấy sản phẩm phù hợp trong database với yêu cầu này. "
                        "Bạn có thể cho mình biết thêm ngân sách, hãng mong muốn hoặc nhu cầu sử dụng cụ thể hơn không?"
                    )
                )
            ]
        }

    # 6. Đưa NLU + sản phẩm từ database cho Qwen diễn đạt
    nlu_text = json.dumps(nlu_result, ensure_ascii=False, indent=2)
    products_text = json.dumps(products, ensure_ascii=False, indent=2)

    system_prompt = SystemMessage(
        content=f"""
Bạn là AI tư vấn laptop và phụ kiện cho shop bán laptop tại Việt Nam.

DỮ LIỆU NLU ĐÃ BÓC TÁCH:
{nlu_text}

LOẠI SẢN PHẨM ĐANG TƯ VẤN:
{product_type}

DỮ LIỆU SẢN PHẨM TÌM ĐƯỢC TỪ DATABASE:
{products_text}

QUY TẮC BẮT BUỘC:
- Chỉ trả lời các câu hỏi liên quan đến laptop, phụ kiện và dịch vụ của shop.
- Chỉ được đề xuất sản phẩm có trong DỮ LIỆU SẢN PHẨM TÌM ĐƯỢC TỪ DATABASE.
- Không được bịa thêm tên sản phẩm, giá, tồn kho, bảo hành hoặc khuyến mãi ngoài database.
- Nếu có sản phẩm phù hợp, hãy đề xuất 1-3 sản phẩm tốt nhất.
- Khi tư vấn, phải giải thích vì sao sản phẩm phù hợp với nhu cầu khách.
- Nếu khách hỏi laptop cho ngành học/nghề nghiệp, hãy giải thích theo nhu cầu thực tế của ngành đó.
- Nếu khách hỏi phụ kiện, hãy giải thích phụ kiện đó phù hợp với laptop/nhu cầu nào.
- Trả lời bằng tiếng Việt, ngắn gọn, thân thiện, dễ hiểu.
- Không nhắc tới JSON, SQL, database nội bộ hay hệ thống backend trong câu trả lời cho khách.

GỢI Ý TƯ VẤN THEO NHU CẦU:
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
        HumanMessage(content=user_message)
    ])
    safe_answer = sanitize_ai_output(response.content)


    return {
        "messages": [AIMessage(content=safe_answer)]
    }


graph_builder = StateGraph(MessagesState)

graph_builder.add_node("laptop_advisor", laptop_advisor_node)

graph_builder.add_edge(START, "laptop_advisor")
graph_builder.add_edge("laptop_advisor", END)

agent = graph_builder.compile()


def ask_ai(user_message: str) -> str:
    result = agent.invoke({
        "messages": [HumanMessage(content=user_message)]
    })

    return result["messages"][-1].content