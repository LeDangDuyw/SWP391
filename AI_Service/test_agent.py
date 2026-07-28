import sys
from ai_agent import ask_ai_with_history

# Đảm bảo in tiếng Việt không lỗi trên terminal Windows
sys.stdout.reconfigure(encoding='utf-8')

print("=" * 80)
print("BẮT ĐẦU CHẠY THỬ NGHIỆM AI AGENT VỚI 3 CÂU HỎI LIÊN TIẾP")
print("=" * 80)

# Kịch bản 3 câu hỏi liên quan đến nhau
conversation_flow = [
    "Em học lập trình tầm 30 triệu cần laptop nào mạnh mẽ nhất?",
    "vậy nói rõ hơn về máy tính 1",
    "nó có được trả góp không?"
]

session_id = "test_agent_session_consecutive"
history = []

for index, question in enumerate(conversation_flow, start=1):
    print("-" * 80)
    print(f"LƯỢT {index}")
    print(f"USER: {question}")
    
    # Gọi AI với lịch sử hội thoại hiện tại
    answer = ask_ai_with_history(question, history=history, session_id=session_id)
    print(f"AI: {answer}")
    
    # Lưu lại lượt hội thoại vào lịch sử
    history.append({"role": "user", "content": question})
    history.append({"role": "assistant", "content": answer})

print("=" * 80)
print("THỬ NGHIỆM HOÀN TẤT VỚI KẾT QUẢ THÀNH CÔNG!")
print("=" * 80)