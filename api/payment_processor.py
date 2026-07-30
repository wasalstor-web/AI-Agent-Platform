"""
Payment Processor Module
معالج الدفع

Handles payment confirmation and premium feature activation.
"""

from flask import Blueprint, request, jsonify
from datetime import datetime, timedelta
import logging
import hashlib
import json

logger = logging.getLogger(__name__)

payment_bp = Blueprint('payment', __name__)


class PaymentStatus:
    """Payment status constants"""
    PENDING = "pending"
    CONFIRMED = "confirmed"
    FAILED = "failed"
    EXPIRED = "expired"


class PaymentProcessor:
    """
    Payment Processor
    معالج الدفع
    
    Handles payment confirmation and premium feature activation
    """
    
    def __init__(self):
        """Initialize payment processor"""
        self.payments = {}
        logger.info("💳 Payment Processor initialized")
    
    def generate_payment_id(self, user_id: str, amount: float) -> str:
        """Generate unique payment ID"""
        timestamp = datetime.now().isoformat()
        data = f"{user_id}:{amount}:{timestamp}"
        return hashlib.sha256(data.encode()).hexdigest()[:16]
    
    def create_payment_request(self, user_id: str, plan: str, amount: float) -> dict:
        """
        Create a new payment request
        
        Args:
            user_id: User identifier
            plan: Premium plan type (basic, pro, enterprise)
            amount: Payment amount
            
        Returns:
            Payment request details
        """
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
        logger.info(f"💳 Created payment request: {payment_id} for user: {user_id}")
        
        return payment_data
    
    def confirm_payment(self, payment_id: str, transaction_ref: str = None) -> dict:
        """
        Confirm a payment and activate premium features
        
        Args:
            payment_id: Payment identifier
            transaction_ref: Optional transaction reference
            
        Returns:
            Payment confirmation details
        """
        if payment_id not in self.payments:
            raise ValueError(f"Payment not found: {payment_id}")
        
        payment = self.payments[payment_id]
        
        # Check if payment already confirmed
        if payment["status"] == PaymentStatus.CONFIRMED:
            logger.warning(f"⚠️ Payment already confirmed: {payment_id}")
            return payment
        
        # Check if payment expired
        if datetime.fromisoformat(payment["expires_at"]) < datetime.now():
            payment["status"] = PaymentStatus.EXPIRED
            logger.warning(f"⏰ Payment expired: {payment_id}")
            raise ValueError("Payment request has expired")
        
        # Confirm payment
        payment["status"] = PaymentStatus.CONFIRMED
        payment["confirmed_at"] = datetime.now().isoformat()
        payment["transaction_ref"] = transaction_ref
        payment["premium_active_until"] = (datetime.now() + timedelta(days=30)).isoformat()
        
        logger.info(f"✅ Payment confirmed: {payment_id} for user: {payment['user_id']}")
        
        return payment
    
    def get_payment_status(self, payment_id: str) -> dict:
        """Get payment status"""
        if payment_id not in self.payments:
            raise ValueError(f"Payment not found: {payment_id}")
        
        return self.payments[payment_id]
    
    def check_premium_status(self, user_id: str) -> dict:
        """
        Check if user has active premium subscription
        
        Args:
            user_id: User identifier
            
        Returns:
            Premium status information
        """
        # Find confirmed payments for this user
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
        
        # Get most recent payment
        latest_payment = max(user_payments, key=lambda p: p["confirmed_at"])
        
        # Check if still active
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
        """Get features for a premium plan"""
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


# Initialize global payment processor
payment_processor = PaymentProcessor()


@payment_bp.route('/api/payment/create', methods=['POST'])
def create_payment():
    """
    Create a new payment request
    
    Request:
    {
        "user_id": "user123",
        "plan": "pro",
        "amount": 29.99
    }
    """
    try:
        data = request.json
        user_id = data.get('user_id')
        plan = data.get('plan', 'basic')
        amount = data.get('amount', 0.0)
        
        if not user_id:
            return jsonify({
                "success": False,
                "error": "user_id is required"
            }), 400
        
        payment_data = payment_processor.create_payment_request(user_id, plan, amount)
        
        return jsonify({
            "success": True,
            "payment": payment_data,
            "timestamp": datetime.now().isoformat()
        }), 200
        
    except Exception as e:
        logger.error(f"Error creating payment: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@payment_bp.route('/api/payment/confirm', methods=['POST'])
def confirm_payment():
    """
    Confirm a payment (simulate successful payment)
    معالجة تأكيد الدفع
    
    Request:
    {
        "payment_id": "abc123",
        "transaction_ref": "txn_xyz789"
    }
    """
    try:
        data = request.json
        payment_id = data.get('payment_id')
        transaction_ref = data.get('transaction_ref', '')
        
        if not payment_id:
            return jsonify({
                "success": False,
                "error": "payment_id is required",
                "error_ar": "معرف الدفع مطلوب"
            }), 400
        
        payment_data = payment_processor.confirm_payment(payment_id, transaction_ref)
        
        return jsonify({
            "success": True,
            "message": "Payment confirmed successfully",
            "message_ar": "تم تأكيد الدفع بنجاح",
            "payment": payment_data,
            "premium_activated": True,
            "timestamp": datetime.now().isoformat()
        }), 200
        
    except ValueError as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 404
    except Exception as e:
        logger.error(f"Error confirming payment: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@payment_bp.route('/api/payment/status/<payment_id>', methods=['GET'])
def get_payment_status(payment_id):
    """Get payment status"""
    try:
        payment_data = payment_processor.get_payment_status(payment_id)
        
        return jsonify({
            "success": True,
            "payment": payment_data,
            "timestamp": datetime.now().isoformat()
        }), 200
        
    except ValueError as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 404
    except Exception as e:
        logger.error(f"Error getting payment status: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@payment_bp.route('/api/premium/status/<user_id>', methods=['GET'])
def get_premium_status(user_id):
    """
    Check premium status for a user
    التحقق من حالة الاشتراك المميز
    """
    try:
        status = payment_processor.check_premium_status(user_id)
        
        return jsonify({
            "success": True,
            "user_id": user_id,
            "premium_status": status,
            "timestamp": datetime.now().isoformat()
        }), 200
        
    except Exception as e:
        logger.error(f"Error checking premium status: {e}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@payment_bp.route('/api/payment/plans', methods=['GET'])
def get_plans():
    """
    Get available premium plans
    الحصول على خطط الاشتراك المتاحة
    """
    plans = {
        "basic": {
            "name": "Basic",
            "name_ar": "أساسي",
            "price": 9.99,
            "currency": "USD",
            "features": payment_processor._get_plan_features("basic")
        },
        "pro": {
            "name": "Professional",
            "name_ar": "احترافي",
            "price": 29.99,
            "currency": "USD",
            "features": payment_processor._get_plan_features("pro")
        },
        "enterprise": {
            "name": "Enterprise",
            "name_ar": "مؤسسات",
            "price": 99.99,
            "currency": "USD",
            "features": payment_processor._get_plan_features("enterprise")
        }
    }
    
    return jsonify({
        "success": True,
        "plans": plans,
        "timestamp": datetime.now().isoformat()
    }), 200
