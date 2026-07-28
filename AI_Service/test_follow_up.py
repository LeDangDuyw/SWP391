import sys
from ai_agent import ask_ai_with_history

# Đảm bảo mã hóa UTF-8 để in ra terminal Windows không bị lỗi
sys.stdout.reconfigure(encoding='utf-8')

session_id = "test_session_123"
history = []

print("=" * 80)
print("TESTING MULTI-TURN CONVERSATION WITH LMSTUDIO / QWEN 2.5-7B")
print("=" * 80)

# Lượt 1: Hỏi danh sách sản phẩm mạnh nhất
q1 = "máy tính nào là mạnh nhất tầm 30 triệu?"
print(f"\nUSER: {q1}")
a1 = ask_ai_with_history(q1, history=history, session_id=session_id)
print(f"AI: {a1}")

# Cập nhật lịch sử
history.append({"role": "user", "content": q1})
history.append({"role": "assistant", "content": a1})

# Lượt 2: Hỏi cụ thể về máy tính thứ 1
q2 = "vậy nói rõ hơn về máy tính 1"
print(f"\nUSER: {q2}")
a2 = ask_ai_with_history(q2, history=history, session_id=session_id)
print(f"AI: {a2}")

# Cập nhật lịch sử
history.append({"role": "user", "content": q2})
history.append({"role": "assistant", "content": a2})

# Lượt 3: Hỏi thêm chính sách trả góp của chiếc máy tính đó
q3 = "nó có được trả góp không?"
print(f"\nUSER: {q3}")
a3 = ask_ai_with_history(q3, history=history, session_id=session_id)
print(f"AI: {a3}")
print("=" * 80)
