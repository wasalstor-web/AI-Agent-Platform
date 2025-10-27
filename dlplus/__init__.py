"""
DL+ Unified Arabic Intelligence System
نظام DL+ للذكاء الصناعي العربي الموحد

Main entry point for the DL+ system.

Author: خليف "ذيبان" العنزي
Location: القصيم – بريدة – المملكة العربية السعودية
"""

__version__ = "1.0.0"
__author__ = "خليف 'ذيبان' العنزي"

# Core components
from .core import (
    DLPlusCore, 
    ArabicProcessor, 
    ContextAnalyzer,
    ModelManager,
    ModelStatus,
    IntegrationBridge,
    ExecutionMode
)

# API components
from .api import FastAPIConnector, InternalExecutionAPI

# Configuration
from .config import Settings, ModelsConfig, AgentsConfig

__all__ = [
    'DLPlusCore',
    'ArabicProcessor', 
    'ContextAnalyzer',
    'ModelManager',
    'ModelStatus',
    'IntegrationBridge',
    'ExecutionMode',
    'FastAPIConnector',
    'InternalExecutionAPI',
    'Settings',
    'ModelsConfig',
    'AgentsConfig'
]
