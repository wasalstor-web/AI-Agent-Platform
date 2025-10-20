#!/usr/bin/env python3
"""
GitHub Actions Command Execution Examples
Demonstrates how to use github-commander.py to execute commands on Hostinger server
"""

import subprocess
import json
import sys
from typing import Dict, Any, Optional

def run_command(command_type: str, payload: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    """
    Execute a command using github-commander.py
    
    Args:
        command_type: Type of command to execute
        payload: Command payload as dictionary
        
    Returns:
        Command result or None if failed
    """
    try:
        result = subprocess.run(
            ['python3', 'github-commander.py', command_type, json.dumps(payload)],
            capture_output=True,
            text=True,
            timeout=120
        )
        
        if result.returncode == 0:
            return json.loads(result.stdout) if result.stdout else None
        else:
            print(f"Command failed: {result.stderr}")
            return None
            
    except subprocess.TimeoutExpired:
        print("Command timed out")
        return None
    except Exception as e:
        print(f"Error executing command: {e}")
        return None

def example_status_check():
    """Example: Check server status"""
    print("=" * 60)
    print("Example 1: Status Check")
    print("=" * 60)
    
    result = run_command('status_check', {})
    if result:
        print(json.dumps(result, indent=2))
    print()

def example_file_operations():
    """Example: File operations"""
    print("=" * 60)
    print("Example 2: File Operations")
    print("=" * 60)
    
    # Create file
    print("Creating file...")
    result = run_command('file_create', {
        'path': 'data/test_from_github.txt',
        'content': 'This file was created from GitHub Actions!'
    })
    if result:
        print(f"✓ File created: {result}")
    
    # Read file
    print("\nReading file...")
    result = run_command('file_read', {
        'path': 'data/test_from_github.txt'
    })
    if result:
        print(f"✓ File content: {result}")
    
    # Update file
    print("\nUpdating file...")
    result = run_command('file_update', {
        'path': 'data/test_from_github.txt',
        'content': 'Updated content from GitHub Actions!'
    })
    if result:
        print(f"✓ File updated: {result}")
    
    # Delete file
    print("\nDeleting file...")
    result = run_command('file_delete', {
        'path': 'data/test_from_github.txt'
    })
    if result:
        print(f"✓ File deleted: {result}")
    print()

def example_openwebui_management():
    """Example: Manage OpenWebUI service"""
    print("=" * 60)
    print("Example 3: OpenWebUI Management")
    print("=" * 60)
    
    # Check status
    print("Checking OpenWebUI status...")
    result = run_command('openwebui_manage', {
        'action': 'status'
    })
    if result:
        print(json.dumps(result, indent=2))
    print()

def example_service_restart():
    """Example: Restart a service"""
    print("=" * 60)
    print("Example 4: Service Restart")
    print("=" * 60)
    
    print("Restarting OpenWebUI service...")
    result = run_command('service_restart', {
        'service': 'openwebui'
    })
    if result:
        print(json.dumps(result, indent=2))
    print()

def example_log_view():
    """Example: View logs"""
    print("=" * 60)
    print("Example 5: View Logs")
    print("=" * 60)
    
    print("Viewing execution logs...")
    result = run_command('log_view', {
        'log_type': 'execution',
        'lines': 20
    })
    if result:
        print(json.dumps(result, indent=2))
    print()

def example_backup_create():
    """Example: Create backup"""
    print("=" * 60)
    print("Example 6: Create Backup")
    print("=" * 60)
    
    print("Creating full backup...")
    result = run_command('backup_create', {
        'type': 'full'
    })
    if result:
        print(json.dumps(result, indent=2))
    print()

def example_github_actions_workflow():
    """Example: GitHub Actions workflow simulation"""
    print("=" * 60)
    print("Example 7: Simulated GitHub Actions Workflow")
    print("=" * 60)
    
    print("Simulating a deployment workflow...")
    
    # Step 1: Check status
    print("\n1. Checking server status...")
    run_command('status_check', {})
    
    # Step 2: Create deployment marker
    print("\n2. Creating deployment marker...")
    run_command('file_create', {
        'path': 'deployments/current.txt',
        'content': f'Deployment at {__import__("datetime").datetime.now().isoformat()}'
    })
    
    # Step 3: Restart services
    print("\n3. Restarting services...")
    run_command('service_restart', {
        'service': 'openwebui'
    })
    
    # Step 4: Verify deployment
    print("\n4. Verifying deployment...")
    run_command('openwebui_manage', {
        'action': 'status'
    })
    
    # Step 5: Create backup
    print("\n5. Creating post-deployment backup...")
    run_command('backup_create', {
        'type': 'full'
    })
    
    print("\n✓ Deployment workflow complete!")
    print()

def example_continuous_monitoring():
    """Example: Continuous monitoring"""
    print("=" * 60)
    print("Example 8: Continuous Monitoring")
    print("=" * 60)
    
    print("Running continuous health checks...")
    
    for i in range(3):
        print(f"\nHealth check #{i+1}...")
        result = run_command('status_check', {})
        if result:
            print("✓ Server is healthy")
        else:
            print("✗ Server health check failed")
        
        if i < 2:
            print("Waiting 5 seconds...")
            __import__('time').sleep(5)
    
    print("\n✓ Monitoring complete!")
    print()

def print_menu():
    """Print example menu"""
    print("\n" + "=" * 60)
    print("GitHub Actions Command Execution Examples")
    print("=" * 60)
    print("\nAvailable examples:")
    print("  1. Status Check")
    print("  2. File Operations (Create, Read, Update, Delete)")
    print("  3. OpenWebUI Management")
    print("  4. Service Restart")
    print("  5. View Logs")
    print("  6. Create Backup")
    print("  7. Simulated GitHub Actions Workflow")
    print("  8. Continuous Monitoring")
    print("  9. Run All Examples")
    print("  0. Exit")
    print()

def main():
    """Main function"""
    examples = {
        '1': example_status_check,
        '2': example_file_operations,
        '3': example_openwebui_management,
        '4': example_service_restart,
        '5': example_log_view,
        '6': example_backup_create,
        '7': example_github_actions_workflow,
        '8': example_continuous_monitoring,
    }
    
    if len(sys.argv) > 1:
        # Run specific example from command line
        choice = sys.argv[1]
        if choice == '9':
            for func in examples.values():
                func()
        elif choice in examples:
            examples[choice]()
        else:
            print(f"Invalid example number: {choice}")
            print_menu()
    else:
        # Interactive mode
        while True:
            print_menu()
            choice = input("Choose an example (0-9): ").strip()
            
            if choice == '0':
                print("Exiting...")
                break
            elif choice == '9':
                print("\nRunning all examples...")
                for func in examples.values():
                    func()
            elif choice in examples:
                examples[choice]()
            else:
                print(f"Invalid choice: {choice}")

if __name__ == "__main__":
    main()
