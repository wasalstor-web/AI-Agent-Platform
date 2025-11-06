"""
Simple DL+ API Server
A simplified version of the DL+ system for quick deployment
نسخة مبسطة من نظام DL+ للنشر السريع
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
import uvicorn

app = FastAPI(
    title="DL+ Intelligence System",
    description="Simplified DL+ API for AI Agent Platform",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "DL+ Intelligence System",
        "version": "1.0.0",
        "status": "operational",
        "author": "خليف 'ذيبان' العنزي"
    }

@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "service": "DL+ Intelligence System"
    }

@app.get("/api/status")
async def get_status():
    """Get system status"""
    return {
        "status": "operational",
        "system": "DL+ Intelligence System",
        "capabilities": [
            "Arabic Language Processing",
            "Context Analysis",
            "Code Generation",
            "Web Retrieval",
            "Advanced Reasoning"
        ],
        "models": [
            "gpt-3.5-turbo",
            "gpt-4",
            "claude-3",
            "llama-3",
            "qwen-arabic",
            "arabert",
            "mistral",
            "deepseek"
        ],
        "timestamp": datetime.now().isoformat()
    }

@app.post("/api/process")
async def process_request(request: dict):
    """Process AI requests"""
    command = request.get("command", "")
    context = request.get("context", {})
    
    return {
        "success": True,
        "response": f"DL+ System processed: {command}",
        "system": "DL+ Intelligence System",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/docs")
async def custom_docs():
    """Redirect to interactive API documentation"""
    return {
        "message": "Visit /docs for interactive API documentation",
        "docs_url": "/docs",
        "redoc_url": "/redoc"
    }

if __name__ == "__main__":
    print("=" * 70)
    print("🧠 DL+ Intelligence System - Simple Server")
    print("نظام DL+ للذكاء الصناعي - خادم مبسط")
    print("=" * 70)
    print("")
    print("Starting server on http://0.0.0.0:8000")
    print("")
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        log_level="info"
    )
