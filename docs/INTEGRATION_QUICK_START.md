# AI Models and Agents Integration - Quick Start
# البدء السريع لتكامل النماذج والوكلاء

## ما الجديد؟ | What's New?

تم تكامل 6 نماذج ذكاء صناعي مفتوحة المصدر مع الوكلاء الذكية لإنشاء منصة تعاونية متقدمة تفهم اللغة العربية بشكل كامل.

We've integrated 6 open-source AI models with intelligent agents to create an advanced collaborative platform with full Arabic language understanding.

## النماذج المتكاملة | Integrated Models

### Arabic Models (نماذج عربية)
1. **AraBERT** - فهم النصوص العربية
2. **CAMeLBERT** - تحليل اللغة العربية المتقدم
3. **Qwen 2.5 Arabic** - توليد النصوص العربية

### General Purpose Models (نماذج عامة)
4. **LLaMA 3** - نموذج متعدد اللغات
5. **DeepSeek** - توليد الأكواد البرمجية
6. **Mistral** - نموذج متوازن الأداء

## الوكلاء المحسّنة | Enhanced Agents

- **CodeGeneratorAgent** - توليد الأكواد باستخدام DeepSeek/LLaMA 3
- **WebRetrievalAgent** - بحث محسّن باستخدام النماذج العربية
- **BaseAgent** - دعم كامل للتكامل مع النماذج

## أمثلة سريعة | Quick Examples

### استخدام النموذج مباشرة | Direct Model Usage

```python
from dlplus.core import ModelManager
from dlplus.config import ModelsConfig

# Initialize
models_config = ModelsConfig()
manager = ModelManager(models_config)

# Load and use AraBERT
await manager.load_model('arabert')
result = await manager.inference('arabert', 'مرحباً بك')
print(result['output'])
```

### استخدام الوكيل مع النماذج | Agent with Models

```python
from dlplus.agents import CodeGeneratorAgent
from dlplus.core import ModelManager

# Create agent with model support
agent = CodeGeneratorAgent()
manager = ModelManager()
agent.set_model_manager(manager)

# Generate code in Arabic
result = await agent.run({
    'description': 'دالة لحساب المضروب',
    'language': 'python'
})
```

### التنفيذ التعاوني | Collaborative Execution

```python
from dlplus.core import IntegrationBridge

# Setup bridge
bridge = IntegrationBridge(manager)
bridge.register_agent('code_gen', agent)

# Collaborative execution
result = await bridge.execute_collaborative(
    {'input': 'ابحث واكتب كود'},
    ['arabert', 'deepseek'],
    ['web_ret', 'code_gen']
)
```

## المزايا الرئيسية | Key Features

✅ **6 نماذج ذكاء صناعي** - AraBERT, CAMeLBERT, Qwen, LLaMA 3, DeepSeek, Mistral
✅ **دعم كامل للعربية** - فهم وتوليد النصوص العربية
✅ **تكامل سلس** - الوكلاء تستخدم النماذج تلقائياً
✅ **أنماط تنفيذ متعددة** - متتابع، متوازي، تعاوني
✅ **إدارة ذكية للموارد** - تحميل/إلغاء تحميل النماذج حسب الحاجة
✅ **إحصائيات شاملة** - مراقبة أداء النماذج والوكلاء

## أنماط التنفيذ | Execution Modes

1. **Model Only** - استخدام النموذج فقط
2. **Agent Only** - استخدام الوكيل فقط
3. **Collaborative** - تعاون بين النماذج والوكلاء
4. **Sequential** - تنفيذ متتابع
5. **Parallel** - تنفيذ متوازي

## الاختبارات | Testing

```bash
# Run all tests (36 tests)
python -m pytest tests/ -v

# Run integration tests only
python -m pytest tests/test_integration.py -v

# Run examples
PYTHONPATH=. python examples/model_integration_examples.py
```

## الوثائق | Documentation

📖 **Full Guide**: [docs/AI_MODELS_INTEGRATION.md](docs/AI_MODELS_INTEGRATION.md)
📝 **Examples**: [examples/model_integration_examples.py](examples/model_integration_examples.py)
🧪 **Tests**: [tests/test_integration.py](tests/test_integration.py)

## البنية | Architecture

```
dlplus/
├── core/
│   ├── model_manager.py        # إدارة دورة حياة النماذج
│   ├── integration_bridge.py   # جسر التكامل بين النماذج والوكلاء
│   └── intelligence_core.py    # النواة الرئيسية المحدّثة
├── agents/
│   ├── base_agent.py           # دعم التكامل مع النماذج
│   ├── code_generator_agent.py # توليد أكواد محسّن
│   └── web_retrieval_agent.py  # بحث محسّن بالذكاء الصناعي
└── config/
    ├── models_config.py        # إعدادات النماذج الستة
    └── agents_config.py        # إعدادات الوكلاء
```

## المتطلبات | Requirements

All dependencies are already in `requirements.txt`:
- fastapi >= 0.104.0
- pydantic >= 2.0.0
- aiofiles >= 23.0.0
- pytest >= 7.4.0

## الخطوات التالية | Next Steps

1. 📚 قراءة الوثائق الكاملة - Read full documentation
2. 🧪 تشغيل الأمثلة - Run examples
3. 🔧 تخصيص النماذج - Customize models
4. 🚀 بناء وكلاء جديدة - Build new agents

## الدعم | Support

لمزيد من المعلومات، راجع:
- Model configurations: `dlplus/config/models_config.py`
- Agent implementations: `dlplus/agents/`
- Core integration: `dlplus/core/`

---

**Author**: خليف "ذيبان" العنزي
**Location**: القصيم – بريدة – المملكة العربية السعودية
**Project**: DL+ Unified Arabic Intelligence System
