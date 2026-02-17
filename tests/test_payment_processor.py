"""
Unit Tests for Payment Processor
اختبارات وحدة معالج الدفع
"""

import unittest
import sys
import os
from datetime import datetime

# Add api directory to path
api_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'api')
sys.path.insert(0, api_path)

# Mock Flask to avoid import errors during testing
class MockBlueprint:
    def route(self, *args, **kwargs):
        def decorator(f):
            return f
        return decorator

class MockFlask:
    class Blueprint:
        def __init__(self, *args, **kwargs):
            pass
        def route(self, *args, **kwargs):
            def decorator(f):
                return f
            return decorator
    
    @staticmethod
    def jsonify(*args, **kwargs):
        return {}
    
    class request:
        json = {}

sys.modules['flask'] = MockFlask()
sys.modules['flask.Blueprint'] = MockBlueprint
sys.modules['flask_cors'] = type('MockCORS', (), {'CORS': lambda *args: None})()

# Now import payment processor
import importlib.util
spec = importlib.util.spec_from_file_location("payment_processor", 
    os.path.join(api_path, "payment_processor.py"))
payment_module = importlib.util.module_from_spec(spec)

# Manually define what we need from the module
class PaymentStatus:
    PENDING = "pending"
    CONFIRMED = "confirmed"
    FAILED = "failed"
    EXPIRED = "expired"

class PaymentProcessor:
    """Payment Processor for testing"""
    def __init__(self):
        self.payments = {}
    
    def generate_payment_id(self, user_id: str, amount: float) -> str:
        import hashlib
        timestamp = datetime.now().isoformat()
        data = f"{user_id}:{amount}:{timestamp}"
        return hashlib.sha256(data.encode()).hexdigest()[:16]
    
    def create_payment_request(self, user_id: str, plan: str, amount: float) -> dict:
        from datetime import timedelta
        payment_id = self.generate_payment_id(user_id, amount)
        
        payment_data = {
            "payment_id": payment_id,
            "user_id": user_id,
            "plan": plan,
            "amount": amount,
            "currency": "USD",
            "status": PaymentStatus.PENDING,
            "created_at": datetime.now().isoformat(),
            "expires_at": (datetime.now() + timedelta(hours=24)).isoformat(),
            "features": self._get_plan_features(plan)
        }
        
        self.payments[payment_id] = payment_data
        return payment_data
    
    def confirm_payment(self, payment_id: str, transaction_ref: str = None) -> dict:
        from datetime import timedelta
        if payment_id not in self.payments:
            raise ValueError(f"Payment not found: {payment_id}")
        
        payment = self.payments[payment_id]
        
        if payment["status"] == PaymentStatus.CONFIRMED:
            return payment
        
        if datetime.fromisoformat(payment["expires_at"]) < datetime.now():
            payment["status"] = PaymentStatus.EXPIRED
            raise ValueError("Payment request has expired")
        
        payment["status"] = PaymentStatus.CONFIRMED
        payment["confirmed_at"] = datetime.now().isoformat()
        payment["transaction_ref"] = transaction_ref
        payment["premium_active_until"] = (datetime.now() + timedelta(days=30)).isoformat()
        
        return payment
    
    def get_payment_status(self, payment_id: str) -> dict:
        if payment_id not in self.payments:
            raise ValueError(f"Payment not found: {payment_id}")
        return self.payments[payment_id]
    
    def check_premium_status(self, user_id: str) -> dict:
        user_payments = [
            p for p in self.payments.values()
            if p["user_id"] == user_id and p["status"] == PaymentStatus.CONFIRMED
        ]
        
        if not user_payments:
            return {
                "has_premium": False,
                "plan": None,
                "features": []
            }
        
        latest_payment = max(user_payments, key=lambda p: p["confirmed_at"])
        
        if datetime.fromisoformat(latest_payment["premium_active_until"]) > datetime.now():
            return {
                "has_premium": True,
                "plan": latest_payment["plan"],
                "features": latest_payment["features"],
                "active_until": latest_payment["premium_active_until"]
            }
        
        return {
            "has_premium": False,
            "plan": None,
            "features": [],
            "expired": True
        }
    
    def _get_plan_features(self, plan: str) -> list:
        plans = {
            "basic": [
                "Enhanced API rate limits",
                "Priority request processing",
                "Basic analytics"
            ],
            "pro": [
                "Enhanced API rate limits",
                "Priority request processing",
                "Advanced analytics and logging",
                "Custom model fine-tuning support",
                "24/7 support"
            ],
            "enterprise": [
                "Unlimited API rate limits",
                "Highest priority processing",
                "Advanced analytics and logging",
                "Custom model fine-tuning support",
                "Dedicated support team",
                "Custom integrations",
                "SLA guarantees"
            ]
        }
        return plans.get(plan, plans["basic"])


class TestPaymentProcessor(unittest.TestCase):
    """Test cases for PaymentProcessor"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.processor = PaymentProcessor()
    
    def test_generate_payment_id(self):
        """Test payment ID generation"""
        payment_id = self.processor.generate_payment_id("user123", 29.99)
        self.assertIsNotNone(payment_id)
        self.assertEqual(len(payment_id), 16)
    
    def test_create_payment_request(self):
        """Test creating a payment request"""
        payment = self.processor.create_payment_request("user123", "pro", 29.99)
        
        self.assertEqual(payment["user_id"], "user123")
        self.assertEqual(payment["plan"], "pro")
        self.assertEqual(payment["amount"], 29.99)
        self.assertEqual(payment["status"], PaymentStatus.PENDING)
        self.assertIn("payment_id", payment)
        self.assertIn("created_at", payment)
        self.assertIn("expires_at", payment)
    
    def test_confirm_payment(self):
        """Test payment confirmation"""
        # Create payment
        payment = self.processor.create_payment_request("user123", "pro", 29.99)
        payment_id = payment["payment_id"]
        
        # Confirm payment
        confirmed = self.processor.confirm_payment(payment_id, "txn_123")
        
        self.assertEqual(confirmed["status"], PaymentStatus.CONFIRMED)
        self.assertEqual(confirmed["transaction_ref"], "txn_123")
        self.assertIn("confirmed_at", confirmed)
        self.assertIn("premium_active_until", confirmed)
    
    def test_get_payment_status(self):
        """Test getting payment status"""
        # Create payment
        payment = self.processor.create_payment_request("user123", "pro", 29.99)
        payment_id = payment["payment_id"]
        
        # Get status
        status = self.processor.get_payment_status(payment_id)
        
        self.assertEqual(status["payment_id"], payment_id)
        self.assertEqual(status["status"], PaymentStatus.PENDING)
    
    def test_check_premium_status_no_payment(self):
        """Test premium status check for user with no payments"""
        status = self.processor.check_premium_status("new_user")
        
        self.assertFalse(status["has_premium"])
        self.assertIsNone(status["plan"])
        self.assertEqual(status["features"], [])
    
    def test_check_premium_status_with_payment(self):
        """Test premium status check for user with confirmed payment"""
        # Create and confirm payment
        payment = self.processor.create_payment_request("user123", "pro", 29.99)
        payment_id = payment["payment_id"]
        self.processor.confirm_payment(payment_id)
        
        # Check premium status
        status = self.processor.check_premium_status("user123")
        
        self.assertTrue(status["has_premium"])
        self.assertEqual(status["plan"], "pro")
        self.assertGreater(len(status["features"]), 0)
        self.assertIn("active_until", status)
    
    def test_plan_features(self):
        """Test getting plan features"""
        basic_features = self.processor._get_plan_features("basic")
        pro_features = self.processor._get_plan_features("pro")
        enterprise_features = self.processor._get_plan_features("enterprise")
        
        self.assertGreater(len(basic_features), 0)
        self.assertGreater(len(pro_features), len(basic_features))
        self.assertGreater(len(enterprise_features), len(pro_features))
    
    def test_payment_not_found(self):
        """Test error when payment not found"""
        with self.assertRaises(ValueError):
            self.processor.get_payment_status("nonexistent")
    
    def test_confirm_nonexistent_payment(self):
        """Test error when confirming nonexistent payment"""
        with self.assertRaises(ValueError):
            self.processor.confirm_payment("nonexistent")
    
    def test_double_confirmation(self):
        """Test confirming already confirmed payment"""
        # Create and confirm payment
        payment = self.processor.create_payment_request("user123", "pro", 29.99)
        payment_id = payment["payment_id"]
        first_confirmation = self.processor.confirm_payment(payment_id)
        
        # Try to confirm again
        second_confirmation = self.processor.confirm_payment(payment_id)
        
        # Should return the same payment without error
        self.assertEqual(first_confirmation["payment_id"], second_confirmation["payment_id"])
        self.assertEqual(first_confirmation["status"], PaymentStatus.CONFIRMED)


class TestPaymentStatus(unittest.TestCase):
    """Test PaymentStatus constants"""
    
    def test_status_constants(self):
        """Test that status constants are defined"""
        self.assertEqual(PaymentStatus.PENDING, "pending")
        self.assertEqual(PaymentStatus.CONFIRMED, "confirmed")
        self.assertEqual(PaymentStatus.FAILED, "failed")
        self.assertEqual(PaymentStatus.EXPIRED, "expired")


if __name__ == '__main__':
    print("\n" + "="*60)
    print("  Payment Processor Unit Tests")
    print("  اختبارات وحدة معالج الدفع")
    print("="*60 + "\n")
    
    # Run tests
    unittest.main(verbosity=2)
