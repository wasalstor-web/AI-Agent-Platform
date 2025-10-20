#!/usr/bin/env python3
"""
OpenWebUI Integration Testing Script
سكريبت اختبار دمج OpenWebUI

This script tests the OpenWebUI integration with all 6 AI models
and validates the webhook endpoints.

المؤسس: خليف 'ذيبان' العنزي
الموقع: القصيم – بريدة – المملكة العربية السعودية
"""

import os
import sys
import asyncio
import json
import time
from typing import Dict, Any, List
import httpx
from datetime import datetime

# Color codes for terminal output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


class OpenWebUITester:
    """
    OpenWebUI Integration Test Suite
    مجموعة اختبارات دمج OpenWebUI
    """
    
    def __init__(self, base_url: str = "http://localhost:8080"):
        """Initialize the tester"""
        self.base_url = base_url
        self.jwt_token = os.getenv(
            "OPENWEBUI_JWT_TOKEN",
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8"
        )
        self.api_key = os.getenv(
            "OPENWEBUI_API_KEY",
            "sk-3720ccd539704717ba9af3453500fe3c"
        )
        
        self.test_results = []
        self.passed_tests = 0
        self.failed_tests = 0
        
        # Test models configuration
        self.test_models = [
            {
                "id": "llama-3-8b",
                "name": "LLaMA 3 8B",
                "test_message": "Hello, how are you?"
            },
            {
                "id": "qwen-2.5-arabic",
                "name": "Qwen 2.5 Arabic",
                "test_message": "مرحباً، كيف حالك؟"
            },
            {
                "id": "arabert",
                "name": "AraBERT",
                "test_message": "اشرح لي معالجة اللغة الطبيعية"
            },
            {
                "id": "mistral-7b",
                "name": "Mistral 7B",
                "test_message": "Explain AI in simple terms"
            },
            {
                "id": "deepseek-coder",
                "name": "DeepSeek Coder",
                "test_message": "Write a Python hello world function"
            },
            {
                "id": "phi-3-mini",
                "name": "Phi-3 Mini",
                "test_message": "What is machine learning?"
            }
        ]
    
    def print_header(self, text: str):
        """Print a section header"""
        print(f"\n{Colors.HEADER}{'=' * 70}{Colors.ENDC}")
        print(f"{Colors.HEADER}{Colors.BOLD}{text}{Colors.ENDC}")
        print(f"{Colors.HEADER}{'=' * 70}{Colors.ENDC}\n")
    
    def print_success(self, text: str):
        """Print success message"""
        print(f"{Colors.OKGREEN}✓{Colors.ENDC} {text}")
    
    def print_error(self, text: str):
        """Print error message"""
        print(f"{Colors.FAIL}✗{Colors.ENDC} {text}")
    
    def print_info(self, text: str):
        """Print info message"""
        print(f"{Colors.OKCYAN}ℹ{Colors.ENDC} {text}")
    
    def print_warning(self, text: str):
        """Print warning message"""
        print(f"{Colors.WARNING}⚠{Colors.ENDC} {text}")
    
    def record_result(self, test_name: str, passed: bool, message: str = ""):
        """Record test result"""
        self.test_results.append({
            "test": test_name,
            "passed": passed,
            "message": message,
            "timestamp": datetime.now().isoformat()
        })
        
        if passed:
            self.passed_tests += 1
            self.print_success(f"{test_name}: {message}")
        else:
            self.failed_tests += 1
            self.print_error(f"{test_name}: {message}")
    
    async def test_server_health(self) -> bool:
        """Test if the server is running and healthy"""
        self.print_header("Test 1: Server Health Check")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(f"{self.base_url}/")
                
                if response.status_code == 200:
                    data = response.json()
                    self.record_result(
                        "Server Health",
                        True,
                        f"Server is running - Status: {data.get('status', 'unknown')}"
                    )
                    return True
                else:
                    self.record_result(
                        "Server Health",
                        False,
                        f"Server returned status code {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "Server Health",
                False,
                f"Cannot connect to server: {str(e)}"
            )
            return False
    
    async def test_models_endpoint(self) -> bool:
        """Test the models listing endpoint"""
        self.print_header("Test 2: Models Endpoint")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(f"{self.base_url}/api/models")
                
                if response.status_code == 200:
                    data = response.json()
                    
                    if data.get('success') and len(data.get('models', [])) == 6:
                        self.record_result(
                            "Models Endpoint",
                            True,
                            f"All 6 models are available"
                        )
                        
                        # List all models
                        self.print_info("Available models:")
                        for model in data['models']:
                            print(f"  - {model['name']} ({model['id']})")
                        
                        return True
                    else:
                        self.record_result(
                            "Models Endpoint",
                            False,
                            f"Expected 6 models, got {len(data.get('models', []))}"
                        )
                        return False
                else:
                    self.record_result(
                        "Models Endpoint",
                        False,
                        f"Status code {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "Models Endpoint",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_webhook_status(self) -> bool:
        """Test webhook status endpoint"""
        self.print_header("Test 3: Webhook Status")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(f"{self.base_url}/webhook/status")
                
                if response.status_code == 200:
                    data = response.json()
                    
                    if data.get('status') == 'operational':
                        self.record_result(
                            "Webhook Status",
                            True,
                            f"Webhook is operational with {data.get('models_enabled', 0)} models"
                        )
                        return True
                    else:
                        self.record_result(
                            "Webhook Status",
                            False,
                            f"Webhook status is {data.get('status', 'unknown')}"
                        )
                        return False
                else:
                    self.record_result(
                        "Webhook Status",
                        False,
                        f"Status code {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "Webhook Status",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_webhook_info(self) -> bool:
        """Test webhook info endpoint"""
        self.print_header("Test 4: Webhook Configuration")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(f"{self.base_url}/webhook/info")
                
                if response.status_code == 200:
                    data = response.json()
                    
                    has_jwt = data.get('authentication', {}).get('jwt_token_provided', False)
                    has_api_key = data.get('authentication', {}).get('api_key_provided', False)
                    
                    if has_jwt and has_api_key:
                        self.record_result(
                            "Webhook Configuration",
                            True,
                            "JWT and API Key are configured"
                        )
                        
                        self.print_info(f"Webhook Base URL: {data.get('webhook_base_url', 'N/A')}")
                        self.print_info(f"Models Enabled: {data.get('models_enabled', 0)}")
                        
                        return True
                    else:
                        self.record_result(
                            "Webhook Configuration",
                            False,
                            f"JWT: {has_jwt}, API Key: {has_api_key}"
                        )
                        return False
                else:
                    self.record_result(
                        "Webhook Configuration",
                        False,
                        f"Status code {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "Webhook Configuration",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_authentication_jwt(self) -> bool:
        """Test JWT authentication"""
        self.print_header("Test 5: JWT Authentication")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                # Test with valid JWT
                headers = {
                    "Authorization": f"Bearer {self.jwt_token}",
                    "Content-Type": "application/json"
                }
                
                data = {
                    "message": "Test authentication",
                    "model": "llama-3-8b"
                }
                
                response = await client.post(
                    f"{self.base_url}/webhook/chat",
                    json=data,
                    headers=headers
                )
                
                if response.status_code == 200:
                    self.record_result(
                        "JWT Authentication",
                        True,
                        "Authentication successful with JWT token"
                    )
                    return True
                else:
                    self.record_result(
                        "JWT Authentication",
                        False,
                        f"Authentication failed with status {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "JWT Authentication",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_authentication_api_key(self) -> bool:
        """Test API Key authentication"""
        self.print_header("Test 6: API Key Authentication")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                # Test with valid API Key
                headers = {
                    "X-API-Key": self.api_key,
                    "Content-Type": "application/json"
                }
                
                data = {
                    "message": "Test authentication",
                    "model": "llama-3-8b"
                }
                
                response = await client.post(
                    f"{self.base_url}/webhook/chat",
                    json=data,
                    headers=headers
                )
                
                if response.status_code == 200:
                    self.record_result(
                        "API Key Authentication",
                        True,
                        "Authentication successful with API Key"
                    )
                    return True
                else:
                    self.record_result(
                        "API Key Authentication",
                        False,
                        f"Authentication failed with status {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "API Key Authentication",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_model(self, model_config: Dict[str, Any]) -> bool:
        """Test a specific AI model"""
        model_id = model_config['id']
        model_name = model_config['name']
        test_message = model_config['test_message']
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                headers = {
                    "X-API-Key": self.api_key,
                    "Content-Type": "application/json"
                }
                
                data = {
                    "message": test_message,
                    "model": model_id
                }
                
                response = await client.post(
                    f"{self.base_url}/webhook/chat",
                    json=data,
                    headers=headers
                )
                
                if response.status_code == 200:
                    result = response.json()
                    
                    if result.get('success'):
                        self.record_result(
                            f"Model: {model_name}",
                            True,
                            f"Response received in {len(result.get('response', ''))} chars"
                        )
                        return True
                    else:
                        self.record_result(
                            f"Model: {model_name}",
                            False,
                            f"Error: {result.get('error', 'Unknown error')}"
                        )
                        return False
                else:
                    self.record_result(
                        f"Model: {model_name}",
                        False,
                        f"Status code {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                f"Model: {model_name}",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_all_models(self) -> bool:
        """Test all 6 AI models"""
        self.print_header("Test 7-12: Testing All 6 AI Models")
        
        all_passed = True
        
        for i, model_config in enumerate(self.test_models, 1):
            self.print_info(f"Testing model {i}/6: {model_config['name']}...")
            passed = await self.test_model(model_config)
            
            if not passed:
                all_passed = False
            
            # Small delay between requests
            await asyncio.sleep(0.5)
        
        return all_passed
    
    async def test_error_handling(self) -> bool:
        """Test error handling with invalid model"""
        self.print_header("Test 13: Error Handling")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                headers = {
                    "X-API-Key": self.api_key,
                    "Content-Type": "application/json"
                }
                
                data = {
                    "message": "Test error",
                    "model": "non-existent-model"
                }
                
                response = await client.post(
                    f"{self.base_url}/webhook/chat",
                    json=data,
                    headers=headers
                )
                
                if response.status_code == 200:
                    result = response.json()
                    
                    if not result.get('success') and 'error' in result:
                        self.record_result(
                            "Error Handling",
                            True,
                            "Properly handles invalid model requests"
                        )
                        return True
                    else:
                        self.record_result(
                            "Error Handling",
                            False,
                            "Did not return error for invalid model"
                        )
                        return False
                else:
                    self.record_result(
                        "Error Handling",
                        True,
                        f"Returned appropriate error status {response.status_code}"
                    )
                    return True
        except Exception as e:
            self.record_result(
                "Error Handling",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def test_arabic_support(self) -> bool:
        """Test Arabic language support"""
        self.print_header("Test 14: Arabic Language Support")
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                headers = {
                    "X-API-Key": self.api_key,
                    "Content-Type": "application/json"
                }
                
                # Test with Arabic message
                data = {
                    "message": "مرحباً يا صديقي، كيف يمكنك مساعدتي اليوم؟",
                    "model": "qwen-2.5-arabic"
                }
                
                response = await client.post(
                    f"{self.base_url}/webhook/chat",
                    json=data,
                    headers=headers
                )
                
                if response.status_code == 200:
                    result = response.json()
                    
                    if result.get('success'):
                        # Check if response contains Arabic text
                        response_text = result.get('response', '')
                        has_arabic = any('\u0600' <= c <= '\u06FF' for c in response_text)
                        
                        if has_arabic:
                            self.record_result(
                                "Arabic Support",
                                True,
                                "Successfully processes and responds in Arabic"
                            )
                            return True
                        else:
                            self.record_result(
                                "Arabic Support",
                                False,
                                "Response does not contain Arabic text"
                            )
                            return False
                    else:
                        self.record_result(
                            "Arabic Support",
                            False,
                            f"Error: {result.get('error', 'Unknown')}"
                        )
                        return False
                else:
                    self.record_result(
                        "Arabic Support",
                        False,
                        f"Status code {response.status_code}"
                    )
                    return False
        except Exception as e:
            self.record_result(
                "Arabic Support",
                False,
                f"Error: {str(e)}"
            )
            return False
    
    async def run_all_tests(self):
        """Run all tests"""
        print(f"\n{Colors.BOLD}{Colors.HEADER}")
        print("=" * 70)
        print("  OpenWebUI Integration Test Suite")
        print("  مجموعة اختبارات دمج OpenWebUI")
        print("=" * 70)
        print(f"{Colors.ENDC}\n")
        
        self.print_info(f"Testing server at: {self.base_url}")
        self.print_info(f"Start time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print()
        
        # Run tests
        await self.test_server_health()
        await self.test_models_endpoint()
        await self.test_webhook_status()
        await self.test_webhook_info()
        await self.test_authentication_jwt()
        await self.test_authentication_api_key()
        await self.test_all_models()
        await self.test_error_handling()
        await self.test_arabic_support()
        
        # Print summary
        self.print_summary()
    
    def print_summary(self):
        """Print test summary"""
        total_tests = self.passed_tests + self.failed_tests
        success_rate = (self.passed_tests / total_tests * 100) if total_tests > 0 else 0
        
        print(f"\n{Colors.HEADER}{'=' * 70}{Colors.ENDC}")
        print(f"{Colors.BOLD}Test Summary / ملخص الاختبارات{Colors.ENDC}")
        print(f"{Colors.HEADER}{'=' * 70}{Colors.ENDC}\n")
        
        print(f"Total Tests: {total_tests}")
        print(f"{Colors.OKGREEN}Passed: {self.passed_tests}{Colors.ENDC}")
        print(f"{Colors.FAIL}Failed: {self.failed_tests}{Colors.ENDC}")
        print(f"Success Rate: {success_rate:.1f}%")
        print(f"End time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
        print(f"\n{Colors.HEADER}{'=' * 70}{Colors.ENDC}\n")
        
        # Save results to file
        self.save_results()
        
        # Exit with appropriate code
        sys.exit(0 if self.failed_tests == 0 else 1)
    
    def save_results(self):
        """Save test results to JSON file"""
        results_file = "test-results-openwebui.json"
        
        report = {
            "timestamp": datetime.now().isoformat(),
            "base_url": self.base_url,
            "total_tests": self.passed_tests + self.failed_tests,
            "passed": self.passed_tests,
            "failed": self.failed_tests,
            "success_rate": (self.passed_tests / (self.passed_tests + self.failed_tests) * 100) if (self.passed_tests + self.failed_tests) > 0 else 0,
            "tests": self.test_results
        }
        
        try:
            with open(results_file, 'w', encoding='utf-8') as f:
                json.dump(report, f, indent=2, ensure_ascii=False)
            
            self.print_success(f"Test results saved to: {results_file}")
        except Exception as e:
            self.print_error(f"Failed to save results: {str(e)}")


async def main():
    """Main entry point"""
    # Get base URL from arguments or environment
    base_url = os.getenv("OPENWEBUI_TEST_URL", "http://localhost:8080")
    
    if len(sys.argv) > 1:
        base_url = sys.argv[1]
    
    # Create tester and run tests
    tester = OpenWebUITester(base_url)
    await tester.run_all_tests()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print(f"\n{Colors.WARNING}Tests interrupted by user{Colors.ENDC}")
        sys.exit(1)
    except Exception as e:
        print(f"\n{Colors.FAIL}Fatal error: {str(e)}{Colors.ENDC}")
        sys.exit(1)
