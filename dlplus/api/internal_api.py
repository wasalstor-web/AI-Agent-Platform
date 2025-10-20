"""
Internal Execution API
واجهة التنفيذ الداخلية

Internal API for executing commands within Hostinger environment.
"""

import logging
import os
import subprocess
from typing import Dict, Any, List
from datetime import datetime
import json

logger = logging.getLogger(__name__)


class InternalExecutionAPI:
    """
    Internal Execution API for Hostinger
    واجهة التنفيذ الداخلية في Hostinger
    
    Handles command execution within Hostinger with security restrictions.
    """
    
    def __init__(self):
        """Initialize the internal execution API"""
        # Whitelist of allowed commands
        self.allowed_commands = {
            'file_create', 'file_update', 'file_read', 'file_delete',
            'service_restart', 'log_view', 'status_check',
            'openwebui_manage', 'backup_create'
        }
        
        # Command execution log
        self.execution_log = []
        
        logger.info("⚡ Internal Execution API initialized")
    
    async def execute(self, command_type: str, payload: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute a command with security checks
        
        Args:
            command_type: Type of command to execute
            payload: Command payload
            
        Returns:
            Execution result
        """
        try:
            # Verify command is allowed
            if command_type not in self.allowed_commands:
                raise ValueError(f"Command '{command_type}' is not whitelisted")
            
            # Log the execution attempt
            log_entry = {
                'timestamp': datetime.now().isoformat(),
                'command_type': command_type,
                'payload': payload,
                'status': 'pending'
            }
            
            # Route to appropriate handler
            handler = getattr(self, f"_handle_{command_type}", None)
            if not handler:
                raise ValueError(f"No handler found for command: {command_type}")
            
            # Execute the command
            result = await handler(payload)
            
            # Update log
            log_entry['status'] = 'completed'
            log_entry['result'] = result
            self.execution_log.append(log_entry)
            
            # Keep only last 100 entries
            if len(self.execution_log) > 100:
                self.execution_log = self.execution_log[-100:]
            
            return result
            
        except Exception as e:
            logger.error(f"Error executing command: {e}")
            log_entry['status'] = 'failed'
            log_entry['error'] = str(e)
            self.execution_log.append(log_entry)
            
            return {
                'success': False,
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }
    
    async def _handle_file_create(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle file creation"""
        try:
            path = payload.get('path')
            content = payload.get('content', '')
            
            if not path:
                raise ValueError("File path is required")
            
            # Security check: prevent path traversal
            if '..' in path or path.startswith('/'):
                raise ValueError("Invalid file path")
            
            # Create file
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return {
                'success': True,
                'action': 'file_created',
                'path': path,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"File creation failed: {e}")
    
    async def _handle_file_update(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle file update"""
        try:
            path = payload.get('path')
            content = payload.get('content', '')
            
            if not path:
                raise ValueError("File path is required")
            
            # Security check
            if '..' in path or path.startswith('/'):
                raise ValueError("Invalid file path")
            
            # Check if file exists
            if not os.path.exists(path):
                raise FileNotFoundError(f"File not found: {path}")
            
            # Update file
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return {
                'success': True,
                'action': 'file_updated',
                'path': path,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"File update failed: {e}")
    
    async def _handle_file_read(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle file reading"""
        try:
            path = payload.get('path')
            
            if not path:
                raise ValueError("File path is required")
            
            # Security check
            if '..' in path or path.startswith('/'):
                raise ValueError("Invalid file path")
            
            # Read file
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            return {
                'success': True,
                'action': 'file_read',
                'path': path,
                'content': content,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"File read failed: {e}")
    
    async def _handle_file_delete(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle file deletion"""
        try:
            path = payload.get('path')
            
            if not path:
                raise ValueError("File path is required")
            
            # Security check
            if '..' in path or path.startswith('/'):
                raise ValueError("Invalid file path")
            
            # Delete file
            if os.path.exists(path):
                os.remove(path)
            
            return {
                'success': True,
                'action': 'file_deleted',
                'path': path,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"File deletion failed: {e}")
    
    async def _handle_service_restart(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle service restart"""
        try:
            service = payload.get('service')
            
            if not service:
                raise ValueError("Service name is required")
            
            # Whitelist of allowed services
            allowed_services = ['openwebui', 'nginx', 'ollama']
            
            if service not in allowed_services:
                raise ValueError(f"Service '{service}' is not allowed")
            
            logger.info(f"🔄 Restarting service: {service}")
            
            # In production, this would restart the actual service
            # For now, just simulate
            return {
                'success': True,
                'action': 'service_restarted',
                'service': service,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"Service restart failed: {e}")
    
    async def _handle_log_view(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle log viewing"""
        try:
            log_type = payload.get('log_type', 'execution')
            lines = payload.get('lines', 50)
            
            if log_type == 'execution':
                # Return last N execution log entries
                recent_logs = self.execution_log[-lines:]
                return {
                    'success': True,
                    'action': 'log_viewed',
                    'log_type': log_type,
                    'logs': recent_logs,
                    'timestamp': datetime.now().isoformat()
                }
            else:
                return {
                    'success': True,
                    'action': 'log_viewed',
                    'log_type': log_type,
                    'logs': [],
                    'message': 'Log type not implemented',
                    'timestamp': datetime.now().isoformat()
                }
            
        except Exception as e:
            raise Exception(f"Log viewing failed: {e}")
    
    async def _handle_status_check(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle status check"""
        try:
            return {
                'success': True,
                'action': 'status_checked',
                'status': 'operational',
                'execution_log_size': len(self.execution_log),
                'allowed_commands': list(self.allowed_commands),
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"Status check failed: {e}")
    
    async def _handle_openwebui_manage(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle OpenWebUI management"""
        try:
            action = payload.get('action')
            
            if not action:
                raise ValueError("Action is required")
            
            allowed_actions = ['start', 'stop', 'restart', 'status']
            
            if action not in allowed_actions:
                raise ValueError(f"Action '{action}' is not allowed")
            
            logger.info(f"🎨 Managing OpenWebUI: {action}")
            
            # In production, this would manage the actual OpenWebUI service
            return {
                'success': True,
                'action': f'openwebui_{action}',
                'service': 'openwebui',
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"OpenWebUI management failed: {e}")
    
    async def _handle_backup_create(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Handle backup creation"""
        try:
            backup_type = payload.get('type', 'full')
            
            logger.info(f"💾 Creating backup: {backup_type}")
            
            # In production, this would create actual backups
            backup_name = f"backup-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
            
            return {
                'success': True,
                'action': 'backup_created',
                'backup_type': backup_type,
                'backup_name': backup_name,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"Backup creation failed: {e}")
    
    def get_execution_log(self, limit: int = 50) -> List[Dict[str, Any]]:
        """Get execution log"""
        return self.execution_log[-limit:]
