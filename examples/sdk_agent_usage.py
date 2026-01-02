"""
SDK Agent Usage Examples
أمثلة استخدام وكيل SDK

Examples showing how to use the unified SDK Agent for all operations.
"""

import asyncio
from dlplus.agents import SDKAgent


async def example_basic_usage():
    """مثال أساسي - Basic Example"""
    print("=" * 50)
    print("مثال 1: استخدام أساسي")
    print("=" * 50)
    
    # Initialize SDK Agent
    sdk = SDKAgent()
    
    # Search
    print("\n1. البحث على الويب:")
    result = await sdk.search("الذكاء الاصطناعي")
    print(f"نتائج البحث: {len(result.get('result', {}).get('results', []))} نتيجة")
    
    # Generate code
    print("\n2. توليد كود:")
    code_result = await sdk.generate_code(
        "دالة لحساب مجموع قائمة أرقام",
        language="python"
    )
    print(f"تم توليد الكود: {code_result.get('success')}")
    
    # Translate
    print("\n3. الترجمة:")
    translation = await sdk.translate("مرحباً بك في نظام DL+", target_language="en")
    print(f"الترجمة: {translation.get('result', {}).get('translated_text', '')}")
    
    # Analyze
    print("\n4. التحليل:")
    analysis = await sdk.analyze("هذا منتج رائع ومفيد جداً")
    print(f"المشاعر: {analysis.get('result', {}).get('results', {}).get('sentiment', {}).get('sentiment_arabic', '')}")


async def example_auto_detection():
    """مثال: الكشف التلقائي - Auto Detection Example"""
    print("\n" + "=" * 50)
    print("مثال 2: الكشف التلقائي للعملية")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    # Auto-detect action
    tasks = [
        {"description": "ابحث عن أحدث تقنيات الذكاء الاصطناعي"},
        {"description": "اكتب كود Python لحساب العدد الأولي"},
        {"description": "ترجم هذا النص إلى الإنجليزية"},
        {"description": "حلل مشاعر هذا النص"}
    ]
    
    for task in tasks:
        result = await sdk.execute({"action": "auto", **task})
        print(f"\nالمهمة: {task['description']}")
        print(f"العملية المكتشفة: {result.get('action')}")
        print(f"الوكيل المستخدم: {result.get('agent')}")


async def example_multi_agent():
    """مثال: عمليات متعددة الوكلاء - Multi-Agent Operations"""
    print("\n" + "=" * 50)
    print("مثال 3: عمليات متعددة الوكلاء")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    # Search and analyze
    print("\n1. البحث والتحليل:")
    result = await sdk.search_and_analyze("الذكاء الاصطناعي في 2024")
    print(f"نتائج البحث: {result.get('success')}")
    print(f"التحليل: {result.get('results', {}).get('analysis') is not None}")
    
    # Translate and analyze
    print("\n2. الترجمة والتحليل:")
    result = await sdk.translate_and_analyze(
        "هذا منتج رائع ومفيد جداً",
        target_language="en"
    )
    print(f"الترجمة: {result.get('success')}")
    print(f"تحليل النص الأصلي: {result.get('analysis_original') is not None}")
    print(f"تحليل النص المترجم: {result.get('analysis_translated') is not None}")
    
    # Generate code with search
    print("\n3. توليد كود مع البحث:")
    result = await sdk.generate_code_with_search(
        "دالة لفرز قائمة",
        language="python",
        search_first=True
    )
    print(f"تم توليد الكود: {result.get('success')}")
    print(f"سياق البحث: {result.get('search_context') is not None}")


async def example_comprehensive():
    """مثال: تحليل شامل - Comprehensive Analysis"""
    print("\n" + "=" * 50)
    print("مثال 4: تحليل شامل")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    text = "نظام DL+ هو نظام ذكاء اصطناعي متقدم يوفر وكلاء ذكية للبحث وتوليد الأكواد والترجمة والتحليل"
    
    result = await sdk.comprehensive_analysis(
        text,
        translate=True,
        target_language="en"
    )
    
    print(f"التحليل الأصلي: {result.get('results', {}).get('analysis') is not None}")
    print(f"الترجمة: {result.get('results', {}).get('translation') is not None}")
    print(f"تحليل المترجم: {result.get('results', {}).get('translated_analysis') is not None}")


async def example_batch_operations():
    """مثال: عمليات جماعية - Batch Operations"""
    print("\n" + "=" * 50)
    print("مثال 5: عمليات جماعية")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    # Batch translate
    texts = [
        "مرحباً",
        "شكراً",
        "مع السلامة"
    ]
    
    print("\n1. ترجمة جماعية:")
    result = await sdk.batch_translate(texts, target_language="en")
    print(f"عدد النصوص المترجمة: {result.get('count', 0)}")
    
    # Batch analyze
    print("\n2. تحليل جماعي:")
    result = await sdk.batch_analyze(texts)
    print(f"عدد النصوص المحللة: {result.get('count', 0)}")


async def example_utility_methods():
    """مثال: وظائف مساعدة - Utility Methods"""
    print("\n" + "=" * 50)
    print("مثال 6: وظائف مساعدة")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    # Get available actions
    print("\n1. العمليات المتاحة:")
    actions = sdk.get_available_actions()
    print(f"العمليات: {', '.join(actions)}")
    
    # Get agent info
    print("\n2. معلومات الوكلاء:")
    info = sdk.get_agent_info()
    print(f"عدد الوكلاء الفرعية: {len(info.get('sub_agents', {}))}")
    
    # Health check
    print("\n3. فحص الصحة:")
    health = await sdk.health_check()
    print(f"حالة SDK Agent: {health.get('sdk_agent', {}).get('status')}")


async def example_fact_check():
    """مثال: فحص الحقائق - Fact Checking"""
    print("\n" + "=" * 50)
    print("مثال 7: فحص الحقائق")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    claim = "الذكاء الاصطناعي سيتجاوز الذكاء البشري في 2025"
    
    result = await sdk.fact_check(claim)
    print(f"الادعاء: {claim}")
    print(f"الحكم: {result.get('verdict_arabic', '')}")
    print(f"درجة المصداقية: {result.get('credibility_score', 0):.2f}")


async def example_code_review():
    """مثال: مراجعة الكود - Code Review"""
    print("\n" + "=" * 50)
    print("مثال 8: مراجعة الكود")
    print("=" * 50)
    
    sdk = SDKAgent()
    
    code = """
def calculate_sum(numbers):
    total = 0
    for num in numbers:
        total += num
    return total
"""
    
    result = await sdk.review_code(code, language="python")
    print(f"جودة الكود: {result.get('analysis', {}).get('quality_score', 0):.2f}")
    print(f"عدد المشاكل: {len(result.get('analysis', {}).get('issues', []))}")


async def main():
    """Run all examples"""
    print("\n" + "=" * 50)
    print("أمثلة استخدام وكيل SDK - SDK Agent Usage Examples")
    print("=" * 50)
    
    await example_basic_usage()
    await example_auto_detection()
    await example_multi_agent()
    await example_comprehensive()
    await example_batch_operations()
    await example_utility_methods()
    await example_fact_check()
    await example_code_review()
    
    print("\n" + "=" * 50)
    print("تم الانتهاء من جميع الأمثلة")
    print("=" * 50)


if __name__ == "__main__":
    asyncio.run(main())

