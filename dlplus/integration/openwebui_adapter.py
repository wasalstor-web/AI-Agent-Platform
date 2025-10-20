"""
OpenWebUI Adapter for DL+ Agents
محول OpenWebUI لوكلاء DL+

Integrates DL+ agents with OpenWebUI
"""

import asyncio
import logging
from typing import Dict, Any, List
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

try:
    from agents.web_retrieval_agent import WebRetrievalAgent
    from agents.code_generator_agent import CodeGeneratorAgent
except ImportError:
    # Try alternative import
    from dlplus.agents.web_retrieval_agent import WebRetrievalAgent
    from dlplus.agents.code_generator_agent import CodeGeneratorAgent

logger = logging.getLogger(__name__)


class OpenWebUIAdapter:
    """
    Adapter to integrate DL+ agents with OpenWebUI
    محول دمج وكلاء DL+ مع OpenWebUI
    """
    
    def __init__(self):
        """Initialize the adapter"""
        try:
            self.web_agent = WebRetrievalAgent()
            self.code_agent = CodeGeneratorAgent()
            logger.info("✅ OpenWebUI Adapter initialized with agents")
        except Exception as e:
            logger.error(f"Error initializing agents: {e}")
            self.web_agent = None
            self.code_agent = None
            raise
    
    async def process_message(
        self,
        message: str,
        model: str,
        context: Dict[str, Any] = None
    ) -> str:
        """
        Process message through appropriate agent
        
        Args:
            message: User message
            model: Selected model
            context: Additional context
            
        Returns:
            Agent response
        """
        # Detect if code generation is requested
        code_keywords = ['code', 'كود', 'برمجة', 'function', 'class', 'script', 'program', 'برنامج']
        if any(keyword in message.lower() for keyword in code_keywords):
            return await self._process_with_code_agent(message, context)
        
        # Detect if web search is requested
        search_keywords = ['search', 'بحث', 'find', 'ابحث', 'اعثر', 'lookup', 'ما هو', 'what is']
        if any(keyword in message.lower() for keyword in search_keywords):
            return await self._process_with_web_agent(message, context)
        
        # Default: general response
        return await self._process_general(message, model, context)
    
    async def _process_with_code_agent(
        self,
        message: str,
        context: Dict[str, Any]
    ) -> str:
        """Process with code generator agent"""
        if not self.code_agent:
            return "Code generation agent is not available"
            
        logger.info(f"💻 Processing with CodeGeneratorAgent: {message[:50]}...")
        
        try:
            # Detect language from context or message
            language = 'python'
            if context:
                language = context.get('language', 'python')
            
            # Check for language hints in message
            lang_hints = {
                'python': ['python', 'بايثون'],
                'javascript': ['javascript', 'js', 'جافا سكريبت'],
                'java': ['java', 'جافا'],
                'go': ['golang', 'go', 'جو'],
                'rust': ['rust', 'رست']
            }
            
            for lang, hints in lang_hints.items():
                if any(hint in message.lower() for hint in hints):
                    language = lang
                    break
            
            result = await self.code_agent.execute({
                'description': message,
                'language': language
            })
            
            if result['success']:
                response = f"**Generated {result['language'].title()} Code:**\n\n"
                response += f"```{result['language']}\n{result['code']}\n```"
                return response
            else:
                return f"❌ Error generating code: {result.get('error', 'Unknown error')}"
        except Exception as e:
            logger.error(f"Error in code agent: {e}")
            return f"❌ Error processing code request: {str(e)}"
    
    async def _process_with_web_agent(
        self,
        message: str,
        context: Dict[str, Any]
    ) -> str:
        """Process with web retrieval agent"""
        if not self.web_agent:
            return "Web search agent is not available"
            
        logger.info(f"🔍 Processing with WebRetrievalAgent: {message[:50]}...")
        
        try:
            # Extract search query from message
            query = message.replace('search', '').replace('بحث', '').replace('find', '').replace('ابحث', '').strip()
            
            result = await self.web_agent.execute({'query': query})
            
            if result['success']:
                response = f"**Search Results for:** {result['query']}\n\n"
                response += f"Found {result['count']} results:\n\n"
                
                for idx, res in enumerate(result['results'], 1):
                    response += f"**{idx}. {res['title']}**\n"
                    response += f"{res['snippet']}\n"
                    response += f"🔗 [{res['url']}]({res['url']})\n"
                    response += f"📊 Relevance: {res['relevance']:.0%}\n\n"
                
                return response
            else:
                return f"❌ Error searching: {result.get('error', 'Unknown error')}"
        except Exception as e:
            logger.error(f"Error in web agent: {e}")
            return f"❌ Error processing search request: {str(e)}"
    
    async def _process_general(
        self,
        message: str,
        model: str,
        context: Dict[str, Any]
    ) -> str:
        """Process general message"""
        logger.info(f"💬 Processing general message with {model}")
        
        # Detect language
        is_arabic = any(ord(char) >= 0x0600 and ord(char) <= 0x06FF for char in message)
        
        if is_arabic:
            return f"""مرحباً! 🤖 أنا نظام DL+ للذكاء الصناعي المتكامل مع OpenWebUI.

**رسالتك:** "{message}"

**النموذج المستخدم:** {model}

**قدراتي المتاحة:**

🔍 **البحث على الويب**
   - ابحث عن أي معلومة على الإنترنت
   - مثال: "ابحث عن الذكاء الصناعي"

💻 **توليد الأكواد البرمجية**
   - أنشئ كود بلغات برمجة متعددة
   - مثال: "اكتب كود Python لحساب المتوسط"

💬 **المحادثة الذكية**
   - دردشة باللغتين العربية والإنجليزية
   - فهم السياق والاستدلال

🧠 **التفكير والتحليل**
   - تحليل البيانات
   - الإجابة على الأسئلة المعقدة

كيف يمكنني مساعدتك اليوم؟"""
        else:
            return f"""Hello! 🤖 I am the DL+ AI System integrated with OpenWebUI.

**Your message:** "{message}"

**Using model:** {model}

**My capabilities:**

🔍 **Web Search**
   - Search for information on the internet
   - Example: "search for artificial intelligence"

💻 **Code Generation**
   - Generate code in multiple programming languages
   - Example: "write Python code to calculate average"

💬 **Smart Conversation**
   - Chat in Arabic and English
   - Context understanding and reasoning

🧠 **Thinking & Analysis**
   - Data analysis
   - Answer complex questions

How can I help you today?"""
    
    def get_available_agents(self) -> List[Dict[str, Any]]:
        """
        Get list of available agents
        
        Returns:
            List of agent information
        """
        agents = []
        
        if self.web_agent:
            agents.append({
                'name': 'WebRetrievalAgent',
                'description': 'Search and retrieve information from the web',
                'description_ar': 'البحث واسترجاع المعلومات من الويب',
                'keywords': ['search', 'بحث', 'find', 'ابحث']
            })
        
        if self.code_agent:
            agents.append({
                'name': 'CodeGeneratorAgent',
                'description': 'Generate code in various programming languages',
                'description_ar': 'توليد الأكواد بلغات برمجة مختلفة',
                'keywords': ['code', 'كود', 'program', 'برنامج', 'function']
            })
        
        return agents
