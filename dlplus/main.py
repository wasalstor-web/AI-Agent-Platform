"""
DL+ System Main Entry Point
نقطة الدخول الرئيسية لنظام DL+

This script starts the complete DL+ system including:
- GitHub Intelligence Core
- FastAPI Connector
- Internal Execution API
"""

import asyncio
import logging
import sys
import os
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent))

from dlplus import DLPlusCore, FastAPIConnector, Settings
import uvicorn

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('dlplus.log', encoding='utf-8')
    ]
)

logger = logging.getLogger(__name__)


async def initialize_system():
    """Initialize the DL+ system"""
    logger.info("=" * 70)
    logger.info("🧠 DL+ Unified Arabic Intelligence System")
    logger.info("نظام DL+ للذكاء الصناعي العربي الموحد")
    logger.info("=" * 70)
    logger.info("")
    logger.info("المؤسس: خليف 'ذيبان' العنزي")
    logger.info("الموقع: القصيم – بريدة – المملكة العربية السعودية")
    logger.info("")
    logger.info("=" * 70)
    
    # Load settings
    logger.info("⚙️ Loading system settings...")
    settings = Settings()
    
    # Initialize core
    logger.info("🧠 Initializing Intelligence Core...")
    core = DLPlusCore()
    await core.initialize()
    
    # Initialize FastAPI connector
    logger.info("🔗 Initializing FastAPI Connector...")
    connector = FastAPIConnector(secret_key=settings.fastapi_secret_key)
    connector.core = core
    
    logger.info("✅ DL+ System initialized successfully!")
    logger.info("")
    
    return settings, core, connector


def main():
    """Main entry point"""
    try:
        # Initialize system
        settings, core, connector = asyncio.run(initialize_system())
        
        # Display system information
        logger.info("📊 System Information:")
        info = settings.get_display_info()
        for key, value in info.items():
            logger.info(f"  {key}: {value}")
        logger.info("")
        
        # Start FastAPI server
        logger.info(f"🚀 Starting FastAPI server on {settings.fastapi_host}:{settings.fastapi_port}")
        logger.info("")
        logger.info("📍 API Endpoints:")
        logger.info(f"  - Root: http://{settings.fastapi_host}:{settings.fastapi_port}/")
        logger.info(f"  - Health: http://{settings.fastapi_host}:{settings.fastapi_port}/api/health")
        logger.info(f"  - Status: http://{settings.fastapi_host}:{settings.fastapi_port}/api/status")
        logger.info(f"  - Process: http://{settings.fastapi_host}:{settings.fastapi_port}/api/process")
        logger.info(f"  - Docs: http://{settings.fastapi_host}:{settings.fastapi_port}/api/docs")
        logger.info("")
        logger.info("=" * 70)
        
        # Run the server
        uvicorn.run(
            connector.get_app(),
            host=settings.fastapi_host,
            port=settings.fastapi_port,
            log_level=settings.log_level.lower()
        )
        
    except KeyboardInterrupt:
        logger.info("\n🛑 Shutting down DL+ system...")
    except Exception as e:
        logger.error(f"❌ Error starting DL+ system: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
