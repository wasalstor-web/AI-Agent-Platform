#!/usr/bin/env python3
"""
Supreme Agent - الوكيل الأعلى المتكامل
Supreme Integrated AI Agent

قدرات الوكيل / Agent Capabilities:
- تنفيذ الأوامر / Execute commands
- تحليل الملفات / Analyze files
- توليد أكواد / Generate code
- فهم السياق / Understand context
- تعلم مستمر / Continuous learning

المؤلف / Author: wasalstor-web
التاريخ / Date: 2025-10-20
"""

import sys
import json
import subprocess
import logging
from typing import Optional, Dict, Any, List
from pathlib import Path
import requests
from datetime import datetime

# إعداد نظام السجلات / Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('supreme_agent.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger('SupremeAgent')


class SupremeAgent:
    """
    الوكيل الأعلى - نظام ذكاء اصطناعي متكامل
    Supreme Agent - Integrated AI System
    """
    
    def __init__(self, 
                 model: str = "supreme-executor",
                 ollama_host: str = "http://localhost:11434",
                 temperature: float = 0.7,
                 max_tokens: int = 4096):
        """
        تهيئة الوكيل / Initialize the agent
        
        Args:
            model: اسم النموذج / Model name
            ollama_host: عنوان خادم Ollama / Ollama server URL
            temperature: درجة الإبداع / Temperature for generation
            max_tokens: أقصى عدد رموز / Maximum tokens
        """
        self.model = model
        self.ollama_host = ollama_host
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.conversation_history: List[Dict[str, str]] = []
        
        logger.info(f"Supreme Agent initialized with model: {model}")
        logger.info(f"Ollama host: {ollama_host}")
        
    def _call_ollama(self, prompt: str, system: Optional[str] = None) -> str:
        """
        استدعاء Ollama API / Call Ollama API
        
        Args:
            prompt: النص المدخل / Input prompt
            system: رسالة النظام / System message
            
        Returns:
            str: استجابة النموذج / Model response
        """
        try:
            url = f"{self.ollama_host}/api/generate"
            payload = {
                "model": self.model,
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": self.temperature,
                    "num_predict": self.max_tokens
                }
            }
            
            if system:
                payload["system"] = system
            
            logger.debug(f"Calling Ollama API: {url}")
            response = requests.post(url, json=payload, timeout=120)
            response.raise_for_status()
            
            result = response.json()
            return result.get('response', '')
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Error calling Ollama API: {e}")
            return f"خطأ في الاتصال بـ Ollama / Error connecting to Ollama: {e}"
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return f"خطأ غير متوقع / Unexpected error: {e}"
    
    def execute(self, command: str) -> str:
        """
        تنفيذ أي أمر / Execute any command
        
        Args:
            command: الأمر المطلوب تنفيذه / Command to execute
            
        Returns:
            str: نتيجة التنفيذ / Execution result
        """
        logger.info(f"Executing command: {command}")
        
        system_prompt = """أنت وكيل تنفيذي متقدم. قم بتحليل الأمر وتنفيذه بدقة.
You are an advanced execution agent. Analyze and execute the command accurately.

إذا كان الأمر يتطلب كود، قدم الكود الكامل والقابل للتشغيل.
If the command requires code, provide complete, executable code.

إذا كان الأمر غير واضح، اطلب التوضيح.
If the command is unclear, ask for clarification."""
        
        response = self._call_ollama(command, system=system_prompt)
        
        # حفظ في السجل / Save to history
        self.conversation_history.append({
            "timestamp": datetime.now().isoformat(),
            "type": "execute",
            "command": command,
            "response": response
        })
        
        return response
    
    def analyze_file(self, filepath: str) -> Dict[str, Any]:
        """
        تحليل ملف / Analyze a file
        
        Args:
            filepath: مسار الملف / File path
            
        Returns:
            dict: نتائج التحليل / Analysis results
        """
        logger.info(f"Analyzing file: {filepath}")
        
        try:
            file_path = Path(filepath)
            
            if not file_path.exists():
                return {
                    "success": False,
                    "error": f"الملف غير موجود / File not found: {filepath}"
                }
            
            # قراءة محتوى الملف / Read file content
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # تحليل الملف باستخدام النموذج / Analyze using model
            analysis_prompt = f"""قم بتحليل هذا الملف بشكل شامل:
Analyze this file comprehensively:

اسم الملف / Filename: {file_path.name}
النوع / Type: {file_path.suffix}

المحتوى / Content:
{content[:2000]}  # أول 2000 حرف / First 2000 characters

قدم:
Provide:
1. ملخص المحتوى / Content summary
2. اللغة المستخدمة / Language used
3. الغرض من الملف / File purpose
4. ملاحظات وتوصيات / Notes and recommendations
"""
            
            analysis = self._call_ollama(analysis_prompt)
            
            result = {
                "success": True,
                "filename": file_path.name,
                "filepath": str(file_path),
                "size": file_path.stat().st_size,
                "extension": file_path.suffix,
                "analysis": analysis,
                "timestamp": datetime.now().isoformat()
            }
            
            # حفظ في السجل / Save to history
            self.conversation_history.append({
                "timestamp": datetime.now().isoformat(),
                "type": "analyze_file",
                "filepath": filepath,
                "result": result
            })
            
            return result
            
        except Exception as e:
            logger.error(f"Error analyzing file: {e}")
            return {
                "success": False,
                "error": str(e)
            }
    
    def generate_code(self, description: str, lang: str = "python") -> str:
        """
        توليد كود برمجي / Generate code
        
        Args:
            description: وصف الكود المطلوب / Code description
            lang: لغة البرمجة / Programming language
            
        Returns:
            str: الكود المولد / Generated code
        """
        logger.info(f"Generating {lang} code for: {description}")
        
        code_prompt = f"""اكتب كود {lang} كامل وقابل للتشغيل بناءً على الوصف التالي:
Write complete, executable {lang} code based on the following description:

الوصف / Description: {description}

متطلبات / Requirements:
1. كود نظيف ومنظم / Clean and organized code
2. تعليقات واضحة / Clear comments
3. معالجة الأخطاء / Error handling
4. أفضل الممارسات / Best practices

قدم الكود فقط بدون شرح إضافي.
Provide only the code without additional explanation."""
        
        code = self._call_ollama(code_prompt)
        
        # حفظ في السجل / Save to history
        self.conversation_history.append({
            "timestamp": datetime.now().isoformat(),
            "type": "generate_code",
            "language": lang,
            "description": description,
            "code": code
        })
        
        return code
    
    def chat(self, message: str, context: Optional[str] = None) -> str:
        """
        محادثة ذكية / Intelligent chat
        
        Args:
            message: الرسالة / Message
            context: سياق إضافي / Additional context
            
        Returns:
            str: الرد / Response
        """
        logger.info(f"Chat message: {message[:100]}...")
        
        # بناء السياق من المحادثات السابقة / Build context from history
        history_context = ""
        if self.conversation_history:
            recent = self.conversation_history[-3:]  # آخر 3 تفاعلات / Last 3 interactions
            history_context = "\n".join([
                f"{h.get('type', 'chat')}: {str(h)[:200]}"
                for h in recent
            ])
        
        full_message = message
        if context:
            full_message = f"{context}\n\n{message}"
        
        if history_context:
            full_message = f"السياق السابق / Previous context:\n{history_context}\n\n{full_message}"
        
        response = self._call_ollama(full_message)
        
        # حفظ في السجل / Save to history
        self.conversation_history.append({
            "timestamp": datetime.now().isoformat(),
            "type": "chat",
            "message": message,
            "response": response
        })
        
        return response
    
    def get_models(self) -> List[str]:
        """
        الحصول على قائمة النماذج المتاحة / Get available models
        
        Returns:
            list: قائمة النماذج / List of models
        """
        try:
            url = f"{self.ollama_host}/api/tags"
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            
            data = response.json()
            models = [model['name'] for model in data.get('models', [])]
            logger.info(f"Available models: {models}")
            return models
            
        except Exception as e:
            logger.error(f"Error getting models: {e}")
            return []
    
    def health_check(self) -> Dict[str, Any]:
        """
        فحص صحة النظام / System health check
        
        Returns:
            dict: حالة النظام / System status
        """
        try:
            # فحص اتصال Ollama / Check Ollama connection
            url = f"{self.ollama_host}/api/tags"
            response = requests.get(url, timeout=5)
            ollama_status = response.status_code == 200
            
            # فحص النموذج / Check model
            models = self.get_models()
            model_available = self.model in models
            
            return {
                "status": "healthy" if (ollama_status and model_available) else "unhealthy",
                "ollama_connected": ollama_status,
                "model_available": model_available,
                "current_model": self.model,
                "available_models": models,
                "conversation_history_size": len(self.conversation_history),
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Health check error: {e}")
            return {
                "status": "unhealthy",
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    def save_history(self, filepath: str = "conversation_history.json"):
        """
        حفظ سجل المحادثات / Save conversation history
        
        Args:
            filepath: مسار الملف / File path
        """
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(self.conversation_history, f, ensure_ascii=False, indent=2)
            logger.info(f"History saved to {filepath}")
        except Exception as e:
            logger.error(f"Error saving history: {e}")
    
    def load_history(self, filepath: str = "conversation_history.json"):
        """
        تحميل سجل المحادثات / Load conversation history
        
        Args:
            filepath: مسار الملف / File path
        """
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                self.conversation_history = json.load(f)
            logger.info(f"History loaded from {filepath}")
        except Exception as e:
            logger.error(f"Error loading history: {e}")


def main():
    """برنامج سطر الأوامر / Command line interface"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Supreme Agent - الوكيل الأعلى المتكامل',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
أمثلة / Examples:
  supreme-agent chat "مرحباً، كيف حالك؟"
  supreme-agent execute "اكتب سكريبت لنسخ الملفات"
  supreme-agent analyze-file script.py
  supreme-agent generate-code "برنامج حاسبة بسيط" --lang python
  supreme-agent health
        """
    )
    
    parser.add_argument('command', 
                       choices=['chat', 'execute', 'analyze-file', 'generate-code', 'health', 'models'],
                       help='الأمر المطلوب / Command to execute')
    parser.add_argument('input', nargs='?', 
                       help='المدخل / Input (message, file path, or description)')
    parser.add_argument('--lang', default='python',
                       help='لغة البرمجة / Programming language (for generate-code)')
    parser.add_argument('--model', default='supreme-executor',
                       help='النموذج المستخدم / Model to use')
    parser.add_argument('--host', default='http://localhost:11434',
                       help='عنوان Ollama / Ollama host')
    
    args = parser.parse_args()
    
    # إنشاء الوكيل / Create agent
    agent = SupremeAgent(model=args.model, ollama_host=args.host)
    
    # تنفيذ الأمر / Execute command
    if args.command == 'chat':
        if not args.input:
            print("خطأ: الرجاء إدخال الرسالة / Error: Please provide a message")
            sys.exit(1)
        result = agent.chat(args.input)
        print(result)
        
    elif args.command == 'execute':
        if not args.input:
            print("خطأ: الرجاء إدخال الأمر / Error: Please provide a command")
            sys.exit(1)
        result = agent.execute(args.input)
        print(result)
        
    elif args.command == 'analyze-file':
        if not args.input:
            print("خطأ: الرجاء إدخال مسار الملف / Error: Please provide a file path")
            sys.exit(1)
        result = agent.analyze_file(args.input)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        
    elif args.command == 'generate-code':
        if not args.input:
            print("خطأ: الرجاء إدخال وصف الكود / Error: Please provide a code description")
            sys.exit(1)
        result = agent.generate_code(args.input, lang=args.lang)
        print(result)
        
    elif args.command == 'health':
        result = agent.health_check()
        print(json.dumps(result, ensure_ascii=False, indent=2))
        
    elif args.command == 'models':
        models = agent.get_models()
        print("النماذج المتاحة / Available models:")
        for model in models:
            print(f"  - {model}")


if __name__ == "__main__":
    main()
