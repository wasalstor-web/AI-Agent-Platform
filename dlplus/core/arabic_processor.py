"""
Arabic Language Processor
معالج اللغة العربية

Handles Arabic language understanding, analysis, and processing.
"""

import logging
import re
from typing import Dict, List, Any

logger = logging.getLogger(__name__)


class ArabicProcessor:
    """
    Arabic Language Processor
    معالج اللغة العربية الفصحى
    
    Processes Arabic text with grammatical, semantic, and contextual analysis.
    """
    
    def __init__(self):
        """Initialize the Arabic processor"""
        self.intent_keywords = self._load_intent_keywords()
        logger.info("📖 Arabic Processor initialized")
    
    def _load_intent_keywords(self) -> Dict[str, List[str]]:
        """Load intent detection keywords"""
        return {
            'code': ['كود', 'برمجة', 'اكتب', 'سكريبت', 'برنامج', 'دالة', 'وظيفة'],
            'search': ['ابحث', 'بحث', 'ايجاد', 'إيجاد', 'معلومات', 'عن', 'ماهو', 'ما هو'],
            'translate': ['ترجم', 'ترجمة', 'translate', 'translation'],
            'analyze': ['حلل', 'تحليل', 'افحص', 'فحص', 'analyze', 'analysis'],
            'execute': ['نفذ', 'تنفيذ', 'شغل', 'تشغيل', 'execute', 'run'],
            'general': ['اشرح', 'شرح', 'ساعد', 'مساعدة', 'أخبر', 'اخبر']
        }
    
    async def analyze(self, text: str) -> Dict[str, Any]:
        """
        Analyze Arabic text
        
        Args:
            text: Arabic text to analyze
            
        Returns:
            Analysis dictionary with intent, entities, and metadata
        """
        try:
            # Normalize the text
            normalized = self._normalize_arabic(text)
            
            # Detect intent
            intent = self._detect_intent(normalized)
            
            # Extract entities
            entities = self._extract_entities(normalized)
            
            # Analyze sentiment
            sentiment = self._analyze_sentiment(normalized)
            
            # Grammar analysis (placeholder)
            grammar = self._analyze_grammar(normalized)
            
            return {
                'original': text,
                'normalized': normalized,
                'intent': intent,
                'entities': entities,
                'sentiment': sentiment,
                'grammar': grammar,
                'language': 'ar',
                'is_classical': self._is_classical_arabic(normalized)
            }
            
        except Exception as e:
            logger.error(f"Error analyzing Arabic text: {e}")
            return {
                'original': text,
                'intent': 'general',
                'entities': [],
                'error': str(e)
            }
    
    def _normalize_arabic(self, text: str) -> str:
        """Normalize Arabic text"""
        # Remove tashkeel (diacritics)
        text = re.sub(r'[\u064B-\u0652]', '', text)
        
        # Normalize alef
        text = re.sub(r'[إأآا]', 'ا', text)
        
        # Normalize teh marbuta
        text = re.sub(r'ة', 'ه', text)
        
        # Normalize ya
        text = re.sub(r'ى', 'ي', text)
        
        # Remove extra spaces
        text = ' '.join(text.split())
        
        return text.strip()
    
    def _detect_intent(self, text: str) -> str:
        """Detect user intent from text"""
        text_lower = text.lower()
        
        # Check each intent category
        for intent, keywords in self.intent_keywords.items():
            for keyword in keywords:
                if keyword in text_lower:
                    return intent
        
        # Default intent
        return 'general'
    
    def _extract_entities(self, text: str) -> List[Dict[str, str]]:
        """Extract named entities from text"""
        entities = []
        
        # Extract URLs
        url_pattern = r'https?://[^\s]+'
        urls = re.findall(url_pattern, text)
        for url in urls:
            entities.append({'type': 'url', 'value': url})
        
        # Extract file paths
        file_pattern = r'/[\w/.-]+|[A-Z]:\\[\w\\.-]+'
        files = re.findall(file_pattern, text)
        for file in files:
            entities.append({'type': 'file_path', 'value': file})
        
        # Extract numbers
        number_pattern = r'\d+'
        numbers = re.findall(number_pattern, text)
        for number in numbers:
            entities.append({'type': 'number', 'value': number})
        
        return entities
    
    def _analyze_sentiment(self, text: str) -> str:
        """Analyze sentiment of the text"""
        # Simple sentiment analysis
        positive_words = ['جيد', 'ممتاز', 'رائع', 'جميل', 'مفيد', 'شكرا', 'شكرا']
        negative_words = ['سيئ', 'خطأ', 'مشكله', 'مشكلة', 'فشل', 'خطا']
        
        text_lower = text.lower()
        
        positive_count = sum(1 for word in positive_words if word in text_lower)
        negative_count = sum(1 for word in negative_words if word in text_lower)
        
        if positive_count > negative_count:
            return 'positive'
        elif negative_count > positive_count:
            return 'negative'
        else:
            return 'neutral'
    
    def _analyze_grammar(self, text: str) -> Dict[str, Any]:
        """Analyze Arabic grammar (placeholder)"""
        # This would use NLP models in production
        return {
            'analyzed': True,
            'word_count': len(text.split()),
            'sentence_count': len(re.split(r'[.!?؟]', text))
        }
    
    def _is_classical_arabic(self, text: str) -> bool:
        """Check if text is in classical Arabic"""
        # Simple heuristic: classical Arabic tends to have certain patterns
        # This is a placeholder - in production would use ML model
        classical_indicators = ['إن', 'أن', 'لقد', 'قد', 'ليس', 'إذا', 'لكن']
        
        text_words = text.split()
        classical_word_count = sum(1 for word in classical_indicators if word in text_words)
        
        return classical_word_count > 0
    
    def generate_arabic_response(self, content: str, style: str = 'formal') -> str:
        """
        Generate proper Arabic response
        
        Args:
            content: Response content
            style: Response style ('formal', 'literary', 'analytical', 'commercial')
            
        Returns:
            Formatted Arabic response
        """
        # Add appropriate opening based on style
        openings = {
            'formal': 'تفضل، ',
            'literary': 'حسناً، ',
            'analytical': 'بناءً على التحليل، ',
            'commercial': 'بكل سرور، '
        }
        
        opening = openings.get(style, 'تفضل، ')
        
        return f"{opening}{content}"
