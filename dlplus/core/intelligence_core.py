"""
DL+ Intelligence Core
نواة الذكاء الصناعي DL+

The main intelligence engine that coordinates all AI models and agents.
"""

import asyncio
import logging
from typing import Dict, List, Any, Optional
from datetime import datetime

logger = logging.getLogger(__name__)


class DLPlusCore:
    """
    DL+ Core Intelligence Engine
    محرك الذكاء الرئيسي لنظام DL+
    
    This is the main brain of the system that:
    - Analyzes user commands in Arabic
    - Selects appropriate models/agents
    - Coordinates execution
    - Generates unified responses in classical Arabic
    """
    
    def __init__(self, config: Optional[Dict[str, Any]] = None):
        """
        Initialize the DL+ Core
        
        Args:
            config: Configuration dictionary for the core system
        """
        self.config = config or {}
        self.models = {}
        self.agents = {}
        self.context_history = []
        self.initialized = False
        self.model_manager = None
        self.integration_bridge = None
        
        logger.info("🧠 DL+ Core Intelligence Engine initializing...")
        
    async def initialize(self):
        """Initialize all AI models and agents"""
        try:
            logger.info("⚡ تحميل النماذج والوكلاء...")
            
            # Initialize Arabic language processor
            from .arabic_processor import ArabicProcessor
            self.arabic_processor = ArabicProcessor()
            
            # Initialize context analyzer
            from .context_analyzer import ContextAnalyzer
            self.context_analyzer = ContextAnalyzer()
            
            # Initialize model manager
            from .model_manager import ModelManager
            from ..config import ModelsConfig
            models_config = ModelsConfig()
            self.model_manager = ModelManager(models_config)
            
            # Load available models
            await self._load_models()
            
            # Initialize integration bridge
            from .integration_bridge import IntegrationBridge
            self.integration_bridge = IntegrationBridge(
                self.model_manager,
                self.agents
            )
            
            # Initialize agents
            await self._initialize_agents()
            
            # Connect model manager to agents
            self._connect_agents_to_models()
            
            self.initialized = True
            logger.info("✅ DL+ Core initialized successfully")
            
        except Exception as e:
            logger.error(f"❌ Error initializing DL+ Core: {e}")
            raise
    
    async def _load_models(self):
        """Load AI models"""
        logger.info("📚 Loading AI models...")
        
        # Preload essential models
        essential_models = ['llama3', 'arabert', 'deepseek']
        results = await self.model_manager.preload_models(essential_models)
        
        loaded_count = sum(1 for success in results.values() if success)
        logger.info(f"📚 Loaded {loaded_count}/{len(essential_models)} essential AI models")
        
        # Update models dictionary
        self.models = self.model_manager.get_all_models_info()
    
    async def _initialize_agents(self):
        """Initialize AI agents"""
        logger.info("🤖 Initializing AI agents...")
        
        # Import agent classes
        from ..agents import WebRetrievalAgent, CodeGeneratorAgent
        
        # Create agent instances
        web_agent = WebRetrievalAgent()
        code_agent = CodeGeneratorAgent()
        
        # Store agents
        self.agents = {
            'web_retrieval': web_agent,
            'code_generator': code_agent
        }
        
        # Register agents with integration bridge
        if self.integration_bridge:
            for agent_name, agent in self.agents.items():
                self.integration_bridge.register_agent(agent_name, agent)
        
        logger.info(f"🤖 Initialized {len(self.agents)} agents")
    
    def _connect_agents_to_models(self):
        """Connect model manager to all agents"""
        for agent_name, agent in self.agents.items():
            agent.set_model_manager(self.model_manager)
            logger.info(f"🔗 Connected model manager to agent '{agent_name}'")
    
    async def process_command(self, command: str, context: Optional[Dict] = None) -> Dict[str, Any]:
        """
        Process user command in Arabic
        معالجة أمر المستخدم بالعربية
        
        Args:
            command: User command in Arabic
            context: Optional context information
            
        Returns:
            Response dictionary with results
        """
        if not self.initialized:
            await self.initialize()
        
        try:
            # Analyze the command
            analysis = await self.arabic_processor.analyze(command)
            
            # Extract intent and entities
            intent = analysis.get('intent', 'general')
            entities = analysis.get('entities', [])
            
            # Update context
            current_context = await self.context_analyzer.analyze(
                command, 
                self.context_history,
                context
            )
            
            # Select appropriate model/agent
            selected_executor = await self._select_executor(intent, entities)
            
            # Execute the command
            result = await self._execute_command(
                command,
                selected_executor,
                current_context
            )
            
            # Generate response in classical Arabic
            response = await self._generate_response(result, current_context)
            
            # Update history
            self.context_history.append({
                'timestamp': datetime.now().isoformat(),
                'command': command,
                'intent': intent,
                'response': response
            })
            
            return {
                'success': True,
                'response': response,
                'intent': intent,
                'executor': selected_executor,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"❌ Error processing command: {e}")
            return {
                'success': False,
                'error': str(e),
                'response': f"عذراً، حدث خطأ أثناء معالجة الأمر: {str(e)}",
                'timestamp': datetime.now().isoformat()
            }
    
    async def _select_executor(self, intent: str, entities: List[str]) -> str:
        """Select the appropriate executor (model or agent)"""
        # Simple intent-based routing
        executor_map = {
            'code': 'code_generator',
            'search': 'web_retrieval',
            'translate': 'translator',
            'analyze': 'analyzer',
            'general': 'llama3'
        }
        return executor_map.get(intent, 'llama3')
    
    async def _execute_command(
        self,
        command: str,
        executor: str,
        context: Dict
    ) -> Dict[str, Any]:
        """Execute the command using the selected executor"""
        try:
            # Check if executor is an agent
            if executor in self.agents:
                agent = self.agents[executor]
                result = await agent.run({
                    'input': command,
                    'context': context
                })
                return {
                    'executor': executor,
                    'executor_type': 'agent',
                    'result': result,
                    'status': 'completed'
                }
            
            # Otherwise, use model through integration bridge
            elif self.integration_bridge:
                result = await self.integration_bridge.execute_with_model(
                    executor,
                    {'input': command},
                    None
                )
                return {
                    'executor': executor,
                    'executor_type': 'model',
                    'result': result,
                    'status': 'completed'
                }
            
            # Fallback
            return {
                'executor': executor,
                'result': f"نتيجة تنفيذ الأمر: {command}",
                'status': 'completed'
            }
            
        except Exception as e:
            logger.error(f"❌ Error executing command: {e}")
            return {
                'executor': executor,
                'error': str(e),
                'status': 'failed'
            }
    
    async def _generate_response(
        self,
        result: Dict[str, Any],
        context: Dict
    ) -> str:
        """Generate response in classical Arabic"""
        # Placeholder for response generation
        # In production, this would use language models to generate proper Arabic
        base_response = result.get('result', 'تم تنفيذ الأمر بنجاح')
        return f"{base_response}\n\nتم التنفيذ بنجاح بواسطة نظام DL+ للذكاء الصناعي."
    
    async def get_status(self) -> Dict[str, Any]:
        """Get system status"""
        status = {
            'initialized': self.initialized,
            'context_history_size': len(self.context_history),
            'timestamp': datetime.now().isoformat()
        }
        
        # Add model manager status
        if self.model_manager:
            status['models'] = {
                'loaded': len(self.model_manager.get_loaded_models()),
                'loaded_models': self.model_manager.get_loaded_models()
            }
        else:
            status['models'] = {'loaded': 0}
        
        # Add agent status
        if self.agents:
            status['agents'] = {
                'count': len(self.agents),
                'agents': [
                    agent.get_status() for agent in self.agents.values()
                ]
            }
        else:
            status['agents'] = {'count': 0}
        
        # Add integration bridge status
        if self.integration_bridge:
            status['integration'] = self.integration_bridge.get_statistics()
        
        return status
    
    async def shutdown(self):
        """Shutdown the core system"""
        logger.info("🔌 Shutting down DL+ Core...")
        
        # Shutdown model manager
        if self.model_manager:
            await self.model_manager.shutdown()
        
        self.initialized = False
        logger.info("✅ DL+ Core shutdown complete")
