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
            'code': ['كود', 'برمجة', 'اكتب', 'سكريبت', 'برنامج', 'دالة', 'وظيفة', 'أنشئ', 'إنشاء', 'صمم', 'تصميم'],
            'search': ['ابحث', 'بحث', 'ايجاد', 'إيجاد', 'معلومات', 'عن', 'ماهو', 'ما هو', 'ما هي', 'أين', 'كيف'],
            'translate': ['ترجم', 'ترجمة', 'translate', 'translation', 'حول', 'تحويل'],
            'analyze': ['حلل', 'تحليل', 'افحص', 'فحص', 'analyze', 'analysis', 'راجع', 'مراجعة', 'دراسة'],
            'execute': ['نفذ', 'تنفيذ', 'شغل', 'تشغيل', 'execute', 'run', 'قم', 'افعل', 'اعمل'],
            'create': ['أنشئ', 'إنشاء', 'اصنع', 'صنع', 'اكتب', 'كتابة', 'أنشأ'],
            'delete': ['احذف', 'حذف', 'أزل', 'إزالة', 'امسح', 'مسح'],
            'update': ['حدث', 'تحديث', 'عدل', 'تعديل', 'غير', 'تغيير'],
            'read': ['اقرأ', 'قراءة', 'اعرض', 'عرض', 'أظهر', 'إظهار'],
            'general': ['اشرح', 'شرح', 'ساعد', 'مساعدة', 'أخبر', 'اخبر', 'ما', 'كيف', 'لماذا']
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
            
            # Detect intent with confidence
            intent_result = self._detect_intent(normalized)
            intent = intent_result.get('intent', 'general')
            intent_confidence = intent_result.get('confidence', 0.5)
            
            # Extract entities
            entities = self._extract_entities(normalized)
            
            # Analyze sentiment
            sentiment = self._analyze_sentiment(normalized)
            
            # Advanced grammar analysis
            grammar = self._analyze_grammar(normalized)
            
            # Extract root words
            roots = self._extract_roots(normalized)
            
            # Morphological analysis
            morphology = self._analyze_morphology(normalized)
            
            return {
                'original': text,
                'normalized': normalized,
                'intent': intent,
                'intent_confidence': intent_confidence,
                'intent_details': intent_result,
                'entities': entities,
                'sentiment': sentiment,
                'grammar': grammar,
                'roots': roots,
                'morphology': morphology,
                'language': 'ar',
                'is_classical': self._is_classical_arabic(normalized),
                'complexity': self._calculate_complexity(normalized)
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
    
    def _detect_intent(self, text: str) -> Dict[str, Any]:
        """Detect user intent from text with confidence scores"""
        text_lower = text.lower()
        intent_scores = {}
        
        # Calculate scores for each intent
        for intent, keywords in self.intent_keywords.items():
            score = 0
            matches = 0
            
            for keyword in keywords:
                if keyword in text_lower:
                    matches += 1
                    # Weight by keyword position (earlier = more important)
                    position = text_lower.find(keyword)
                    if position < len(text) * 0.3:  # In first 30% of text
                        score += 2
                    else:
                        score += 1
            
            if matches > 0:
                intent_scores[intent] = score / len(keywords)  # Normalize
        
        # Get best intent
        if intent_scores:
            best_intent = max(intent_scores.items(), key=lambda x: x[1])
            return {
                'intent': best_intent[0],
                'confidence': best_intent[1],
                'all_scores': intent_scores
            }
        
        # Default intent
        return {
            'intent': 'general',
            'confidence': 0.5,
            'all_scores': {}
        }
    
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
        """Analyze Arabic grammar with advanced features"""
        words = text.split()
        sentences = re.split(r'[.!?؟]', text)
        sentences = [s.strip() for s in sentences if s.strip()]
        
        # Analyze word types
        verbs = self._extract_verbs(words)
        nouns = self._extract_nouns(words)
        particles = self._extract_particles(words)
        
        # Analyze sentence structure
        sentence_types = self._analyze_sentence_types(sentences)
        
        # Check for common grammatical patterns
        has_subject = self._has_subject(text)
        has_predicate = self._has_predicate(text)
        
        return {
            'analyzed': True,
            'word_count': len(words),
            'sentence_count': len(sentences),
            'verbs': verbs,
            'nouns': nouns,
            'particles': particles,
            'sentence_types': sentence_types,
            'has_subject': has_subject,
            'has_predicate': has_predicate,
            'grammar_score': self._calculate_grammar_score(text, has_subject, has_predicate)
        }
    
    def _extract_verbs(self, words: List[str]) -> List[str]:
        """Extract verbs from text"""
        # Common Arabic verb patterns
        verb_patterns = [
            r'^[يفت]ع\w+',  # فعل ماضي/مضارع
            r'^است\w+',     # استفعل
            r'^ان\w+',      # انفعل
            r'^تف\w+',     # تفعل
        ]
        
        verbs = []
        for word in words:
            for pattern in verb_patterns:
                if re.match(pattern, word):
                    verbs.append(word)
                    break
        
        return verbs
    
    def _extract_nouns(self, words: List[str]) -> List[str]:
        """Extract nouns from text"""
        # Common Arabic noun patterns
        noun_indicators = ['ال', 'أل', 'لل', 'بال', 'كال']
        nouns = []
        
        for word in words:
            # Check for definite article
            if any(word.startswith(indicator) for indicator in noun_indicators):
                nouns.append(word)
            # Check for common noun endings
            elif word.endswith(('ة', 'ه', 'ون', 'ين', 'ات')):
                nouns.append(word)
        
        return nouns
    
    def _extract_particles(self, words: List[str]) -> List[str]:
        """Extract particles from text"""
        particles = ['و', 'من', 'في', 'على', 'إلى', 'عن', 'مع', 'ب', 'ل', 'ك', 'أن', 'إن', 'قد', 'لقد']
        found_particles = [w for w in words if w in particles]
        return found_particles
    
    def _analyze_sentence_types(self, sentences: List[str]) -> Dict[str, int]:
        """Analyze sentence types"""
        types = {
            'declarative': 0,  # خبرية
            'interrogative': 0,  # استفهامية
            'imperative': 0,  # أمرية
            'exclamatory': 0  # تعجبية
        }
        
        for sentence in sentences:
            if any(q in sentence for q in ['ما', 'ماذا', 'من', 'أين', 'كيف', 'لماذا', 'متى']):
                types['interrogative'] += 1
            elif sentence.endswith('!'):
                types['exclamatory'] += 1
            elif any(imp in sentence for imp in ['افعل', 'نفذ', 'قم', 'اعمل']):
                types['imperative'] += 1
            else:
                types['declarative'] += 1
        
        return types
    
    def _has_subject(self, text: str) -> bool:
        """Check if text has a subject"""
        # Simple check for subject indicators
        subject_indicators = ['هو', 'هي', 'أنت', 'أنا', 'نحن', 'هم', 'هن']
        return any(indicator in text for indicator in subject_indicators)
    
    def _has_predicate(self, text: str) -> bool:
        """Check if text has a predicate"""
        # Check for verbs or descriptive words
        has_verb = any(self._extract_verbs(text.split()))
        has_description = any(word.endswith(('ة', 'ه', 'ون', 'ين')) for word in text.split())
        return has_verb or has_description
    
    def _calculate_grammar_score(self, text: str, has_subject: bool, has_predicate: bool) -> float:
        """Calculate grammar quality score"""
        score = 0.5  # Base score
        
        if has_subject:
            score += 0.2
        if has_predicate:
            score += 0.2
        
        # Check for proper sentence structure
        words = text.split()
        if len(words) >= 3:  # Minimum sentence length
            score += 0.1
        
        return min(score, 1.0)
    
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
    
    def _extract_roots(self, text: str) -> List[str]:
        """Extract root words (جذور) from Arabic text"""
        # Simplified root extraction
        # In production, use proper Arabic morphology libraries
        words = text.split()
        roots = []
        
        # Common Arabic root patterns (3-letter roots)
        for word in words:
            # Remove common prefixes and suffixes
            cleaned = re.sub(r'^(ال|أل|لل|بال|كال)', '', word)
            cleaned = re.sub(r'(ة|ه|ون|ين|ات)$', '', cleaned)
            
            # Extract potential 3-letter root
            if len(cleaned) >= 3:
                # Simple heuristic: take first 3 consonants
                consonants = re.sub(r'[ايوأإآ]', '', cleaned)
                if len(consonants) >= 3:
                    roots.append(consonants[:3])
        
        return list(set(roots))  # Remove duplicates
    
    def _analyze_morphology(self, text: str) -> Dict[str, Any]:
        """Analyze Arabic morphology"""
        words = text.split()
        
        # Count different word forms
        forms = {
            'masculine': 0,
            'feminine': 0,
            'plural': 0,
            'singular': 0,
            'definite': 0,
            'indefinite': 0
        }
        
        for word in words:
            # Check for feminine marker
            if word.endswith(('ة', 'ه')):
                forms['feminine'] += 1
            else:
                forms['masculine'] += 1
            
            # Check for plural markers
            if word.endswith(('ون', 'ين', 'ات')):
                forms['plural'] += 1
            else:
                forms['singular'] += 1
            
            # Check for definite article
            if word.startswith(('ال', 'أل')):
                forms['definite'] += 1
            else:
                forms['indefinite'] += 1
        
        return {
            'word_forms': forms,
            'total_words': len(words),
            'morphology_richness': len(set(forms.values())) / len(forms) if forms else 0
        }
    
    def _calculate_complexity(self, text: str) -> Dict[str, Any]:
        """Calculate text complexity"""
        words = text.split()
        sentences = re.split(r'[.!?؟]', text)
        sentences = [s.strip() for s in sentences if s.strip()]
        
        # Average word length
        avg_word_length = sum(len(w) for w in words) / len(words) if words else 0
        
        # Average sentence length
        avg_sentence_length = len(words) / len(sentences) if sentences else 0
        
        # Vocabulary diversity (unique words / total words)
        unique_words = len(set(words))
        vocabulary_diversity = unique_words / len(words) if words else 0
        
        # Complexity score (0-1)
        complexity_score = min(
            (avg_word_length / 10) * 0.3 +
            (avg_sentence_length / 20) * 0.3 +
            vocabulary_diversity * 0.4,
            1.0
        )
        
        return {
            'score': complexity_score,
            'level': 'simple' if complexity_score < 0.4 else 'medium' if complexity_score < 0.7 else 'complex',
            'avg_word_length': avg_word_length,
            'avg_sentence_length': avg_sentence_length,
            'vocabulary_diversity': vocabulary_diversity
        }
    
    def stem_word(self, word: str) -> str:
        """
        Stem Arabic word to its root form
        
        Args:
            word: Arabic word to stem
            
        Returns:
            Stemmed word
        """
        # Remove definite article
        word = re.sub(r'^(ال|أل)', '', word)
        
        # Remove common suffixes
        word = re.sub(r'(ة|ه|ون|ين|ات|ين|ون)$', '', word)
        
        # Remove common prefixes
        word = re.sub(r'^(است|ان|تف|مست)', '', word)
        
        return word
    
    def lemmatize(self, text: str) -> List[str]:
        """
        Lemmatize Arabic text (reduce words to base forms)
        
        Args:
            text: Arabic text to lemmatize
            
        Returns:
            List of lemmatized words
        """
        words = text.split()
        lemmatized = [self.stem_word(word) for word in words]
        return lemmatized
