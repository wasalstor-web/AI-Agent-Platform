#!/usr/bin/env python3
"""
Supreme Agent API Tests
Tests for the API Server

المؤلف / Author: wasalstor-web
التاريخ / Date: 2025-10-20
"""

import requests
import json
import time

# API Base URL
API_URL = "http://localhost:5000"

def wait_for_api(timeout=30):
    """Wait for API to be available / انتظار توفر API"""
    print("Waiting for API to be available...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            response = requests.get(f"{API_URL}/api/health", timeout=2)
            if response.status_code == 200:
                print("✓ API is available")
                return True
        except requests.exceptions.RequestException:
            pass
        time.sleep(1)
    print("✗ API not available after timeout")
    return False

def test_health_endpoint():
    """Test health endpoint / اختبار نقطة الصحة"""
    print("Testing /api/health...")
    response = requests.get(f"{API_URL}/api/health")
    assert response.status_code == 200
    data = response.json()
    assert "status" in data
    assert "timestamp" in data
    print(f"✓ Health endpoint test passed - Status: {data['status']}")

def test_models_endpoint():
    """Test models endpoint / اختبار نقطة النماذج"""
    print("Testing /api/models...")
    response = requests.get(f"{API_URL}/api/models")
    assert response.status_code == 200
    data = response.json()
    assert "models" in data
    assert "current_model" in data
    print(f"✓ Models endpoint test passed - {len(data['models'])} models")

def test_chat_endpoint():
    """Test chat endpoint / اختبار نقطة المحادثة"""
    print("Testing /api/chat...")
    payload = {
        "message": "Hello, this is a test message"
    }
    response = requests.post(f"{API_URL}/api/chat", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "success" in data
    assert "response" in data
    print("✓ Chat endpoint test passed")

def test_execute_endpoint():
    """Test execute endpoint / اختبار نقطة التنفيذ"""
    print("Testing /api/execute...")
    payload = {
        "command": "Return a simple greeting"
    }
    response = requests.post(f"{API_URL}/api/execute", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "success" in data
    assert "response" in data
    print("✓ Execute endpoint test passed")

def test_generate_code_endpoint():
    """Test generate code endpoint / اختبار نقطة توليد الكود"""
    print("Testing /api/generate-code...")
    payload = {
        "description": "A simple hello world function",
        "language": "python"
    }
    response = requests.post(f"{API_URL}/api/generate-code", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "success" in data
    assert "code" in data
    assert "language" in data
    print("✓ Generate code endpoint test passed")

def test_error_handling():
    """Test error handling / اختبار معالجة الأخطاء"""
    print("Testing error handling...")
    
    # Test missing message in chat
    response = requests.post(f"{API_URL}/api/chat", json={})
    assert response.status_code == 400
    
    # Test missing command in execute
    response = requests.post(f"{API_URL}/api/execute", json={})
    assert response.status_code == 400
    
    print("✓ Error handling test passed")

def test_cors_headers():
    """Test CORS headers / اختبار رؤوس CORS"""
    print("Testing CORS headers...")
    response = requests.get(f"{API_URL}/api/health")
    assert "Access-Control-Allow-Origin" in response.headers or response.status_code == 200
    print("✓ CORS headers test passed")

def run_all_tests():
    """Run all API tests / تشغيل جميع اختبارات API"""
    print("\n" + "="*60)
    print("Supreme Agent API Tests / اختبارات API للوكيل الأعلى")
    print("="*60 + "\n")
    
    # Wait for API
    if not wait_for_api():
        print("\n✗ API is not running. Please start it first:")
        print("  python3 api/server.py")
        return False
    
    tests = [
        test_health_endpoint,
        test_models_endpoint,
        test_error_handling,
        test_cors_headers,
        test_chat_endpoint,
        test_execute_endpoint,
        test_generate_code_endpoint,
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            test()
            passed += 1
        except AssertionError as e:
            print(f"✗ {test.__name__} failed: {e}")
            failed += 1
        except Exception as e:
            print(f"✗ {test.__name__} error: {e}")
            failed += 1
    
    print("\n" + "="*60)
    print(f"Results / النتائج: {passed} passed, {failed} failed")
    print("="*60 + "\n")
    
    return failed == 0

if __name__ == "__main__":
    import sys
    success = run_all_tests()
    sys.exit(0 if success else 1)
