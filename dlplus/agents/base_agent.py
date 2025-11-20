"""
Base Agent
الوكيل الأساسي

Base class for all DL+ agents.
"""

import logging
from abc import ABC, abstractmethod
from typing import Dict, Any, Optional, List
from datetime import datetime

logger = logging.getLogger(__name__)


class BaseAgent(ABC):
    """
    Base Agent for DL+ System
    الوكيل الأساسي لنظام DL+
    
    All agents must inherit from this class.
    """
    
    def __init__(self, name: str, config: Optional[Dict[str, Any]] = None):
        """
        Initialize the agent
        
        Args:
            name: Agent name
            config: Agent configuration
        """
        self.name = name
        self.config = config or {}
        self.enabled = True
        self.execution_count = 0
        self.last_execution = None
        self.model_manager = None  # Will be set by integration bridge
        self.preferred_models = []  # Preferred models for this agent
        
        logger.info(f"🤖 Agent '{name}' initialized")
    
    @abstractmethod
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute a task
        
        Args:
            task: Task dictionary with parameters
            
        Returns:
            Result dictionary
        """
        pass
    
    async def run(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Run the agent with error handling
        
        Args:
            task: Task to execute
            
        Returns:
            Execution result
        """
        if not self.enabled:
            return {
                'success': False,
                'error': 'Agent is disabled',
                'agent': self.name
            }
        
        try:
            logger.info(f"🚀 Running agent '{self.name}'")
            
            # Execute the task
            result = await self.execute(task)
            
            # Update metrics
            self.execution_count += 1
            self.last_execution = datetime.now().isoformat()
            
            # Add metadata
            result['agent'] = self.name
            result['execution_count'] = self.execution_count
            result['timestamp'] = self.last_execution
            
            logger.info(f"✅ Agent '{self.name}' completed successfully")
            
            return result
            
        except Exception as e:
            logger.error(f"❌ Agent '{self.name}' failed: {e}")
            return {
                'success': False,
                'error': str(e),
                'agent': self.name,
                'timestamp': datetime.now().isoformat()
            }
    
    def enable(self):
        """Enable the agent"""
        self.enabled = True
        logger.info(f"✅ Agent '{self.name}' enabled")
    
    def disable(self):
        """Disable the agent"""
        self.enabled = False
        logger.info(f"⏸️  Agent '{self.name}' disabled")
    
    def get_status(self) -> Dict[str, Any]:
        """Get agent status"""
        return {
            'name': self.name,
            'enabled': self.enabled,
            'execution_count': self.execution_count,
            'last_execution': self.last_execution,
            'config': self.config,
            'has_model_manager': self.model_manager is not None,
            'preferred_models': self.preferred_models
        }
    
    def set_model_manager(self, model_manager: Any):
        """
        Set the model manager for AI model integration
        
        Args:
            model_manager: ModelManager instance
        """
        self.model_manager = model_manager
        logger.info(f"🔗 Model Manager connected to agent '{self.name}'")
    
    def set_preferred_models(self, models: List[str]):
        """
        Set preferred models for this agent
        
        Args:
            models: List of model IDs
        """
        self.preferred_models = models
        logger.info(f"📋 Agent '{self.name}' preferred models: {models}")
    
    async def use_model(
        self,
        model_id: str,
        input_text: str,
        parameters: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Use an AI model from within the agent
        
        Args:
            model_id: Model identifier
            input_text: Input text for the model
            parameters: Optional inference parameters
            
        Returns:
            Model inference result
        """
        if not self.model_manager:
            return {
                'success': False,
                'error': 'No model manager connected to this agent'
            }
        
        return await self.model_manager.inference(model_id, input_text, parameters)
    
    def __repr__(self) -> str:
        return f"<{self.__class__.__name__} name='{self.name}' enabled={self.enabled}>"
