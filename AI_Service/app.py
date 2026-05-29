from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from ai_agent import ask_ai
from spacy_nlu import analyze_with_spacy


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


@app.post("/chat")
def chat(request: ChatRequest):
    answer = ask_ai(request.message)

    return {
        "answer": answer,
        "session_id": request.session_id
    }