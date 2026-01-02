"""
Web Retrieval Agent
وكيل البحث على الويب

Advanced agent for web search and information retrieval with real search capabilities.
"""

import logging
import asyncio
from typing import Dict, Any, List, Optional
from datetime import datetime
import httpx
from .base_agent import BaseAgent

logger = logging.getLogger(__name__)


class WebRetrievalAgent(BaseAgent):
    """
    Web Retrieval Agent - Enhanced Version
    وكيل البحث على الويب - النسخة المحسّنة
    
    Advanced web search with multiple search engines, content analysis, and filtering.
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the web retrieval agent"""
        super().__init__("Web Retrieval Agent", config)
        self.max_results = config.get('max_results', 10) if config else 10
        self.timeout = config.get('timeout', 30) if config else 30
        self.search_engines = config.get('search_engines', ['duckduckgo', 'google', 'bing']) if config else ['duckduckgo']
        self.enable_content_extraction = config.get('enable_content_extraction', True) if config else True
        self.content_cache = {}
        
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute web search with advanced features
        
        Args:
            task: Task containing:
                - 'query': Search query
                - 'filters': Optional filters (language, date, site)
                - 'search_type': 'web', 'images', 'news', 'videos'
                - 'max_results': Maximum results to return
                
        Returns:
            Enhanced search results with analysis
        """
        query = task.get('query')
        if not query:
            return {
                'success': False,
                'error': 'Query is required'
            }
        
        logger.info(f"🔍 Searching for: {query}")
        
        # Get search parameters
        search_type = task.get('search_type', 'web')
        filters = task.get('filters', {})
        max_results = task.get('max_results', self.max_results)
        
        # Perform multi-engine search
        results = await self._multi_engine_search(query, search_type, filters, max_results)
        
        # Analyze and rank results
        analyzed_results = await self._analyze_results(results, query)
        
        # Extract content if enabled
        if self.enable_content_extraction:
            enriched_results = await self._enrich_with_content(analyzed_results)
        else:
            enriched_results = analyzed_results
        
        # Generate summary
        summary = await self._generate_summary(enriched_results, query)
        
        return {
            'success': True,
            'query': query,
            'search_type': search_type,
            'results': enriched_results,
            'count': len(enriched_results),
            'summary': summary,
            'timestamp': datetime.now().isoformat(),
            'sources': list(set(r.get('source', 'unknown') for r in enriched_results))
        }
    
    async def _multi_engine_search(
        self,
        query: str,
        search_type: str,
        filters: Dict[str, Any],
        max_results: int
    ) -> List[Dict[str, Any]]:
        """
        Search using multiple engines in parallel
        
        Args:
            query: Search query
            search_type: Type of search
            filters: Search filters
            max_results: Maximum results
            
        Returns:
            Combined results from all engines
        """
        tasks = []
        
        for engine in self.search_engines:
            if engine == 'duckduckgo':
                tasks.append(self._search_duckduckgo(query, search_type, max_results))
            elif engine == 'google':
                tasks.append(self._search_google(query, search_type, filters, max_results))
            elif engine == 'bing':
                tasks.append(self._search_bing(query, search_type, filters, max_results))
        
        # Execute searches in parallel
        results_lists = await asyncio.gather(*tasks, return_exceptions=True)
        
        # Combine and deduplicate results
        all_results = []
        seen_urls = set()
        
        for results in results_lists:
            if isinstance(results, Exception):
                logger.error(f"Search error: {results}")
                continue
                
            for result in results:
                url = result.get('url', '')
                if url and url not in seen_urls:
                    seen_urls.add(url)
                    all_results.append(result)
        
        return all_results[:max_results]
    
    async def _search_duckduckgo(
        self,
        query: str,
        search_type: str,
        max_results: int
    ) -> List[Dict[str, Any]]:
        """Search using DuckDuckGo (free, no API key needed)"""
        try:
            # Use DuckDuckGo HTML search (no API key required)
            async with httpx.AsyncClient(timeout=self.timeout) as client:
                # DuckDuckGo instant answer API
                response = await client.get(
                    'https://api.duckduckgo.com/',
                    params={
                        'q': query,
                        'format': 'json',
                        'no_html': '1',
                        'skip_disambig': '1'
                    }
                )
                
                if response.status_code == 200:
                    data = response.json()
                    results = []
                    
                    # Add instant answer if available
                    if data.get('AbstractText'):
                        results.append({
                            'title': data.get('Heading', query),
                            'url': data.get('AbstractURL', ''),
                            'snippet': data.get('AbstractText', ''),
                            'source': 'duckduckgo',
                            'type': 'instant_answer',
                            'relevance': 0.95
                        })
                    
                    # Add related topics
                    for topic in data.get('RelatedTopics', [])[:max_results]:
                        if isinstance(topic, dict) and 'Text' in topic:
                            results.append({
                                'title': topic.get('Text', '').split(' - ')[0] if ' - ' in topic.get('Text', '') else query,
                                'url': topic.get('FirstURL', ''),
                                'snippet': topic.get('Text', ''),
                                'source': 'duckduckgo',
                                'type': 'related_topic',
                                'relevance': 0.85
                            })
                    
                    return results[:max_results]
                    
        except Exception as e:
            logger.error(f"DuckDuckGo search error: {e}")
            return []
    
    async def _search_google(
        self,
        query: str,
        search_type: str,
        filters: Dict[str, Any],
        max_results: int
    ) -> List[Dict[str, Any]]:
        """Search using Google Custom Search API"""
        # Note: Requires Google Custom Search API key
        # For now, return empty - implement when API key is available
        logger.info("Google search requires API key - skipping")
        return []
    
    async def _search_bing(
        self,
        query: str,
        search_type: str,
        filters: Dict[str, Any],
        max_results: int
    ) -> List[Dict[str, Any]]:
        """Search using Bing Search API"""
        # Note: Requires Bing Search API key
        # For now, return empty - implement when API key is available
        logger.info("Bing search requires API key - skipping")
        return []
    
    async def _analyze_results(
        self,
        results: List[Dict[str, Any]],
        query: str
    ) -> List[Dict[str, Any]]:
        """
        Analyze and rank search results
        
        Args:
            results: Raw search results
            query: Original query
            
        Returns:
            Analyzed and ranked results
        """
        analyzed = []
        
        for result in results:
            # Calculate relevance score
            relevance = self._calculate_relevance(result, query)
            
            # Detect language
            language = self._detect_language(result.get('snippet', ''))
            
            # Extract key phrases
            key_phrases = self._extract_key_phrases(result.get('snippet', ''))
            
            analyzed.append({
                **result,
                'relevance_score': relevance,
                'language': language,
                'key_phrases': key_phrases,
                'analyzed_at': datetime.now().isoformat()
            })
        
        # Sort by relevance
        analyzed.sort(key=lambda x: x.get('relevance_score', 0), reverse=True)
        
        return analyzed
    
    def _calculate_relevance(self, result: Dict[str, Any], query: str) -> float:
        """Calculate relevance score for a result"""
        score = result.get('relevance', 0.5)
        
        # Boost score if query terms appear in title
        title = result.get('title', '').lower()
        query_lower = query.lower()
        query_words = set(query_lower.split())
        title_words = set(title.split())
        
        if query_words:
            title_overlap = len(query_words & title_words) / len(query_words)
            score += title_overlap * 0.3
        
        # Boost score if query terms appear in snippet
        snippet = result.get('snippet', '').lower()
        snippet_words = set(snippet.split())
        if query_words:
            snippet_overlap = len(query_words & snippet_words) / len(query_words)
            score += snippet_overlap * 0.2
        
        return min(score, 1.0)
    
    def _detect_language(self, text: str) -> str:
        """Detect language of text"""
        # Simple language detection
        arabic_chars = sum(1 for char in text if '\u0600' <= char <= '\u06FF')
        total_chars = len([c for c in text if c.isalpha()])
        
        if total_chars > 0 and arabic_chars / total_chars > 0.3:
            return 'ar'
        return 'en'
    
    def _extract_key_phrases(self, text: str, max_phrases: int = 5) -> List[str]:
        """Extract key phrases from text"""
        # Simple key phrase extraction
        words = text.split()
        # Filter common words
        common_words = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by',
                       'ال', 'في', 'من', 'على', 'إلى', 'عن', 'مع', 'و', 'أو', 'لكن'}
        
        # Count word frequencies
        word_freq = {}
        for word in words:
            word_lower = word.lower().strip('.,!?;:()[]{}"\'-')
            if len(word_lower) > 3 and word_lower not in common_words:
                word_freq[word_lower] = word_freq.get(word_lower, 0) + 1
        
        # Get top phrases
        sorted_phrases = sorted(word_freq.items(), key=lambda x: x[1], reverse=True)
        return [phrase for phrase, freq in sorted_phrases[:max_phrases]]
    
    async def _enrich_with_content(
        self,
        results: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """
        Enrich results with extracted content from URLs
        
        Args:
            results: Search results
            
        Returns:
            Enriched results with content
        """
        enriched = []
        
        for result in results[:5]:  # Limit to top 5 for performance
            url = result.get('url')
            if not url:
                enriched.append(result)
                continue
            
            # Check cache
            if url in self.content_cache:
                result['extracted_content'] = self.content_cache[url]
                enriched.append(result)
                continue
            
            # Extract content
            try:
                content = await self._extract_url_content(url)
                result['extracted_content'] = content
                self.content_cache[url] = content
                
                # Limit cache size
                if len(self.content_cache) > 100:
                    # Remove oldest entry
                    oldest_key = next(iter(self.content_cache))
                    del self.content_cache[oldest_key]
                    
            except Exception as e:
                logger.warning(f"Failed to extract content from {url}: {e}")
                result['extracted_content'] = None
            
            enriched.append(result)
        
        # Add remaining results without content extraction
        enriched.extend(results[5:])
        
        return enriched
    
    async def _extract_url_content(self, url: str) -> Optional[str]:
        """
        Extract main content from a URL
        
        Args:
            url: URL to extract content from
            
        Returns:
            Extracted content or None
        """
        try:
            async with httpx.AsyncClient(timeout=10, follow_redirects=True) as client:
                response = await client.get(url, headers={
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
                })
                
                if response.status_code == 200:
                    # Simple content extraction (remove HTML tags)
                    import re
                    text = response.text
                    # Remove script and style tags
                    text = re.sub(r'<script[^>]*>.*?</script>', '', text, flags=re.DOTALL | re.IGNORECASE)
                    text = re.sub(r'<style[^>]*>.*?</style>', '', text, flags=re.DOTALL | re.IGNORECASE)
                    # Remove HTML tags
                    text = re.sub(r'<[^>]+>', ' ', text)
                    # Clean up whitespace
                    text = ' '.join(text.split())
                    # Limit length
                    return text[:2000] if len(text) > 2000 else text
                    
        except Exception as e:
            logger.error(f"Content extraction error for {url}: {e}")
            return None
        
        return None
    
    async def _generate_summary(
        self,
        results: List[Dict[str, Any]],
        query: str
    ) -> str:
        """
        Generate a summary of search results
        
        Args:
            results: Search results
            query: Original query
            
        Returns:
            Summary text
        """
        if not results:
            return f"لم يتم العثور على نتائج للبحث عن: {query}"
        
        top_results = results[:3]
        summary_parts = [f"تم العثور على {len(results)} نتيجة للبحث عن '{query}':\n"]
        
        for i, result in enumerate(top_results, 1):
            title = result.get('title', 'بدون عنوان')
            snippet = result.get('snippet', '')[:150]
            summary_parts.append(f"{i}. {title}\n   {snippet}...")
        
        return '\n'.join(summary_parts)
    
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
        
        # Add context-based filters
        filters = {}
        if 'language' in context:
            filters['language'] = context['language']
        if 'date_range' in context:
            filters['date_range'] = context['date_range']
        
        return await self.execute({
            'query': enhanced_query,
            'filters': filters
        })
    
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
    
    async def fact_check(self, claim: str) -> Dict[str, Any]:
        """
        Fact-check a claim by searching and analyzing results
        
        Args:
            claim: Claim to fact-check
            
        Returns:
            Fact-check results
        """
        logger.info(f"🔍 Fact-checking: {claim}")
        
        # Search for the claim
        search_results = await self.execute({'query': claim, 'max_results': 5})
        
        if not search_results.get('success'):
            return {
                'success': False,
                'error': 'Search failed'
            }
        
        results = search_results.get('results', [])
        
        # Analyze credibility
        credibility_score = self._calculate_credibility(results)
        
        # Determine verdict
        if credibility_score > 0.7:
            verdict = 'likely_true'
            verdict_ar = 'محتمل الصحة'
        elif credibility_score < 0.3:
            verdict = 'likely_false'
            verdict_ar = 'محتمل الخطأ'
        else:
            verdict = 'uncertain'
            verdict_ar = 'غير مؤكد'
        
        return {
            'success': True,
            'claim': claim,
            'verdict': verdict,
            'verdict_arabic': verdict_ar,
            'credibility_score': credibility_score,
            'sources': results,
            'timestamp': datetime.now().isoformat()
        }
    
    def _calculate_credibility(self, results: List[Dict[str, Any]]) -> float:
        """Calculate credibility score based on sources"""
        if not results:
            return 0.0
        
        # Simple credibility calculation
        # In production, use reputation databases
        total_score = 0.0
        count = 0
        
        for result in results:
            url = result.get('url', '')
            relevance = result.get('relevance_score', 0.5)
            
            # Check domain reputation (simplified)
            domain_trust = self._get_domain_trust(url)
            
            total_score += relevance * domain_trust
            count += 1
        
        return total_score / count if count > 0 else 0.0
    
    def _get_domain_trust(self, url: str) -> float:
        """Get trust score for a domain"""
        # Simple domain trust scoring
        trusted_domains = {
            'edu': 0.9,
            'gov': 0.9,
            'org': 0.7,
            'wikipedia.org': 0.8,
            'bbc.com': 0.8,
            'reuters.com': 0.8
        }
        
        for domain, trust in trusted_domains.items():
            if domain in url:
                return trust
        
        return 0.5  # Default trust score
