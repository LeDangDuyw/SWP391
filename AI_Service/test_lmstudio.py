import os
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

load_dotenv()
print("BASE URL =", os.getenv("LMSTUDIO_BASE_URL"))
print("MODEL =", os.getenv("LMSTUDIO_MODEL"))

llm = ChatOpenAI(
    model=os.getenv("LMSTUDIO_MODEL"),
    base_url=os.getenv("LMSTUDIO_BASE_URL"),
    api_key="lm-studio",
    temperature=0.2,
)

response = llm.invoke("Xin chào, hãy trả lời bằng tiếng Việt ngắn gọn.")

print(response.content)