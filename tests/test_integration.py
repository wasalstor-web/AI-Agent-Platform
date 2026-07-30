"""
Tests for Model Integration
اختبارات تكامل النماذج
"""

import pytest
from dlplus.core import ModelManager, IntegrationBridge, ModelStatus
from dlplus.config import ModelsConfig
from dlplus.agents import CodeGeneratorAgent, WebRetrievalAgent


@pytest.mark.asyncio
async def test_model_manager_initialization():
    """Test model manager initialization"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    assert manager is not None
    assert len(manager.loaded_models) == 0


@pytest.mark.asyncio
async def test_load_model():
    """Test loading a model"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load AraBERT
    success = await manager.load_model('arabert')
    
    assert success is True
    assert 'arabert' in manager.loaded_models
    assert manager.get_model_status('arabert') == ModelStatus.READY


@pytest.mark.asyncio
async def test_load_multiple_models():
    """Test loading multiple models"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Preload multiple models
    results = await manager.preload_models(['arabert', 'llama3', 'deepseek'])
    
    assert all(results.values())
    assert len(manager.get_loaded_models()) == 3


@pytest.mark.asyncio
async def test_model_inference():
    """Test model inference"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load and run inference with LLaMA 3
    await manager.load_model('llama3')
    
    result = await manager.inference(
        'llama3',
        'مرحباً، كيف حالك؟',
        {'temperature': 0.7}
    )
    
    assert result['success'] is True
    assert 'output' in result
    assert result['model_id'] == 'llama3'


@pytest.mark.asyncio
async def test_unload_model():
    """Test unloading a model"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load and then unload
    await manager.load_model('mistral')
    success = await manager.unload_model('mistral')
    
    assert success is True
    assert 'mistral' not in manager.loaded_models
    assert manager.get_model_status('mistral') == ModelStatus.UNLOADED


@pytest.mark.asyncio
async def test_batch_inference():
    """Test batch inference"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    await manager.load_model('arabert')
    
    inputs = ['نص أول', 'نص ثاني', 'نص ثالث']
    results = await manager.batch_inference('arabert', inputs)
    
    assert len(results) == 3
    assert all(r['success'] for r in results)


@pytest.mark.asyncio
async def test_integration_bridge_initialization():
    """Test integration bridge initialization"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    assert bridge is not None
    assert bridge.model_manager == manager


@pytest.mark.asyncio
async def test_integration_bridge_register_agent():
    """Test registering agent with bridge"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    agent = CodeGeneratorAgent()
    bridge.register_agent('code_generator', agent)
    
    assert 'code_generator' in bridge.agent_registry


@pytest.mark.asyncio
async def test_execute_with_model():
    """Test executing task with model only"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    await manager.load_model('qwen_arabic')
    
    result = await bridge.execute_with_model(
        'qwen_arabic',
        {'input': 'اشرح الذكاء الصناعي'}
    )
    
    assert result['success'] is True
    assert 'output' in result
    assert result['mode'] == 'model_only'


@pytest.mark.asyncio
async def test_execute_collaborative():
    """Test collaborative execution with models and agents"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Register agents
    code_agent = CodeGeneratorAgent()
    web_agent = WebRetrievalAgent()
    bridge.register_agent('code_generator', code_agent)
    bridge.register_agent('web_retrieval', web_agent)
    
    # Load models
    await manager.preload_models(['arabert', 'deepseek'])
    
    # Execute collaborative task
    result = await bridge.execute_collaborative(
        {'input': 'ابحث عن معلومات واكتب كود Python'},
        ['arabert', 'deepseek'],
        ['web_retrieval', 'code_generator']
    )
    
    assert result['success'] is True
    assert 'models' in result['results']
    assert 'agents' in result['results']
    assert len(result['results']['collaboration_flow']) > 0


@pytest.mark.asyncio
async def test_execute_sequential():
    """Test sequential execution"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Register agent
    agent = CodeGeneratorAgent()
    bridge.register_agent('code_generator', agent)
    
    # Execute sequential chain
    result = await bridge.execute_sequential(
        {'input': 'اكتب دالة لحساب المجموع'},
        [
            {'type': 'model', 'id': 'arabert'},
            {'type': 'model', 'id': 'deepseek'},
            {'type': 'agent', 'id': 'code_generator'}
        ]
    )
    
    assert result['success'] is True
    assert len(result['steps']) == 3
    assert result['mode'] == 'sequential'


@pytest.mark.asyncio
async def test_execute_parallel():
    """Test parallel execution"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Register agents
    bridge.register_agent('code_generator', CodeGeneratorAgent())
    bridge.register_agent('web_retrieval', WebRetrievalAgent())
    
    # Execute parallel
    result = await bridge.execute_parallel(
        {'input': 'معالجة النص'},
        [
            {'type': 'model', 'id': 'arabert'},
            {'type': 'model', 'id': 'camelbert'},
            {'type': 'agent', 'id': 'web_retrieval'}
        ]
    )
    
    assert result['success'] is True
    assert 'results' in result
    assert result['mode'] == 'parallel'


@pytest.mark.asyncio
async def test_agent_with_model_manager():
    """Test agent using model manager"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Create agent and connect model manager
    agent = CodeGeneratorAgent()
    agent.set_model_manager(manager)
    
    # Load preferred models
    await manager.preload_models(agent.preferred_models)
    
    # Execute agent task
    result = await agent.run({
        'description': 'دالة لحساب المضروب',
        'language': 'python'
    })
    
    assert result['success'] is True
    assert 'code' in result


@pytest.mark.asyncio
async def test_web_agent_with_ai_enhancement():
    """Test web retrieval agent with AI query enhancement"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Create and configure agent
    agent = WebRetrievalAgent()
    agent.set_model_manager(manager)
    
    # Load Arabic models
    await manager.preload_models(['arabert', 'camelbert'])
    
    # Execute search with AI enhancement
    result = await agent.run({
        'query': 'الذكاء الصناعي'
    })
    
    assert result['success'] is True
    assert 'enhanced_query' in result
    assert result['count'] > 0


@pytest.mark.asyncio
async def test_model_manager_statistics():
    """Test model manager statistics"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load some models
    await manager.preload_models(['arabert', 'llama3'])
    
    # Run inference
    await manager.inference('arabert', 'اختبار')
    await manager.inference('llama3', 'test')
    
    # Check statistics
    info = manager.get_all_models_info()
    
    assert info['total_loaded'] == 2
    assert len(info['loaded_models']) == 2


@pytest.mark.asyncio
async def test_integration_bridge_statistics():
    """Test integration bridge statistics"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Register agents
    bridge.register_agent('code_gen', CodeGeneratorAgent())
    bridge.register_agent('web_ret', WebRetrievalAgent())
    
    # Load models
    await manager.preload_models(['arabert', 'llama3'])
    
    # Get statistics
    stats = bridge.get_statistics()
    
    assert 'total_executions' in stats
    assert 'registered_agents' in stats
    assert 'loaded_models' in stats
    assert len(stats['registered_agents']) == 2
    assert len(stats['loaded_models']) == 2


@pytest.mark.asyncio
async def test_arabic_model_preference():
    """Test Arabic-understanding models are preferred"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Get Arabic NLP models
    config = ModelsConfig()
    arabic_models = config.get_models_by_capability('arabic_nlp')
    
    assert len(arabic_models) >= 2
    assert any('arabert' in m.model_id.lower() for m in arabic_models)
    assert any('camelbert' in m.model_id.lower() for m in arabic_models)


@pytest.mark.asyncio
async def test_code_generation_models():
    """Test code generation capable models"""
    config = ModelsConfig()
    coding_models = config.get_models_by_capability('coding')
    
    assert len(coding_models) >= 2
    # DeepSeek and LLaMA 3 should have coding capability
    model_ids = [m.model_id.lower() for m in coding_models]
    assert any('deepseek' in mid or 'llama' in mid for mid in model_ids)


@pytest.mark.asyncio
async def test_shutdown():
    """Test proper shutdown of model manager"""
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load models
    await manager.preload_models(['arabert', 'llama3'])
    assert len(manager.get_loaded_models()) == 2
    
    # Shutdown
    await manager.shutdown()
    
    # All models should be unloaded
    assert len(manager.get_loaded_models()) == 0
