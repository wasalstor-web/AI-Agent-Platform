// AI Agent Platform - Main Application
// منصة DL+ للذكاء الاصطناعي

// Configuration
const CONFIG = {
    GITHUB_PAGES_URL: 'https://wasalstor-web.github.io/AI-Agent-Platform/',
    REPO_URL: 'https://github.com/wasalstor-web/AI-Agent-Platform',
    VERSION: '1.0.0'
};

// Models Data
const MODELS = [
    {
        id: 'llama3',
        name: 'LLaMA 3 8B',
        nameAr: 'لاما 3 - 8 بليون معامل',
        icon: '🦙',
        status: 'active',
        description: 'نموذج لغوي متقدم من Meta، متخصص في فهم وتوليد النصوص متعدد اللغات',
        capabilities: ['توليد النص', 'الاستدلال', 'البرمجة', 'متعدد اللغات'],
        provider: 'Meta AI',
        parameters: '8B'
    },
    {
        id: 'qwen_arabic',
        name: 'Qwen 2.5 Arabic',
        nameAr: 'كوين 2.5 العربي',
        icon: '🇸🇦',
        status: 'active',
        description: 'نموذج متخصص في اللغة العربية من Alibaba، مُحسّن للفهم والتوليد العربي',
        capabilities: ['اللغة العربية', 'الفهم العميق', 'الاستدلال', 'التوليد'],
        provider: 'Alibaba Cloud',
        parameters: '7B'
    },
    {
        id: 'mistral',
        name: 'Mistral 7B',
        nameAr: 'ميسترال 7 بليون',
        icon: '🌬️',
        status: 'active',
        description: 'نموذج قوي ومتوازن من Mistral AI، يجمع بين الأداء العالي والكفاءة',
        capabilities: ['توليد النص', 'الاستدلال', 'متعدد اللغات', 'الإبداع'],
        provider: 'Mistral AI',
        parameters: '7B'
    },
    {
        id: 'deepseek',
        name: 'DeepSeek Coder',
        nameAr: 'ديب سييك للبرمجة',
        icon: '💻',
        status: 'active',
        description: 'نموذج متخصص في البرمجة وكتابة الأكواد، مع قدرات استدلال عميقة',
        capabilities: ['البرمجة', 'الاستدلال', 'حل المشاكل', 'تصحيح الأخطاء'],
        provider: 'DeepSeek AI',
        parameters: '6.7B'
    },
    {
        id: 'arabert',
        name: 'AraBERT',
        nameAr: 'أرابرت',
        icon: '📚',
        status: 'active',
        description: 'نموذج متخصص في معالجة اللغة الطبيعية العربية من الجامعة الأمريكية في بيروت',
        capabilities: ['فهم النصوص', 'معالجة العربية', 'تحليل المشاعر', 'التصنيف'],
        provider: 'AUB MIND Lab',
        parameters: 'Base'
    },
    {
        id: 'camelbert',
        name: 'CAMeLBERT',
        nameAr: 'كاملبرت',
        icon: '🐫',
        status: 'active',
        description: 'نموذج BERT المحسّن للغة العربية، مع دعم متعدد اللهجات',
        capabilities: ['فهم النصوص', 'معالجة العربية', 'استخراج الكيانات', 'التحليل اللغوي'],
        provider: 'CAMeL Lab',
        parameters: 'Base'
    }
];

// Agents Data
const AGENTS = [
    {
        id: 'base_agent',
        name: 'Base Agent',
        nameAr: 'الوكيل الأساسي',
        icon: '🤖',
        description: 'وكيل أساسي يوفر الوظائف الأساسية لجميع الوكلاء الآخرين',
        capabilities: ['إدارة الذاكرة', 'معالجة الرسائل', 'التحكم في النماذج']
    },
    {
        id: 'code_generator_agent',
        name: 'Code Generator Agent',
        nameAr: 'وكيل توليد الأكواد',
        icon: '⚡',
        description: 'وكيل متخصص في توليد وتحسين الأكواد البرمجية بلغات متعددة',
        capabilities: ['توليد الأكواد', 'تحسين الأكواد', 'شرح الأكواد', 'اكتشاف الأخطاء']
    },
    {
        id: 'web_retrieval_agent',
        name: 'Web Retrieval Agent',
        nameAr: 'وكيل استرجاع الويب',
        icon: '🌐',
        description: 'وكيل متخصص في البحث واسترجاع المعلومات من مصادر الويب',
        capabilities: ['البحث الذكي', 'استرجاع البيانات', 'تحليل المحتوى', 'الفلترة']
    }
];

// DOM Elements
let modelsGrid, agentsGrid, chatMessages, chatInput, sendBtn, selectedModel;

// Initialize Application
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 DL+ AI Agent Platform Initializing...');
    
    // Get DOM elements
    modelsGrid = document.getElementById('modelsGrid');
    agentsGrid = document.getElementById('agentsGrid');
    chatMessages = document.getElementById('chatMessages');
    chatInput = document.getElementById('chatInput');
    sendBtn = document.getElementById('sendBtn');
    selectedModel = document.getElementById('selectedModel');
    
    // Initialize components
    initNavigation();
    renderModels();
    renderAgents();
    initChat();
    updateSystemStatus();
    
    console.log('✅ DL+ Platform Ready!');
});

// Navigation
function initNavigation() {
    const navBtns = document.querySelectorAll('.nav-btn');
    const sections = document.querySelectorAll('.content-section');
    
    navBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const sectionId = btn.dataset.section;
            
            // Update active button
            navBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            // Update active section
            sections.forEach(section => {
                section.classList.remove('active');
                if (section.id === sectionId) {
                    section.classList.add('active');
                }
            });
        });
    });
}

// Render Models
function renderModels() {
    modelsGrid.innerHTML = '';
    
    MODELS.forEach(model => {
        const modelCard = document.createElement('div');
        modelCard.className = 'model-card';
        modelCard.innerHTML = `
            <div class="model-icon">${model.icon}</div>
            <div class="model-name">${model.name}</div>
            <div class="model-name-ar">${model.nameAr}</div>
            <div class="model-description">${model.description}</div>
            <div class="model-status ${model.status}">${getStatusText(model.status)}</div>
            <div class="model-capabilities">
                ${model.capabilities.map(cap => `<span class="capability-tag">${cap}</span>`).join('')}
            </div>
            <div style="margin-top: 15px; font-size: 0.9em; color: #888;">
                <strong>المزود:</strong> ${model.provider} | <strong>الحجم:</strong> ${model.parameters}
            </div>
        `;
        
        modelCard.addEventListener('click', () => {
            showModelDetails(model);
        });
        
        modelsGrid.appendChild(modelCard);
    });
}

// Render Agents
function renderAgents() {
    agentsGrid.innerHTML = '';
    
    AGENTS.forEach(agent => {
        const agentCard = document.createElement('div');
        agentCard.className = 'agent-card';
        agentCard.innerHTML = `
            <div class="agent-icon">${agent.icon}</div>
            <div class="agent-name">${agent.name}</div>
            <div class="agent-name" style="font-size: 1.1em; color: #f56565; margin-bottom: 15px;">${agent.nameAr}</div>
            <div class="agent-description">${agent.description}</div>
            <div style="margin-top: 15px;">
                <strong style="color: #f56565;">القدرات:</strong>
                <div style="margin-top: 10px; display: flex; flex-wrap: wrap; gap: 8px;">
                    ${agent.capabilities.map(cap => `
                        <span style="background: rgba(245, 101, 101, 0.1); color: #f56565; padding: 5px 12px; border-radius: 12px; font-size: 0.85em; font-weight: 600;">
                            ${cap}
                        </span>
                    `).join('')}
                </div>
            </div>
        `;
        
        agentCard.addEventListener('click', () => {
            showAgentDetails(agent);
        });
        
        agentsGrid.appendChild(agentCard);
    });
}

// Initialize Chat
function initChat() {
    sendBtn.addEventListener('click', sendMessage);
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });
}

// Send Message
function sendMessage() {
    const message = chatInput.value.trim();
    if (!message) return;
    
    // Clear welcome message if present
    const welcomeMsg = chatMessages.querySelector('.welcome-message');
    if (welcomeMsg) {
        welcomeMsg.remove();
    }
    
    // Add user message
    addMessage(message, 'user');
    chatInput.value = '';
    
    // Simulate AI response
    setTimeout(() => {
        const modelName = selectedModel.options[selectedModel.selectedIndex].text;
        const response = generateResponse(message, modelName);
        addMessage(response, 'ai');
    }, 1000);
}

// Add Message to Chat
function addMessage(text, sender) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${sender}`;
    messageDiv.textContent = text;
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

// Generate AI Response
function generateResponse(message, modelName) {
    const responses = [
        `مرحباً! أنا ${modelName}. كيف يمكنني مساعدتك اليوم؟`,
        `شكراً على سؤالك. باستخدام ${modelName}، يمكنني مساعدتك في مجموعة متنوعة من المهام.`,
        `أنا هنا للمساعدة باستخدام ${modelName}. هل لديك سؤال محدد؟`,
        `باستخدام قدرات ${modelName}، يمكنني تقديم إجابات دقيقة ومفيدة.`,
        `هذا سؤال رائع! دعني أستخدم ${modelName} لإعطائك أفضل إجابة ممكنة.`
    ];
    
    return responses[Math.floor(Math.random() * responses.length)];
}

// Show Model Details
function showModelDetails(model) {
    alert(`📊 تفاصيل النموذج\n\n` +
          `الاسم: ${model.name}\n` +
          `الاسم بالعربية: ${model.nameAr}\n` +
          `المزود: ${model.provider}\n` +
          `الحجم: ${model.parameters}\n` +
          `الحالة: ${getStatusText(model.status)}\n\n` +
          `الوصف: ${model.description}\n\n` +
          `القدرات:\n${model.capabilities.map(c => `• ${c}`).join('\n')}`);
}

// Show Agent Details
function showAgentDetails(agent) {
    alert(`🤖 تفاصيل الوكيل\n\n` +
          `الاسم: ${agent.name}\n` +
          `الاسم بالعربية: ${agent.nameAr}\n\n` +
          `الوصف: ${agent.description}\n\n` +
          `القدرات:\n${agent.capabilities.map(c => `• ${c}`).join('\n')}`);
}

// Get Status Text
function getStatusText(status) {
    const statusMap = {
        'active': 'نشط ✓',
        'loading': 'يتم التحميل...',
        'error': 'خطأ ✗'
    };
    return statusMap[status] || status;
}

// Update System Status
function updateSystemStatus() {
    // Update active models count
    const activeModelsCount = MODELS.filter(m => m.status === 'active').length;
    document.getElementById('activeModels').textContent = activeModelsCount;
    
    // Update active agents count
    document.getElementById('activeAgents').textContent = AGENTS.length;
    
    // Update last update time
    const now = new Date();
    const updateTime = document.getElementById('lastUpdate');
    if (updateTime) {
        updateTime.textContent = now.toLocaleTimeString('ar-SA', { 
            hour: '2-digit', 
            minute: '2-digit' 
        });
    }
    
    // Update every minute
    setInterval(() => {
        const minutesAgo = Math.floor((new Date() - now) / 60000);
        if (updateTime) {
            updateTime.textContent = minutesAgo === 0 ? 'الآن' : `${minutesAgo}`;
        }
    }, 60000);
}

// Console Welcome Message
console.log(`
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🚀 DL+ Unified Arabic Intelligence System                  ║
║   منصة DL+ للذكاء الاصطناعي الموحد                          ║
║                                                               ║
║   Version: ${CONFIG.VERSION}                                          ║
║   GitHub: ${CONFIG.REPO_URL}   ║
║                                                               ║
║   تم التطوير بواسطة: خليف 'ذيبان' العنزي                   ║
║   القصيم - بريدة - المملكة العربية السعودية                ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

📊 System Status:
   ✅ Models Active: ${MODELS.length}
   ✅ Agents Active: ${AGENTS.length}
   ✅ Platform: GitHub Pages
   ✅ Status: Operational

🔗 Links:
   • GitHub Pages: ${CONFIG.GITHUB_PAGES_URL}
   • Repository: ${CONFIG.REPO_URL}

💡 Tip: Open DevTools Console to see system logs
`);
