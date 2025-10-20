"""
DL+ API Module
وحدة واجهات برمجة التطبيقات

Contains API connectors for GitHub-Hostinger integration.
"""

__version__ = "1.0.0"

from .fastapi_connector import FastAPIConnector
from .internal_api import InternalExecutionAPI

__all__ = ['FastAPIConnector', 'InternalExecutionAPI']
