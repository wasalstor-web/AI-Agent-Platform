"""
Example: Agent Usage
مثال: استخدام الوكلاء

This example demonstrates how to use DL+ agents.
"""

import asyncio
import sys
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from dlplus.agents import WebRetrievalAgent, CodeGeneratorAgent


async def main():
    """Main example function"""
    print("=" * 70)
    print("🤖 DL+ Agents - Usage Example")
    print("مثال استخدام وكلاء DL+")
    print("=" * 70)
    print()
    
    # Example 1: Web Retrieval Agent
    print("📝 Example 1: Web Retrieval Agent")
    print("-" * 70)
    
    web_agent = WebRetrievalAgent({'max_results': 5})
    result = await web_agent.run({
        'query': 'الذكاء الصناعي في التعليم'
    })
    
    print(f"Success: {result['success']}")
    print(f"Query: {result.get('query', 'N/A')}")
    print(f"Results count: {result.get('count', 0)}")
    if result.get('results'):
        print("Top results:")
        for i, r in enumerate(result['results'][:3], 1):
            print(f"  {i}. {r['title']}")
    print()
    
    # Example 2: Code Generator Agent
    print("📝 Example 2: Code Generator Agent")
    print("-" * 70)
    
    code_agent = CodeGeneratorAgent()
    result = await code_agent.run({
        'description': 'دالة لحساب المتوسط الحسابي',
        'language': 'python',
        'requirements': ['numpy']
    })
    
    print(f"Success: {result['success']}")
    print(f"Language: {result.get('language', 'N/A')}")
    print("Generated code:")
    print(result.get('code', 'N/A'))
    print()
    
    # Example 3: Generate code with tests
    print("📝 Example 3: Code with Tests")
    print("-" * 70)
    
    result = await code_agent.generate_with_tests(
        description='دالة لإيجاد الأعداد الأولية',
        language='python'
    )
    
    if result['success']:
        print("Main code:")
        print(result['code'])
        print("\nTests:")
        print(result['tests'])
    print()
    
    # Example 4: Agent Status
    print("📊 Agent Status")
    print("-" * 70)
    print("Web Agent:", web_agent.get_status())
    print("Code Agent:", code_agent.get_status())
    print()


if __name__ == "__main__":
    asyncio.run(main())
