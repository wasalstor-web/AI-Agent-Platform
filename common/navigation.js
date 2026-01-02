/**
 * Central Navigation System
 * نظام التنقل المركزي
 * 
 * نظام مرن لإدارة التنقل بين الصفحات المتعددة
 * Flexible system for managing navigation between multiple pages
 */

// Navigation Configuration
// إعدادات التنقل
const NAVIGATION_CONFIG = {
    pages: [
        {
            id: 'home',
            url: 'index.html',
            icon: '🏠',
            ar: 'الرئيسية',
            en: 'Home',
            order: 1
        },
        {
            id: 'servers',
            url: 'servers.html',
            icon: '🖥️',
            ar: 'السيرفرات',
            en: 'Servers',
            order: 2
        },
        {
            id: 'monitoring',
            url: 'monitoring.html',
            icon: '📊',
            ar: 'المراقبة',
            en: 'Monitoring',
            order: 3
        }
    ],
    containerId: 'nav-menu-container',
    activeClass: 'active',
    position: 'bottom' // 'top' or 'bottom'
};

/**
 * Initialize Navigation
 * تهيئة التنقل
 */
function initNavigation() {
    const container = document.getElementById(NAVIGATION_CONFIG.containerId);
    if (!container) {
        console.warn('Navigation container not found');
        return;
    }
    
    // Get current page
    const currentPage = getCurrentPage();
    
    // Sort pages by order
    const sortedPages = [...NAVIGATION_CONFIG.pages].sort((a, b) => a.order - b.order);
    
    // Generate navigation HTML
    let navHTML = '<nav class="nav-menu">';
    
    sortedPages.forEach(page => {
        const isActive = currentPage === page.id;
        const currentLang = getCurrentLanguage();
        const label = currentLang === 'ar' ? page.ar : page.en;
        
        navHTML += `
            <a href="${page.url}" 
               class="${isActive ? NAVIGATION_CONFIG.activeClass : ''}" 
               data-page-id="${page.id}"
               onclick="handleNavigation(event, '${page.id}')">
                <span data-ar="${page.ar}" data-en="${page.en}">${page.icon} ${label}</span>
            </a>
        `;
    });
    
    navHTML += '</nav>';
    container.innerHTML = navHTML;
    
    // Update active state on language change
    updateNavigationLanguage();
}

/**
 * Get Current Page ID
 * الحصول على معرف الصفحة الحالية
 */
function getCurrentPage() {
    const path = window.location.pathname;
    const filename = path.split('/').pop() || 'index.html';
    
    const page = NAVIGATION_CONFIG.pages.find(p => p.url === filename);
    return page ? page.id : 'home';
}

/**
 * Handle Navigation Click
 * معالجة النقر على التنقل
 */
function handleNavigation(event, pageId) {
    // Allow default navigation
    // Allow page to handle navigation if needed
    const page = NAVIGATION_CONFIG.pages.find(p => p.id === pageId);
    if (page && typeof window.onBeforeNavigate === 'function') {
        const shouldNavigate = window.onBeforeNavigate(pageId, page.url);
        if (shouldNavigate === false) {
            event.preventDefault();
            return false;
        }
    }
    
    // Update active state immediately for better UX
    updateActiveNavigation(pageId);
}

/**
 * Update Active Navigation State
 * تحديث حالة التنقل النشط
 */
function updateActiveNavigation(pageId) {
    const navLinks = document.querySelectorAll('.nav-menu a');
    navLinks.forEach(link => {
        if (link.dataset.pageId === pageId) {
            link.classList.add(NAVIGATION_CONFIG.activeClass);
        } else {
            link.classList.remove(NAVIGATION_CONFIG.activeClass);
        }
    });
}

/**
 * Update Navigation Language
 * تحديث لغة التنقل
 */
function updateNavigationLanguage() {
    const currentLang = getCurrentLanguage();
    const navLinks = document.querySelectorAll('.nav-menu a span');
    
    navLinks.forEach(span => {
        if (span.hasAttribute('data-ar') && span.hasAttribute('data-en')) {
            const icon = span.textContent.split(' ')[0]; // Extract icon
            const text = currentLang === 'ar' ? span.getAttribute('data-ar') : span.getAttribute('data-en');
            span.textContent = `${icon} ${text}`;
        }
    });
}

/**
 * Add New Page to Navigation
 * إضافة صفحة جديدة للتنقل
 */
function addNavigationPage(pageConfig) {
    // Validate config
    if (!pageConfig.id || !pageConfig.url) {
        console.error('Page config must have id and url');
        return false;
    }
    
    // Check if page already exists
    if (NAVIGATION_CONFIG.pages.find(p => p.id === pageConfig.id)) {
        console.warn(`Page ${pageConfig.id} already exists`);
        return false;
    }
    
    // Add default values
    const newPage = {
        icon: pageConfig.icon || '📄',
        ar: pageConfig.ar || pageConfig.id,
        en: pageConfig.en || pageConfig.id,
        order: pageConfig.order || NAVIGATION_CONFIG.pages.length + 1,
        ...pageConfig
    };
    
    NAVIGATION_CONFIG.pages.push(newPage);
    
    // Reinitialize navigation if already initialized
    if (document.getElementById(NAVIGATION_CONFIG.containerId)) {
        initNavigation();
    }
    
    return true;
}

/**
 * Remove Page from Navigation
 * إزالة صفحة من التنقل
 */
function removeNavigationPage(pageId) {
    const index = NAVIGATION_CONFIG.pages.findIndex(p => p.id === pageId);
    if (index === -1) {
        console.warn(`Page ${pageId} not found`);
        return false;
    }
    
    NAVIGATION_CONFIG.pages.splice(index, 1);
    
    // Reinitialize navigation
    if (document.getElementById(NAVIGATION_CONFIG.containerId)) {
        initNavigation();
    }
    
    return true;
}

/**
 * Get Navigation Pages
 * الحصول على صفحات التنقل
 */
function getNavigationPages() {
    return [...NAVIGATION_CONFIG.pages];
}

/**
 * Navigate to Page Programmatically
 * الانتقال لصفحة برمجياً
 */
function navigateToPage(pageId) {
    const page = NAVIGATION_CONFIG.pages.find(p => p.id === pageId);
    if (!page) {
        console.error(`Page ${pageId} not found`);
        return false;
    }
    
    window.location.href = page.url;
    return true;
}

// Auto-initialize on DOM load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initNavigation);
} else {
    initNavigation();
}

// Export for use in other scripts
if (typeof window !== 'undefined') {
    window.NavigationSystem = {
        init: initNavigation,
        addPage: addNavigationPage,
        removePage: removeNavigationPage,
        getPages: getNavigationPages,
        navigate: navigateToPage,
        updateLanguage: updateNavigationLanguage,
        config: NAVIGATION_CONFIG
    };
}

