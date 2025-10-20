#!/usr/bin/env python3
"""
Supreme Agent API Server - خادم API للوكيل الأعلى
Flask REST API for Supreme Agent

المؤلف / Author: wasalstor-web
التاريخ / Date: 2025-10-20
"""

import sys
import os
from pathlib import Path

# إضافة المسار للوحدات / Add path for modules
sys.path.insert(0, str(Path(__file__).parent.parent))

from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import json
from datetime import datetime
from scripts.supreme_agent import SupremeAgent

# إعداد Flask / Setup Flask
app = Flask(__name__)
CORS(app)  # تفعيل CORS / Enable CORS

# إعداد السجلات / Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('SupremeAPI')

# إنشاء الوكيل / Create agent instance
agent = SupremeAgent(
    model=os.getenv('SUPREME_MODEL', 'supreme-executor'),
    ollama_host=os.getenv('OLLAMA_HOST', 'http://localhost:11434')
)


@app.route('/')
def index():
    """الصفحة الرئيسية / Home page"""
    return jsonify({
        "name": "Supreme Agent API",
        "version": "1.0.0",
        "description": "الوكيل الأعلى المتكامل / Supreme Integrated Agent",
        "endpoints": {
            "POST /api/chat": "محادثة / Chat",
            "POST /api/execute": "تنفيذ أمر / Execute command",
            "POST /api/analyze": "تحليل ملف / Analyze file",
            "POST /api/generate-code": "توليد كود / Generate code",
            "GET /api/models": "قائمة النماذج / List models",
            "GET /api/health": "فحص الصحة / Health check"
        },
        "documentation": "/api/docs"
    })


@app.route('/api/docs')
def docs():
    """توثيق API / API Documentation"""
    return jsonify({
        "title": "Supreme Agent API Documentation",
        "version": "1.0.0",
        "endpoints": [
            {
                "path": "/api/chat",
                "method": "POST",
                "description": "محادثة مع الوكيل / Chat with agent",
                "parameters": {
                    "message": "string - الرسالة / Message (required)",
                    "context": "string - سياق إضافي / Additional context (optional)"
                },
                "example": {
                    "message": "مرحباً، كيف حالك؟",
                    "context": "نحن نتحدث عن البرمجة"
                }
            },
            {
                "path": "/api/execute",
                "method": "POST",
                "description": "تنفيذ أمر / Execute command",
                "parameters": {
                    "command": "string - الأمر / Command (required)"
                },
                "example": {
                    "command": "اكتب سكريبت لنسخ الملفات"
                }
            },
            {
                "path": "/api/analyze",
                "method": "POST",
                "description": "تحليل ملف / Analyze file",
                "parameters": {
                    "filepath": "string - مسار الملف / File path (required)"
                },
                "example": {
                    "filepath": "/path/to/file.py"
                }
            },
            {
                "path": "/api/generate-code",
                "method": "POST",
                "description": "توليد كود / Generate code",
                "parameters": {
                    "description": "string - وصف الكود / Code description (required)",
                    "language": "string - لغة البرمجة / Programming language (default: python)"
                },
                "example": {
                    "description": "برنامج حاسبة بسيط",
                    "language": "python"
                }
            },
            {
                "path": "/api/models",
                "method": "GET",
                "description": "قائمة النماذج المتاحة / List available models"
            },
            {
                "path": "/api/health",
                "method": "GET",
                "description": "فحص صحة النظام / System health check"
            }
        ]
    })


@app.route('/api/chat', methods=['POST'])
def chat():
    """محادثة / Chat endpoint"""
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({
                "success": False,
                "error": "الرسالة مطلوبة / Message required"
            }), 400
        
        message = data['message']
        context = data.get('context')
        
        response = agent.chat(message, context=context)
        
        return jsonify({
            "success": True,
            "response": response,
            "timestamp": datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"Chat error: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/execute', methods=['POST'])
def execute():
    """تنفيذ أمر / Execute command endpoint"""
    try:
        data = request.get_json()
        
        if not data or 'command' not in data:
            return jsonify({
                "success": False,
                "error": "الأمر مطلوب / Command required"
            }), 400
        
        command = data['command']
        response = agent.execute(command)
        
        return jsonify({
            "success": True,
            "response": response,
            "timestamp": datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"Execute error: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/analyze', methods=['POST'])
def analyze():
    """تحليل ملف / Analyze file endpoint"""
    try:
        data = request.get_json()
        
        if not data or 'filepath' not in data:
            return jsonify({
                "success": False,
                "error": "مسار الملف مطلوب / Filepath required"
            }), 400
        
        filepath = data['filepath']
        result = agent.analyze_file(filepath)
        
        return jsonify(result)
        
    except Exception as e:
        logger.error(f"Analyze error: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/generate-code', methods=['POST'])
def generate_code():
    """توليد كود / Generate code endpoint"""
    try:
        data = request.get_json()
        
        if not data or 'description' not in data:
            return jsonify({
                "success": False,
                "error": "وصف الكود مطلوب / Description required"
            }), 400
        
        description = data['description']
        language = data.get('language', 'python')
        
        code = agent.generate_code(description, lang=language)
        
        return jsonify({
            "success": True,
            "code": code,
            "language": language,
            "timestamp": datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"Generate code error: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/models', methods=['GET'])
def models():
    """قائمة النماذج / List models endpoint"""
    try:
        models_list = agent.get_models()
        
        return jsonify({
            "success": True,
            "models": models_list,
            "current_model": agent.model,
            "timestamp": datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"Models error: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/health', methods=['GET'])
def health():
    """فحص الصحة / Health check endpoint"""
    try:
        health_status = agent.health_check()
        return jsonify(health_status)
        
    except Exception as e:
        logger.error(f"Health check error: {e}")
        return jsonify({
            "status": "unhealthy",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }), 500


@app.errorhandler(404)
def not_found(error):
    """معالج 404 / 404 handler"""
    return jsonify({
        "success": False,
        "error": "الصفحة غير موجودة / Page not found"
    }), 404


@app.errorhandler(500)
def internal_error(error):
    """معالج 500 / 500 handler"""
    return jsonify({
        "success": False,
        "error": "خطأ في الخادم / Internal server error"
    }), 500


if __name__ == '__main__':
    # إعدادات الخادم / Server settings
    host = os.getenv('API_HOST', '0.0.0.0')
    port = int(os.getenv('API_PORT', 5000))
    debug = os.getenv('API_DEBUG', 'False').lower() == 'true'
    
    logger.info(f"Starting Supreme Agent API Server...")
    logger.info(f"Host: {host}")
    logger.info(f"Port: {port}")
    logger.info(f"Debug: {debug}")
    logger.info(f"Model: {agent.model}")
    logger.info(f"Ollama: {agent.ollama_host}")
    
    print("\n" + "="*60)
    print("  Supreme Agent API Server")
    print("  الوكيل الأعلى - خادم API")
    print("="*60)
    print(f"\n  Server running at: http://{host}:{port}")
    print(f"  Documentation: http://{host}:{port}/api/docs")
    print(f"  Health check: http://{host}:{port}/api/health")
    print("\n" + "="*60 + "\n")
    
    app.run(host=host, port=port, debug=debug)
