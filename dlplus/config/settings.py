"""
DL+ System Settings
إعدادات نظام DL+

Main configuration settings for the DL+ system.
"""

import os
from typing import Dict, Any, Optional
from pydantic import BaseModel, Field
import yaml
import json


class Settings(BaseModel):
    """
    DL+ System Settings
    إعدادات نظام DL+
    """
    
    # System Information
    system_name: str = "DL+ Unified Arabic Intelligence System"
    system_name_arabic: str = "نظام DL+ للذكاء الصناعي العربي"
    version: str = "1.0.0"
    author: str = "خليف 'ذيبان' العنزي"
    location: str = "القصيم – بريدة – المملكة العربية السعودية"
    
    # GitHub Configuration
    github_enabled: bool = True
    github_token: Optional[str] = Field(default=None, env="GITHUB_TOKEN")
    github_repo: Optional[str] = Field(default=None, env="GITHUB_REPO")
    
    # Hostinger Configuration
    hostinger_enabled: bool = True
    hostinger_host: str = Field(default="localhost", env="HOSTINGER_HOST")
    hostinger_port: int = Field(default=8000, env="HOSTINGER_PORT")
    
    # FastAPI Configuration
    fastapi_host: str = Field(default="0.0.0.0", env="FASTAPI_HOST")
    fastapi_port: int = Field(default=8000, env="FASTAPI_PORT")
    fastapi_secret_key: str = Field(default="change-me", env="FASTAPI_SECRET_KEY")
    
    # OpenWebUI Configuration
    openwebui_enabled: bool = True
    openwebui_port: int = Field(default=3000, env="OPENWEBUI_PORT")
    openwebui_host: str = Field(default="0.0.0.0", env="OPENWEBUI_HOST")
    
    # AI Models Configuration
    models_enabled: bool = True
    default_model: str = "llama3"
    models_path: str = "./models"
    
    # Arabic Language Settings
    language: str = "ar"
    arabic_style: str = "formal"  # formal, literary, analytical, commercial
    enable_classical_arabic: bool = True
    
    # Agent Configuration
    agents_enabled: bool = True
    max_agents: int = 10
    agent_timeout: int = 300  # seconds
    
    # Context Settings
    max_context_history: int = 10
    context_window_size: int = 4096
    
    # Security Settings
    enable_authentication: bool = True
    enable_encryption: bool = True
    allowed_origins: list = ["*"]
    
    # Logging Configuration
    log_level: str = "INFO"
    log_file: str = "./logs/dlplus.log"
    enable_file_logging: bool = True
    
    # Performance Settings
    async_mode: bool = True
    max_workers: int = 4
    request_timeout: int = 60
    
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
    
    @classmethod
    def load_from_file(cls, file_path: str) -> 'Settings':
        """Load settings from YAML or JSON file"""
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"Settings file not found: {file_path}")
        
        with open(file_path, 'r', encoding='utf-8') as f:
            if file_path.endswith('.yaml') or file_path.endswith('.yml'):
                data = yaml.safe_load(f)
            elif file_path.endswith('.json'):
                data = json.load(f)
            else:
                raise ValueError("Unsupported file format. Use .yaml, .yml, or .json")
        
        return cls(**data)
    
    def save_to_file(self, file_path: str):
        """Save settings to YAML or JSON file"""
        data = self.dict()
        
        with open(file_path, 'w', encoding='utf-8') as f:
            if file_path.endswith('.yaml') or file_path.endswith('.yml'):
                yaml.dump(data, f, allow_unicode=True, default_flow_style=False)
            elif file_path.endswith('.json'):
                json.dump(data, f, ensure_ascii=False, indent=2)
            else:
                raise ValueError("Unsupported file format. Use .yaml, .yml, or .json")
    
    def get_display_info(self) -> Dict[str, Any]:
        """Get display information for the system"""
        return {
            "اسم النظام": self.system_name_arabic,
            "System Name": self.system_name,
            "الإصدار": self.version,
            "Version": self.version,
            "المؤسس": self.author,
            "Founder": self.author,
            "الموقع": self.location,
            "Location": self.location
        }
