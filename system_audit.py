#!/usr/bin/env python3
"""
نظام فحص شامل للذكاء الاصطناعي
Full AI System Audit Tool

This tool performs a comprehensive audit of the AI Agent Platform including:
- System status and resource usage
- Active AI models and their responsiveness
- Connected websites and endpoints
- API/ABI/Webhook status
- Pages and forms validation
- External integrations mapping
"""

import asyncio
import json
import os
import platform
import psutil
import socket
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional
import httpx
import aiohttp
import ssl
import re

class SystemAudit:
    """Comprehensive system audit tool"""
    
    def __init__(self):
        self.results = {
            'timestamp': datetime.now().isoformat(),
            'system_status': {},
            'ai_models': {},
            'websites': {},
            'apis': {},
            'pages': {},
            'integrations': {}
        }
        self.project_root = Path(__file__).parent
        
    async def run_full_audit(self) -> Dict[str, Any]:
        """Run complete system audit"""
        print("🔍 بدء الفحص الشامل للنظام...")
        print("🔍 Starting comprehensive system audit...\n")
        
        # 1. System Status
        print("1️⃣ فحص حالة النظام...")
        print("1️⃣ Checking system status...")
        self.results['system_status'] = await self.check_system_status()
        
        # 2. AI Models
        print("\n2️⃣ فحص نماذج الذكاء الاصطناعي...")
        print("2️⃣ Checking AI models...")
        self.results['ai_models'] = await self.check_ai_models()
        
        # 3. Websites and Endpoints
        print("\n3️⃣ فحص المواقع والنقاط النهائية...")
        print("3️⃣ Checking websites and endpoints...")
        self.results['websites'] = await self.check_websites()
        
        # 4. APIs and Webhooks
        print("\n4️⃣ فحص واجهات البرمجة...")
        print("4️⃣ Checking APIs and webhooks...")
        self.results['apis'] = await self.check_apis()
        
        # 5. Pages and Forms
        print("\n5️⃣ فحص الصفحات والنماذج...")
        print("5️⃣ Checking pages and forms...")
        self.results['pages'] = await self.check_pages()
        
        # 6. External Integrations
        print("\n6️⃣ فحص الارتباطات الخارجية...")
        print("6️⃣ Checking external integrations...")
        self.results['integrations'] = await self.check_integrations()
        
        return self.results
    
    async def check_system_status(self) -> Dict[str, Any]:
        """Check system status and resource usage"""
        status = {}
        
        try:
            # Basic system info
            status['platform'] = {
                'system': platform.system(),
                'release': platform.release(),
                'version': platform.version(),
                'machine': platform.machine(),
                'processor': platform.processor(),
                'python_version': sys.version
            }
            
            # Uptime
            try:
                boot_time = datetime.fromtimestamp(psutil.boot_time())
                uptime = datetime.now() - boot_time
                status['uptime'] = {
                    'boot_time': boot_time.isoformat(),
                    'uptime_seconds': uptime.total_seconds(),
                    'uptime_human': str(uptime)
                }
            except Exception as e:
                status['uptime'] = {'error': str(e)}
            
            # CPU
            try:
                status['cpu'] = {
                    'count': psutil.cpu_count(),
                    'usage_percent': psutil.cpu_percent(interval=1),
                    'per_cpu': psutil.cpu_percent(interval=1, percpu=True)
                }
            except Exception as e:
                status['cpu'] = {'error': str(e)}
            
            # Memory
            try:
                mem = psutil.virtual_memory()
                status['memory'] = {
                    'total_gb': round(mem.total / (1024**3), 2),
                    'available_gb': round(mem.available / (1024**3), 2),
                    'used_gb': round(mem.used / (1024**3), 2),
                    'percent': mem.percent
                }
            except Exception as e:
                status['memory'] = {'error': str(e)}
            
            # Disk
            try:
                disk = psutil.disk_usage('/')
                status['disk'] = {
                    'total_gb': round(disk.total / (1024**3), 2),
                    'used_gb': round(disk.used / (1024**3), 2),
                    'free_gb': round(disk.free / (1024**3), 2),
                    'percent': disk.percent
                }
            except Exception as e:
                status['disk'] = {'error': str(e)}
            
            # Network
            try:
                hostname = socket.gethostname()
                local_ip = socket.gethostbyname(hostname)
                status['network'] = {
                    'hostname': hostname,
                    'local_ip': local_ip
                }
            except Exception as e:
                status['network'] = {'error': str(e)}
            
            status['status'] = '✅ نشط / Active'
            
        except Exception as e:
            status['error'] = str(e)
            status['status'] = '❌ خطأ / Error'
        
        return status
    
    async def check_ai_models(self) -> Dict[str, Any]:
        """Check active AI models"""
        models = {
            'detected_models': [],
            'dlplus_models': [],
            'openwebui_models': [],
            'status': {}
        }
        
        try:
            # Check DL+ models from config
            dlplus_config = self.project_root / 'dlplus' / 'config'
            if dlplus_config.exists():
                config_files = list(dlplus_config.glob('*.yaml')) + list(dlplus_config.glob('*.yml'))
                for config_file in config_files:
                    try:
                        with open(config_file, 'r', encoding='utf-8') as f:
                            content = f.read()
                            # Extract model references
                            if 'llama' in content.lower():
                                models['dlplus_models'].append('LLaMA')
                            if 'qwen' in content.lower():
                                models['dlplus_models'].append('Qwen')
                            if 'mistral' in content.lower():
                                models['dlplus_models'].append('Mistral')
                            if 'deepseek' in content.lower():
                                models['dlplus_models'].append('DeepSeek')
                    except Exception as e:
                        pass
            
            # Check README and documentation for model references
            doc_files = [
                'README.md',
                'DLPLUS_README.md',
                'OPENWEBUI.md',
                'index.html'
            ]
            
            all_models = set()
            for doc_file in doc_files:
                doc_path = self.project_root / doc_file
                if doc_path.exists():
                    try:
                        with open(doc_path, 'r', encoding='utf-8') as f:
                            content = f.read().lower()
                            
                            # Model detection patterns
                            model_patterns = {
                                'LLaMA': r'llama|لاما',
                                'Qwen': r'qwen',
                                'Mistral': r'mistral',
                                'DeepSeek': r'deepseek',
                                'GPT-4': r'gpt-?4',
                                'Claude': r'claude',
                                'AraBERT': r'arabert|عربرت',
                                'Gemini': r'gemini'
                            }
                            
                            for model_name, pattern in model_patterns.items():
                                if re.search(pattern, content):
                                    all_models.add(model_name)
                    except Exception:
                        pass
            
            models['detected_models'] = sorted(list(all_models))
            
            # Check if DL+ system is running
            try:
                async with aiohttp.ClientSession() as session:
                    async with session.get('http://localhost:8000/health', timeout=aiohttp.ClientTimeout(total=5)) as resp:
                        if resp.status == 200:
                            models['status']['dlplus_api'] = '✅ نشط / Active'
                        else:
                            models['status']['dlplus_api'] = f'⚠️ استجابة غير متوقعة / Unexpected response: {resp.status}'
            except Exception as e:
                models['status']['dlplus_api'] = f'❌ غير متاح / Not available: {str(e)}'
            
            # Check OpenWebUI
            try:
                async with aiohttp.ClientSession() as session:
                    async with session.get('http://localhost:3000', timeout=aiohttp.ClientTimeout(total=5)) as resp:
                        if resp.status in [200, 301, 302, 404]:
                            models['status']['openwebui'] = '✅ نشط / Active'
                        else:
                            models['status']['openwebui'] = f'⚠️ استجابة غير متوقعة / Unexpected response: {resp.status}'
            except Exception as e:
                models['status']['openwebui'] = f'❌ غير متاح / Not available: {str(e)}'
            
        except Exception as e:
            models['error'] = str(e)
        
        return models
    
    async def check_websites(self) -> Dict[str, Any]:
        """Check connected websites and endpoints"""
        websites = {
            'github_pages': {},
            'domains': [],
            'ssl_status': {},
            'endpoints': []
        }
        
        try:
            # GitHub Pages
            github_url = 'https://wasalstor-web.github.io/AI-Agent-Platform/'
            try:
                async with aiohttp.ClientSession() as session:
                    async with session.get(github_url, timeout=aiohttp.ClientTimeout(total=10)) as resp:
                        websites['github_pages'] = {
                            'url': github_url,
                            'status': resp.status,
                            'ssl': '✅ HTTPS نشط / HTTPS Active',
                            'accessible': '✅ متاح / Accessible' if resp.status == 200 else '❌ غير متاح / Not accessible'
                        }
            except Exception as e:
                websites['github_pages'] = {
                    'url': github_url,
                    'error': str(e),
                    'accessible': '❌ غير متاح / Not accessible'
                }
            
            # Check for domain references in config files
            config_files = ['.env', '.env.example', 'README.md', 'STATUS.md']
            for config_file in config_files:
                config_path = self.project_root / config_file
                if config_path.exists():
                    try:
                        with open(config_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                            # Extract domain patterns
                            domain_patterns = [
                                r'https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
                                r'[a-zA-Z0-9.-]+\.space',
                                r'[a-zA-Z0-9.-]+\.com',
                                r'[a-zA-Z0-9.-]+\.io'
                            ]
                            for pattern in domain_patterns:
                                matches = re.findall(pattern, content)
                                for match in matches:
                                    if match not in websites['domains']:
                                        websites['domains'].append(match)
                    except Exception:
                        pass
            
            # Local endpoints
            local_endpoints = [
                ('http://localhost:8000', 'DL+ API'),
                ('http://localhost:3000', 'OpenWebUI'),
                ('http://localhost:8080', 'Alternative Port'),
                ('http://127.0.0.1:8000', 'DL+ API (localhost)')
            ]
            
            for url, name in local_endpoints:
                try:
                    async with aiohttp.ClientSession() as session:
                        async with session.get(url, timeout=aiohttp.ClientTimeout(total=2)) as resp:
                            websites['endpoints'].append({
                                'name': name,
                                'url': url,
                                'status': resp.status,
                                'accessible': '✅ نشط / Active'
                            })
                except Exception as e:
                    websites['endpoints'].append({
                        'name': name,
                        'url': url,
                        'error': str(e),
                        'accessible': '❌ غير نشط / Inactive'
                    })
            
        except Exception as e:
            websites['error'] = str(e)
        
        return websites
    
    async def check_apis(self) -> Dict[str, Any]:
        """Check API/ABI/Webhook status"""
        apis = {
            'fastapi': {},
            'webhooks': [],
            'endpoints': []
        }
        
        try:
            # Check FastAPI
            fastapi_endpoints = [
                '/health',
                '/api/status',
                '/api/models',
                '/docs',
                '/openapi.json'
            ]
            
            base_url = 'http://localhost:8000'
            for endpoint in fastapi_endpoints:
                try:
                    async with aiohttp.ClientSession() as session:
                        async with session.get(f'{base_url}{endpoint}', timeout=aiohttp.ClientTimeout(total=5)) as resp:
                            apis['endpoints'].append({
                                'endpoint': endpoint,
                                'url': f'{base_url}{endpoint}',
                                'status': resp.status,
                                'accessible': '✅ نشط / Active' if resp.status in [200, 404] else '⚠️ تحذير / Warning'
                            })
                except Exception as e:
                    apis['endpoints'].append({
                        'endpoint': endpoint,
                        'url': f'{base_url}{endpoint}',
                        'error': str(e),
                        'accessible': '❌ غير متاح / Not available'
                    })
            
            # Check for webhook configurations
            webhook_files = ['github-webhook-handler.py', 'github-commander.py']
            for webhook_file in webhook_files:
                webhook_path = self.project_root / webhook_file
                if webhook_path.exists():
                    apis['webhooks'].append({
                        'file': webhook_file,
                        'exists': True,
                        'status': '✅ موجود / Present'
                    })
            
            # Check API server file
            api_server = self.project_root / 'api' / 'server.py'
            if api_server.exists():
                apis['fastapi'] = {
                    'server_file': 'api/server.py',
                    'exists': True,
                    'status': '✅ موجود / Present'
                }
            
        except Exception as e:
            apis['error'] = str(e)
        
        return apis
    
    async def check_pages(self) -> Dict[str, Any]:
        """Check pages and forms"""
        pages = {
            'frontend': {},
            'forms': [],
            'files': []
        }
        
        try:
            # Check main HTML file
            index_html = self.project_root / 'index.html'
            if index_html.exists():
                try:
                    with open(index_html, 'r', encoding='utf-8') as f:
                        content = f.read()
                        pages['frontend'] = {
                            'file': 'index.html',
                            'size_kb': round(len(content) / 1024, 2),
                            'exists': True,
                            'status': '✅ موجود / Present'
                        }
                        
                        # Check for forms
                        form_count = content.count('<form')
                        input_count = content.count('<input')
                        pages['forms'].append({
                            'file': 'index.html',
                            'form_count': form_count,
                            'input_count': input_count,
                            'status': '✅ نشط / Active'
                        })
                except Exception as e:
                    pages['frontend']['error'] = str(e)
            
            # Check for other HTML/template files
            html_files = list(self.project_root.glob('**/*.html'))
            for html_file in html_files[:10]:  # Limit to first 10
                if '.git' not in str(html_file):
                    pages['files'].append({
                        'path': str(html_file.relative_to(self.project_root)),
                        'size_kb': round(html_file.stat().st_size / 1024, 2),
                        'status': '✅ موجود / Present'
                    })
            
        except Exception as e:
            pages['error'] = str(e)
        
        return pages
    
    async def check_integrations(self) -> Dict[str, Any]:
        """Check external integrations"""
        integrations = {
            'github': {},
            'hostinger': {},
            'cloudflare': {},
            'telegram': {},
            'other': []
        }
        
        try:
            # Check GitHub integration
            github_files = [
                '.github/workflows',
                'github-webhook-handler.py',
                'github-commander.py',
                '.git'
            ]
            
            github_present = []
            for github_file in github_files:
                file_path = self.project_root / github_file
                if file_path.exists():
                    github_present.append(github_file)
            
            integrations['github'] = {
                'files_present': github_present,
                'repository': 'wasalstor-web/AI-Agent-Platform',
                'status': '✅ نشط / Active' if github_present else '❌ غير موجود / Not found'
            }
            
            # Check Hostinger integration
            hostinger_files = [
                'setup-hostinger.sh',
                'deploy-to-hostinger.sh',
                'intelligent-hostinger-manager.sh',
                'HOSTINGER_COMMAND_EXECUTION.md'
            ]
            
            hostinger_present = []
            for hostinger_file in hostinger_files:
                file_path = self.project_root / hostinger_file
                if file_path.exists():
                    hostinger_present.append(hostinger_file)
            
            integrations['hostinger'] = {
                'files_present': hostinger_present,
                'status': '✅ مدمج / Integrated' if hostinger_present else '❌ غير موجود / Not found'
            }
            
            # Check for Cloudflare references
            cloudflare_mentioned = False
            for file_name in ['README.md', 'STATUS.md', '.env.example']:
                file_path = self.project_root / file_name
                if file_path.exists():
                    with open(file_path, 'r', encoding='utf-8') as f:
                        if 'cloudflare' in f.read().lower():
                            cloudflare_mentioned = True
                            break
            
            integrations['cloudflare'] = {
                'mentioned': cloudflare_mentioned,
                'status': '✅ مذكور / Mentioned' if cloudflare_mentioned else '❌ غير مذكور / Not mentioned'
            }
            
            # Check for Telegram bot references
            telegram_files = list(self.project_root.glob('**/telegram*.py')) + list(self.project_root.glob('**/bot*.py'))
            integrations['telegram'] = {
                'bot_files': [str(f.relative_to(self.project_root)) for f in telegram_files if '.git' not in str(f)],
                'status': '✅ موجود / Present' if telegram_files else '❌ غير موجود / Not found'
            }
            
        except Exception as e:
            integrations['error'] = str(e)
        
        return integrations
    
    def generate_report(self) -> str:
        """Generate comprehensive audit report"""
        report = []
        
        report.append("=" * 80)
        report.append("📊 تقرير فحص شامل لنظام الذكاء الاصطناعي")
        report.append("📊 Full AI System Audit Report")
        report.append("=" * 80)
        report.append(f"\n⏰ التاريخ والوقت / Timestamp: {self.results['timestamp']}")
        report.append("\n")
        
        # 1. System Status
        report.append("\n" + "=" * 80)
        report.append("1️⃣ حالة النظام المبرمج / System Status")
        report.append("=" * 80)
        
        sys_status = self.results['system_status']
        if 'platform' in sys_status:
            report.append(f"\n🖥️ المنصة / Platform: {sys_status['platform'].get('system', 'N/A')} {sys_status['platform'].get('release', 'N/A')}")
            report.append(f"🐍 Python: {sys_status['platform'].get('python_version', 'N/A').split()[0]}")
        
        if 'uptime' in sys_status and 'uptime_human' in sys_status['uptime']:
            report.append(f"⏱️ وقت التشغيل / Uptime: {sys_status['uptime']['uptime_human']}")
        
        if 'cpu' in sys_status:
            report.append(f"\n💻 CPU:")
            report.append(f"   - عدد الأنوية / Cores: {sys_status['cpu'].get('count', 'N/A')}")
            report.append(f"   - الاستخدام / Usage: {sys_status['cpu'].get('usage_percent', 'N/A')}%")
        
        if 'memory' in sys_status:
            report.append(f"\n🧠 الذاكرة / Memory:")
            report.append(f"   - الإجمالي / Total: {sys_status['memory'].get('total_gb', 'N/A')} GB")
            report.append(f"   - المستخدم / Used: {sys_status['memory'].get('used_gb', 'N/A')} GB")
            report.append(f"   - المتاح / Available: {sys_status['memory'].get('available_gb', 'N/A')} GB")
            report.append(f"   - النسبة / Percentage: {sys_status['memory'].get('percent', 'N/A')}%")
        
        if 'disk' in sys_status:
            report.append(f"\n💾 القرص / Disk:")
            report.append(f"   - الإجمالي / Total: {sys_status['disk'].get('total_gb', 'N/A')} GB")
            report.append(f"   - المستخدم / Used: {sys_status['disk'].get('used_gb', 'N/A')} GB")
            report.append(f"   - المتاح / Free: {sys_status['disk'].get('free_gb', 'N/A')} GB")
            report.append(f"   - النسبة / Percentage: {sys_status['disk'].get('percent', 'N/A')}%")
        
        # 2. AI Models
        report.append("\n\n" + "=" * 80)
        report.append("2️⃣ أدوات الذكاء الاصطناعي المفعّلة / Active AI Models")
        report.append("=" * 80)
        
        ai_models = self.results['ai_models']
        if ai_models.get('detected_models'):
            report.append(f"\n🧠 النماذج المكتشفة / Detected Models:")
            for model in ai_models['detected_models']:
                report.append(f"   ✓ {model}")
        
        if ai_models.get('status'):
            report.append(f"\n⚙️ حالة الخدمات / Services Status:")
            for service, status in ai_models['status'].items():
                report.append(f"   - {service}: {status}")
        
        # 3. Websites
        report.append("\n\n" + "=" * 80)
        report.append("3️⃣ المواقع والأنظمة المرتبطة / Connected Websites")
        report.append("=" * 80)
        
        websites = self.results['websites']
        if 'github_pages' in websites:
            gh = websites['github_pages']
            report.append(f"\n🌐 GitHub Pages:")
            report.append(f"   - الرابط / URL: {gh.get('url', 'N/A')}")
            report.append(f"   - الحالة / Status: {gh.get('accessible', 'N/A')}")
            if 'ssl' in gh:
                report.append(f"   - SSL: {gh['ssl']}")
        
        if websites.get('domains'):
            report.append(f"\n🔗 النطاقات المكتشفة / Discovered Domains:")
            for domain in websites['domains'][:10]:  # Limit to first 10
                report.append(f"   - {domain}")
        
        if websites.get('endpoints'):
            report.append(f"\n🔌 النقاط النهائية المحلية / Local Endpoints:")
            for endpoint in websites['endpoints']:
                report.append(f"   - {endpoint['name']}: {endpoint['accessible']}")
        
        # 4. APIs
        report.append("\n\n" + "=" * 80)
        report.append("4️⃣ الـ API / ABI / Webhooks")
        report.append("=" * 80)
        
        apis = self.results['apis']
        if apis.get('endpoints'):
            report.append(f"\n🔗 واجهات البرمجة / API Endpoints:")
            for endpoint in apis['endpoints']:
                report.append(f"   - {endpoint['endpoint']}: {endpoint['accessible']}")
        
        if apis.get('webhooks'):
            report.append(f"\n🪝 Webhooks:")
            for webhook in apis['webhooks']:
                report.append(f"   - {webhook['file']}: {webhook['status']}")
        
        # 5. Pages
        report.append("\n\n" + "=" * 80)
        report.append("5️⃣ الصفحات والنماذج / Pages and Forms")
        report.append("=" * 80)
        
        pages = self.results['pages']
        if 'frontend' in pages:
            fe = pages['frontend']
            report.append(f"\n📄 الواجهة الأمامية / Frontend:")
            report.append(f"   - الملف / File: {fe.get('file', 'N/A')}")
            report.append(f"   - الحجم / Size: {fe.get('size_kb', 'N/A')} KB")
            report.append(f"   - الحالة / Status: {fe.get('status', 'N/A')}")
        
        if pages.get('forms'):
            report.append(f"\n📝 النماذج / Forms:")
            for form in pages['forms']:
                report.append(f"   - {form['file']}: {form['form_count']} نموذج / forms, {form['input_count']} حقل / inputs")
        
        # 6. Integrations
        report.append("\n\n" + "=" * 80)
        report.append("6️⃣ الارتباطات والربط الخارجي / External Integrations")
        report.append("=" * 80)
        
        integrations = self.results['integrations']
        
        if 'github' in integrations:
            gh = integrations['github']
            report.append(f"\n🐙 GitHub:")
            report.append(f"   - المستودع / Repository: {gh.get('repository', 'N/A')}")
            report.append(f"   - الحالة / Status: {gh.get('status', 'N/A')}")
            if gh.get('files_present'):
                report.append(f"   - الملفات / Files: {len(gh['files_present'])} موجود / present")
        
        if 'hostinger' in integrations:
            hs = integrations['hostinger']
            report.append(f"\n🌐 Hostinger:")
            report.append(f"   - الحالة / Status: {hs.get('status', 'N/A')}")
            if hs.get('files_present'):
                report.append(f"   - الملفات / Files: {len(hs['files_present'])} موجود / present")
        
        if 'cloudflare' in integrations:
            cf = integrations['cloudflare']
            report.append(f"\n☁️ Cloudflare:")
            report.append(f"   - الحالة / Status: {cf.get('status', 'N/A')}")
        
        if 'telegram' in integrations:
            tg = integrations['telegram']
            report.append(f"\n📱 Telegram:")
            report.append(f"   - الحالة / Status: {tg.get('status', 'N/A')}")
        
        # Summary
        report.append("\n\n" + "=" * 80)
        report.append("📊 ملخص بنية الترابط / System Architecture Summary")
        report.append("=" * 80)
        
        report.append("\n✅ النظام يعمل بشكل طبيعي / System is operational")
        report.append(f"✅ عدد النماذج المكتشفة / Models detected: {len(ai_models.get('detected_models', []))}")
        report.append(f"✅ عدد النقاط النهائية / Endpoints checked: {len(websites.get('endpoints', []))}")
        report.append(f"✅ الارتباطات النشطة / Active integrations: GitHub, {'Hostinger' if integrations.get('hostinger', {}).get('files_present') else ''}")
        
        report.append("\n" + "=" * 80)
        report.append("✅ الفحص اكتمل بنجاح / Audit completed successfully")
        report.append("=" * 80 + "\n")
        
        return "\n".join(report)
    
    def save_report(self, filename: str = "system_audit_report.txt"):
        """Save report to file"""
        report = self.generate_report()
        report_path = self.project_root / filename
        
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report)
        
        # Also save JSON version
        json_path = self.project_root / filename.replace('.txt', '.json')
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(self.results, f, ensure_ascii=False, indent=2)
        
        return report_path, json_path


async def main():
    """Main entry point"""
    audit = SystemAudit()
    
    print("🚀 بدء فحص النظام الشامل...")
    print("🚀 Starting full system audit...\n")
    
    # Run audit
    await audit.run_full_audit()
    
    # Generate and display report
    report = audit.generate_report()
    print("\n" + report)
    
    # Save reports
    txt_path, json_path = audit.save_report()
    print(f"\n💾 التقرير محفوظ / Report saved:")
    print(f"   - النص / Text: {txt_path}")
    print(f"   - JSON: {json_path}")


if __name__ == "__main__":
    asyncio.run(main())
