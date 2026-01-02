"""
Translation Agent
وكيل الترجمة

Advanced translation agent with multi-language support and context awareness.
"""

import logging
from typing import Dict, Any, List, Optional
from datetime import datetime
from .base_agent import BaseAgent

logger = logging.getLogger(__name__)


class TranslationAgent(BaseAgent):
    """
    Translation Agent
    وكيل الترجمة
    
    Provides advanced translation capabilities with context awareness and quality checks.
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the translation agent"""
        super().__init__("Translation Agent", config)
        self.supported_languages = {
            'ar': 'Arabic',
            'en': 'English',
            'fr': 'French',
            'es': 'Spanish',
            'de': 'German',
            'it': 'Italian',
            'pt': 'Portuguese',
            'ru': 'Russian',
            'zh': 'Chinese',
            'ja': 'Japanese',
            'ko': 'Korean',
            'tr': 'Turkish',
            'hi': 'Hindi',
            'ur': 'Urdu'
        }
        self.enable_ai_translation = config.get('enable_ai_translation', False) if config else False
        self.enable_context_aware = config.get('enable_context_aware', True) if config else True
        self.translation_cache = {}
        
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Translate text
        
        Args:
            task: Task containing:
                - 'text': Text to translate
                - 'source_language': Source language code
                - 'target_language': Target language code
                - 'context': Optional context for better translation
                - 'style': Translation style (formal, casual, technical)
                
        Returns:
            Translation result
        """
        text = task.get('text')
        source_lang = task.get('source_language', 'auto')
        target_lang = task.get('target_language', 'en')
        context = task.get('context', {})
        style = task.get('style', 'formal')
        
        if not text:
            return {
                'success': False,
                'error': 'Text is required'
            }
        
        # Auto-detect language if needed
        if source_lang == 'auto':
            source_lang = await self._detect_language(text)
        
        # Validate languages
        if source_lang not in self.supported_languages and source_lang != 'auto':
            return {
                'success': False,
                'error': f'Source language {source_lang} is not supported',
                'supported_languages': list(self.supported_languages.keys())
            }
        
        if target_lang not in self.supported_languages:
            return {
                'success': False,
                'error': f'Target language {target_lang} is not supported',
                'supported_languages': list(self.supported_languages.keys())
            }
        
        # Check if same language
        if source_lang == target_lang:
            return {
                'success': True,
                'text': text,
                'translated_text': text,
                'source_language': source_lang,
                'target_language': target_lang,
                'confidence': 1.0,
                'note': 'Source and target languages are the same'
            }
        
        logger.info(f"🌐 Translating from {source_lang} to {target_lang}")
        
        # Check cache
        cache_key = f"{source_lang}:{target_lang}:{text[:50]}"
        if cache_key in self.translation_cache:
            logger.info("📦 Using cached translation")
            return self.translation_cache[cache_key]
        
        # Perform translation
        if self.enable_ai_translation:
            translated = await self._translate_with_ai(text, source_lang, target_lang, context, style)
        else:
            translated = await self._translate_with_rules(text, source_lang, target_lang, context, style)
        
        # Quality check
        quality = await self._check_translation_quality(text, translated, source_lang, target_lang)
        
        result = {
            'success': True,
            'text': text,
            'translated_text': translated,
            'source_language': source_lang,
            'target_language': target_lang,
            'source_language_name': self.supported_languages.get(source_lang, source_lang),
            'target_language_name': self.supported_languages.get(target_lang, target_lang),
            'quality_score': quality['score'],
            'quality_notes': quality['notes'],
            'style': style,
            'timestamp': datetime.now().isoformat()
        }
        
        # Cache result
        if len(self.translation_cache) < 1000:
            self.translation_cache[cache_key] = result
        
        return result
    
    async def _translate_with_ai(
        self,
        text: str,
        source_lang: str,
        target_lang: str,
        context: Dict[str, Any],
        style: str
    ) -> str:
        """
        Translate using AI model
        
        Note: Requires AI model integration
        """
        # Placeholder for AI translation
        # In production, integrate with:
        # - Google Translate API
        # - DeepL API
        # - OpenAI GPT
        # - Custom translation models
        
        logger.info("🤖 Using AI translation (fallback to rules)")
        return await self._translate_with_rules(text, source_lang, target_lang, context, style)
    
    async def _translate_with_rules(
        self,
        text: str,
        source_lang: str,
        target_lang: str,
        context: Dict[str, Any],
        style: str
    ) -> str:
        """Translate using rule-based approach"""
        # Simple rule-based translation for common phrases
        # In production, use proper translation libraries or AI
        
        # Common Arabic-English translations
        if source_lang == 'ar' and target_lang == 'en':
            translations = {
                'مرحبا': 'Hello',
                'شكرا': 'Thank you',
                'نعم': 'Yes',
                'لا': 'No',
                'من فضلك': 'Please'
            }
            for ar, en in translations.items():
                if ar in text:
                    text = text.replace(ar, en)
            return text or f"[Translation from {source_lang} to {target_lang}]: {text}"
        
        # For other language pairs, return placeholder
        return f"[Translation from {source_lang} to {target_lang}]: {text}"
    
    async def _detect_language(self, text: str) -> str:
        """Detect language of text"""
        # Simple language detection
        arabic_chars = sum(1 for char in text if '\u0600' <= char <= '\u06FF')
        total_chars = len([c for c in text if c.isalpha()])
        
        if total_chars > 0:
            arabic_ratio = arabic_chars / total_chars if total_chars > 0 else 0
            
            if arabic_ratio > 0.3:
                return 'ar'
            
            # Check for other languages (simplified)
            if any(char in text for char in 'àáâãäåæçèéêë'):
                return 'fr'
            if any(char in text for char in 'ñ'):
                return 'es'
            if any(char in text for char in 'äöüß'):
                return 'de'
            if any(char in text for char in 'àèéìíîòóù'):
                return 'it'
            if any(char in text for char in 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'):
                return 'ru'
            if any(char in text for char in '中文'):
                return 'zh'
            if any(char in text for char in 'ひらがなカタカナ'):
                return 'ja'
        
        # Default to English
        return 'en'
    
    async def _check_translation_quality(
        self,
        original: str,
        translated: str,
        source_lang: str,
        target_lang: str
    ) -> Dict[str, Any]:
        """Check translation quality"""
        notes = []
        score = 0.8  # Default score
        
        # Check length similarity
        original_len = len(original.split())
        translated_len = len(translated.split())
        
        if original_len > 0:
            length_ratio = translated_len / original_len
            if length_ratio < 0.3 or length_ratio > 3.0:
                notes.append('Translation length differs significantly from original')
                score -= 0.2
            elif 0.5 <= length_ratio <= 2.0:
                score += 0.1
        
        # Check for placeholder text
        if '[Translation' in translated or 'Not translated' in translated:
            notes.append('Translation appears to be incomplete')
            score -= 0.3
        
        # Check for special characters preservation
        if source_lang == 'ar' and target_lang != 'ar':
            # Arabic text should be properly transliterated or translated
            if any('\u0600' <= char <= '\u06FF' for char in translated):
                notes.append('Arabic characters found in translation - may need review')
        
        score = max(0.0, min(1.0, score))
        
        return {
            'score': score,
            'notes': notes,
            'original_length': original_len,
            'translated_length': translated_len
        }
    
    async def translate_batch(
        self,
        texts: List[str],
        source_lang: str,
        target_lang: str
    ) -> Dict[str, Any]:
        """
        Translate multiple texts at once
        
        Args:
            texts: List of texts to translate
            source_lang: Source language
            target_lang: Target language
            
        Returns:
            Batch translation results
        """
        results = []
        
        for text in texts:
            result = await self.execute({
                'text': text,
                'source_language': source_lang,
                'target_language': target_lang
            })
            results.append(result)
        
        return {
            'success': True,
            'results': results,
            'count': len(results),
            'timestamp': datetime.now().isoformat()
        }
    
    async def transliterate(
        self,
        text: str,
        source_script: str,
        target_script: str
    ) -> Dict[str, Any]:
        """
        Transliterate text between scripts
        
        Args:
            text: Text to transliterate
            source_script: Source script (e.g., 'arabic', 'latin')
            target_script: Target script (e.g., 'latin', 'arabic')
            
        Returns:
            Transliteration result
        """
        # Placeholder for transliteration
        # In production, use proper transliteration libraries
        
        logger.info(f"🔄 Transliterating from {source_script} to {target_script}")
        
        return {
            'success': True,
            'text': text,
            'transliterated_text': text,  # Placeholder
            'source_script': source_script,
            'target_script': target_script,
            'timestamp': datetime.now().isoformat()
        }

