/**
 * Central Language System
 * نظام اللغة المركزي
 * 
 * نظام مركزي لإدارة اللغات في جميع الصفحات
 * Central system for managing languages across all pages
 */

// Language Configuration
// إعدادات اللغة
const LANGUAGE_CONFIG = {
    defaultLang: 'ar',
    supportedLangs: ['ar', 'en'],
    storageKey: 'dashboard_language',
    autoDetect: true
};

// Current Language State
// حالة اللغة الحالية
let currentLanguage = LANGUAGE_CONFIG.defaultLang;

/**
 * Initialize Language System
 * تهيئة نظام اللغة
 */
function initLanguage() {
    // Load saved language or detect
    const savedLang = localStorage.getItem(LANGUAGE_CONFIG.storageKey);
    
    if (savedLang && LANGUAGE_CONFIG.supportedLangs.includes(savedLang)) {
        currentLanguage = savedLang;
    } else if (LANGUAGE_CONFIG.autoDetect) {
        // Auto-detect from browser
        const browserLang = navigator.language || navigator.userLanguage;
        if (browserLang.startsWith('ar')) {
            currentLanguage = 'ar';
        } else {
            currentLanguage = 'en';
        }
    }
    
    // Apply language
    applyLanguage(currentLanguage);
    
    // Initialize language toggle button
    initLanguageToggle();
}

/**
 * Apply Language to Page
 * تطبيق اللغة على الصفحة
 */
function applyLanguage(lang) {
    currentLanguage = lang;
    
    // Update HTML attributes
    document.documentElement.setAttribute('lang', lang);
    document.body.setAttribute('dir', lang === 'ar' ? 'rtl' : 'ltr');
    
    // Update all translatable elements
    updateTranslatableElements(lang);
    
    // Update placeholders
    updatePlaceholders(lang);
    
    // Update language toggle button
    updateLanguageToggleButton(lang);
    
    // Save to localStorage
    localStorage.setItem(LANGUAGE_CONFIG.storageKey, lang);
    
    // Trigger custom event
    window.dispatchEvent(new CustomEvent('languageChanged', { 
        detail: { language: lang } 
    }));
    
    // Update navigation if exists
    if (typeof updateNavigationLanguage === 'function') {
        updateNavigationLanguage();
    }
}

/**
 * Update Translatable Elements
 * تحديث العناصر القابلة للترجمة
 */
function updateTranslatableElements(lang) {
    document.querySelectorAll('[data-ar], [data-en]').forEach(el => {
        if (el.hasAttribute('data-ar') && el.hasAttribute('data-en')) {
            const text = lang === 'ar' ? el.getAttribute('data-ar') : el.getAttribute('data-en');
            
            // Preserve HTML if it's innerHTML
            if (el.innerHTML && el.innerHTML.includes('<')) {
                el.innerHTML = text;
            } else {
                el.textContent = text;
            }
        }
    });
}

/**
 * Update Placeholders
 * تحديث النصوص التوضيحية
 */
function updatePlaceholders(lang) {
    document.querySelectorAll('[data-ar-placeholder], [data-en-placeholder]').forEach(el => {
        if (el.hasAttribute('data-ar-placeholder') && el.hasAttribute('data-en-placeholder')) {
            el.placeholder = lang === 'ar' ? el.getAttribute('data-ar-placeholder') : el.getAttribute('data-en-placeholder');
        }
    });
}

/**
 * Initialize Language Toggle Button
 * تهيئة زر تبديل اللغة
 */
function initLanguageToggle() {
    const langBtn = document.getElementById('lang-toggle-btn');
    if (langBtn) {
        langBtn.addEventListener('click', toggleLanguage);
        updateLanguageToggleButton(currentLanguage);
    }
}

/**
 * Update Language Toggle Button
 * تحديث زر تبديل اللغة
 */
function updateLanguageToggleButton(lang) {
    const langBtn = document.getElementById('lang-toggle-btn');
    if (langBtn) {
        const nextLang = lang === 'ar' ? 'en' : 'ar';
        const nextLangText = nextLang === 'ar' ? 'العربية' : 'English';
        langBtn.innerHTML = `<span>${nextLangText}</span>`;
        langBtn.setAttribute('aria-label', `Switch to ${nextLangText}`);
    }
}

/**
 * Toggle Language
 * تبديل اللغة
 */
function toggleLanguage() {
    const newLang = currentLanguage === 'ar' ? 'en' : 'ar';
    applyLanguage(newLang);
}

/**
 * Get Current Language
 * الحصول على اللغة الحالية
 */
function getCurrentLanguage() {
    return currentLanguage;
}

/**
 * Set Language
 * تعيين اللغة
 */
function setLanguage(lang) {
    if (!LANGUAGE_CONFIG.supportedLangs.includes(lang)) {
        console.error(`Language ${lang} is not supported`);
        return false;
    }
    
    applyLanguage(lang);
    return true;
}

/**
 * Get Translation
 * الحصول على الترجمة
 */
function getTranslation(key, lang = null) {
    const targetLang = lang || currentLanguage;
    // This can be extended to use translation files
    return key;
}

// Auto-initialize on DOM load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initLanguage);
} else {
    initLanguage();
}

// Export for use in other scripts
if (typeof window !== 'undefined') {
    window.LanguageSystem = {
        init: initLanguage,
        toggle: toggleLanguage,
        set: setLanguage,
        get: getCurrentLanguage,
        getTranslation: getTranslation,
        config: LANGUAGE_CONFIG
    };
    
    // Global helper function
    window.getCurrentLanguage = getCurrentLanguage;
}

