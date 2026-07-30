"""
DL+ Core Intelligence Module
نواة الذكاء الصناعي DL+

This module contains the core AI intelligence components for the DL+ system.
"""

__version__ = "1.0.0"
__author__ = "خليف 'ذيبان' العنزي"

from .intelligence_core import DLPlusCore
from .arabic_processor import ArabicProcessor
from .context_analyzer import ContextAnalyzer
from .model_manager import ModelManager, ModelStatus
from .integration_bridge import IntegrationBridge, ExecutionMode

__all__ = [
    'DLPlusCore', 
    'ArabicProcessor', 
    'ContextAnalyzer',
    'ModelManager',
    'ModelStatus',
    'IntegrationBridge',
    'ExecutionMode'
]
