from collections import defaultdict    

MAX_MESSAGES_PER_SESSION = 10

chat_store = defaultdict(list)

def get_history(session_id: str) -> list:
    return chat_store[session_id][-MAX_MESSAGES_PER_SESSION:]
def add_message(session_id: str, role: str, content: str):
    chat_store[session_id].append({
        "role": role,
        "content": content
    })
    if len(chat_store[session_id]) > MAX_MESSAGES_PER_SESSION:
        chat_store[session_id] = chat_store[session_id][-MAX_MESSAGES_PER_SESSION:]
def clear_history(session_id: str):
    chat_store[session_id] = []
    last_products_store[session_id] = []

last_products_store = defaultdict(list)
current_products_store = defaultdict(list)

def get_last_products(session_id: str) -> list:
    return last_products_store[session_id]

def set_last_products(session_id: str, products: list):
    last_products_store[session_id] = products
    current_products_store[session_id] = products or []

def get_current_products(session_id: str) -> list:
    return current_products_store[session_id]

def set_current_products(session_id: str, products: list):
    current_products_store[session_id] = products or []