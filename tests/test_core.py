"""
Tests for DL+ Core
اختبارات نواة DL+
"""

import pytest
import asyncio
from dlplus.core import DLPlusCore


@pytest.mark.asyncio
async def test_core_initialization():
    """Test core initialization"""
    core = DLPlusCore()
    await core.initialize()
    
    assert core.initialized is True
    assert len(core.models) > 0
    assert len(core.agents) > 0


@pytest.mark.asyncio
async def test_process_command():
    """Test command processing"""
    core = DLPlusCore()
    await core.initialize()
    
    result = await core.process_command("مرحباً")
    
    assert result['success'] is True
    assert 'response' in result
    assert 'intent' in result
    assert 'timestamp' in result


@pytest.mark.asyncio
async def test_get_status():
    """Test status retrieval"""
    core = DLPlusCore()
    await core.initialize()
    
    status = await core.get_status()
    
    assert status['initialized'] is True
    assert 'models' in status
    assert 'agents' in status
    assert 'timestamp' in status


@pytest.mark.asyncio
async def test_shutdown():
    """Test shutdown"""
    core = DLPlusCore()
    await core.initialize()
    await core.shutdown()
    
    assert core.initialized is False
