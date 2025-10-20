"""
Example: Basic DL+ Usage
مثال: الاستخدام الأساسي لنظام DL+

This example demonstrates basic usage of the DL+ system.
"""

import asyncio
import sys
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from dlplus import DLPlusCore, Settings


async def main():
    """Main example function"""
    print("=" * 70)
    print("🧠 DL+ System - Basic Usage Example")
    print("مثال الاستخدام الأساسي لنظام DL+")
    print("=" * 70)
    print()
    
    # Load settings
    print("⚙️  Loading settings...")
    settings = Settings()
    print(f"✅ System: {settings.system_name_arabic}")
    print()
    
    # Initialize core
    print("🧠 Initializing DL+ Core...")
    core = DLPlusCore()
    await core.initialize()
    print()
    
    # Example 1: Simple greeting
    print("📝 Example 1: Simple Greeting")
    print("-" * 70)
    result = await core.process_command("مرحباً، كيف حالك؟")
    print(f"Response: {result['response']}")
    print()
    
    # Example 2: Code generation request
    print("📝 Example 2: Code Generation")
    print("-" * 70)
    result = await core.process_command(
        "اكتب لي كود بايثون لحساب مجموع قائمة من الأرقام"
    )
    print(f"Intent: {result['intent']}")
    print(f"Response: {result['response']}")
    print()
    
    # Example 3: Information search
    print("📝 Example 3: Information Search")
    print("-" * 70)
    result = await core.process_command(
        "ابحث عن معلومات حول الذكاء الصناعي"
    )
    print(f"Intent: {result['intent']}")
    print(f"Response: {result['response']}")
    print()
    
    # Check system status
    print("📊 System Status")
    print("-" * 70)
    status = await core.get_status()
    print(f"Initialized: {status['initialized']}")
    print(f"Models: {status['models']}")
    print(f"Agents: {status['agents']}")
    print(f"Context History: {status['context_history_size']}")
    print()
    
    # Shutdown
    print("🔌 Shutting down...")
    await core.shutdown()
    print("✅ Done!")
    print()


if __name__ == "__main__":
    asyncio.run(main())
