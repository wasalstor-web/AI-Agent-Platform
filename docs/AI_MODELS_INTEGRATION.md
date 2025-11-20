# AI Models and Agents Integration Guide
# دليل تكامل النماذج والوكلاء الذكية

## نظرة عامة | Overview

This guide explains how the AI models and agents are integrated in the DL+ system to create a collaborative, Arabic-understanding AI platform.

يشرح هذا الدليل كيفية تكامل نماذج الذكاء الصناعي والوكلاء في نظام DL+ لإنشاء منصة ذكاء صناعي تعاونية تفهم اللغة العربية.

## Architecture | البنية المعمارية

### Components | المكونات

1. **Model Manager (مدير النماذج)**
   - Manages AI model lifecycle
   - Handles model loading/unloading
   - Provides inference interface
   - Tracks model statistics

2. **Integration Bridge (جسر التكامل)**
   - Connects models and agents
   - Coordinates collaborative execution
   - Supports multiple execution modes
   - Manages execution history

3. **Enhanced Agents (الوكلاء المحسّنة)**
   - Can use AI models directly
   - Define preferred models
   - Fallback to templates if models unavailable
   - Seamless model integration

## Supported AI Models | النماذج المدعومة

### Arabic Language Models | نماذج اللغة العربية

1. **AraBERT (أرابرت)**
   - Provider: HuggingFace
   - Model: `aubmindlab/bert-base-arabertv2`
   - Capabilities: Arabic NLP, text understanding, sentiment analysis
   - Best for: Arabic text analysis and understanding

2. **CAMeLBERT (كاملبرت)**
   - Provider: HuggingFace
   - Model: `CAMeL-Lab/bert-base-arabic-camelbert-mix`
   - Capabilities: Arabic NLP, NER, text classification
   - Best for: Named entity recognition in Arabic

3. **Qwen 2.5 Arabic (كوين 2.5 العربي)**
   - Provider: HuggingFace
   - Model: `Qwen/Qwen2.5-7B`
   - Capabilities: Text generation, Arabic understanding, reasoning
   - Best for: Advanced Arabic text generation

### General Purpose Models | النماذج العامة

4. **LLaMA 3 (لاما 3)**
   - Provider: HuggingFace
   - Model: `meta-llama/Meta-Llama-3-8B`
   - Capabilities: Text generation, reasoning, coding, multilingual
   - Best for: General-purpose tasks and multilingual support

5. **DeepSeek (ديب سييك)**
   - Provider: HuggingFace
   - Model: `deepseek-ai/deepseek-coder-6.7b-base`
   - Capabilities: Code generation, reasoning, problem-solving
   - Best for: Code generation and programming tasks

6. **Mistral (ميسترال)**
   - Provider: HuggingFace
   - Model: `mistralai/Mistral-7B-v0.1`
   - Capabilities: Text generation, reasoning, multilingual
   - Best for: Balanced performance across tasks

## Usage Examples | أمثلة الاستخدام

### 1. Basic Model Inference | الاستنتاج الأساسي للنماذج

```python
from dlplus.core import ModelManager, ModelsConfig

# Initialize model manager
models_config = ModelsConfig()
manager = ModelManager(models_config)

# Load a model
await manager.load_model('arabert')

# Run inference
result = await manager.inference(
    'arabert',
    'مرحباً، كيف حالك؟',
    {'temperature': 0.7}
)

print(result['output'])
```

### 2. Using Models with Agents | استخدام النماذج مع الوكلاء

```python
from dlplus.agents import CodeGeneratorAgent
from dlplus.core import ModelManager, ModelsConfig

# Create agent
agent = CodeGeneratorAgent()

# Set up model manager
models_config = ModelsConfig()
manager = ModelManager(models_config)
agent.set_model_manager(manager)

# Load preferred models
await manager.preload_models(agent.preferred_models)

# Execute task (agent will use AI models)
result = await agent.run({
    'description': 'دالة لحساب المضروب',
    'language': 'python'
})
```

### 3. Collaborative Execution | التنفيذ التعاوني

```python
from dlplus.core import ModelManager, IntegrationBridge
from dlplus.agents import CodeGeneratorAgent, WebRetrievalAgent
from dlplus.config import ModelsConfig

# Setup
models_config = ModelsConfig()
manager = ModelManager(models_config)
bridge = IntegrationBridge(manager)

# Register agents
bridge.register_agent('code_gen', CodeGeneratorAgent())
bridge.register_agent('web_ret', WebRetrievalAgent())

# Load models
await manager.preload_models(['arabert', 'deepseek'])

# Execute collaborative task
result = await bridge.execute_collaborative(
    {'input': 'ابحث عن معلومات عن الذكاء الصناعي ثم اكتب كود Python'},
    ['arabert', 'deepseek'],
    ['web_ret', 'code_gen']
)
```

### 4. Sequential Execution Chain | سلسلة التنفيذ المتتابع

```python
# Execute tasks in sequence
result = await bridge.execute_sequential(
    {'input': 'اكتب برنامج Python لحساب الأعداد الأولية'},
    [
        {'type': 'model', 'id': 'arabert'},      # Understand Arabic
        {'type': 'model', 'id': 'deepseek'},     # Generate code
        {'type': 'agent', 'id': 'code_gen'}      # Format and validate
    ]
)
```

### 5. Parallel Execution | التنفيذ المتوازي

```python
# Execute multiple models/agents in parallel
result = await bridge.execute_parallel(
    {'input': 'تحليل النص التالي: الذكاء الصناعي'},
    [
        {'type': 'model', 'id': 'arabert'},
        {'type': 'model', 'id': 'camelbert'},
        {'type': 'model', 'id': 'qwen_arabic'}
    ]
)
```

## Execution Modes | أنماط التنفيذ

### 1. Model Only | النموذج فقط
Uses AI model without agent involvement.
```python
result = await bridge.execute_with_model('llama3', {'input': 'query'})
```

### 2. Agent Only | الوكيل فقط
Uses agent without direct model access (agent may use models internally).
```python
result = await agent.run({'input': 'query'})
```

### 3. Collaborative | تعاوني
Models and agents work together.
```python
result = await bridge.execute_collaborative(task, models, agents)
```

### 4. Sequential | متتابع
Execute in a specific order, passing output between steps.
```python
result = await bridge.execute_sequential(task, execution_chain)
```

### 5. Parallel | متوازي
Execute multiple models/agents simultaneously.
```python
result = await bridge.execute_parallel(task, executors)
```

## Best Practices | أفضل الممارسات

### 1. Model Loading | تحميل النماذج

- Load only essential models initially
- Use lazy loading for other models
- Unload unused models to free memory

```python
# Load essential models
await manager.preload_models(['llama3', 'arabert', 'deepseek'])

# Load on-demand
await manager.load_model('mistral')

# Unload when done
await manager.unload_model('mistral')
```

### 2. Resource Management | إدارة الموارد

```python
# Get model statistics
stats = manager.get_model_info('arabert')
print(f"Inference count: {stats['stats']['inference_count']}")

# Cleanup on shutdown
await manager.shutdown()
```

## Integration with DLPlusCore | التكامل مع نواة DL+

The core system automatically initializes all components:

```python
from dlplus import DLPlusCore

# Initialize system
core = DLPlusCore()
await core.initialize()

# Process commands in Arabic
result = await core.process_command('اكتب كود Python لحساب الفيبوناتشي')
```

For more information, see:
- Model configurations: `dlplus/config/models_config.py`
- Agent implementations: `dlplus/agents/`
- Integration tests: `tests/test_integration.py`
