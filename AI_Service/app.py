from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from ai_agent import ask_ai_with_history

# from ai_agent_fallback import ask_ai_with_history
from chat_memory import get_history, add_message, clear_history, set_current_products, get_current_products
from spacy_nlu import analyze_with_spacy
from security_guard import is_dangerous_request, get_security_refusal, check_safety_with_llm


app = FastAPI(
    title="Laptop Shop AI Chatbot",
    description="Local AI chatbot tư vấn laptop và phụ kiện cho shop",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ChatRequest(BaseModel):
    message: str
    session_id: str | None = None
    user_id: int | None = None


@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": "Laptop Shop AI Chatbot"
    }


@app.post("/analyze")
def analyze(request: ChatRequest):
    nlu_result = analyze_with_spacy(request.message)

    return {
        "message": request.message,
        "nlu": nlu_result
    }
@app.post("/clear_history")
def clear_chat_history(request: ChatRequest):
    session_id = request.session_id or "default_session"
    clear_history(session_id)

    return {
        "status": "cleared", 
        "session_id": session_id
    }

@app.post("/chat")
def chat(request: ChatRequest):
    session_id = request.session_id or "default_session"
    
    # 1. Kiểm tra an ninh nhanh bằng Regex (0ms)
    if is_dangerous_request(request.message):
        return {
            "answer": get_security_refusal(),
            "session_id": session_id,
            "products": [],
            "is_violation": True,
            "violation_type": "KEYWORDS_ATTEMPT"
        }
        
    # 2. Kiểm tra bảo mật bằng LLM phụ (Ollama Llama Guard)
    # Lọc phân tầng: chỉ gọi Ollama khi tin nhắn dài hơn 20 ký tự để tối ưu tốc độ
    if len(request.message) > 20:
        safety_check = check_safety_with_llm(request.message)
        if not safety_check["safe"]:
            violation_type = f"LLM_GUARD_{safety_check['category'].upper().replace(' ', '_')}" if safety_check['category'] else "LLM_GUARD_VIOLATION"
            return {
                "answer": get_security_refusal(),
                "session_id": session_id,
                "products": [],
                "is_violation": True,
                "violation_type": violation_type
            }

    # 3. Nếu tin nhắn an toàn, chạy Agent chính tư vấn sản phẩm
    set_current_products(session_id, [])
    history = get_history(session_id)
    answer = ask_ai_with_history(user_messages=request.message, history=history, session_id=session_id)

    # Kiểm tra xem câu trả lời của AI có bị bộ lọc an ninh sanitize hay không
    refusal_msg = get_security_refusal()
    is_violation = (answer == refusal_msg)
    violation_type = "OUTPUT_SENSITIVE_LEAK" if is_violation else None

    add_message(session_id, "user", request.message)
    add_message(session_id, "assistant", answer)

    products = get_current_products(session_id)

    return {
        "answer": answer,
        "session_id": session_id,
        "products": products,
        "is_violation": is_violation,
        "violation_type": violation_type
    }