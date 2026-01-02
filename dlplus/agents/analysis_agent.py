"""
Analysis Agent
وكيل التحليل

Advanced analysis agent for text, data, sentiment, and more.
"""

import logging
import re
from typing import Dict, Any, List, Optional
from datetime import datetime
from collections import Counter
from .base_agent import BaseAgent

logger = logging.getLogger(__name__)


class AnalysisAgent(BaseAgent):
    """
    Analysis Agent
    وكيل التحليل
    
    Provides comprehensive analysis capabilities including sentiment, topics, entities, and trends.
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the analysis agent"""
        super().__init__("Analysis Agent", config)
        self.analysis_types = config.get('analysis_types', [
            'sentiment', 'topic', 'entity', 'trend', 'keyword', 'summary'
        ]) if config else ['sentiment', 'topic', 'entity', 'trend', 'keyword', 'summary']
        
        # Sentiment dictionaries
        self.positive_words_ar = [
            'جيد', 'ممتاز', 'رائع', 'جميل', 'مفيد', 'شكرا', 'شكراً',
            'ممتازة', 'رائعة', 'جميلة', 'مفيدة', 'عظيم', 'عظيمة'
        ]
        self.negative_words_ar = [
            'سيئ', 'خطأ', 'مشكله', 'مشكلة', 'فشل', 'خطا', 'سيئة',
            'مشاكل', 'فشلت', 'فاشل', 'فاشلة', 'رديء', 'رديئة'
        ]
        self.positive_words_en = [
            'good', 'excellent', 'great', 'wonderful', 'amazing', 'fantastic',
            'perfect', 'awesome', 'brilliant', 'outstanding'
        ]
        self.negative_words_en = [
            'bad', 'terrible', 'awful', 'horrible', 'worst', 'poor',
            'disappointing', 'frustrating', 'annoying', 'hate'
        ]
        
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Perform analysis
        
        Args:
            task: Task containing:
                - 'text': Text to analyze
                - 'analysis_type': Type of analysis (sentiment, topic, entity, etc.)
                - 'language': Language of text (auto-detect if not provided)
                
        Returns:
            Analysis results
        """
        text = task.get('text')
        analysis_type = task.get('analysis_type', 'comprehensive')
        language = task.get('language', 'auto')
        
        if not text:
            return {
                'success': False,
                'error': 'Text is required'
            }
        
        # Auto-detect language
        if language == 'auto':
            language = self._detect_language(text)
        
        logger.info(f"🔍 Analyzing text (type: {analysis_type}, language: {language})")
        
        # Perform analysis based on type
        if analysis_type == 'comprehensive':
            results = await self._comprehensive_analysis(text, language)
        elif analysis_type == 'sentiment':
            results = await self._sentiment_analysis(text, language)
        elif analysis_type == 'topic':
            results = await self._topic_analysis(text, language)
        elif analysis_type == 'entity':
            results = await self._entity_analysis(text, language)
        elif analysis_type == 'keyword':
            results = await self._keyword_analysis(text, language)
        elif analysis_type == 'summary':
            results = await self._summarize(text, language)
        else:
            return {
                'success': False,
                'error': f'Unknown analysis type: {analysis_type}',
                'available_types': ['comprehensive', 'sentiment', 'topic', 'entity', 'keyword', 'summary']
            }
        
        return {
            'success': True,
            'text': text,
            'analysis_type': analysis_type,
            'language': language,
            'results': results,
            'timestamp': datetime.now().isoformat()
        }
    
    async def _comprehensive_analysis(self, text: str, language: str) -> Dict[str, Any]:
        """Perform comprehensive analysis"""
        return {
            'sentiment': await self._sentiment_analysis(text, language),
            'topics': await self._topic_analysis(text, language),
            'entities': await self._entity_analysis(text, language),
            'keywords': await self._keyword_analysis(text, language),
            'statistics': self._calculate_statistics(text, language),
            'summary': await self._summarize(text, language)
        }
    
    async def _sentiment_analysis(self, text: str, language: str) -> Dict[str, Any]:
        """Analyze sentiment"""
        text_lower = text.lower()
        
        # Choose word lists based on language
        if language == 'ar':
            positive_words = self.positive_words_ar
            negative_words = self.negative_words_ar
        else:
            positive_words = self.positive_words_en
            negative_words = self.negative_words_en
        
        # Count sentiment words
        positive_count = sum(1 for word in positive_words if word in text_lower)
        negative_count = sum(1 for word in negative_words if word in text_lower)
        
        # Calculate sentiment score
        total_sentiment_words = positive_count + negative_count
        if total_sentiment_words > 0:
            sentiment_score = (positive_count - negative_count) / total_sentiment_words
        else:
            sentiment_score = 0.0
        
        # Determine sentiment
        if sentiment_score > 0.2:
            sentiment = 'positive'
            sentiment_ar = 'إيجابي'
        elif sentiment_score < -0.2:
            sentiment = 'negative'
            sentiment_ar = 'سلبي'
        else:
            sentiment = 'neutral'
            sentiment_ar = 'محايد'
        
        return {
            'sentiment': sentiment,
            'sentiment_arabic': sentiment_ar,
            'score': sentiment_score,
            'positive_count': positive_count,
            'negative_count': negative_count,
            'confidence': min(abs(sentiment_score) * 2, 1.0)
        }
    
    async def _topic_analysis(self, text: str, language: str) -> Dict[str, Any]:
        """Extract topics from text"""
        # Simple topic extraction based on keywords
        words = text.split()
        
        # Filter common words
        if language == 'ar':
            stop_words = {'و', 'من', 'في', 'على', 'إلى', 'عن', 'مع', 'هذا', 'ذلك', 'ال', 'أن', 'إن'}
        else:
            stop_words = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'is', 'are', 'was', 'were'}
        
        # Count word frequencies
        word_freq = Counter()
        for word in words:
            word_clean = re.sub(r'[^\w\s]', '', word.lower())
            if len(word_clean) > 2 and word_clean not in stop_words:
                word_freq[word_clean] += 1
        
        # Get top topics
        top_topics = word_freq.most_common(5)
        
        return {
            'topics': [{'word': word, 'frequency': freq} for word, freq in top_topics],
            'topic_count': len(word_freq),
            'main_topic': top_topics[0][0] if top_topics else None
        }
    
    async def _entity_analysis(self, text: str, language: str) -> Dict[str, Any]:
        """Extract named entities"""
        entities = {
            'urls': [],
            'emails': [],
            'phone_numbers': [],
            'dates': [],
            'numbers': [],
            'proper_nouns': []
        }
        
        # Extract URLs
        url_pattern = r'https?://[^\s]+|www\.[^\s]+'
        entities['urls'] = re.findall(url_pattern, text)
        
        # Extract emails
        email_pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
        entities['emails'] = re.findall(email_pattern, text)
        
        # Extract phone numbers (simplified)
        phone_pattern = r'[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}'
        entities['phone_numbers'] = re.findall(phone_pattern, text)
        
        # Extract dates (simplified)
        date_pattern = r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}[/-]\d{1,2}[/-]\d{1,2}'
        entities['dates'] = re.findall(date_pattern, text)
        
        # Extract numbers
        number_pattern = r'\d+'
        entities['numbers'] = re.findall(number_pattern, text)
        
        # Extract proper nouns (capitalized words)
        if language != 'ar':
            proper_noun_pattern = r'\b[A-Z][a-z]+\b'
            entities['proper_nouns'] = re.findall(proper_noun_pattern, text)
        
        return {
            'entities': entities,
            'total_entities': sum(len(v) for v in entities.values())
        }
    
    async def _keyword_analysis(self, text: str, language: str) -> Dict[str, Any]:
        """Extract and analyze keywords"""
        words = text.split()
        
        # Filter and count
        if language == 'ar':
            stop_words = {'و', 'من', 'في', 'على', 'إلى', 'عن', 'مع', 'هذا', 'ذلك', 'ال'}
        else:
            stop_words = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by'}
        
        word_freq = Counter()
        for word in words:
            word_clean = re.sub(r'[^\w\s]', '', word.lower())
            if len(word_clean) > 2 and word_clean not in stop_words:
                word_freq[word_clean] += 1
        
        # Calculate TF-IDF-like scores (simplified)
        max_freq = word_freq.most_common(1)[0][1] if word_freq else 1
        keywords = [
            {
                'word': word,
                'frequency': freq,
                'score': freq / max_freq
            }
            for word, freq in word_freq.most_common(10)
        ]
        
        return {
            'keywords': keywords,
            'total_keywords': len(word_freq),
            'unique_keywords': len(set(word_freq.keys()))
        }
    
    async def _summarize(self, text: str, language: str, max_sentences: int = 3) -> Dict[str, Any]:
        """Generate text summary"""
        sentences = re.split(r'[.!?؟]\s+', text)
        sentences = [s.strip() for s in sentences if s.strip()]
        
        if len(sentences) <= max_sentences:
            summary = ' '.join(sentences)
        else:
            # Simple summarization: take first and last sentences
            summary = ' '.join(sentences[:max_sentences//2] + sentences[-max_sentences//2:])
        
        return {
            'summary': summary,
            'original_length': len(text),
            'summary_length': len(summary),
            'compression_ratio': len(summary) / len(text) if len(text) > 0 else 0,
            'sentence_count': len(sentences)
        }
    
    def _calculate_statistics(self, text: str, language: str) -> Dict[str, Any]:
        """Calculate text statistics"""
        words = text.split()
        sentences = re.split(r'[.!?؟]\s+', text)
        paragraphs = text.split('\n\n')
        
        return {
            'character_count': len(text),
            'character_count_no_spaces': len(text.replace(' ', '')),
            'word_count': len(words),
            'sentence_count': len([s for s in sentences if s.strip()]),
            'paragraph_count': len([p for p in paragraphs if p.strip()]),
            'average_word_length': sum(len(w) for w in words) / len(words) if words else 0,
            'average_sentence_length': len(words) / len(sentences) if sentences else 0,
            'language': language
        }
    
    def _detect_language(self, text: str) -> str:
        """Detect language of text"""
        arabic_chars = sum(1 for char in text if '\u0600' <= char <= '\u06FF')
        total_chars = len([c for c in text if c.isalpha()])
        
        if total_chars > 0 and arabic_chars / total_chars > 0.3:
            return 'ar'
        return 'en'
    
    async def analyze_trends(
        self,
        texts: List[str],
        time_periods: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """
        Analyze trends across multiple texts
        
        Args:
            texts: List of texts to analyze
            time_periods: Optional time periods for each text
            
        Returns:
            Trend analysis results
        """
        # Analyze each text
        analyses = []
        for text in texts:
            analysis = await self._comprehensive_analysis(text, 'auto')
            analyses.append(analysis)
        
        # Extract trends
        sentiments = [a['sentiment']['sentiment'] for a in analyses]
        sentiment_trend = Counter(sentiments)
        
        # Extract common topics
        all_topics = []
        for analysis in analyses:
            topics = analysis.get('topics', {}).get('topics', [])
            all_topics.extend([t['word'] for t in topics])
        
        topic_trend = Counter(all_topics)
        
        return {
            'success': True,
            'text_count': len(texts),
            'sentiment_distribution': dict(sentiment_trend),
            'top_topics': dict(topic_trend.most_common(10)),
            'analyses': analyses,
            'timestamp': datetime.now().isoformat()
        }

