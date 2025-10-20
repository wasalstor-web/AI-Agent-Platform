"""
Example: Model Integration Usage
مثال: استخدام تكامل النماذج

Demonstrates how to use the integrated AI models and agents.
"""

import asyncio
import logging
from dlplus.core import ModelManager, IntegrationBridge
from dlplus.agents import CodeGeneratorAgent, WebRetrievalAgent
from dlplus.config import ModelsConfig

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


async def example_basic_model_usage():
    """Example 1: Basic model inference"""
    logger.info("\n" + "="*70)
    logger.info("Example 1: Basic Model Inference | مثال 1: الاستنتاج الأساسي للنموذج")
    logger.info("="*70 + "\n")
    
    # Initialize model manager
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load AraBERT for Arabic text understanding
    await manager.load_model('arabert')
    
    # Run inference
    result = await manager.inference(
        'arabert',
        'مرحباً، أريد تحليل هذا النص العربي',
        {'temperature': 0.7}
    )
    
    logger.info(f"✅ Model Output: {result['output']}")
    
    # Cleanup
    await manager.shutdown()


async def example_agent_with_models():
    """Example 2: Using agents with AI models"""
    logger.info("\n" + "="*70)
    logger.info("Example 2: Agent with AI Models | مثال 2: الوكيل مع النماذج الذكية")
    logger.info("="*70 + "\n")
    
    # Setup
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Create code generator agent
    agent = CodeGeneratorAgent()
    agent.set_model_manager(manager)
    
    # Load preferred models for code generation
    logger.info("📥 Loading models: DeepSeek, LLaMA 3...")
    await manager.preload_models(['deepseek', 'llama3'])
    
    # Execute code generation task in Arabic
    logger.info("\n🎯 Task: Generate Python function for factorial calculation")
    result = await agent.run({
        'description': 'دالة لحساب المضروب (factorial) للأعداد الصحيحة',
        'language': 'python'
    })
    
    if result['success']:
        logger.info(f"\n✅ Generated Code:\n{result['code']}")
    else:
        logger.info(f"\n❌ Error: {result.get('error')}")
    
    # Cleanup
    await manager.shutdown()


async def example_web_retrieval_enhanced():
    """Example 3: Web retrieval with AI query enhancement"""
    logger.info("\n" + "="*70)
    logger.info("Example 3: Enhanced Web Search | مثال 3: البحث المحسّن على الويب")
    logger.info("="*70 + "\n")
    
    # Setup
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Create web retrieval agent
    agent = WebRetrievalAgent()
    agent.set_model_manager(manager)
    
    # Load Arabic models for query enhancement
    logger.info("📥 Loading Arabic models: AraBERT, CAMeLBERT...")
    await manager.preload_models(['arabert', 'camelbert'])
    
    # Execute search with AI-enhanced query
    logger.info("\n🔍 Searching: الذكاء الصناعي والتعلم الآلي")
    result = await agent.run({
        'query': 'الذكاء الصناعي والتعلم الآلي'
    })
    
    if result['success']:
        logger.info(f"\n📊 Original Query: {result['query']}")
        logger.info(f"✨ Enhanced Query: {result.get('enhanced_query', 'N/A')}")
        logger.info(f"📈 Found {result['count']} results")
    
    # Cleanup
    await manager.shutdown()


async def example_collaborative_execution():
    """Example 4: Collaborative execution with multiple models and agents"""
    logger.info("\n" + "="*70)
    logger.info("Example 4: Collaborative Execution | مثال 4: التنفيذ التعاوني")
    logger.info("="*70 + "\n")
    
    # Setup
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Register agents
    code_agent = CodeGeneratorAgent()
    web_agent = WebRetrievalAgent()
    bridge.register_agent('code_gen', code_agent)
    bridge.register_agent('web_ret', web_agent)
    
    # Load models
    logger.info("📥 Loading models: AraBERT, DeepSeek...")
    await manager.preload_models(['arabert', 'deepseek'])
    
    # Execute collaborative task
    logger.info("\n🤝 Collaborative Task: Search + Code Generation")
    result = await bridge.execute_collaborative(
        {'input': 'ابحث عن معلومات عن خوارزميات الفرز ثم اكتب كود Python لـ Quick Sort'},
        ['arabert', 'deepseek'],
        ['web_ret', 'code_gen']
    )
    
    if result['success']:
        logger.info("\n✅ Collaborative Execution Complete")
        logger.info(f"📊 Models used: {list(result['results']['models'].keys())}")
        logger.info(f"🤖 Agents used: {list(result['results']['agents'].keys())}")
        logger.info(f"⛓️ Execution flow: {len(result['results']['collaboration_flow'])} steps")
    
    # Cleanup
    await manager.shutdown()


async def example_sequential_execution():
    """Example 5: Sequential execution chain"""
    logger.info("\n" + "="*70)
    logger.info("Example 5: Sequential Execution | مثال 5: التنفيذ المتتابع")
    logger.info("="*70 + "\n")
    
    # Setup
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Register agent
    code_agent = CodeGeneratorAgent()
    bridge.register_agent('code_gen', code_agent)
    
    # Load models
    await manager.preload_models(['arabert', 'deepseek'])
    
    # Execute sequential chain
    logger.info("⛓️ Executing sequential chain:")
    logger.info("   1. AraBERT - Understand Arabic input")
    logger.info("   2. DeepSeek - Generate code logic")
    logger.info("   3. Code Agent - Format and validate\n")
    
    result = await bridge.execute_sequential(
        {'input': 'اكتب برنامج Python لحساب الأعداد الأولية حتى 100'},
        [
            {'type': 'model', 'id': 'arabert'},
            {'type': 'model', 'id': 'deepseek'},
            {'type': 'agent', 'id': 'code_gen'}
        ]
    )
    
    if result['success']:
        logger.info(f"\n✅ Sequential Execution Complete")
        logger.info(f"📊 Steps executed: {len(result['steps'])}")
        logger.info(f"🎯 Final output available")
    
    # Cleanup
    await manager.shutdown()


async def example_parallel_execution():
    """Example 6: Parallel execution with multiple models"""
    logger.info("\n" + "="*70)
    logger.info("Example 6: Parallel Execution | مثال 6: التنفيذ المتوازي")
    logger.info("="*70 + "\n")
    
    # Setup
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    bridge = IntegrationBridge(manager)
    
    # Load multiple Arabic models
    logger.info("📥 Loading Arabic models for parallel analysis...")
    await manager.preload_models(['arabert', 'camelbert', 'qwen_arabic'])
    
    # Execute parallel analysis
    logger.info("\n⚡ Running parallel text analysis with 3 models...")
    result = await bridge.execute_parallel(
        {'input': 'تحليل النص: الذكاء الصناعي يغير العالم'},
        [
            {'type': 'model', 'id': 'arabert'},
            {'type': 'model', 'id': 'camelbert'},
            {'type': 'model', 'id': 'qwen_arabic'}
        ]
    )
    
    if result['success']:
        logger.info("\n✅ Parallel Execution Complete")
        logger.info(f"📊 Results from {len(result['results'])} models")
        for key in result['results'].keys():
            logger.info(f"   - {key}")
    
    # Cleanup
    await manager.shutdown()


async def example_model_statistics():
    """Example 7: Model statistics and monitoring"""
    logger.info("\n" + "="*70)
    logger.info("Example 7: Model Statistics | مثال 7: إحصائيات النماذج")
    logger.info("="*70 + "\n")
    
    # Setup
    models_config = ModelsConfig()
    manager = ModelManager(models_config)
    
    # Load models
    await manager.preload_models(['arabert', 'llama3', 'deepseek'])
    
    # Run some inferences
    logger.info("🔄 Running test inferences...")
    await manager.inference('arabert', 'نص تجريبي 1')
    await manager.inference('arabert', 'نص تجريبي 2')
    await manager.inference('llama3', 'test text')
    
    # Get statistics
    info = manager.get_all_models_info()
    
    logger.info(f"\n📊 Statistics:")
    logger.info(f"   Total loaded models: {info['total_loaded']}")
    logger.info(f"   Models by status:")
    for status, models in info['models_by_status'].items():
        if models:
            logger.info(f"      {status}: {len(models)} models")
    
    # Individual model stats
    logger.info("\n📈 AraBERT Statistics:")
    arabert_info = manager.get_model_info('arabert')
    if arabert_info:
        logger.info(f"   Inference count: {arabert_info['stats']['inference_count']}")
        logger.info(f"   Status: {arabert_info['status']}")
    
    # Cleanup
    await manager.shutdown()


async def main():
    """Run all examples"""
    logger.info("\n" + "="*70)
    logger.info("🚀 AI Models and Agents Integration Examples")
    logger.info("أمثلة تكامل النماذج والوكلاء الذكية")
    logger.info("="*70)
    
    examples = [
        ("Basic Model Usage", example_basic_model_usage),
        ("Agent with Models", example_agent_with_models),
        ("Enhanced Web Search", example_web_retrieval_enhanced),
        ("Collaborative Execution", example_collaborative_execution),
        ("Sequential Execution", example_sequential_execution),
        ("Parallel Execution", example_parallel_execution),
        ("Model Statistics", example_model_statistics),
    ]
    
    for i, (name, example_func) in enumerate(examples, 1):
        try:
            await example_func()
        except Exception as e:
            logger.error(f"\n❌ Error in {name}: {e}")
    
    logger.info("\n" + "="*70)
    logger.info("✅ All examples completed!")
    logger.info("="*70 + "\n")


if __name__ == "__main__":
    asyncio.run(main())
