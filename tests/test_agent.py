#!/usr/bin/env python3
"""
Supreme Agent Tests
Tests for the Supreme Agent core functionality

المؤلف / Author: wasalstor-web
التاريخ / Date: 2025-10-20
"""

import sys
import os
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from scripts.supreme_agent import SupremeAgent

def test_agent_initialization():
    """Test agent initialization / اختبار تهيئة الوكيل"""
    print("Testing agent initialization...")
    agent = SupremeAgent()
    assert agent.model == "supreme-executor"
    assert agent.ollama_host == "http://localhost:11434"
    assert agent.temperature == 0.7
    print("✓ Agent initialization test passed")

def test_health_check():
    """Test health check / اختبار فحص الصحة"""
    print("Testing health check...")
    agent = SupremeAgent()
    health = agent.health_check()
    assert "status" in health
    assert "timestamp" in health
    print(f"✓ Health check test passed - Status: {health['status']}")

def test_get_models():
    """Test get models / اختبار الحصول على النماذج"""
    print("Testing get models...")
    agent = SupremeAgent()
    models = agent.get_models()
    assert isinstance(models, list)
    print(f"✓ Get models test passed - Found {len(models)} models")

def test_conversation_history():
    """Test conversation history / اختبار سجل المحادثات"""
    print("Testing conversation history...")
    agent = SupremeAgent()
    
    # Initially empty
    assert len(agent.conversation_history) == 0
    
    # Add an entry manually
    agent.conversation_history.append({
        "type": "test",
        "message": "test message",
        "timestamp": "2025-10-20T00:00:00"
    })
    
    assert len(agent.conversation_history) == 1
    print("✓ Conversation history test passed")

def test_save_load_history():
    """Test save and load history / اختبار حفظ وتحميل السجل"""
    print("Testing save and load history...")
    agent = SupremeAgent()
    
    # Add test data
    agent.conversation_history = [
        {"type": "test", "message": "test1"},
        {"type": "test", "message": "test2"}
    ]
    
    # Save to temporary file
    import tempfile
    with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as f:
        test_file = f.name
    
    try:
        agent.save_history(test_file)
        
        # Load in new agent
        agent2 = SupremeAgent()
        agent2.load_history(test_file)
        
        assert len(agent2.conversation_history) == 2
        print("✓ Save/load history test passed")
    finally:
        # Cleanup
        if os.path.exists(test_file):
            os.remove(test_file)

def run_all_tests():
    """Run all tests / تشغيل جميع الاختبارات"""
    print("\n" + "="*60)
    print("Supreme Agent Tests / اختبارات الوكيل الأعلى")
    print("="*60 + "\n")
    
    tests = [
        test_agent_initialization,
        test_conversation_history,
        test_save_load_history,
        test_get_models,
        test_health_check,
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            test()
            passed += 1
        except Exception as e:
            print(f"✗ {test.__name__} failed: {e}")
            failed += 1
    
    print("\n" + "="*60)
    print(f"Results / النتائج: {passed} passed, {failed} failed")
    print("="*60 + "\n")
    
    return failed == 0

if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
