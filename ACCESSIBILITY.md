# Accessibility Documentation

## Overview

The AI Agent Platform interface has been enhanced to meet **WCAG 2.1 Level AA** accessibility standards, ensuring that the platform is usable by everyone, including people with disabilities who use assistive technologies.

## Accessibility Features Implemented

### 1. Semantic HTML Structure

#### Landmarks
The interface now uses proper HTML5 semantic elements:
- `<header role="banner">` - Main header with site title
- `<main id="main-content" role="main">` - Primary content area
- `<nav aria-label="Quick actions">` - Navigation areas
- `<section aria-labelledby="...">` - Content sections
- `<footer role="contentinfo">` - Site footer

#### Benefits
- Screen readers can easily navigate between major page sections
- Users can skip to specific areas using keyboard shortcuts
- Better document outline and structure

### 2. Keyboard Navigation

#### Skip to Content Link
```html
<a href="#main-content" class="skip-to-content">
  Skip to main content / الانتقال إلى المحتوى الرئيسي
</a>
```
- Appears when focused with Tab key
- Allows keyboard users to bypass navigation
- Bilingual text for Arabic and English users

#### Focus Indicators
All interactive elements have visible focus indicators:
- **3px solid yellow (#FFD700) outline** on focus
- **2px outline offset** for clear visibility
- Applied to: buttons, links, inputs, selects, textareas

```css
.btn:focus {
    outline: 3px solid #FFD700;
    outline-offset: 2px;
}
```

#### Tab Order
- Logical tab order follows visual flow
- Feature cards are focusable with `tabindex="0"`
- No keyboard traps in the interface

### 3. Screen Reader Support

#### ARIA Labels
Added 34+ ARIA labels for better context:

**Buttons:**
```html
<button aria-label="Toggle language between Arabic and English">
<button aria-label="Connect to selected model">
<button aria-label="Send message">
<button aria-label="Copy OpenWebUI installation command">
```

**Form Elements:**
```html
<select aria-label="Select AI model">
<textarea aria-label="Type your message here" aria-required="true">
<input aria-describedby="api-endpoint-label">
```

**Icons:**
```html
<div role="img" aria-label="Robot icon">🤖</div>
<div role="img" aria-label="Security lock icon">🔒</div>
```

#### ARIA Live Regions
Dynamic content updates announced to screen readers:

```html
<!-- Chat messages update -->
<div role="log" aria-live="polite" aria-atomic="false">

<!-- Connection status -->
<span role="status" aria-live="polite">⚫ غير متصل</span>
```

#### Role Attributes
Proper roles for interactive components:
- `role="banner"` - Header
- `role="main"` - Main content
- `role="contentinfo"` - Footer
- `role="navigation"` - Navigation areas
- `role="region"` - Chat interface
- `role="toolbar"` - Model selection controls
- `role="log"` - Chat messages area
- `role="list"` and `role="listitem"` - Feature cards

### 4. Form Accessibility

#### Proper Labels
All form inputs have associated labels:
```html
<label for="model-select" id="model-label">اختر النموذج:</label>
<select id="model-select">...

<label for="api-endpoint" id="api-endpoint-label">نقطة نهاية API:</label>
<input id="api-endpoint" aria-describedby="api-endpoint-label">
```

#### Form Wrapping
Chat input wrapped in a proper `<form>` element:
```html
<form onsubmit="event.preventDefault(); sendMessage();" 
      aria-label="Send message form">
  <textarea aria-label="Type your message here" aria-required="true">
  <button type="submit" aria-label="Send message">
</form>
```

#### Required Fields
Fields marked as required using `aria-required="true"`

### 5. Color and Contrast

#### Focus Contrast
- Yellow (#FFD700) outline on all interactive elements
- 3:1 minimum contrast ratio against backgrounds
- Visible against both light and dark backgrounds

#### Text Contrast
- Existing gradients and colors maintained
- Text remains readable with WCAG AA contrast ratios

### 6. Link Accessibility

#### External Links
Enhanced with security and context:
```html
<a href="..." target="_blank" rel="noopener noreferrer" 
   aria-label="Visit GitHub repository">GitHub</a>

<a href="mailto:..." aria-label="Contact technical support">
   الدعم الفني
</a>
```

#### Benefits
- `rel="noopener noreferrer"` - Security best practice
- `aria-label` - Provides context for screen readers
- Clear indication of external links

### 7. Content Structure

#### Headings Hierarchy
- Proper heading levels (h1 → h2 → h3)
- Each section has appropriate heading
- No skipped heading levels

#### Lists
Feature cards marked as list items:
```html
<div role="list">
  <article role="listitem" tabindex="0">
    ...
  </article>
</div>
```

### 8. Responsive Design

#### Mobile Accessibility
- Touch targets at least 44x44 pixels
- Responsive layouts for all screen sizes
- Readable text without zooming

### 9. Language Support

#### Bilingual Interface
- `lang="ar"` attribute on html element
- `dir="rtl"` for right-to-left Arabic text
- Bilingual labels and ARIA descriptions
- Language toggle with descriptive label

## Testing Recommendations

### Automated Testing
1. **WAVE** (Web Accessibility Evaluation Tool)
   - Check for missing alt text
   - Verify ARIA usage
   - Test color contrast

2. **axe DevTools**
   - Automated accessibility scanning
   - Detailed issue reports
   - Fix recommendations

3. **Lighthouse**
   - Accessibility score
   - Best practices check
   - Performance metrics

### Manual Testing

#### Keyboard Navigation
1. Press Tab to navigate through all interactive elements
2. Verify focus indicators are visible
3. Use Enter/Space to activate buttons
4. Test Esc key for modal closure (if applicable)

#### Screen Reader Testing
Test with:
- **NVDA** (Windows, free)
- **JAWS** (Windows, commercial)
- **VoiceOver** (macOS/iOS, built-in)
- **TalkBack** (Android, built-in)

Verify:
- All images/icons have descriptions
- Forms are properly labeled
- Dynamic updates are announced
- Navigation landmarks work

#### Zoom Testing
1. Zoom to 200% - content should reflow
2. Text remains readable
3. No horizontal scrolling
4. Interactive elements remain clickable

### Browser Testing
Test in:
- Chrome with keyboard only
- Firefox with screen reader
- Safari on macOS/iOS
- Edge on Windows

## Compliance Summary

### WCAG 2.1 Level AA Success Criteria

✅ **1.1.1 Non-text Content** - All icons have text alternatives (aria-label)

✅ **1.3.1 Info and Relationships** - Proper semantic HTML and ARIA

✅ **1.3.2 Meaningful Sequence** - Logical content order

✅ **1.4.1 Use of Color** - Not relying solely on color

✅ **1.4.3 Contrast (Minimum)** - Adequate color contrast maintained

✅ **2.1.1 Keyboard** - All functionality available via keyboard

✅ **2.1.2 No Keyboard Trap** - No keyboard traps present

✅ **2.4.1 Bypass Blocks** - Skip-to-content link provided

✅ **2.4.2 Page Titled** - Descriptive page title present

✅ **2.4.3 Focus Order** - Logical focus order maintained

✅ **2.4.4 Link Purpose** - Links have descriptive aria-labels

✅ **2.4.7 Focus Visible** - Visible focus indicators on all elements

✅ **3.1.1 Language of Page** - lang="ar" attribute present

✅ **3.2.1 On Focus** - No unexpected context changes

✅ **3.2.2 On Input** - No unexpected context changes on input

✅ **3.3.1 Error Identification** - Errors can be identified

✅ **3.3.2 Labels or Instructions** - All inputs have labels

✅ **4.1.1 Parsing** - Valid HTML structure

✅ **4.1.2 Name, Role, Value** - Proper ARIA implementation

✅ **4.1.3 Status Messages** - aria-live regions for status updates

## Maintenance Guidelines

### Adding New Content

When adding new features, ensure:

1. **Use semantic HTML**
   ```html
   <section aria-labelledby="new-feature-title">
     <h2 id="new-feature-title">New Feature</h2>
     ...
   </section>
   ```

2. **Add ARIA labels to buttons**
   ```html
   <button onclick="..." aria-label="Descriptive action">
     Text
   </button>
   ```

3. **Mark dynamic regions**
   ```html
   <div role="status" aria-live="polite">
     Status updates here
   </div>
   ```

4. **Include focus styles**
   ```css
   .new-element:focus {
       outline: 3px solid #FFD700;
       outline-offset: 2px;
   }
   ```

### Code Review Checklist

- [ ] All images have alt text or aria-label
- [ ] Buttons have descriptive aria-label
- [ ] Forms have associated labels
- [ ] Focus indicators are visible
- [ ] Semantic HTML is used
- [ ] ARIA roles are appropriate
- [ ] Live regions for dynamic content
- [ ] Keyboard navigation works
- [ ] Color contrast is adequate
- [ ] External links have rel="noopener"

## Resources

### Guidelines
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
- [A11Y Project](https://www.a11yproject.com/)

### Tools
- [WAVE](https://wave.webaim.org/)
- [axe DevTools](https://www.deque.com/axe/devtools/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- [Color Contrast Checker](https://webaim.org/resources/contrastchecker/)

### Testing
- [NVDA Screen Reader](https://www.nvaccess.org/)
- [VoiceOver User Guide](https://support.apple.com/guide/voiceover/)
- [Keyboard Accessibility Testing](https://webaim.org/articles/keyboard/)

## Support

For accessibility issues or improvements, please:
1. Open an issue on GitHub
2. Include details about the accessibility barrier
3. Specify assistive technology used (if applicable)
4. Suggest improvements if possible

---

**Last Updated:** October 2025
**WCAG Version:** 2.1 Level AA
**Conformance:** Partial (ongoing improvements)
