import json
import os
CORRECTIONS_FILE = "c:/Users/NC/laptop-ai/data/corrections.json"
TRAINING_MODE_FILE = "c:/Users/NC/laptop-ai/data/training_mode.txt"
SFT_DATASET_FILE = "c:/Users/NC/laptop-ai/data/laptop_advisor_sft_200.jsonl"
def is_training_mode_on() -> bool:
    """Kiểm tra chế độ ghi dữ liệu train đang Bật hay Tắt."""
    if not os.path.exists(TRAINING_MODE_FILE):
        return False
    with open(TRAINING_MODE_FILE, "r", encoding="utf-8") as f:
        return f.read().strip() == "ON"
def set_training_mode(status: str):
    """Bật (ON) hoặc Tắt (OFF) chế độ ghi dữ liệu train."""
    os.makedirs(os.path.dirname(TRAINING_MODE_FILE), exist_ok=True)
    with open(TRAINING_MODE_FILE, "w", encoding="utf-8") as f:
        f.write(status)
def append_to_sft_dataset(query: str, answer: str):
    """Ghi nhận câu hội thoại chuẩn vào tệp dataset SFT (.jsonl) phục vụ train offline."""
    os.makedirs(os.path.dirname(SFT_DATASET_FILE), exist_ok=True)
    data = {
        "messages": [
            {"role": "system", "content": "Bạn là AI tư vấn laptop cho shop bán laptop tại Việt Nam."},
            {"role": "user", "content": query},
            {"role": "assistant", "content": answer}
        ]
    }
    with open(SFT_DATASET_FILE, "a", encoding="utf-8") as f:
        f.write(json.dumps(data, ensure_ascii=False) + "\n")
def save_correction(user_query: str, correct_answer: str):
    """Lưu câu sửa lỗi của Admin vào file JSON để học tức thì."""
    corrections = []
    os.makedirs(os.path.dirname(CORRECTIONS_FILE), exist_ok=True)
    if os.path.exists(CORRECTIONS_FILE):
        try:
            with open(CORRECTIONS_FILE, "r", encoding="utf-8") as f:
                corrections = json.load(f)
        except:
            pass
    # Thêm câu sửa mới lên đầu
    corrections.insert(0, {
        "user_query": user_query.lower().strip(),
        "correct_answer": correct_answer.strip()
    })
    with open(CORRECTIONS_FILE, "w", encoding="utf-8") as f:
        json.dump(corrections, f, ensure_ascii=False, indent=2)
def get_corrections_prompt() -> str:
    """Tạo prompt chứa danh sách các câu đã được sửa lỗi để đưa vào ngữ cảnh của AI."""
    if not os.path.exists(CORRECTIONS_FILE):
        return ""
    try:
        with open(CORRECTIONS_FILE, "r", encoding="utf-8") as f:
            corrections = json.load(f)
        if not corrections:
            return ""
        prompt = "\nLƯU Ý QUAN TRỌNG (ƯU TIÊN): Dưới đây là các câu trả lời bạn ĐÃ ĐƯỢC ADMIN SỬA LỖI. Hãy ưu tiên trả lời giống hệt như thế này nếu khách hỏi câu tương tự:\n"
        for item in corrections[:10]: # Lấy tối đa 10 quy tắc gần nhất để tránh loãng prompt
            prompt += f"- Câu hỏi: '{item['user_query']}' -> Trả lời chuẩn: '{item['correct_answer']}'\n"
        return prompt
    except:
        return ""
def handle_admin_command(user_message: str, history) -> str | None:
    """Xử lý các lệnh cấu hình của Admin. Trả về kết quả phản hồi nếu là lệnh, trả về None nếu là tin nhắn chat thường."""
    msg = user_message.strip()
    
    # 1. Lệnh bật/tắt chế độ Train
    if msg.lower() == "/train on":
        set_training_mode("ON")
        return "Chế độ huấn luyện & thu thập dữ liệu SFT đã BẬT. Tất cả đoạn chat sửa lỗi sẽ được ghi nhận vào dataset."
    
    if msg.lower() == "/train off":
        set_training_mode("OFF")
        return "Chế độ huấn luyện & thu thập dữ liệu SFT đã TẮT."
    # 2. Lệnh sửa lỗi câu trả lời
    if msg.lower().startswith("/day "):
        correct_answer = msg[5:].strip()
        
        # Tìm câu hỏi cuối cùng của user từ lịch sử để đối chiếu sửa lỗi
        last_user_query = ""
        if history:
            for item in reversed(history):
                # Định dạng lịch sử có thể là dict {"role": "user", "content": "..."}
                # Hoặc đối tượng tin nhắn của LangGraph
                role = getattr(item, "type", item.get("role", ""))
                content = getattr(item, "content", item.get("content", ""))
                
                if role == "user" or role == "human":
                    last_user_query = content
                    break
                    
        if last_user_query:
            save_correction(last_user_query, correct_answer)
            
            # Nếu đang bật chế độ train, ghi nhận vào file .jsonl luôn
            if is_training_mode_on():
                append_to_sft_dataset(last_user_query, correct_answer)
                
            return f"Dạ, em đã nhớ! Từ giờ nếu khách hỏi '{last_user_query}', em sẽ trả lời: '{correct_answer}'."
        return "Không tìm thấy câu hỏi trước đó trong lịch sử để áp dụng bài học."
        
    return None