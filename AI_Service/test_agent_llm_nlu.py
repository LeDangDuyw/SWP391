import sys
from ai_agent_llm_nlu import ask_ai_with_history

# Đảm bảo in tiếng Việt không lỗi trên terminal Windows
sys.stdout.reconfigure(encoding='utf-8')

print("=" * 80)
print("BẮT ĐẦU CHẠY THỬ NGHIỆM AI AGENT (PURE LLM NLU) VỚI CÁC CÂU HỎI LIÊN TIẾP")
print("=" * 80)

# Kịch bản hội thoại để thử nghiệm khả năng phân tích của Pure LLM NLU
conversation_flow = [
    # 1. Câu hỏi bình thường
    "Em học lập trình tầm 30 triệu cần laptop nào mạnh mẽ nhất?",
    
    # 2. Câu hỏi ngữ cảnh chỉ định
    "vậy nói rõ hơn về máy tính 1",
    
    # 3. Câu hỏi chính sách rõ ràng
    "tìm laptop màn hình full",
    
    # 4. Câu hỏi phức tạp/ẩn ý (Dịch từ "mười mấy củ" -> 10.000.000 - 19.000.000 VNĐ)
    "Anh muốn tìm thêm một con máy tầm mười mấy củ mỏng nhẹ thôi để mang đi học cho tiện"
]

session_id = "test_agent_llm_nlu_session"
history = []

for index, question in enumerate(conversation_flow, start=1):
    print("-" * 80)
    print(f"LƯỢT {index}")
    print(f"USER: {question}")
    
    # Gọi AI với lịch sử hội thoại hiện tại (dùng agent pure LLM NLU mới)
    answer = ask_ai_with_history(question, history=history, session_id=session_id)
    print(f"AI: {answer}")
    
    # Lưu lại lượt hội thoại vào lịch sử
    history.append({"role": "user", "content": question})
    history.append({"role": "assistant", "content": answer})

print("=" * 80)
print("THỬ NGHIỆM HOÀN TẤT VỚI KẾT QUẢ THÀNH CÔNG!")
print("=" * 80)
