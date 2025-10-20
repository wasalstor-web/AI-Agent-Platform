"""
AI Models Configuration
إعدادات نماذج الذكاء الصناعي

Configuration for AI models used in DL+ system.
"""

from typing import Dict, Any, List
from pydantic import BaseModel


class ModelConfig(BaseModel):
    """Configuration for a single AI model"""
    name: str
    name_arabic: str
    type: str  # language, vision, audio, multimodal
    provider: str  # huggingface, openai, local, etc.
    model_id: str
    enabled: bool = True
    priority: int = 1  # Lower number = higher priority
    capabilities: List[str] = []
    parameters: Dict[str, Any] = {}


class ModelsConfig:
    """
    AI Models Configuration for DL+
    إعدادات نماذج الذكاء الصناعي لنظام DL+
    """
    
    def __init__(self):
        """Initialize models configuration"""
        self.models = self._initialize_models()
    
    def _initialize_models(self) -> Dict[str, ModelConfig]:
        """Initialize default models"""
        return {
            'arabert': ModelConfig(
                name="AraBERT",
                name_arabic="أرابرت",
                type="language",
                provider="huggingface",
                model_id="aubmindlab/bert-base-arabertv2",
                capabilities=["text_understanding", "arabic_nlp", "sentiment_analysis"],
                parameters={
                    "max_length": 512,
                    "temperature": 0.7
                }
            ),
            'camelbert': ModelConfig(
                name="CAMeLBERT",
                name_arabic="كاملبرت",
                type="language",
                provider="huggingface",
                model_id="CAMeL-Lab/bert-base-arabic-camelbert-mix",
                capabilities=["text_understanding", "arabic_nlp", "ner"],
                parameters={
                    "max_length": 512,
                    "temperature": 0.7
                }
            ),
            'qwen_arabic': ModelConfig(
                name="Qwen 2.5 Arabic",
                name_arabic="كوين 2.5 العربي",
                type="language",
                provider="huggingface",
                model_id="Qwen/Qwen2.5-7B",
                capabilities=["text_generation", "arabic_understanding", "reasoning"],
                parameters={
                    "max_length": 4096,
                    "temperature": 0.8,
                    "top_p": 0.9
                }
            ),
            'llama3': ModelConfig(
                name="LLaMA 3",
                name_arabic="لاما 3",
                type="language",
                provider="huggingface",
                model_id="meta-llama/Meta-Llama-3-8B",
                priority=1,
                capabilities=["text_generation", "reasoning", "coding", "multilingual"],
                parameters={
                    "max_length": 8192,
                    "temperature": 0.7,
                    "top_p": 0.9
                }
            ),
            'deepseek': ModelConfig(
                name="DeepSeek",
                name_arabic="ديب سييك",
                type="language",
                provider="huggingface",
                model_id="deepseek-ai/deepseek-coder-6.7b-base",
                capabilities=["coding", "reasoning", "problem_solving"],
                parameters={
                    "max_length": 4096,
                    "temperature": 0.7
                }
            ),
            'mistral': ModelConfig(
                name="Mistral",
                name_arabic="ميسترال",
                type="language",
                provider="huggingface",
                model_id="mistralai/Mistral-7B-v0.1",
                capabilities=["text_generation", "reasoning", "multilingual"],
                parameters={
                    "max_length": 4096,
                    "temperature": 0.7
                }
            )
        }
    
    def get_model(self, model_id: str) -> ModelConfig:
        """Get model configuration by ID"""
        return self.models.get(model_id)
    
    def get_models_by_capability(self, capability: str) -> List[ModelConfig]:
        """Get all models with a specific capability"""
        return [
            model for model in self.models.values()
            if capability in model.capabilities and model.enabled
        ]
    
    def get_enabled_models(self) -> List[ModelConfig]:
        """Get all enabled models"""
        return [model for model in self.models.values() if model.enabled]
    
    def get_models_info(self) -> Dict[str, Any]:
        """Get information about all models"""
        return {
            model_id: {
                "name": model.name,
                "name_arabic": model.name_arabic,
                "type": model.type,
                "enabled": model.enabled,
                "capabilities": model.capabilities
            }
            for model_id, model in self.models.items()
        }
