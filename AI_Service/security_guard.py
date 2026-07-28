import re
import unicodedata


def remove_accents(text: str) -> str:
    text = unicodedata.normalize("NFD", text)
    text = "".join(ch for ch in text if unicodedata.category(ch) != "Mn")
    text = text.replace("đ", "d").replace("Đ", "D")
    return text


def normalize_text(text: str) -> str:
    text = text.lower()
    text = remove_accents(text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


# Những cụm được phép xuất hiện vì đây là nhu cầu học/làm laptop hợp lệ
SAFE_TECH_TERMS = [
    "sql server",
    "netbeans",
    "tomcat",
    "visual studio",
    "vs code",
    "docker",
    "may ao",
    "machine learning",
    "ai local",
    "data science",
    "power bi",
]


def contains_safe_tech_context(text: str) -> bool:
    text_norm = normalize_text(text)
    return any(term in text_norm for term in SAFE_TECH_TERMS)


def is_prompt_injection(text: str) -> bool:
    text_norm = normalize_text(text)

    injection_patterns = [
        "bo qua luat",
        "bo qua huong dan",
        "bo qua cac phuong phap bao ve",
        "ignore previous",
        "ignore all",
        "ignore instructions",
        "jailbreak",
        "disable protection",
        "system prompt",
        "developer message",
        "hidden instruction",
        "ban la ai",
        "prompt goc",
        "dong vai",
        "tuong tuong",
        "tuong tuong ban la",
        "hacker",
        "roleplay",
        "pretend to be",
        "act as",
    ]

    return any(pattern in text_norm for pattern in injection_patterns)


def is_secret_request(text: str) -> bool:
    text_norm = normalize_text(text)

    secret_patterns = [
        ".env",
        "env file",
        "api key",
        "apikey",
        "secret",
        "token",
        "password",
        "mat khau",
        "connection string",
        "chuoi ket noi",
        "database connection string",
        "db_user",
        "db_password",
        "db_server",
        "jdbc",
        "odbc",
        "lay mat khau",
        "cho toi mat khau",
        "cho xem mat khau",
        "mat khau admin",
        "admin password",
    ]

    return any(pattern in text_norm for pattern in secret_patterns)


def is_internal_data_request(text: str) -> bool:
    text_norm = normalize_text(text)

    dangerous_patterns = [
        "truy cap database",
        "truy cap co so du lieu",
        "lay database",
        "dump database",
        "in ra database",
        "lay toan bo database",
        "database cua hang",
        "co so du lieu cua hang",
        "du lieu cua hang",
        "du lieu he thong",
        "select * from",
        "bang user",
        "bang admin",
        "thong tin khach hang",
        "don hang cua nguoi khac",
        "ma nguon",
        "source code",
        "server config",
        "cau hinh server",
        "file he thong",
        "doc file server",
        "xoa database",
        "drop table",
        "delete from",
        "show tables",
        "danh sach user",
        "danh sach khach hang",
        "danh sach admin",
    ]

    return any(pattern in text_norm for pattern in dangerous_patterns)


def is_dangerous_request(user_text: str) -> bool:
    text_norm = normalize_text(user_text)

    # Nếu người dùng hỏi nhu cầu học IT như SQL Server/NetBeans/Docker thì không chặn
    if contains_safe_tech_context(text_norm):
        # Nhưng nếu cùng lúc có yêu cầu lấy secret thì vẫn chặn
        if is_secret_request(text_norm) or is_prompt_injection(text_norm) or is_internal_data_request(text_norm):
            return True
        return False

    if is_prompt_injection(text_norm):
        return True

    if is_secret_request(text_norm):
        return True

    if is_internal_data_request(text_norm):
        return True

    return False


def get_security_refusal() -> str:
    return (
        "Xin lỗi, tôi không thể hỗ trợ yêu cầu truy cập dữ liệu hệ thống, "
        "cấu hình server, connection string, mã nguồn, database nội bộ hoặc thông tin riêng tư. "
        "Tôi chỉ có thể hỗ trợ tư vấn laptop, phụ kiện và các chính sách công khai của shop."
    )


def sanitize_ai_output(answer: str) -> str:
    text_norm = normalize_text(answer)

    sensitive_output_patterns = [
        ".env",
        "lmstudio_base_url",
        "lmstudio_model",
        "db_driver",
        "db_server",
        "db_name",
        "db_user",
        "db_password",
        "connection string",
        "trusted_connection",
        "trustservercertificate",
        "uid=",
        "pwd=",
        "server=",
        "database=",
        "jdbc:",
        "odbc",
    ]

    for pattern in sensitive_output_patterns:
        if pattern in text_norm:
            return get_security_refusal()

    return answer


def check_safety_with_llm(user_message: str) -> dict:
    """
    Sử dụng Llama Guard 3 qua Ollama để phân loại tính an toàn của tin nhắn.
    Tự động hỗ trợ kết nối qua host.docker.internal (Docker) và localhost.
    Trả về dict: {"safe": True/False, "category": "..."}
    """
    import os
    import requests
    
    SECURITY_MODEL = "llama-guard3:1b"
    ollama_host = os.getenv("OLLAMA_BASE_URL", "http://host.docker.internal:11434")
    
    urls_to_try = [
        f"{ollama_host.rstrip('/')}/v1/chat/completions",
        "http://localhost:11434/v1/chat/completions"
    ]
    
    payload = {
        "model": SECURITY_MODEL,
        "messages": [
            {"role": "user", "content": user_message}
        ],
        "temperature": 0.0
    }
    
    for url in urls_to_try:
        try:
            response = requests.post(url, json=payload, timeout=3.0)
            if response.status_code == 200:
                result = response.json()
                content = result['choices'][0]['message']['content'].strip().lower()
                
                if "unsafe" in content:
                    lines = content.split('\n')
                    category = lines[1] if len(lines) > 1 else "Unknown violation"
                    return {"safe": False, "category": category}
                    
                return {"safe": True, "category": None}
        except Exception as e:
            continue
            
    return {"safe": True, "category": None}