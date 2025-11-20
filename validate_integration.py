#!/usr/bin/env python3
"""
Integration Validation Script
نص التحقق من التكامل

Validates the complete AI models and agents integration.
"""

import asyncio
import sys
from pathlib import Path

# Add project to path
sys.path.insert(0, str(Path(__file__).parent))

from dlplus import DLPlusCore, ModelManager, IntegrationBridge
from dlplus.agents import CodeGeneratorAgent, WebRetrievalAgent
from dlplus.config import ModelsConfig


async def validate_integration():
    """Validate complete integration"""
    print("\n" + "="*70)
    print("🧪 AI Models and Agents Integration Validation")
    print("التحقق من تكامل النماذج والوكلاء الذكية")
    print("="*70 + "\n")
    
    validation_results = {
        'total': 0,
        'passed': 0,
        'failed': 0
    }
    
    def test(name, condition, details=""):
        """Helper to track test results"""
        validation_results['total'] += 1
        if condition:
            validation_results['passed'] += 1
            print(f"✅ {name}")
            if details:
                print(f"   {details}")
        else:
            validation_results['failed'] += 1
            print(f"❌ {name}")
            if details:
                print(f"   {details}")
        return condition
    
    try:
        # Test 1: ModelsConfig
        print("\n📋 Testing Model Configuration...")
        models_config = ModelsConfig()
        test(
            "ModelsConfig initialization",
            models_config is not None,
            f"Configured models: {len(models_config.models)}"
        )
        test(
            "All 6 models configured",
            len(models_config.models) == 6,
            f"Models: {list(models_config.models.keys())}"
        )
        
        # Test 2: ModelManager
        print("\n🔧 Testing Model Manager...")
        manager = ModelManager(models_config)
        test("ModelManager initialization", manager is not None)
        
        # Load models
        await manager.load_model('arabert')
        test(
            "AraBERT loading",
            'arabert' in manager.loaded_models,
            "Arabic understanding model loaded"
        )
        
        await manager.load_model('deepseek')
        test(
            "DeepSeek loading",
            'deepseek' in manager.loaded_models,
            "Code generation model loaded"
        )
        
        # Test inference
        result = await manager.inference('arabert', 'مرحباً')
        test(
            "Model inference",
            result.get('success'),
            "Model can process Arabic text"
        )
        
        # Test 3: IntegrationBridge
        print("\n🌉 Testing Integration Bridge...")
        bridge = IntegrationBridge(manager)
        test("IntegrationBridge initialization", bridge is not None)
        
        # Register agents
        code_agent = CodeGeneratorAgent()
        web_agent = WebRetrievalAgent()
        bridge.register_agent('code_gen', code_agent)
        bridge.register_agent('web_ret', web_agent)
        
        test(
            "Agent registration",
            len(bridge.agent_registry) == 2,
            "2 agents registered successfully"
        )
        
        # Test 4: Agent Enhancement
        print("\n🤖 Testing Enhanced Agents...")
        code_agent.set_model_manager(manager)
        test(
            "Agent-Model connection",
            code_agent.model_manager is not None,
            "CodeGeneratorAgent connected to ModelManager"
        )
        
        test(
            "Preferred models configuration",
            len(code_agent.preferred_models) > 0,
            f"Preferred: {code_agent.preferred_models}"
        )
        
        # Test 5: Execution Modes
        print("\n⚡ Testing Execution Modes...")
        
        # Model-only execution
        result = await bridge.execute_with_model(
            'arabert',
            {'input': 'اختبار'}
        )
        test(
            "Model-only execution",
            result.get('success'),
            f"Mode: {result.get('mode')}"
        )
        
        # Collaborative execution
        await manager.load_model('llama3')
        result = await bridge.execute_collaborative(
            {'input': 'test collaborative'},
            ['arabert', 'llama3'],
            ['code_gen']
        )
        test(
            "Collaborative execution",
            result.get('success'),
            f"Models and agents worked together"
        )
        
        # Sequential execution
        result = await bridge.execute_sequential(
            {'input': 'test sequential'},
            [
                {'type': 'model', 'id': 'arabert'},
                {'type': 'agent', 'id': 'code_gen'}
            ]
        )
        test(
            "Sequential execution",
            result.get('success'),
            f"Executed {len(result.get('steps', []))} steps"
        )
        
        # Test 6: DLPlusCore Integration
        print("\n🧠 Testing DLPlusCore Integration...")
        core = DLPlusCore()
        await core.initialize()
        
        test(
            "DLPlusCore initialization",
            core.initialized,
            "System fully initialized"
        )
        
        test(
            "Models loaded in core",
            core.model_manager is not None,
            f"{len(core.model_manager.loaded_models)} models loaded"
        )
        
        test(
            "Integration bridge in core",
            core.integration_bridge is not None,
            "Integration bridge created"
        )
        
        test(
            "Agents initialized",
            len(core.agents) > 0,
            f"{len(core.agents)} agents ready"
        )
        
        # Test command processing
        result = await core.process_command('اكتب دالة بسيطة')
        test(
            "Command processing",
            result.get('success'),
            "Arabic command processed successfully"
        )
        
        # Test 7: Status and Statistics
        print("\n📊 Testing Status and Statistics...")
        status = await core.get_status()
        
        test(
            "System status reporting",
            'models' in status and 'agents' in status,
            f"Models: {status['models'].get('loaded', 0)}, Agents: {status['agents'].get('count', 0)}"
        )
        
        stats = bridge.get_statistics()
        test(
            "Integration statistics",
            'total_executions' in stats,
            f"Total executions tracked: {stats['total_executions']}"
        )
        
        # Cleanup
        print("\n🧹 Testing Cleanup...")
        await core.shutdown()
        # Note: Core has its own model manager instance
        test(
            "System shutdown",
            not core.initialized,
            "Core properly shut down"
        )
        
    except Exception as e:
        print(f"\n❌ Validation error: {e}")
        import traceback
        traceback.print_exc()
        validation_results['failed'] += 1
    
    # Print results
    print("\n" + "="*70)
    print("📈 Validation Results | نتائج التحقق")
    print("="*70)
    print(f"Total Tests: {validation_results['total']}")
    print(f"✅ Passed: {validation_results['passed']}")
    print(f"❌ Failed: {validation_results['failed']}")
    
    if validation_results['failed'] == 0:
        print("\n🎉 ALL VALIDATIONS PASSED! Integration is production-ready!")
        print("جميع عمليات التحقق نجحت! التكامل جاهز للإنتاج! 🎊")
    else:
        print(f"\n⚠️ {validation_results['failed']} validation(s) failed!")
    
    print("="*70 + "\n")
    
    return validation_results['failed'] == 0


if __name__ == "__main__":
    success = asyncio.run(validate_integration())
    sys.exit(0 if success else 1)
