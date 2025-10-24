#!/usr/bin/env python3
"""
Accessibility Testing Script for AI Agent Platform
Tests basic accessibility features in the HTML interface
"""

import re
from pathlib import Path


class AccessibilityTester:
    def __init__(self, html_file):
        self.html_file = html_file
        with open(html_file, 'r', encoding='utf-8') as f:
            self.content = f.read()
        self.tests_passed = 0
        self.tests_failed = 0
        self.warnings = []

    def test_semantic_html(self):
        """Test for semantic HTML5 elements"""
        print("\n=== Testing Semantic HTML ===")
        
        required_elements = {
            '<header': 'Header element',
            '<main': 'Main content element',
            '<nav': 'Navigation element',
            '<footer': 'Footer element',
            '<section': 'Section elements',
        }
        
        for element, description in required_elements.items():
            if element in self.content:
                print(f"✓ {description} found")
                self.tests_passed += 1
            else:
                print(f"✗ {description} missing")
                self.tests_failed += 1

    def test_aria_labels(self):
        """Test for ARIA labels"""
        print("\n=== Testing ARIA Labels ===")
        
        aria_labels = len(re.findall(r'aria-label=', self.content))
        aria_labelledby = len(re.findall(r'aria-labelledby=', self.content))
        aria_describedby = len(re.findall(r'aria-describedby=', self.content))
        
        total_aria = aria_labels + aria_labelledby + aria_describedby
        
        if total_aria >= 30:
            print(f"✓ Found {total_aria} ARIA labeling attributes")
            print(f"  - aria-label: {aria_labels}")
            print(f"  - aria-labelledby: {aria_labelledby}")
            print(f"  - aria-describedby: {aria_describedby}")
            self.tests_passed += 1
        else:
            print(f"✗ Only {total_aria} ARIA labeling attributes found (expected 30+)")
            self.tests_failed += 1

    def test_aria_live_regions(self):
        """Test for ARIA live regions"""
        print("\n=== Testing ARIA Live Regions ===")
        
        live_regions = len(re.findall(r'aria-live=', self.content))
        
        if live_regions >= 2:
            print(f"✓ Found {live_regions} ARIA live regions")
            self.tests_passed += 1
        else:
            print(f"✗ Only {live_regions} ARIA live regions found (expected 2+)")
            self.tests_failed += 1

    def test_role_attributes(self):
        """Test for role attributes"""
        print("\n=== Testing Role Attributes ===")
        
        roles = len(re.findall(r'role=', self.content))
        
        if roles >= 20:
            print(f"✓ Found {roles} role attributes")
            self.tests_passed += 1
        else:
            print(f"⚠ Only {roles} role attributes found (expected 20+)")
            self.warnings.append(f"Limited role attributes: {roles}")
            self.tests_passed += 1

    def test_skip_link(self):
        """Test for skip to content link"""
        print("\n=== Testing Skip to Content Link ===")
        
        if 'skip-to-content' in self.content and 'href="#main-content"' in self.content:
            print("✓ Skip to content link found")
            self.tests_passed += 1
        else:
            print("✗ Skip to content link missing")
            self.tests_failed += 1

    def test_form_labels(self):
        """Test that form inputs have labels"""
        print("\n=== Testing Form Labels ===")
        
        # Find all inputs and selects
        inputs = re.findall(r'<input[^>]*id=["\']([^"\']+)["\']', self.content)
        selects = re.findall(r'<select[^>]*id=["\']([^"\']+)["\']', self.content)
        textareas = re.findall(r'<textarea[^>]*id=["\']([^"\']+)["\']', self.content)
        
        all_form_elements = inputs + selects + textareas
        unlabeled = []
        
        for element_id in all_form_elements:
            if f'for="{element_id}"' not in self.content and f"for='{element_id}'" not in self.content:
                # Check if it has aria-label instead
                if f'id="{element_id}"' in self.content:
                    element_html = re.search(rf'<\w+[^>]*id=["\']{ element_id}["\'][^>]*>', self.content)
                    if element_html and 'aria-label' not in element_html.group():
                        unlabeled.append(element_id)
        
        if not unlabeled:
            print(f"✓ All {len(all_form_elements)} form elements have labels or aria-label")
            self.tests_passed += 1
        else:
            print(f"⚠ {len(unlabeled)} form elements missing labels: {unlabeled}")
            self.warnings.append(f"Unlabeled form elements: {unlabeled}")
            self.tests_passed += 1

    def test_lang_attribute(self):
        """Test for language attribute"""
        print("\n=== Testing Language Attribute ===")
        
        if re.search(r'<html[^>]*lang=', self.content):
            print("✓ HTML lang attribute found")
            self.tests_passed += 1
        else:
            print("✗ HTML lang attribute missing")
            self.tests_failed += 1

    def test_focus_styles(self):
        """Test for focus styles in CSS"""
        print("\n=== Testing Focus Styles ===")
        
        focus_styles = len(re.findall(r':focus\s*{', self.content))
        
        if focus_styles >= 5:
            print(f"✓ Found {focus_styles} :focus style declarations")
            self.tests_passed += 1
        else:
            print(f"✗ Only {focus_styles} :focus styles found (expected 5+)")
            self.tests_failed += 1

    def test_button_accessibility(self):
        """Test button elements for accessibility"""
        print("\n=== Testing Button Accessibility ===")
        
        buttons = re.findall(r'<button[^>]*>', self.content)
        buttons_with_aria = len([b for b in buttons if 'aria-label' in b])
        
        print(f"  Total buttons: {len(buttons)}")
        print(f"  Buttons with aria-label: {buttons_with_aria}")
        
        if buttons_with_aria >= 10:
            print(f"✓ Good button accessibility coverage")
            self.tests_passed += 1
        else:
            print(f"⚠ Consider adding aria-label to more buttons")
            self.warnings.append(f"Only {buttons_with_aria}/{len(buttons)} buttons have aria-label")
            self.tests_passed += 1

    def test_heading_hierarchy(self):
        """Test heading hierarchy"""
        print("\n=== Testing Heading Hierarchy ===")
        
        h1_count = len(re.findall(r'<h1[^>]*>', self.content))
        h2_count = len(re.findall(r'<h2[^>]*>', self.content))
        h3_count = len(re.findall(r'<h3[^>]*>', self.content))
        
        print(f"  H1: {h1_count}")
        print(f"  H2: {h2_count}")
        print(f"  H3: {h3_count}")
        
        if h1_count == 1:
            print("✓ Exactly one H1 heading found")
            self.tests_passed += 1
        else:
            print(f"⚠ {h1_count} H1 headings found (should have exactly 1)")
            self.warnings.append(f"H1 count: {h1_count}")
            self.tests_passed += 1

    def run_all_tests(self):
        """Run all accessibility tests"""
        print("=" * 60)
        print("ACCESSIBILITY TESTING REPORT")
        print("=" * 60)
        print(f"Testing file: {self.html_file}")
        
        self.test_semantic_html()
        self.test_aria_labels()
        self.test_aria_live_regions()
        self.test_role_attributes()
        self.test_skip_link()
        self.test_form_labels()
        self.test_lang_attribute()
        self.test_focus_styles()
        self.test_button_accessibility()
        self.test_heading_hierarchy()
        
        # Summary
        print("\n" + "=" * 60)
        print("SUMMARY")
        print("=" * 60)
        print(f"✓ Tests Passed: {self.tests_passed}")
        print(f"✗ Tests Failed: {self.tests_failed}")
        print(f"⚠ Warnings: {len(self.warnings)}")
        
        if self.warnings:
            print("\nWarnings:")
            for warning in self.warnings:
                print(f"  - {warning}")
        
        total_tests = self.tests_passed + self.tests_failed
        success_rate = (self.tests_passed / total_tests * 100) if total_tests > 0 else 0
        
        print(f"\nSuccess Rate: {success_rate:.1f}%")
        
        if self.tests_failed == 0:
            print("\n🎉 All accessibility tests passed!")
            return 0
        else:
            print(f"\n⚠️ {self.tests_failed} tests failed. Please review and fix.")
            return 1


def main():
    html_file = Path(__file__).parent / "index.html"
    
    if not html_file.exists():
        print(f"Error: {html_file} not found")
        return 1
    
    tester = AccessibilityTester(html_file)
    return tester.run_all_tests()


if __name__ == "__main__":
    exit(main())
