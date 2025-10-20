"""
Context Analyzer
محلل السياق

Analyzes and maintains conversation context for better understanding.
"""

import logging
from typing import Dict, List, Any, Optional
from datetime import datetime

logger = logging.getLogger(__name__)


class ContextAnalyzer:
    """
    Context Analyzer for DL+
    محلل السياق لنظام DL+
    
    Maintains and analyzes conversation context to provide better responses.
    """
    
    def __init__(self, max_history: int = 10):
        """
        Initialize the context analyzer
        
        Args:
            max_history: Maximum number of conversation turns to keep in context
        """
        self.max_history = max_history
        self.current_topic = None
        self.user_preferences = {}
        logger.info("🔍 Context Analyzer initialized")
    
    async def analyze(
        self,
        current_input: str,
        history: List[Dict[str, Any]],
        additional_context: Optional[Dict] = None
    ) -> Dict[str, Any]:
        """
        Analyze context for the current input
        
        Args:
            current_input: Current user input
            history: Conversation history
            additional_context: Additional context information
            
        Returns:
            Context analysis dictionary
        """
        try:
            # Limit history to max_history
            recent_history = history[-self.max_history:] if history else []
            
            # Detect topic changes
            topic_changed = await self._detect_topic_change(
                current_input,
                recent_history
            )
            
            # Extract references to previous messages
            references = await self._extract_references(
                current_input,
                recent_history
            )
            
            # Analyze user intent evolution
            intent_evolution = await self._analyze_intent_evolution(
                recent_history
            )
            
            # Update current topic
            if topic_changed:
                self.current_topic = await self._extract_topic(current_input)
            
            context = {
                'timestamp': datetime.now().isoformat(),
                'current_topic': self.current_topic,
                'topic_changed': topic_changed,
                'references': references,
                'intent_evolution': intent_evolution,
                'history_size': len(recent_history),
                'user_preferences': self.user_preferences
            }
            
            # Add additional context if provided
            if additional_context:
                context.update(additional_context)
            
            return context
            
        except Exception as e:
            logger.error(f"Error analyzing context: {e}")
            return {
                'timestamp': datetime.now().isoformat(),
                'error': str(e)
            }
    
    async def _detect_topic_change(
        self,
        current_input: str,
        history: List[Dict[str, Any]]
    ) -> bool:
        """Detect if the topic has changed"""
        if not history:
            return True
        
        # Get last command
        last_command = history[-1].get('command', '')
        
        # Simple topic change detection based on keyword overlap
        current_words = set(current_input.lower().split())
        last_words = set(last_command.lower().split())
        
        # Calculate overlap
        if not last_words:
            return True
        
        overlap = len(current_words & last_words) / len(last_words)
        
        # If less than 20% overlap, consider it a topic change
        return overlap < 0.2
    
    async def _extract_references(
        self,
        current_input: str,
        history: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """Extract references to previous messages"""
        references = []
        
        # Check for reference keywords
        reference_keywords = [
            'السابق', 'سابق', 'ذلك', 'هذا', 'نفس', 'مثل',
            'previous', 'that', 'this', 'same', 'like'
        ]
        
        current_lower = current_input.lower()
        for keyword in reference_keywords:
            if keyword in current_lower:
                # Found a reference
                references.append({
                    'keyword': keyword,
                    'position': current_lower.find(keyword),
                    'likely_refers_to': 'previous_message'
                })
        
        return references
    
    async def _analyze_intent_evolution(
        self,
        history: List[Dict[str, Any]]
    ) -> Dict[str, Any]:
        """Analyze how user intent has evolved"""
        if not history:
            return {'intents': [], 'pattern': 'new_conversation'}
        
        # Extract intents from history
        intents = [item.get('intent', 'general') for item in history]
        
        # Detect patterns
        if len(set(intents)) == 1:
            pattern = 'focused'  # User staying on same topic
        elif len(intents) > 3 and len(set(intents[-3:])) == 1:
            pattern = 'converging'  # User narrowing down
        else:
            pattern = 'exploring'  # User exploring different topics
        
        return {
            'intents': intents,
            'pattern': pattern,
            'unique_intents': len(set(intents))
        }
    
    async def _extract_topic(self, text: str) -> str:
        """Extract the main topic from text"""
        # Simple topic extraction based on key nouns
        # In production, this would use NLP models
        words = text.split()
        
        # Filter out common words
        common_words = {
            'و', 'من', 'في', 'على', 'إلى', 'عن', 'مع', 'هذا', 'ذلك',
            'and', 'the', 'to', 'from', 'with', 'this', 'that'
        }
        
        topic_words = [w for w in words if w.lower() not in common_words and len(w) > 2]
        
        if topic_words:
            return ' '.join(topic_words[:3])  # First 3 significant words
        else:
            return 'general'
    
    def update_user_preferences(self, preferences: Dict[str, Any]):
        """Update user preferences"""
        self.user_preferences.update(preferences)
        logger.info(f"Updated user preferences: {list(preferences.keys())}")
    
    def get_context_summary(self, history: List[Dict[str, Any]]) -> str:
        """Get a summary of the current context"""
        if not history:
            return "محادثة جديدة"
        
        recent = history[-3:] if len(history) >= 3 else history
        intents = [item.get('intent', 'general') for item in recent]
        
        return f"السياق الحالي: {self.current_topic or 'عام'} | الأوامر الأخيرة: {', '.join(intents)}"
