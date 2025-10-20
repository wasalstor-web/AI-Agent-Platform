/**
 * Supreme Agent - Web Interface JavaScript
 * الوكيل الأعلى - واجهة الويب
 * 
 * Author: wasalstor-web
 * Date: 2025-10-20
 */

// Configuration / الإعدادات
let config = {
    apiUrl: localStorage.getItem('apiUrl') || 'http://localhost:5000',
    defaultModel: localStorage.getItem('defaultModel') || 'supreme-executor',
    temperature: parseFloat(localStorage.getItem('temperature')) || 0.7,
    language: localStorage.getItem('language') || 'ar',
    theme: localStorage.getItem('theme') || 'light'
};

// State / الحالة
let state = {
    currentTab: 'chat',
    conversationHistory: JSON.parse(localStorage.getItem('conversationHistory')) || [],
    isConnected: false
};

// Initialize / التهيئة
document.addEventListener('DOMContentLoaded', () => {
    initializeTheme();
    initializeLanguage();
    initializeTabs();
    initializeEventListeners();
    checkHealth();
    loadHistory();
});

// Theme Management / إدارة الوضع
function initializeTheme() {
    document.documentElement.setAttribute('data-theme', config.theme);
    updateThemeIcon();
}

function toggleTheme() {
    config.theme = config.theme === 'light' ? 'dark' : 'light';
    localStorage.setItem('theme', config.theme);
    initializeTheme();
}

function updateThemeIcon() {
    const icon = document.querySelector('#themeToggle .icon');
    icon.textContent = config.theme === 'light' ? '🌙' : '☀️';
}

// Language Management / إدارة اللغة
function initializeLanguage() {
    document.documentElement.setAttribute('dir', config.language === 'ar' ? 'rtl' : 'ltr');
    document.documentElement.setAttribute('lang', config.language);
    updateLanguageTexts();
}

function toggleLanguage() {
    config.language = config.language === 'ar' ? 'en' : 'ar';
    localStorage.setItem('language', config.language);
    initializeLanguage();
}

function updateLanguageTexts() {
    const elements = document.querySelectorAll('[data-ar][data-en]');
    elements.forEach(el => {
        const text = config.language === 'ar' ? el.getAttribute('data-ar') : el.getAttribute('data-en');
        if (el.placeholder !== undefined) {
            el.placeholder = text;
        } else {
            el.textContent = text;
        }
    });
}

// Tab Management / إدارة التبويبات
function initializeTabs() {
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.addEventListener('click', () => {
            const tab = item.getAttribute('data-tab');
            switchTab(tab);
        });
    });
}

function switchTab(tabName) {
    // Update navigation
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('data-tab') === tabName) {
            item.classList.add('active');
        }
    });
    
    // Update content
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.remove('active');
        if (content.id === `tab-${tabName}`) {
            content.classList.add('active');
        }
    });
    
    state.currentTab = tabName;
    
    // Load data for specific tabs
    if (tabName === 'models') {
        loadModels();
    } else if (tabName === 'history') {
        displayHistory();
    }
}

// Event Listeners / مستمعي الأحداث
function initializeEventListeners() {
    // Theme toggle
    document.getElementById('themeToggle').addEventListener('click', toggleTheme);
    
    // Language toggle
    document.getElementById('langToggle').addEventListener('click', toggleLanguage);
    
    // Settings
    document.getElementById('settingsBtn').addEventListener('click', openSettings);
    document.querySelector('.modal-close').addEventListener('click', closeSettings);
    document.getElementById('saveSettingsBtn').addEventListener('click', saveSettings);
    
    // Chat
    document.getElementById('chatSendBtn').addEventListener('click', sendChatMessage);
    document.getElementById('chatInput').addEventListener('keypress', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendChatMessage();
        }
    });
    
    // Execute
    document.getElementById('executeBtn').addEventListener('click', executeCommand);
    
    // Analyze
    document.getElementById('analyzeBtn').addEventListener('click', analyzeFile);
    document.getElementById('analyzeFileUpload').addEventListener('change', handleFileUpload);
    
    // Generate
    document.getElementById('generateBtn').addEventListener('click', generateCode);
    
    // Models
    document.getElementById('refreshModelsBtn').addEventListener('click', loadModels);
    
    // History
    document.getElementById('exportHistoryBtn').addEventListener('click', exportHistory);
    document.getElementById('clearHistoryBtn').addEventListener('click', clearHistory);
    
    // Temperature slider
    document.getElementById('temperature').addEventListener('input', (e) => {
        document.getElementById('temperatureValue').textContent = e.target.value;
    });
}

// API Functions / دوال API
async function apiCall(endpoint, method = 'GET', data = null) {
    try {
        const options = {
            method,
            headers: {
                'Content-Type': 'application/json'
            }
        };
        
        if (data) {
            options.body = JSON.stringify(data);
        }
        
        const response = await fetch(`${config.apiUrl}${endpoint}`, options);
        const result = await response.json();
        
        return result;
    } catch (error) {
        console.error('API call error:', error);
        showNotification('خطأ في الاتصال / Connection error', 'error');
        return { success: false, error: error.message };
    }
}

// Health Check / فحص الصحة
async function checkHealth() {
    const result = await apiCall('/api/health');
    
    if (result.status === 'healthy') {
        state.isConnected = true;
        updateStatus('متصل / Connected', true);
    } else {
        state.isConnected = false;
        updateStatus('غير متصل / Disconnected', false);
    }
}

function updateStatus(text, connected) {
    const statusText = document.getElementById('statusText');
    const statusDot = document.getElementById('statusDot');
    
    statusText.textContent = text;
    
    if (connected) {
        statusDot.classList.add('connected');
    } else {
        statusDot.classList.remove('connected');
    }
}

// Chat Functions / دوال المحادثة
function sendQuickMessage(message) {
    document.getElementById('chatInput').value = message;
    sendChatMessage();
}

async function sendChatMessage() {
    const input = document.getElementById('chatInput');
    const message = input.value.trim();
    
    if (!message) return;
    
    // Add user message
    addMessage(message, 'user');
    
    // Clear input
    input.value = '';
    
    // Show typing indicator
    const typingId = addMessage('...', 'agent', true);
    
    // Call API
    const result = await apiCall('/api/chat', 'POST', { message });
    
    // Remove typing indicator
    removeMessage(typingId);
    
    // Add agent response
    if (result.success) {
        addMessage(result.response, 'agent');
        
        // Save to history
        saveToHistory('chat', message, result.response);
    } else {
        addMessage(`خطأ: ${result.error}`, 'agent');
    }
}

function addMessage(text, sender, isTyping = false) {
    const messagesDiv = document.getElementById('chatMessages');
    const messageId = `msg-${Date.now()}`;
    
    // Remove welcome message if exists
    const welcomeMsg = messagesDiv.querySelector('.welcome-message');
    if (welcomeMsg) {
        welcomeMsg.remove();
    }
    
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${sender}`;
    messageDiv.id = messageId;
    
    const avatar = sender === 'user' ? '👤' : '🤖';
    
    messageDiv.innerHTML = `
        <div class="message-avatar">${avatar}</div>
        <div class="message-content">${escapeHtml(text)}</div>
    `;
    
    messagesDiv.appendChild(messageDiv);
    messagesDiv.scrollTop = messagesDiv.scrollHeight;
    
    return messageId;
}

function removeMessage(messageId) {
    const message = document.getElementById(messageId);
    if (message) {
        message.remove();
    }
}

// Execute Functions / دوال التنفيذ
async function executeCommand() {
    const input = document.getElementById('executeInput');
    const resultDiv = document.getElementById('executeResult');
    const command = input.value.trim();
    
    if (!command) {
        showNotification('الرجاء إدخال أمر / Please enter a command', 'warning');
        return;
    }
    
    resultDiv.innerHTML = '<div class="loading"></div>';
    resultDiv.classList.add('show');
    
    const result = await apiCall('/api/execute', 'POST', { command });
    
    if (result.success) {
        resultDiv.innerHTML = `<pre>${escapeHtml(result.response)}</pre>`;
        saveToHistory('execute', command, result.response);
    } else {
        resultDiv.innerHTML = `<p style="color: var(--error)">خطأ: ${result.error}</p>`;
    }
}

// Analyze Functions / دوال التحليل
async function analyzeFile() {
    const filepath = document.getElementById('analyzeFilepath').value.trim();
    const resultDiv = document.getElementById('analyzeResult');
    
    if (!filepath) {
        showNotification('الرجاء إدخال مسار الملف / Please enter file path', 'warning');
        return;
    }
    
    resultDiv.innerHTML = '<div class="loading"></div>';
    resultDiv.classList.add('show');
    
    const result = await apiCall('/api/analyze', 'POST', { filepath });
    
    if (result.success) {
        const html = `
            <h3>تحليل الملف / File Analysis</h3>
            <p><strong>الاسم / Name:</strong> ${result.filename}</p>
            <p><strong>الحجم / Size:</strong> ${formatBytes(result.size)}</p>
            <p><strong>النوع / Type:</strong> ${result.extension}</p>
            <div style="margin-top: 1rem;">
                <strong>التحليل / Analysis:</strong>
                <pre>${escapeHtml(result.analysis)}</pre>
            </div>
        `;
        resultDiv.innerHTML = html;
        saveToHistory('analyze', filepath, result.analysis);
    } else {
        resultDiv.innerHTML = `<p style="color: var(--error)">خطأ: ${result.error}</p>`;
    }
}

function handleFileUpload(event) {
    const file = event.target.files[0];
    if (file) {
        document.getElementById('analyzeFilepath').value = file.name;
        showNotification(`تم اختيار: ${file.name}`, 'success');
    }
}

// Generate Code Functions / دوال توليد الكود
async function generateCode() {
    const description = document.getElementById('generateInput').value.trim();
    const language = document.getElementById('codeLanguage').value;
    const resultDiv = document.getElementById('generateResult');
    
    if (!description) {
        showNotification('الرجاء إدخال وصف الكود / Please enter code description', 'warning');
        return;
    }
    
    resultDiv.innerHTML = '<div class="loading"></div>';
    resultDiv.classList.add('show');
    
    const result = await apiCall('/api/generate-code', 'POST', { description, language });
    
    if (result.success) {
        const html = `
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3>كود ${language} مولد / Generated ${language} Code</h3>
                <button onclick="copyCode(this)" class="btn-secondary">
                    <span class="icon">📋</span>
                    <span class="text">نسخ / Copy</span>
                </button>
            </div>
            <pre><code>${escapeHtml(result.code)}</code></pre>
        `;
        resultDiv.innerHTML = html;
        saveToHistory('generate', `${language}: ${description}`, result.code);
    } else {
        resultDiv.innerHTML = `<p style="color: var(--error)">خطأ: ${result.error}</p>`;
    }
}

function copyCode(button) {
    const code = button.parentElement.nextElementSibling.textContent;
    navigator.clipboard.writeText(code);
    showNotification('تم النسخ / Copied', 'success');
}

// Models Functions / دوال النماذج
async function loadModels() {
    const listDiv = document.getElementById('modelsList');
    listDiv.innerHTML = '<div class="loading"></div>';
    
    const result = await apiCall('/api/models');
    
    if (result.success) {
        if (result.models.length === 0) {
            listDiv.innerHTML = '<p>لا توجد نماذج متاحة / No models available</p>';
            return;
        }
        
        const html = result.models.map(model => `
            <div class="model-card">
                <h3>${model}</h3>
                <p>${model === result.current_model ? '✓ ' : ''}${model === result.current_model ? 'النموذج الحالي / Current' : ''}</p>
            </div>
        `).join('');
        
        listDiv.innerHTML = html;
    } else {
        listDiv.innerHTML = `<p style="color: var(--error)">خطأ: ${result.error}</p>`;
    }
}

// History Functions / دوال السجل
function saveToHistory(type, input, output) {
    const entry = {
        id: Date.now(),
        type,
        input,
        output,
        timestamp: new Date().toISOString()
    };
    
    state.conversationHistory.unshift(entry);
    
    // Keep only last 100 entries
    if (state.conversationHistory.length > 100) {
        state.conversationHistory = state.conversationHistory.slice(0, 100);
    }
    
    localStorage.setItem('conversationHistory', JSON.stringify(state.conversationHistory));
}

function loadHistory() {
    state.conversationHistory = JSON.parse(localStorage.getItem('conversationHistory')) || [];
}

function displayHistory() {
    const listDiv = document.getElementById('historyList');
    
    if (state.conversationHistory.length === 0) {
        listDiv.innerHTML = '<p>لا يوجد سجل / No history</p>';
        return;
    }
    
    const html = state.conversationHistory.map(entry => {
        const date = new Date(entry.timestamp).toLocaleString(config.language === 'ar' ? 'ar-SA' : 'en-US');
        const typeIcons = { chat: '💬', execute: '⚡', analyze: '📊', generate: '💻' };
        
        return `
            <div class="history-item" onclick="viewHistoryItem(${entry.id})">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                    <span>${typeIcons[entry.type]} ${entry.type}</span>
                    <span style="color: var(--text-secondary); font-size: 0.875rem;">${date}</span>
                </div>
                <p style="color: var(--text-secondary); overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                    ${escapeHtml(entry.input.substring(0, 100))}
                </p>
            </div>
        `;
    }).join('');
    
    listDiv.innerHTML = html;
}

function viewHistoryItem(id) {
    const entry = state.conversationHistory.find(e => e.id === id);
    if (!entry) return;
    
    // Switch to appropriate tab and populate
    switchTab(entry.type === 'chat' ? 'chat' : entry.type);
    
    // Show entry details
    alert(`${entry.type}\n\nInput: ${entry.input}\n\nOutput: ${entry.output.substring(0, 200)}...`);
}

function exportHistory() {
    const dataStr = JSON.stringify(state.conversationHistory, null, 2);
    const dataBlob = new Blob([dataStr], { type: 'application/json' });
    const url = URL.createObjectURL(dataBlob);
    
    const link = document.createElement('a');
    link.href = url;
    link.download = `supreme-agent-history-${Date.now()}.json`;
    link.click();
    
    URL.revokeObjectURL(url);
    showNotification('تم التصدير / Exported', 'success');
}

function clearHistory() {
    if (confirm('هل أنت متأكد من مسح السجل؟ / Are you sure you want to clear history?')) {
        state.conversationHistory = [];
        localStorage.removeItem('conversationHistory');
        displayHistory();
        showNotification('تم مسح السجل / History cleared', 'success');
    }
}

// Settings Functions / دوال الإعدادات
function openSettings() {
    document.getElementById('settingsModal').classList.add('show');
    document.getElementById('apiUrl').value = config.apiUrl;
    document.getElementById('defaultModel').value = config.defaultModel;
    document.getElementById('temperature').value = config.temperature;
    document.getElementById('temperatureValue').textContent = config.temperature;
}

function closeSettings() {
    document.getElementById('settingsModal').classList.remove('show');
}

function saveSettings() {
    config.apiUrl = document.getElementById('apiUrl').value;
    config.defaultModel = document.getElementById('defaultModel').value;
    config.temperature = parseFloat(document.getElementById('temperature').value);
    
    localStorage.setItem('apiUrl', config.apiUrl);
    localStorage.setItem('defaultModel', config.defaultModel);
    localStorage.setItem('temperature', config.temperature);
    
    closeSettings();
    showNotification('تم حفظ الإعدادات / Settings saved', 'success');
    checkHealth();
}

// Utility Functions / دوال مساعدة
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatBytes(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

function showNotification(message, type = 'info') {
    // Simple notification - could be enhanced with a library
    const colors = {
        success: 'var(--success)',
        error: 'var(--error)',
        warning: 'var(--warning)',
        info: 'var(--accent-primary)'
    };
    
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem 1.5rem;
        background: ${colors[type]};
        color: white;
        border-radius: 0.5rem;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        z-index: 10000;
        animation: slideIn 0.3s ease;
    `;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'fadeOut 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Auto-check health every 30 seconds
setInterval(checkHealth, 30000);
