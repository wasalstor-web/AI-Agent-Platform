#!/usr/bin/env python3
"""
OpenWebUI Integration Script
سكريبت دمج OpenWebUI

This script integrates OpenWebUI with the AI Agent Platform using
the provided API keys and JWT tokens.

المؤسس: خليف 'ذيبان' العنزي
الموقع: القصيم – بريدة – المملكة العربية السعودية
"""

import os
import json
import asyncio
import logging
from typing import Dict, Any, List
from fastapi import FastAPI, HTTPException, Request, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import httpx
from datetime import datetime
import uvicorn

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class OpenWebUIIntegration:
    """
    OpenWebUI Integration Manager
    مدير دمج OpenWebUI
    """
    
    def __init__(self):
        """Initialize the integration"""
        # API Credentials from problem statement
        self.jwt_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8"
        self.api_key = "sk-3720ccd539704717ba9af3453500fe3c"
        
        # OpenWebUI Configuration
        self.openwebui_url = os.getenv("OPENWEBUI_URL", "http://localhost:3000")
        self.webhook_base_url = os.getenv("WEBHOOK_BASE_URL", "https://wasalstor-web.github.io/AI-Agent-Platform")
        
        # Available open-source AI models
        self.available_models = [
            {
                "id": "llama-3-8b",
                "name": "LLaMA 3 8B",
                "provider": "Meta",
                "type": "open-source",
                "description": "Meta's LLaMA 3 model - general purpose",
                "enabled": True
            },
            {
                "id": "qwen-2.5-arabic",
                "name": "Qwen 2.5 Arabic",
                "provider": "Alibaba",
                "type": "open-source",
                "description": "Arabic language specialized model",
                "enabled": True
            },
            {
                "id": "arabert",
                "name": "AraBERT",
                "provider": "AUB",
                "type": "open-source",
                "description": "Arabic BERT for NLP tasks",
                "enabled": True
            },
            {
                "id": "mistral-7b",
                "name": "Mistral 7B",
                "provider": "Mistral AI",
                "type": "open-source",
                "description": "Efficient and powerful multilingual model",
                "enabled": True
            },
            {
                "id": "deepseek-coder",
                "name": "DeepSeek Coder",
                "provider": "DeepSeek",
                "type": "open-source",
                "description": "Specialized code generation model",
                "enabled": True
            },
            {
                "id": "phi-3-mini",
                "name": "Phi-3 Mini",
                "provider": "Microsoft",
                "type": "open-source",
                "description": "Compact but powerful model",
                "enabled": True
            }
        ]
        
        # Webhook endpoints
        self.webhook_endpoints = {
            "chat": f"{self.webhook_base_url}/webhook/chat",
            "model": f"{self.webhook_base_url}/webhook/model",
            "status": f"{self.webhook_base_url}/webhook/status"
        }
        
        logger.info("🔗 OpenWebUI Integration initialized")
        logger.info(f"📍 Webhook URL: {self.webhook_base_url}")
    
    def get_enabled_models(self) -> List[Dict[str, Any]]:
        """Get list of enabled models"""
        return [model for model in self.available_models if model['enabled']]
    
    async def authenticate_request(self, token: str) -> bool:
        """Authenticate request using JWT token"""
        return token == self.jwt_token
    
    async def validate_api_key(self, api_key: str) -> bool:
        """Validate API key"""
        return api_key == self.api_key
    
    async def process_chat_message(
        self, 
        message: str, 
        model_id: str, 
        context: Dict[str, Any] = None
    ) -> Dict[str, Any]:
        """
        Process chat message through selected model
        معالجة رسالة الدردشة عبر النموذج المحدد
        """
        try:
            # Find the model
            model = next(
                (m for m in self.available_models if m['id'] == model_id),
                None
            )
            
            if not model:
                return {
                    "success": False,
                    "error": f"Model {model_id} not found"
                }
            
            if not model['enabled']:
                return {
                    "success": False,
                    "error": f"Model {model_id} is not enabled"
                }
            
            # Process based on model type
            response = await self._generate_response(message, model, context)
            
            return {
                "success": True,
                "model": model['name'],
                "model_id": model_id,
                "response": response,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error processing chat message: {e}")
            return {
                "success": False,
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    async def _generate_response(
        self, 
        message: str, 
        model: Dict[str, Any],
        context: Dict[str, Any] = None
    ) -> str:
        """
        Generate response using the model
        توليد الاستجابة باستخدام النموذج
        """
        # Arabic language detection
        is_arabic = any(ord(char) >= 0x0600 and ord(char) <= 0x06FF for char in message)
        
        if is_arabic:
            response = f"""مرحباً! أنا نموذج {model['name']} وأنا جاهز لمساعدتك.

رسالتك: "{message}"

أنا نموذج ذكاء صناعي مفتوح المصدر من {model['provider']}، ومتخصص في {model['description']}.

في بيئة الإنتاج الكاملة، سأقوم بمعالجة طلبك بشكل متقدم باستخدام قدراتي في:
- فهم اللغة العربية الطبيعية
- توليد نصوص عالية الجودة
- الإجابة على الأسئلة المعقدة
- المساعدة في المهام المتنوعة

كيف يمكنني مساعدتك اليوم؟"""
        else:
            response = f"""Hello! I am {model['name']} and I'm ready to assist you.

Your message: "{message}"

I'm an open-source AI model from {model['provider']}, specialized in {model['description']}.

In full production environment, I will process your request with advanced capabilities including:
- Natural language understanding
- High-quality text generation
- Complex question answering
- Assistance with various tasks

How can I help you today?"""
        
        return response
    
    def get_webhook_info(self) -> Dict[str, Any]:
        """Get webhook configuration information"""
        return {
            "webhook_base_url": self.webhook_base_url,
            "endpoints": self.webhook_endpoints,
            "authentication": {
                "type": "JWT + API Key",
                "jwt_token_provided": bool(self.jwt_token),
                "api_key_provided": bool(self.api_key)
            },
            "models_enabled": len(self.get_enabled_models()),
            "status": "active"
        }


# Create FastAPI application
app = FastAPI(
    title="OpenWebUI Integration - AI Agent Platform",
    description="دمج OpenWebUI مع منصة الوكلاء الذكية",
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize integration
integration = OpenWebUIIntegration()


@app.get("/")
async def root():
    """Root endpoint with integration information"""
    return {
        "name": "OpenWebUI Integration",
        "description": "دمج OpenWebUI مع النماذج المفتوحة المصدر",
        "status": "active",
        "webhook_url": integration.webhook_base_url,
        "models_available": len(integration.get_enabled_models()),
        "endpoints": {
            "models": "/api/models",
            "chat": "/webhook/chat",
            "status": "/webhook/status",
            "info": "/webhook/info"
        },
        "documentation": "/api/docs"
    }


@app.get("/api/models")
async def list_models():
    """List available AI models"""
    models = integration.get_enabled_models()
    return {
        "success": True,
        "count": len(models),
        "models": models,
        "timestamp": datetime.now().isoformat()
    }


@app.post("/webhook/chat")
async def webhook_chat(
    request: Request,
    authorization: str = Header(None),
    x_api_key: str = Header(None)
):
    """
    Webhook endpoint for chat messages from OpenWebUI
    نقطة الاستقبال للرسائل من OpenWebUI
    """
    try:
        # Authenticate
        if authorization:
            token = authorization.replace("Bearer ", "")
            if not await integration.authenticate_request(token):
                raise HTTPException(status_code=401, detail="Invalid JWT token")
        
        if x_api_key:
            if not await integration.validate_api_key(x_api_key):
                raise HTTPException(status_code=401, detail="Invalid API key")
        
        # Get request data
        data = await request.json()
        message = data.get("message", "")
        model_id = data.get("model", "llama-3-8b")
        context = data.get("context", {})
        
        logger.info(f"📨 Received chat message: {message[:50]}...")
        
        # Process message
        result = await integration.process_chat_message(message, model_id, context)
        
        return JSONResponse(content=result)
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in webhook chat: {e}")
        return JSONResponse(
            status_code=500,
            content={
                "success": False,
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
        )


@app.get("/webhook/status")
async def webhook_status():
    """Webhook status endpoint"""
    return {
        "status": "operational",
        "integration": "openwebui",
        "models_enabled": len(integration.get_enabled_models()),
        "timestamp": datetime.now().isoformat()
    }


@app.get("/webhook/info")
async def webhook_info():
    """Get webhook configuration information"""
    return integration.get_webhook_info()


@app.post("/webhook/model")
async def webhook_model_action(
    request: Request,
    authorization: str = Header(None),
    x_api_key: str = Header(None)
):
    """
    Webhook for model management actions
    نقطة الاستقبال لإدارة النماذج
    """
    try:
        # Authenticate
        if authorization:
            token = authorization.replace("Bearer ", "")
            if not await integration.authenticate_request(token):
                raise HTTPException(status_code=401, detail="Invalid JWT token")
        
        # Get request data
        data = await request.json()
        action = data.get("action", "list")
        model_id = data.get("model_id")
        
        if action == "list":
            models = integration.get_enabled_models()
            return {"success": True, "models": models}
        
        elif action == "enable" and model_id:
            # Enable model logic
            return {"success": True, "action": "enabled", "model_id": model_id}
        
        elif action == "disable" and model_id:
            # Disable model logic
            return {"success": True, "action": "disabled", "model_id": model_id}
        
        else:
            return {"success": False, "error": "Invalid action or missing model_id"}
        
    except Exception as e:
        logger.error(f"Error in model webhook: {e}")
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )


def main():
    """Main entry point"""
    logger.info("=" * 70)
    logger.info("🚀 Starting OpenWebUI Integration Server")
    logger.info("=" * 70)
    logger.info("")
    logger.info("📍 Webhook Configuration:")
    info = integration.get_webhook_info()
    logger.info(f"  Base URL: {info['webhook_base_url']}")
    logger.info(f"  Chat Endpoint: {info['endpoints']['chat']}")
    logger.info(f"  Status Endpoint: {info['endpoints']['status']}")
    logger.info(f"  Models Enabled: {info['models_enabled']}")
    logger.info("")
    logger.info("🔐 Authentication:")
    logger.info(f"  JWT Token: {'✓ Configured' if info['authentication']['jwt_token_provided'] else '✗ Missing'}")
    logger.info(f"  API Key: {'✓ Configured' if info['authentication']['api_key_provided'] else '✗ Missing'}")
    logger.info("")
    logger.info("🤖 Available Models:")
    for model in integration.get_enabled_models():
        logger.info(f"  - {model['name']} ({model['id']})")
    logger.info("")
    logger.info("=" * 70)
    logger.info("")
    
    # Start server
    port = int(os.getenv("PORT", 8080))
    host = os.getenv("HOST", "0.0.0.0")
    
    logger.info(f"🌐 Server starting on http://{host}:{port}")
    logger.info(f"📚 API Documentation: http://{host}:{port}/api/docs")
    logger.info("")
    
    uvicorn.run(app, host=host, port=port, log_level="info")


if __name__ == "__main__":
    main()
