#!/usr/bin/env python3
"""
GitHub Commander Script for Hostinger Server Integration
Executes commands on Hostinger server at 72.61.178.135:8000
Supports 9 command types with retry logic and permanent connection
"""

import requests
import logging
import time
import sys
import os
import json
from typing import Dict, Any, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('github-commander.log')
    ]
)

# Configuration - can be overridden by environment variables
HOSTINGER_SERVER = os.getenv('HOSTINGER_SERVER', '72.61.178.135:8000')
API_URL = f'http://{HOSTINGER_SERVER}'
API_KEY = os.getenv('HOSTINGER_API_KEY', 'aip_bb1dc27e182e83edcf6ea1e6b989d3c8d32d0e54a00b26f39cfda657fc493cea')
RETRY_LIMIT = int(os.getenv('RETRY_LIMIT', '5'))
RETRY_DELAY = int(os.getenv('RETRY_DELAY', '3'))
CONNECTION_TIMEOUT = int(os.getenv('CONNECTION_TIMEOUT', '30'))

# Supported command types
SUPPORTED_COMMANDS = [
    'file_create',
    'file_read',
    'file_update',
    'file_delete',
    'service_restart',
    'openwebui_manage',
    'log_view',
    'status_check',
    'backup_create'
]

def send_command(command_type: str, payload: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    """
    Send command to Hostinger server with retry logic and exponential backoff.
    
    Args:
        command_type: Type of command to execute (one of SUPPORTED_COMMANDS)
        payload: Command payload with parameters
        
    Returns:
        Response dictionary or None if all retries failed
    """
    if command_type not in SUPPORTED_COMMANDS:
        logging.error(f"Unsupported command type: {command_type}")
        logging.info(f"Supported commands: {', '.join(SUPPORTED_COMMANDS)}")
        return None
    
    url = f"{API_URL}/api/github/execute"
    headers = {
        'X-API-Key': API_KEY,
        'Content-Type': 'application/json'
    }
    data = {
        'type': command_type,
        'payload': payload
    }
    
    logging.info(f"Executing command: {command_type}")
    logging.debug(f"Payload: {json.dumps(payload, indent=2)}")
    
    for attempt in range(RETRY_LIMIT):
        try:
            # Exponential backoff for retries
            if attempt > 0:
                delay = RETRY_DELAY * (2 ** (attempt - 1))
                logging.info(f"Retry attempt {attempt + 1}/{RETRY_LIMIT} after {delay}s delay")
                time.sleep(delay)
            
            response = requests.post(
                url,
                json=data,
                headers=headers,
                timeout=CONNECTION_TIMEOUT
            )
            
            response.raise_for_status()
            result = response.json()
            
            logging.info(f"✓ Command executed successfully")
            logging.debug(f"Response: {json.dumps(result, indent=2)}")
            
            return result
            
        except requests.exceptions.Timeout:
            logging.error(f"✗ Attempt {attempt + 1} timed out after {CONNECTION_TIMEOUT}s")
        except requests.exceptions.ConnectionError as e:
            logging.error(f"✗ Attempt {attempt + 1} connection failed: {e}")
        except requests.exceptions.HTTPError as e:
            logging.error(f"✗ Attempt {attempt + 1} HTTP error: {e}")
            # Don't retry on 4xx errors (client errors)
            if response.status_code < 500:
                logging.error("Client error - not retrying")
                return None
        except requests.exceptions.RequestException as e:
            logging.error(f"✗ Attempt {attempt + 1} failed: {e}")
        except json.JSONDecodeError as e:
            logging.error(f"✗ Invalid JSON response: {e}")
    
    logging.error(f"✗ All {RETRY_LIMIT} attempts failed for command: {command_type}")
    return None

def check_server_health() -> bool:
    """
    Check if Hostinger server is healthy and reachable.
    
    Returns:
        True if server is healthy, False otherwise
    """
    try:
        url = f"{API_URL}/api/health"
        response = requests.get(url, timeout=10)
        
        if response.status_code == 200:
            health_data = response.json()
            logging.info(f"✓ Server is healthy: {health_data}")
            return True
        else:
            logging.warning(f"Server returned status code: {response.status_code}")
            return False
            
    except Exception as e:
        logging.error(f"✗ Server health check failed: {e}")
        return False

def execute_command_from_args():
    """
    Execute command from command line arguments.
    Usage: python github-commander.py <command_type> <payload_json>
    """
    if len(sys.argv) < 3:
        print("Usage: python github-commander.py <command_type> <payload_json>")
        print(f"\nSupported command types:")
        for cmd in SUPPORTED_COMMANDS:
            print(f"  - {cmd}")
        print("\nExample:")
        print('  python github-commander.py status_check \'{}\'')
        print('  python github-commander.py file_create \'{"path": "test.txt", "content": "Hello"}\'')
        sys.exit(1)
    
    command_type = sys.argv[1]
    
    try:
        payload = json.loads(sys.argv[2])
    except json.JSONDecodeError as e:
        logging.error(f"Invalid JSON payload: {e}")
        sys.exit(1)
    
    # Check server health first
    if not check_server_health():
        logging.warning("Server health check failed, but attempting to execute command anyway...")
    
    # Execute command
    result = send_command(command_type, payload)
    
    if result:
        print(json.dumps(result, indent=2))
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        execute_command_from_args()
    else:
        # Interactive mode
        print("GitHub Commander - Interactive Mode")
        print(f"Server: {API_URL}")
        print(f"\nSupported commands:")
        for i, cmd in enumerate(SUPPORTED_COMMANDS, 1):
            print(f"  {i}. {cmd}")
        
        # Check server health
        print("\nChecking server health...")
        check_server_health()
        
        print("\nEnter command type and payload (or 'quit' to exit):")
        
        while True:
            try:
                cmd_input = input("\nCommand type: ").strip()
                if cmd_input.lower() in ('quit', 'exit', 'q'):
                    break
                
                payload_input = input("Payload (JSON): ").strip()
                payload = json.loads(payload_input) if payload_input else {}
                
                result = send_command(cmd_input, payload)
                if result:
                    print(json.dumps(result, indent=2))
                    
            except KeyboardInterrupt:
                print("\nExiting...")
                break
            except json.JSONDecodeError as e:
                logging.error(f"Invalid JSON: {e}")
            except Exception as e:
                logging.error(f"Error: {e}")