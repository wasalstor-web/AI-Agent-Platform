"""
Tests for Agents
اختبارات الوكلاء
"""

import pytest
from dlplus.agents import WebRetrievalAgent, CodeGeneratorAgent


@pytest.mark.asyncio
async def test_web_retrieval_agent():
    """Test web retrieval agent"""
    agent = WebRetrievalAgent()
    
    result = await agent.run({
        'query': 'الذكاء الصناعي'
    })
    
    assert result['success'] is True
    assert 'results' in result
    assert result['count'] > 0


@pytest.mark.asyncio
async def test_web_retrieval_agent_no_query():
    """Test web retrieval agent without query"""
    agent = WebRetrievalAgent()
    
    result = await agent.run({})
    
    assert result['success'] is False
    assert 'error' in result


@pytest.mark.asyncio
async def test_code_generator_agent():
    """Test code generator agent"""
    agent = CodeGeneratorAgent()
    
    result = await agent.run({
        'description': 'دالة لحساب المجموع',
        'language': 'python'
    })
    
    assert result['success'] is True
    assert 'code' in result
    assert result['language'] == 'python'


@pytest.mark.asyncio
async def test_code_generator_unsupported_language():
    """Test code generator with unsupported language"""
    agent = CodeGeneratorAgent()
    
    result = await agent.run({
        'description': 'test',
        'language': 'unsupported'
    })
    
    assert result['success'] is False
    assert 'error' in result


@pytest.mark.asyncio
async def test_code_generator_with_tests():
    """Test code generator with tests"""
    agent = CodeGeneratorAgent()
    
    result = await agent.generate_with_tests(
        description='test function',
        language='python'
    )
    
    assert result['success'] is True
    assert 'code' in result
    assert 'tests' in result


@pytest.mark.asyncio
async def test_agent_status():
    """Test agent status"""
    agent = WebRetrievalAgent()
    
    status = agent.get_status()
    
    assert 'name' in status
    assert 'enabled' in status
    assert 'execution_count' in status


@pytest.mark.asyncio
async def test_agent_enable_disable():
    """Test agent enable/disable"""
    agent = WebRetrievalAgent()
    
    assert agent.enabled is True
    
    agent.disable()
    assert agent.enabled is False
    
    agent.enable()
    assert agent.enabled is True


@pytest.mark.asyncio
async def test_disabled_agent_execution():
    """Test executing a disabled agent"""
    agent = WebRetrievalAgent()
    agent.disable()
    
    result = await agent.run({
        'query': 'test'
    })
    
    assert result['success'] is False
    assert 'disabled' in result['error'].lower()
