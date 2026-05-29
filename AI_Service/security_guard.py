import re


DANGEROUS_PATTERNS = [
    # Prompt injection
    "bỏ qua",
    "bo qua",
    "ignore previous",
    "ignore all",
    "bỏ qua luật",
    "bo qua luat",
    "bỏ qua hướng dẫn",
    "bo qua huong dan",
    "disable protection",
    "jailbreak",
    "system prompt",
    "developer message",
    "hidden instruction",

    # Secrets / config
    ".env",
    "env file",
    "api key",
    "apikey",
    "secret",
    "token",
    "password",
    "mật khẩu",
    "mat khau",
    "connection string",
    "database connection",
    "chuỗi kết nối",
    "chuoi ket noi",
    "jdbc",
    "odbc",
    "db_user",
    "db_password",
    "db_server",

    # Server / database access
    "truy cập database",
    "truy cap database",
    "truy cập cơ sở dữ liệu",
    "truy cap co so du lieu",
    "dump database",
    "lấy database",
    "lay database",
    "in ra database",
    "select *",
    "bảng user",
    "bang user",
    "admin",
    "source code",
    "mã nguồn",
    "ma nguon",
    "server config",
    "cấu hình server",
    "cau hinh server",
]


SENSITIVE_OUTPUT_PATTERNS = [
    ".env",
    "LMSTUDIO_BASE_URL",
    "LMSTUDIO_MODEL",
    "DB_DRIVER",
    "DB_SERVER",
    "DB_NAME",
    "DB_USER",
    "DB_PASSWORD",
    "connection string",
    "Trusted_Connection",
    "TrustServerCertificate",
    "UID=",
    "PWD=",
    "SERVER=",
    "DATABASE=",
    "jdbc:",
    "odbc",
    "sa",
]


def normalize_text(text: str) -> str:
    text = text.lower()
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def is_dangerous_request(user_text: str) -> bool:
    text = normalize_text(user_text)

    return any(pattern.lower() in text for pattern in DANGEROUS_PATTERNS)


def get_security_refusal() -> str:
    return (
        "Xin lỗi, tôi không thể hỗ trợ yêu cầu truy cập dữ liệu hệ thống, "
        "cấu hình server, connection string, mã nguồn, database nội bộ hoặc thông tin riêng tư. "
        "Tôi chỉ có thể hỗ trợ tư vấn laptop, phụ kiện và các chính sách công khai của shop."
    )


def sanitize_ai_output(answer: str) -> str:
    text = answer.lower()

    for pattern in SENSITIVE_OUTPUT_PATTERNS:
        if pattern.lower() in text:
            return get_security_refusal()

    return answer