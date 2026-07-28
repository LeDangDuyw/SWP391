import os
import sys
import time
import json
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage
from spacy_nlu import analyze_with_spacy

# Đảm bảo in tiếng Việt không lỗi trên terminal Windows
sys.stdout.reconfigure(encoding='utf-8')

load_dotenv()


# Khởi tạo Local LLM để test NLU tối ưu
llm_nlu = ChatOpenAI(
    model=os.getenv("LMSTUDIO_MODEL"),
    base_url=os.getenv("LMSTUDIO_BASE_URL"),
    api_key="lm-studio",
    temperature=0.0,
    max_tokens=150,
)

# Danh sách các câu hỏi thử nghiệm đa dạng
TEST_QUERIES = [
    # 1. Câu hỏi tư vấn chuẩn (SpaCy bắt được ngay)
    "Em cần mua máy tính Asus khoảng 25 triệu để lập trình",
    
    # 2. Câu hỏi chính sách rõ ràng (SpaCy rẽ luồng nhanh)
    "Mua hàng ở shop thì bảo hành bao lâu thế ạ?",
    
    # 3. Câu hỏi phức tạp/ẩn ý (SpaCy trả về 'unknown' -> LLM NLU cứu cánh)
    "Em có ngân sách tầm 3 chục củ, muốn kiếm con máy mỏng nhẹ, pin trâu để đi công tác thường xuyên",
    
    # 4. Câu hỏi ngoài phạm vi (Out of scope)
    "Cho em hỏi tối nay có trận bóng đá nào hay không?",
    
    # 5. Câu hỏi có cấu hình phức tạp (SpaCy bắt được một phần, LLM bắt trọn)
    "Tìm cho anh laptop HP RAM 32GB có card rời tầm giá dưới 40tr"
]

# =========================================================
# Định nghĩa các phương pháp phân tích NLU
# =========================================================

# --- PHƯƠNG PHÁP A: SpaCy NLU (Rule-based) ---
def run_spacy_nlu(query: str):
    start_time = time.time()
    result = analyze_with_spacy(query)
    latency = (time.time() - start_time) * 1000 # ms
    return result, latency


# --- PHƯƠNG PHÁP B: Optimized LLM NLU (Local LLM qua API) ---
def analyze_with_llm_optimized(text: str) -> dict:
    prompt = f"""
Bạn là một AI phân tích NLU tiếng Việt cho hệ thống chatbot tư vấn cửa hàng laptop.
Nhiệm vụ của bạn là trích xuất intent (ý định) và các thực thể (entities) từ câu hỏi của khách hàng.

Hãy trả về duy nhất một đối tượng JSON có cấu trúc sau:
{{
  "intent": "laptop_advice" | "compare_laptop" | "warranty_policy" | "installment_policy" | "delivery_policy" | "out_of_scope" | "unknown",
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
            return json.loads(json_str)
    except Exception as e:
        print(f"\n[LLM ERROR] {e}")
    
    return {"intent": "unknown", "budget": None, "brand": None, "majors_or_needs": [], "constraints": {}}

def run_llm_nlu(query: str):
    start_time = time.time()
    result = analyze_with_llm_optimized(query)
    latency = (time.time() - start_time) * 1000 # ms
    return result, latency


# --- CÁCH 1: Fallback Router (SpaCy -> LLM NLU) ---
def run_fallback_router(query: str):
    start_time = time.time()
    
    # Thử chạy SpaCy trước
    result = analyze_with_spacy(query)
    fallback_used = False
    
    # Nếu SpaCy không nhận diện được (intent unknown), gọi LLM cứu cánh
    if result.get("intent") == "unknown":
        fallback_used = True
        llm_res = analyze_with_llm_optimized(query)
        if llm_res and llm_res.get("intent") != "unknown":
            result.update(llm_res)
            # Giữ lại raw_text gốc
            result["raw_text"] = query
            
    latency = (time.time() - start_time) * 1000 # ms
    return result, latency, fallback_used


# --- CÁCH 2: BERT-based NLU (Sử dụng transformers local) ---
HAS_TRANSFORMERS = False
classifier = None

try:
    from transformers import pipeline
    HAS_TRANSFORMERS = True
    print("Đang tải mô hình BERT/mDeBERTa cho Cách 2 (lần đầu sẽ mất vài phút tải file)...")
    # Sử dụng mô hình mDeBERTa nhỏ (~500MB) tối ưu cho đa ngôn ngữ & tiếng Việt
    classifier = pipeline(
        "zero-shot-classification", 
        model="MoritzLaurer/mDeBERTa-v3-base-xnli-multilingual-nli-2ep"
    )
except ImportError:
    pass

def run_bert_nlu(query: str):
    if not HAS_TRANSFORMERS or classifier is None:
        return {"error": "Chưa cài đặt thư viện 'transformers' và 'torch'"}, 0.0
    
    start_time = time.time()
    
    candidate_labels = [
        "tư vấn laptop", 
        "so sánh laptop", 
        "chính sách bảo hành", 
        "chính sách trả góp", 
        "chính sách giao hàng", 
        "ngoài phạm vi"
    ]
    
    label_to_intent = {
        "tư vấn laptop": "laptop_advice",
        "so sánh laptop": "compare_laptop",
        "chính sách bảo hành": "warranty_policy",
        "chính sách trả góp": "installment_policy",
        "chính sách giao hàng": "delivery_policy",
        "ngoài phạm vi": "out_of_scope"
    }
    
    res = classifier(query, candidate_labels, hypothesis_template="Đây là câu hỏi liên quan đến {}")
    top_label = res["labels"][0]
    score = res["scores"][0]
    
    intent = label_to_intent.get(top_label, "unknown")
    
    latency = (time.time() - start_time) * 1000
    
    return {
        "intent": intent,
        "confidence": round(score, 3),
        "raw_label": top_label
    }, latency


# =========================================================
# Chạy chương trình thử nghiệm
# =========================================================
if __name__ == "__main__":
    print("=" * 100)
    print("BẮT ĐẦU CHẠY KIỂM THỬ VÀ SO SÁNH CÁC PHƯƠNG PHÁP NLU LOCAL")
    print("=" * 100)
    
    for i, query in enumerate(TEST_QUERIES, start=1):
        print(f"\n👉 CÂU HỎI {i}: '{query}'")
        print("-" * 50)
        
        # 1. Test SpaCy NLU
        spacy_res, spacy_time = run_spacy_nlu(query)
        print(f"| [SpaCy NLU]       | Intent: {spacy_res.get('intent'):<18} | Time: {spacy_time:7.2f} ms | Brand: {str(spacy_res.get('brand')):<6} | Budget: {str(spacy_res.get('budget')):<10} |")
        
        # 2. Test Optimized LLM NLU
        llm_res, llm_time = run_llm_nlu(query)
        print(f"| [LLM NLU]         | Intent: {llm_res.get('intent'):<18} | Time: {llm_time:7.2f} ms | Brand: {str(llm_res.get('brand')):<6} | Budget: {str(llm_res.get('budget')):<10} |")
        
        # 3. Test Fallback Router (Cách 1)
        fallback_res, fallback_time, used = run_fallback_router(query)
        indicator = "💡 Dùng LLM" if used else "⚡ Chỉ SpaCy"
        print(f"| [Fallback Router] | Intent: {fallback_res.get('intent'):<18} | Time: {fallback_time:7.2f} ms | Luồng: {indicator:<10} |")
        
        # 4. Test BERT NLU (Cách 2)
        if HAS_TRANSFORMERS:
            bert_res, bert_time = run_bert_nlu(query)
            print(f"| [BERT NLU]        | Intent: {bert_res.get('intent'):<18} | Time: {bert_time:7.2f} ms | Conf:  {bert_res.get('confidence'):<10} |")
        else:
            print(f"| [BERT NLU]        | Nhãn: Chưa được cài đặt. Để test Cách 2 (BERT NLU), hãy chạy: 'pip install transformers torch'")

    print("\n" + "=" * 100)
    print("THỬ NGHIỆM HOÀN TẤT!")
    print("=" * 100)
