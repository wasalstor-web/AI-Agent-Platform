#!/usr/bin/env python3
"""
Payment Processing Tests
اختبارات معالجة الدفع

Test the payment confirmation API endpoints
"""

import requests
import json
import sys
from datetime import datetime

# Configuration
API_BASE_URL = "http://localhost:5000"

def print_section(title):
    """Print a section header"""
    print("\n" + "="*60)
    print(f"  {title}")
    print("="*60)

def print_result(test_name, success, details=""):
    """Print test result"""
    status = "✅ PASS" if success else "❌ FAIL"
    print(f"{status} - {test_name}")
    if details:
        print(f"    {details}")

def test_get_plans():
    """Test getting available plans"""
    print_section("اختبار 1: الحصول على الخطط المتاحة | Test 1: Get Plans")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/payment/plans")
        data = response.json()
        
        if response.status_code == 200 and data.get('success'):
            print_result("Get Plans", True, f"Found {len(data.get('plans', {}))} plans")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return True
        else:
            print_result("Get Plans", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        print_result("Get Plans", False, f"Error: {str(e)}")
        return False

def test_create_payment():
    """Test creating a payment request"""
    print_section("اختبار 2: إنشاء طلب دفع | Test 2: Create Payment")
    
    payload = {
        "user_id": "test_user_123",
        "plan": "pro",
        "amount": 29.99
    }
    
    try:
        response = requests.post(
            f"{API_BASE_URL}/api/payment/create",
            json=payload,
            headers={'Content-Type': 'application/json'}
        )
        data = response.json()
        
        if response.status_code == 200 and data.get('success'):
            payment_id = data.get('payment', {}).get('payment_id')
            print_result("Create Payment", True, f"Payment ID: {payment_id}")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return payment_id
        else:
            print_result("Create Payment", False, f"Status: {response.status_code}")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return None
    except Exception as e:
        print_result("Create Payment", False, f"Error: {str(e)}")
        return None

def test_confirm_payment(payment_id):
    """Test confirming a payment"""
    print_section("اختبار 3: تأكيد الدفع | Test 3: Confirm Payment")
    
    if not payment_id:
        print_result("Confirm Payment", False, "No payment ID provided")
        return False
    
    payload = {
        "payment_id": payment_id,
        "transaction_ref": "txn_test_123456"
    }
    
    try:
        response = requests.post(
            f"{API_BASE_URL}/api/payment/confirm",
            json=payload,
            headers={'Content-Type': 'application/json'}
        )
        data = response.json()
        
        if response.status_code == 200 and data.get('success'):
            print_result("Confirm Payment", True, data.get('message'))
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return True
        else:
            print_result("Confirm Payment", False, f"Status: {response.status_code}")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return False
    except Exception as e:
        print_result("Confirm Payment", False, f"Error: {str(e)}")
        return False

def test_payment_status(payment_id):
    """Test getting payment status"""
    print_section("اختبار 4: حالة الدفع | Test 4: Payment Status")
    
    if not payment_id:
        print_result("Payment Status", False, "No payment ID provided")
        return False
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/payment/status/{payment_id}")
        data = response.json()
        
        if response.status_code == 200 and data.get('success'):
            status = data.get('payment', {}).get('status')
            print_result("Payment Status", True, f"Status: {status}")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return True
        else:
            print_result("Payment Status", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        print_result("Payment Status", False, f"Error: {str(e)}")
        return False

def test_premium_status(user_id):
    """Test getting premium status"""
    print_section("اختبار 5: حالة الاشتراك المميز | Test 5: Premium Status")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/premium/status/{user_id}")
        data = response.json()
        
        if response.status_code == 200 and data.get('success'):
            has_premium = data.get('premium_status', {}).get('has_premium')
            print_result("Premium Status", True, f"Has Premium: {has_premium}")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            return True
        else:
            print_result("Premium Status", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        print_result("Premium Status", False, f"Error: {str(e)}")
        return False

def test_api_health():
    """Test API health endpoint"""
    print_section("اختبار 0: صحة API | Test 0: API Health")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/health")
        data = response.json()
        
        if response.status_code == 200 and data.get('status') == 'healthy':
            print_result("API Health", True, "API is healthy")
            return True
        else:
            print_result("API Health", False, "API is not healthy")
            return False
    except Exception as e:
        print_result("API Health", False, f"Cannot connect to API: {str(e)}")
        print("\n⚠️  Make sure the API server is running:")
        print("    cd api && python server.py")
        return False

def run_all_tests():
    """Run all payment processing tests"""
    print("\n" + "🧪 "*30)
    print("  Payment Processing Tests")
    print("  اختبارات معالجة الدفع")
    print("🧪 "*30)
    
    # Test 0: API Health
    if not test_api_health():
        print("\n❌ API is not available. Stopping tests.")
        sys.exit(1)
    
    # Test 1: Get Plans
    test_get_plans()
    
    # Test 2: Create Payment
    payment_id = test_create_payment()
    
    if payment_id:
        # Test 3: Confirm Payment
        test_confirm_payment(payment_id)
        
        # Test 4: Payment Status
        test_payment_status(payment_id)
        
        # Test 5: Premium Status
        test_premium_status("test_user_123")
    
    print_section("ملخص الاختبار | Test Summary")
    print("✅ All tests completed!")
    print("\nNext steps:")
    print("1. Open payment-confirmation.html in your browser")
    print("2. Test the payment flow manually")
    print("3. Verify premium features are activated")

if __name__ == "__main__":
    run_all_tests()
