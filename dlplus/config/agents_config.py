"""
Agents Configuration
إعدادات الوكلاء

Configuration for AI agents used in DL+ system.
"""

from typing import Dict, Any, List
from pydantic import BaseModel


class AgentConfig(BaseModel):
    """Configuration for a single agent"""
    name: str
    name_arabic: str
    type: str  # retrieval, code, analysis, translation, execution
    enabled: bool = True
    priority: int = 5
    capabilities: List[str] = []
    tools: List[str] = []
    parameters: Dict[str, Any] = {}


class AgentsConfig:
    """
    AI Agents Configuration for DL+
    إعدادات الوكلاء الذكيين لنظام DL+
    """
    
    def __init__(self):
        """Initialize agents configuration"""
        self.agents = self._initialize_agents()
    
    def _initialize_agents(self) -> Dict[str, AgentConfig]:
        """Initialize default agents"""
        return {
            'web_retrieval': AgentConfig(
                name="Web Retrieval Agent",
                name_arabic="وكيل البحث على الويب",
                type="retrieval",
                priority=3,
                capabilities=["web_search", "information_retrieval", "fact_checking"],
                tools=["search_engine", "web_scraper", "url_parser"],
                parameters={
                    "max_results": 10,
                    "timeout": 30
                }
            ),
            'code_generator': AgentConfig(
                name="Code Generator Agent",
                name_arabic="وكيل توليد الأكواد",
                type="code",
                priority=2,
                capabilities=["code_generation", "code_review", "debugging"],
                tools=["compiler", "linter", "formatter"],
                parameters={
                    "supported_languages": ["python", "javascript", "java", "c++", "go"],
                    "max_length": 1000
                }
            ),
            'translator': AgentConfig(
                name="Translation Agent",
                name_arabic="وكيل الترجمة",
                type="translation",
                priority=4,
                capabilities=["translation", "language_detection", "transliteration"],
                tools=["translator", "language_detector"],
                parameters={
                    "source_languages": ["ar", "en", "fr", "es"],
                    "target_languages": ["ar", "en", "fr", "es"]
                }
            ),
            'analyzer': AgentConfig(
                name="Analysis Agent",
                name_arabic="وكيل التحليل",
                type="analysis",
                priority=3,
                capabilities=["data_analysis", "sentiment_analysis", "text_analysis"],
                tools=["analyzer", "visualizer", "reporter"],
                parameters={
                    "analysis_types": ["sentiment", "topic", "entity", "trend"]
                }
            ),
            'system_control': AgentConfig(
                name="System Control Agent",
                name_arabic="وكيل التحكم بالنظام",
                type="execution",
                priority=1,
                capabilities=["system_management", "file_operations", "service_control"],
                tools=["file_manager", "service_manager", "task_scheduler"],
                parameters={
                    "allowed_operations": ["read", "write", "restart", "status"]
                }
            ),
            'context_manager': AgentConfig(
                name="Context Manager Agent",
                name_arabic="وكيل إدارة السياق",
                type="management",
                priority=2,
                capabilities=["context_tracking", "memory_management", "session_control"],
                tools=["context_store", "memory_cache", "session_manager"],
                parameters={
                    "max_context_size": 10,
                    "retention_time": 3600
                }
            ),
            'learning': AgentConfig(
                name="Self-Learning Agent",
                name_arabic="وكيل التعلم الذاتي",
                type="learning",
                priority=5,
                capabilities=["self_improvement", "pattern_recognition", "adaptation"],
                tools=["learning_module", "feedback_analyzer", "model_updater"],
                parameters={
                    "learning_rate": 0.01,
                    "update_frequency": "daily"
                }
            )
        }
    
    def get_agent(self, agent_id: str) -> AgentConfig:
        """Get agent configuration by ID"""
        return self.agents.get(agent_id)
    
    def get_agents_by_type(self, agent_type: str) -> List[AgentConfig]:
        """Get all agents of a specific type"""
        return [
            agent for agent in self.agents.values()
            if agent.type == agent_type and agent.enabled
        ]
    
    def get_agents_by_capability(self, capability: str) -> List[AgentConfig]:
        """Get all agents with a specific capability"""
        return [
            agent for agent in self.agents.values()
            if capability in agent.capabilities and agent.enabled
        ]
    
    def get_enabled_agents(self) -> List[AgentConfig]:
        """Get all enabled agents"""
        return [agent for agent in self.agents.values() if agent.enabled]
    
    def get_agents_info(self) -> Dict[str, Any]:
        """Get information about all agents"""
        return {
            agent_id: {
                "name": agent.name,
                "name_arabic": agent.name_arabic,
                "type": agent.type,
                "enabled": agent.enabled,
                "capabilities": agent.capabilities,
                "tools": agent.tools
            }
            for agent_id, agent in self.agents.items()
        }
