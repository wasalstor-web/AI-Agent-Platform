#!/usr/bin/env python3
"""
أمثلة على تنفيذ الأوامر على خادم Hostinger
Examples of Command Execution on Hostinger Server

This script demonstrates how to interact with the DL+ system
to execute commands on a Hostinger server.
"""

import asyncio
import httpx
from typing import Dict, Any


class HostingerCommandExecutor:
    """
    منفذ أوامر Hostinger
    Hostinger Command Executor

    A simple client for executing commands on Hostinger through DL+ API.
    """

    def __init__(self, base_url: str, api_key: str):
        """
        Initialize the executor

        Args:
            base_url: Base URL of DL+ API (e.g., http://your-server:8000)
            api_key: Your API key for authentication
        """
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key
        self.headers = {"X-API-Key": api_key, "Content-Type": "application/json"}

    async def execute(self, command_type: str, payload: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute a command on Hostinger

        Args:
            command_type: Type of command (e.g., 'file_create', 'service_restart')
            payload: Command payload

        Returns:
            Response from the server
        """
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.base_url}/api/github/execute",
                headers=self.headers,
                json={"type": command_type, "payload": payload},
                timeout=30.0,
            )
            response.raise_for_status()
            return response.json()

    async def check_health(self) -> Dict[str, Any]:
        """Check API health"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/api/health")
            response.raise_for_status()
            return response.json()

    async def get_status(self) -> Dict[str, Any]:
        """Get system status"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/api/status", headers=self.headers)
            response.raise_for_status()
            return response.json()


# ============================================================================
# أمثلة الاستخدام / Usage Examples
# ============================================================================


async def example_1_file_operations():
    """
    مثال 1: عمليات الملفات
    Example 1: File Operations
    """
    print("=" * 60)
    print("مثال 1: عمليات الملفات / Example 1: File Operations")
    print("=" * 60)

    executor = HostingerCommandExecutor(base_url="http://localhost:8000", api_key="your-secret-key")

    try:
        # 1. إنشاء ملف / Create a file
        print("\n1. إنشاء ملف جديد / Creating new file...")
        result = await executor.execute(
            "file_create", {"path": "data/test.txt", "content": "مرحباً من نظام DL+\nHello from DL+ System"}
        )
        print(f"✅ نجح: {result}")

        # 2. قراءة الملف / Read the file
        print("\n2. قراءة الملف / Reading file...")
        result = await executor.execute("file_read", {"path": "data/test.txt"})
        print(f"✅ المحتوى: {result['result']['content']}")

        # 3. تحديث الملف / Update the file
        print("\n3. تحديث الملف / Updating file...")
        result = await executor.execute(
            "file_update", {"path": "data/test.txt", "content": "محتوى محدث\nUpdated content"}
        )
        print(f"✅ نجح: {result}")

        # 4. حذف الملف / Delete the file
        print("\n4. حذف الملف / Deleting file...")
        result = await executor.execute("file_delete", {"path": "data/test.txt"})
        print(f"✅ نجح: {result}")

    except Exception as e:
        print(f"❌ خطأ / Error: {e}")


async def example_2_service_management():
    """
    مثال 2: إدارة الخدمات
    Example 2: Service Management
    """
    print("\n" + "=" * 60)
    print("مثال 2: إدارة الخدمات / Example 2: Service Management")
    print("=" * 60)

    executor = HostingerCommandExecutor(base_url="http://localhost:8000", api_key="your-secret-key")

    try:
        # إعادة تشغيل OpenWebUI / Restart OpenWebUI
        print("\nإعادة تشغيل OpenWebUI / Restarting OpenWebUI...")
        result = await executor.execute("service_restart", {"service": "openwebui"})
        print(f"✅ نجح: {result}")

    except Exception as e:
        print(f"❌ خطأ / Error: {e}")


async def example_3_openwebui_management():
    """
    مثال 3: إدارة OpenWebUI
    Example 3: OpenWebUI Management
    """
    print("\n" + "=" * 60)
    print("مثال 3: إدارة OpenWebUI / Example 3: OpenWebUI Management")
    print("=" * 60)

    executor = HostingerCommandExecutor(base_url="http://localhost:8000", api_key="your-secret-key")

    try:
        # 1. فحص الحالة / Check status
        print("\n1. فحص حالة OpenWebUI / Checking OpenWebUI status...")
        result = await executor.execute("openwebui_manage", {"action": "status"})
        print(f"✅ الحالة: {result}")

        # 2. إعادة التشغيل / Restart
        print("\n2. إعادة تشغيل OpenWebUI / Restarting OpenWebUI...")
        result = await executor.execute("openwebui_manage", {"action": "restart"})
        print(f"✅ نجح: {result}")

    except Exception as e:
        print(f"❌ خطأ / Error: {e}")


async def example_4_logs_and_status():
    """
    مثال 4: السجلات والحالة
    Example 4: Logs and Status
    """
    print("\n" + "=" * 60)
    print("مثال 4: السجلات والحالة / Example 4: Logs and Status")
    print("=" * 60)

    executor = HostingerCommandExecutor(base_url="http://localhost:8000", api_key="your-secret-key")

    try:
        # 1. فحص صحة النظام / Health check
        print("\n1. فحص صحة النظام / System health check...")
        health = await executor.check_health()
        print(f"✅ الصحة: {health}")

        # 2. حالة النظام / System status
        print("\n2. حالة النظام / System status...")
        status = await executor.get_status()
        print(f"✅ الحالة: {status}")

        # 3. عرض السجلات / View logs
        print("\n3. عرض سجلات التنفيذ / View execution logs...")
        result = await executor.execute("log_view", {"log_type": "execution", "lines": 10})
        logs = result.get("result", {}).get("logs", [])
        print(f"✅ آخر {len(logs)} عملية:")
        for log in logs[-5:]:  # عرض آخر 5 عمليات / Show last 5 operations
            print(f"   - {log.get('timestamp', 'N/A')}: {log.get('command_type', 'N/A')} - {log.get('status', 'N/A')}")

        # 4. فحص الحالة / Status check
        print("\n4. فحص حالة التنفيذ / Execution status check...")
        result = await executor.execute("status_check", {})
        print(f"✅ التفاصيل: {result}")

    except Exception as e:
        print(f"❌ خطأ / Error: {e}")


async def example_5_backup():
    """
    مثال 5: النسخ الاحتياطي
    Example 5: Backup
    """
    print("\n" + "=" * 60)
    print("مثال 5: النسخ الاحتياطي / Example 5: Backup")
    print("=" * 60)

    executor = HostingerCommandExecutor(base_url="http://localhost:8000", api_key="your-secret-key")

    try:
        # إنشاء نسخة احتياطية / Create backup
        print("\nإنشاء نسخة احتياطية كاملة / Creating full backup...")
        result = await executor.execute("backup_create", {"type": "full"})
        print(f"✅ نجح: {result}")
        print(f"   اسم النسخة / Backup name: {result['result']['backup_name']}")

    except Exception as e:
        print(f"❌ خطأ / Error: {e}")


async def example_6_workflow():
    """
    مثال 6: سير عمل كامل
    Example 6: Complete Workflow

    This example demonstrates a complete deployment workflow:
    1. Create configuration file
    2. Restart service
    3. Check status
    4. Create backup
    """
    print("\n" + "=" * 60)
    print("مثال 6: سير عمل كامل / Example 6: Complete Workflow")
    print("=" * 60)

    executor = HostingerCommandExecutor(base_url="http://localhost:8000", api_key="your-secret-key")

    try:
        # 1. إنشاء ملف تكوين / Create config file
        print("\n1. إنشاء ملف التكوين / Creating configuration file...")
        config_content = """
# DL+ Configuration
server:
  host: 0.0.0.0
  port: 8000
  debug: false

logging:
  level: INFO
  format: json

security:
  enable_authentication: true
  allowed_origins:
    - https://yourdomain.com
"""
        result = await executor.execute("file_create", {"path": "config/production.yaml", "content": config_content})
        print("✅ ملف التكوين تم إنشاؤه / Config file created")

        # 2. إنشاء نسخة احتياطية قبل التحديث / Backup before update
        print("\n2. إنشاء نسخة احتياطية / Creating backup...")
        result = await executor.execute("backup_create", {"type": "full"})
        print(f"✅ النسخة الاحتياطية: {result['result']['backup_name']}")

        # 3. إعادة تشغيل الخدمة / Restart service
        print("\n3. إعادة تشغيل الخدمة / Restarting service...")
        result = await executor.execute("openwebui_manage", {"action": "restart"})
        print("✅ الخدمة تم إعادة تشغيلها / Service restarted")

        # 4. فحص الحالة / Check status
        print("\n4. فحص الحالة بعد التحديث / Checking status after update...")
        await asyncio.sleep(2)  # انتظار قصير / Short wait
        health = await executor.check_health()
        print(f"✅ الصحة: {health['status']}")

        # 5. عرض السجلات الأخيرة / View recent logs
        print("\n5. عرض السجلات الأخيرة / Viewing recent logs...")
        result = await executor.execute("log_view", {"log_type": "execution", "lines": 5})
        print("✅ العمليات الأخيرة / Recent operations:")
        for log in result["result"]["logs"][-3:]:
            print(f"   - {log['command_type']}: {log['status']}")

        print("\n🎉 سير العمل اكتمل بنجاح! / Workflow completed successfully!")

    except Exception as e:
        print(f"❌ خطأ / Error: {e}")


async def main():
    """
    الدالة الرئيسية - تشغيل جميع الأمثلة
    Main function - Run all examples
    """
    print("\n")
    print("=" * 60)
    print("  أمثلة تنفيذ الأوامر على Hostinger")
    print("  Hostinger Command Execution Examples")
    print("=" * 60)
    print("\n⚠️  ملاحظة: تأكد من تشغيل نظام DL+ أولاً!")
    print("⚠️  Note: Make sure DL+ system is running first!")
    print("   ./start-dlplus.sh")
    print("\n⚠️  وتحديث API key في الأمثلة!")
    print("⚠️  And update the API key in the examples!")
    print()

    # اختر الأمثلة التي تريد تشغيلها / Choose which examples to run
    # يمكنك التعليق/إلغاء التعليق على السطور التالية
    # You can comment/uncomment the following lines

    await example_1_file_operations()
    await example_2_service_management()
    await example_3_openwebui_management()
    await example_4_logs_and_status()
    await example_5_backup()
    await example_6_workflow()

    print("\n" + "=" * 60)
    print("✅ جميع الأمثلة اكتملت! / All examples completed!")
    print("=" * 60)


if __name__ == "__main__":
    # تشغيل الأمثلة / Run examples
    asyncio.run(main())
