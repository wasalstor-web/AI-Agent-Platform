"""
Tests for System Audit Tool
اختبارات أداة فحص النظام الشامل
"""

import pytest
import asyncio
import json
from pathlib import Path
import sys

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from system_audit import SystemAudit


@pytest.mark.asyncio
async def test_system_audit_initialization():
    """Test SystemAudit initialization"""
    audit = SystemAudit()
    
    assert audit is not None
    assert 'timestamp' in audit.results
    assert 'system_status' in audit.results
    assert 'ai_models' in audit.results
    assert 'websites' in audit.results
    assert 'apis' in audit.results
    assert 'pages' in audit.results
    assert 'integrations' in audit.results


@pytest.mark.asyncio
async def test_check_system_status():
    """Test system status checking"""
    audit = SystemAudit()
    status = await audit.check_system_status()
    
    assert status is not None
    assert 'platform' in status
    assert 'cpu' in status
    assert 'memory' in status
    assert 'disk' in status
    assert status['status'] == '✅ نشط / Active'


@pytest.mark.asyncio
async def test_check_ai_models():
    """Test AI models detection"""
    audit = SystemAudit()
    models = await audit.check_ai_models()
    
    assert models is not None
    assert 'detected_models' in models
    assert 'status' in models
    assert isinstance(models['detected_models'], list)


@pytest.mark.asyncio
async def test_check_websites():
    """Test website checking"""
    audit = SystemAudit()
    websites = await audit.check_websites()
    
    assert websites is not None
    assert 'github_pages' in websites
    assert 'domains' in websites
    assert 'endpoints' in websites
    assert isinstance(websites['domains'], list)


@pytest.mark.asyncio
async def test_check_apis():
    """Test API checking"""
    audit = SystemAudit()
    apis = await audit.check_apis()
    
    assert apis is not None
    assert 'endpoints' in apis
    assert 'webhooks' in apis
    assert isinstance(apis['endpoints'], list)


@pytest.mark.asyncio
async def test_check_pages():
    """Test page checking"""
    audit = SystemAudit()
    pages = await audit.check_pages()
    
    assert pages is not None
    assert 'frontend' in pages
    assert 'forms' in pages
    assert 'files' in pages


@pytest.mark.asyncio
async def test_check_integrations():
    """Test integrations checking"""
    audit = SystemAudit()
    integrations = await audit.check_integrations()
    
    assert integrations is not None
    assert 'github' in integrations
    assert 'hostinger' in integrations
    assert 'cloudflare' in integrations
    assert 'telegram' in integrations


@pytest.mark.asyncio
async def test_run_full_audit():
    """Test complete audit run"""
    audit = SystemAudit()
    results = await audit.run_full_audit()
    
    assert results is not None
    assert 'timestamp' in results
    assert 'system_status' in results
    assert 'ai_models' in results
    assert 'websites' in results
    assert 'apis' in results
    assert 'pages' in results
    assert 'integrations' in results
    
    # Verify system status was checked
    assert results['system_status'] != {}
    assert 'platform' in results['system_status']


def test_generate_report():
    """Test report generation"""
    audit = SystemAudit()
    
    # Add some dummy data
    audit.results['system_status'] = {
        'platform': {'system': 'Linux', 'python_version': '3.12'},
        'cpu': {'count': 4, 'usage_percent': 10.0},
        'memory': {'total_gb': 16, 'used_gb': 8, 'percent': 50},
        'disk': {'total_gb': 100, 'used_gb': 50, 'percent': 50},
        'status': '✅ نشط / Active'
    }
    audit.results['ai_models'] = {
        'detected_models': ['LLaMA', 'GPT-4'],
        'status': {}
    }
    audit.results['websites'] = {
        'github_pages': {'url': 'test', 'accessible': 'yes'},
        'domains': ['example.com'],
        'endpoints': []
    }
    audit.results['apis'] = {'endpoints': [], 'webhooks': []}
    audit.results['pages'] = {'frontend': {}, 'forms': []}
    audit.results['integrations'] = {
        'github': {'status': '✅ نشط / Active'},
        'hostinger': {'status': '✅ مدمج / Integrated'}
    }
    
    report = audit.generate_report()
    
    assert report is not None
    assert isinstance(report, str)
    assert len(report) > 0
    assert '📊 تقرير فحص شامل' in report
    assert 'Full AI System Audit Report' in report
    assert '✅' in report


def test_save_report(tmp_path):
    """Test report saving"""
    audit = SystemAudit()
    audit.project_root = tmp_path
    
    # Add minimal data
    audit.results['system_status'] = {'status': '✅ نشط / Active'}
    audit.results['ai_models'] = {'detected_models': []}
    audit.results['websites'] = {'github_pages': {}, 'domains': [], 'endpoints': []}
    audit.results['apis'] = {'endpoints': [], 'webhooks': []}
    audit.results['pages'] = {'frontend': {}, 'forms': []}
    audit.results['integrations'] = {}
    
    # Save report
    txt_path, json_path = audit.save_report()
    
    # Verify files were created
    assert txt_path.exists()
    assert json_path.exists()
    
    # Verify text report content
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
        assert '📊 تقرير فحص شامل' in content
        assert 'Full AI System Audit Report' in content
    
    # Verify JSON report content
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        assert 'timestamp' in data
        assert 'system_status' in data
        assert 'ai_models' in data
