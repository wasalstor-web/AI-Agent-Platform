"""
Example: API Client Usage
مثال: استخدام عميل API

This example demonstrates how to interact with the DL+ API.
"""

import asyncio
import httpx


async def main():
    """Main example function"""
    print("=" * 70)
    print("🔌 DL+ API Client - Usage Example")
    print("مثال استخدام عميل واجهة API")
    print("=" * 70)
    print()
    
    # Configuration
    BASE_URL = "http://localhost:8000"
    API_KEY = "your-api-key-here"  # Replace with your actual API key
    
    headers = {
        "X-API-Key": API_KEY,
        "Content-Type": "application/json"
    }
    
    async with httpx.AsyncClient() as client:
        # Example 1: Health Check
        print("📝 Example 1: Health Check")
        print("-" * 70)
        
        response = await client.get(f"{BASE_URL}/api/health")
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        print()
        
        # Example 2: System Status
        print("📝 Example 2: System Status")
        print("-" * 70)
        
        response = await client.get(
            f"{BASE_URL}/api/status",
            headers=headers
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"System Status: {data['status']}")
            print(f"Initialized: {data['initialized']}")
            print(f"Models: {data['models']}")
            print(f"Agents: {data['agents']}")
        else:
            print(f"Error: {response.status_code}")
        print()
        
        # Example 3: Process Command
        print("📝 Example 3: Process Command")
        print("-" * 70)
        
        response = await client.post(
            f"{BASE_URL}/api/process",
            headers=headers,
            json={
                "command": "اشرح لي ما هو الذكاء الصناعي",
                "context": {
                    "user_id": "example_user",
                    "language": "ar"
                }
            }
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"Success: {data['success']}")
            print(f"Intent: {data['intent']}")
            print(f"Response: {data['response']}")
        else:
            print(f"Error: {response.status_code}")
        print()
        
        # Example 4: Execute GitHub Command
        print("📝 Example 4: Execute Command")
        print("-" * 70)
        
        response = await client.post(
            f"{BASE_URL}/api/github/execute",
            headers=headers,
            json={
                "type": "status_check",
                "payload": {}
            }
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"Success: {data['success']}")
            print(f"Result: {data['result']}")
        else:
            print(f"Error: {response.status_code}")
        print()


if __name__ == "__main__":
    print("⚠️  Make sure the DL+ server is running on http://localhost:8000")
    print("   Start it with: python dlplus/main.py")
    print()
    
    try:
        asyncio.run(main())
    except httpx.ConnectError:
        print("\n❌ Could not connect to the server.")
        print("   Please make sure the DL+ server is running.")
    except Exception as e:
        print(f"\n❌ Error: {e}")
