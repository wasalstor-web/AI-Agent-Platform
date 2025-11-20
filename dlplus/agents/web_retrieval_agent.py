"""
Web Retrieval Agent
وكيل البحث على الويب

Agent for web search and information retrieval.
"""

import logging
from typing import Dict, Any
from .base_agent import BaseAgent

logger = logging.getLogger(__name__)


class WebRetrievalAgent(BaseAgent):
    """
    Web Retrieval Agent
    وكيل البحث على الويب
    
    Searches the web for information and retrieves relevant content.
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the web retrieval agent"""
        super().__init__("Web Retrieval Agent", config)
        self.max_results = config.get('max_results', 10) if config else 10
        self.timeout = config.get('timeout', 30) if config else 30
        # Prefer Arabic-understanding models for query enhancement
        self.set_preferred_models(['arabert', 'camelbert', 'qwen_arabic'])
    
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute web search
        
        Args:
            task: Task containing 'query' and optional 'filters'
            
        Returns:
            Search results
        """
        query = task.get('query')
        if not query:
            return {
                'success': False,
                'error': 'Query is required'
            }
        
        logger.info(f"🔍 Searching for: {query}")
        
        # Enhance query using AI models if available
        enhanced_query = await self._enhance_query_with_ai(query)
        
        # Perform search
        results = await self._search(enhanced_query)
        
        return {
            'success': True,
            'query': query,
            'enhanced_query': enhanced_query,
            'results': results,
            'count': len(results)
        }
    
    async def _enhance_query_with_ai(self, query: str) -> str:
        """
        Enhance search query using AI models
        
        Args:
            query: Original search query
            
        Returns:
            Enhanced query
        """
        if not self.model_manager:
            return query
        
        # Try to use Arabic models for query understanding
        for model_id in self.preferred_models:
            try:
                prompt = f"""تحليل وتحسين استعلام البحث التالي:

الاستعلام: {query}

قم بتحليل الاستعلام وتحسينه لنتائج بحث أفضل. اذكر الكلمات المفتاحية المهمة والمفاهيم ذات الصلة."""
                
                result = await self.use_model(model_id, prompt)
                
                if result.get('success'):
                    logger.info(f"✅ Query enhanced using model '{model_id}'")
                    return result.get('output', query)
                    
            except Exception as e:
                logger.warning(f"⚠️ Model '{model_id}' failed: {e}")
                continue
        
        return query
    
    async def _search(self, query: str) -> list:
        """
        Perform the actual search
        
        This is a placeholder. In production, integrate with:
        - Google Custom Search API
        - Bing Search API
        - DuckDuckGo API
        - Or any other search service
        """
        # Simulated results
        return [
            {
                'title': f'نتيجة بحث عن: {query}',
                'url': 'https://example.com/result1',
                'snippet': f'هذه نتيجة بحث محاكاة للاستعلام: {query}',
                'relevance': 0.95
            },
            {
                'title': f'معلومات إضافية: {query}',
                'url': 'https://example.com/result2',
                'snippet': f'المزيد من المعلومات حول: {query}',
                'relevance': 0.87
            }
        ]
    
    async def search_with_context(
        self,
        query: str,
        context: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Search with additional context
        
        Args:
            query: Search query
            context: Additional context information
            
        Returns:
            Enhanced search results
        """
        # Enhance query with context
        enhanced_query = self._enhance_query(query, context)
        
        return await self.execute({'query': enhanced_query})
    
    def _enhance_query(self, query: str, context: Dict[str, Any]) -> str:
        """Enhance query with context information"""
        # Simple enhancement - in production, use ML models
        language = context.get('language', 'ar')
        
        if language == 'ar' and not self._is_arabic(query):
            # Add Arabic context
            return f"{query} بالعربية"
        
        return query
    
    def _is_arabic(self, text: str) -> bool:
        """Check if text contains Arabic characters"""
        arabic_chars = set(range(0x0600, 0x06FF))
        return any(ord(char) in arabic_chars for char in text)
