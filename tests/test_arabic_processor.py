"""
Tests for Arabic Processor
اختبارات معالج اللغة العربية
"""

import pytest
from dlplus.core import ArabicProcessor


@pytest.mark.asyncio
async def test_arabic_processor_initialization():
    """Test processor initialization"""
    processor = ArabicProcessor()
    assert processor is not None


@pytest.mark.asyncio
async def test_analyze_arabic_text():
    """Test Arabic text analysis"""
    processor = ArabicProcessor()
    
    result = await processor.analyze("مرحباً كيف حالك؟")
    
    assert 'intent' in result
    assert 'entities' in result
    assert 'sentiment' in result
    assert result['language'] == 'ar'


@pytest.mark.asyncio
async def test_normalize_arabic():
    """Test Arabic normalization"""
    processor = ArabicProcessor()
    
    # Test with diacritics
    text = "مَرْحَباً"
    normalized = processor._normalize_arabic(text)
    
    assert 'َ' not in normalized  # Fatha removed
    assert 'ْ' not in normalized  # Sukun removed


@pytest.mark.asyncio
async def test_intent_detection():
    """Test intent detection"""
    processor = ArabicProcessor()
    
    # Test code intent
    result = await processor.analyze("اكتب لي كود بايثون")
    assert result['intent'] == 'code'
    
    # Test search intent
    result = await processor.analyze("ابحث عن معلومات")
    assert result['intent'] == 'search'
    
    # Test general intent
    result = await processor.analyze("مرحباً")
    assert result['intent'] == 'general'


@pytest.mark.asyncio
async def test_entity_extraction():
    """Test entity extraction"""
    processor = ArabicProcessor()
    
    # Test URL extraction
    result = await processor.analyze("زر https://example.com للمزيد")
    entities = result['entities']
    
    assert len(entities) > 0
    assert any(e['type'] == 'url' for e in entities)
