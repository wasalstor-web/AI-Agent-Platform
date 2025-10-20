"""
FastAPI Connector
موصل FastAPI

Gateway between GitHub Intelligence Core and Hostinger.
"""

from fastapi import FastAPI, HTTPException, Header, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict, Any, Optional
import logging
import hashlib
import hmac
from datetime import datetime

logger = logging.getLogger(__name__)


class CommandRequest(BaseModel):
    """Request model for commands"""
    command: str
    context: Optional[Dict[str, Any]] = None
    user_id: Optional[str] = None
    session_id: Optional[str] = None


class CommandResponse(BaseModel):
    """Response model for commands"""
    success: bool
    response: str
    intent: Optional[str] = None
    executor: Optional[str] = None
    timestamp: str
    error: Optional[str] = None


class StatusResponse(BaseModel):
    """System status response"""
    status: str
    initialized: bool
    models: int
    agents: int
    timestamp: str


class FastAPIConnector:
    """
    FastAPI Connector for DL+ System
    موصل FastAPI لنظام DL+
    
    This is the official gateway for communication between:
    - GitHub Intelligence Core
    - Hostinger execution environment
    - OpenWebUI interface
    """
    
    def __init__(self, secret_key: str):
        """
        Initialize FastAPI connector
        
        Args:
            secret_key: Secret key for authentication
        """
        self.app = FastAPI(
            title="DL+ FastAPI Connector",
            description="بوابة التنفيذ الرسمية لنظام DL+",
            version="1.0.0",
            docs_url="/api/docs",
            redoc_url="/api/redoc"
        )
        
        self.secret_key = secret_key
        self.core = None
        
        # Add CORS middleware
        self.app.add_middleware(
            CORSMiddleware,
            allow_origins=["*"],  # Configure based on your needs
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )
        
        # Setup routes
        self._setup_routes()
        
        logger.info("🔗 FastAPI Connector initialized")
    
    def verify_signature(self, signature: str, payload: str) -> bool:
        """Verify request signature"""
        expected = hmac.new(
            self.secret_key.encode(),
            payload.encode(),
            hashlib.sha256
        ).hexdigest()
        return hmac.compare_digest(signature, expected)
    
    async def get_api_key(self, x_api_key: str = Header(None)) -> str:
        """Dependency for API key verification"""
        if not x_api_key:
            raise HTTPException(status_code=401, detail="API key required")
        
        # In production, verify against database
        # For now, simple check
        if x_api_key != self.secret_key:
            raise HTTPException(status_code=401, detail="Invalid API key")
        
        return x_api_key
    
    def _setup_routes(self):
        """Setup API routes"""
        
        @self.app.get("/")
        async def root():
            """Root endpoint"""
            return {
                "name": "DL+ FastAPI Connector",
                "version": "1.0.0",
                "description": "بوابة التنفيذ الرسمية لنظام DL+",
                "status": "active",
                "endpoints": {
                    "process": "/api/process",
                    "status": "/api/status",
                    "health": "/api/health"
                }
            }
        
        @self.app.get("/api/health")
        async def health_check():
            """Health check endpoint"""
            return {
                "status": "healthy",
                "timestamp": datetime.now().isoformat()
            }
        
        @self.app.get("/api/status", response_model=StatusResponse)
        async def get_status(api_key: str = Depends(self.get_api_key)):
            """Get system status"""
            if not self.core:
                return StatusResponse(
                    status="not_initialized",
                    initialized=False,
                    models=0,
                    agents=0,
                    timestamp=datetime.now().isoformat()
                )
            
            status = await self.core.get_status()
            return StatusResponse(
                status="operational",
                initialized=status['initialized'],
                models=status['models'],
                agents=status['agents'],
                timestamp=status['timestamp']
            )
        
        @self.app.post("/api/process", response_model=CommandResponse)
        async def process_command(
            request: CommandRequest,
            api_key: str = Depends(self.get_api_key)
        ):
            """
            Process user command through DL+ Intelligence Core
            معالجة أمر المستخدم عبر نواة الذكاء DL+
            """
            try:
                if not self.core:
                    # Initialize core if not already done
                    from dlplus.core import DLPlusCore
                    self.core = DLPlusCore()
                    await self.core.initialize()
                
                # Process the command
                result = await self.core.process_command(
                    request.command,
                    request.context
                )
                
                return CommandResponse(
                    success=result['success'],
                    response=result['response'],
                    intent=result.get('intent'),
                    executor=result.get('executor'),
                    timestamp=result['timestamp'],
                    error=result.get('error')
                )
                
            except Exception as e:
                logger.error(f"Error processing command: {e}")
                return CommandResponse(
                    success=False,
                    response=f"عذراً، حدث خطأ: {str(e)}",
                    timestamp=datetime.now().isoformat(),
                    error=str(e)
                )
        
        @self.app.post("/api/github/execute")
        async def execute_from_github(
            request: Dict[str, Any],
            api_key: str = Depends(self.get_api_key)
        ):
            """
            Receive execution commands from GitHub
            استقبال أوامر التنفيذ من GitHub
            """
            try:
                command_type = request.get('type', 'unknown')
                payload = request.get('payload', {})
                
                logger.info(f"📨 Received command from GitHub: {command_type}")
                
                # Route to internal execution API
                from .internal_api import InternalExecutionAPI
                internal_api = InternalExecutionAPI()
                
                result = await internal_api.execute(command_type, payload)
                
                return {
                    'success': True,
                    'result': result,
                    'timestamp': datetime.now().isoformat()
                }
                
            except Exception as e:
                logger.error(f"Error executing GitHub command: {e}")
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.post("/api/hostinger/report")
        async def report_to_github(
            request: Dict[str, Any],
            api_key: str = Depends(self.get_api_key)
        ):
            """
            Send reports from Hostinger to GitHub
            إرسال تقارير من Hostinger إلى GitHub
            """
            try:
                event_type = request.get('event', 'unknown')
                data = request.get('data', {})
                
                logger.info(f"📤 Sending report to GitHub: {event_type}")
                
                # In production, this would send to GitHub webhook/API
                return {
                    'success': True,
                    'event': event_type,
                    'acknowledged': True,
                    'timestamp': datetime.now().isoformat()
                }
                
            except Exception as e:
                logger.error(f"Error sending report: {e}")
                raise HTTPException(status_code=500, detail=str(e))
    
    def get_app(self) -> FastAPI:
        """Get the FastAPI application"""
        return self.app
