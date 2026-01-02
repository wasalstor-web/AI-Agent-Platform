"""
Code Generator Agent - Enhanced Version
وكيل توليد الأكواد - النسخة المحسّنة

Advanced code generation with AI models, code analysis, and quality improvements.
"""

import logging
import re
import ast
import subprocess
from typing import Dict, Any, List, Optional
from datetime import datetime
from .base_agent import BaseAgent

logger = logging.getLogger(__name__)


class CodeGeneratorAgent(BaseAgent):
    """
    Code Generator Agent - Enhanced
    وكيل توليد الأكواد - المحسّن
    
    Generates high-quality code with AI assistance, analysis, and optimization.
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the code generator agent"""
        super().__init__("Code Generator Agent", config)
        self.supported_languages = [
            'python', 'javascript', 'java', 'c++', 'cpp', 'go', 'rust',
            'typescript', 'php', 'ruby', 'swift', 'kotlin', 'dart', 'csharp',
            'html', 'css', 'sql', 'bash', 'shell'
        ]
        self.default_language = 'python'
        self.enable_ai_generation = config.get('enable_ai_generation', False) if config else False
        self.enable_code_analysis = config.get('enable_code_analysis', True) if config else True
        self.enable_auto_fix = config.get('enable_auto_fix', True) if config else True
        self.ai_model = config.get('ai_model', 'deepseek-coder') if config else 'deepseek-coder'
        
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate code with advanced features
        
        Args:
            task: Task containing:
                - 'description': Code description
                - 'language': Programming language
                - 'requirements': List of requirements
                - 'style': Code style preferences
                - 'include_tests': Whether to include tests
                - 'optimize': Whether to optimize code
                
        Returns:
            Generated code with analysis and metadata
        """
        description = task.get('description')
        language = task.get('language', self.default_language).lower()
        requirements = task.get('requirements', [])
        style = task.get('style', 'standard')
        include_tests = task.get('include_tests', False)
        optimize = task.get('optimize', False)
        
        if not description:
            return {
                'success': False,
                'error': 'Description is required'
            }
        
        if language not in self.supported_languages:
            return {
                'success': False,
                'error': f'Language {language} is not supported',
                'supported_languages': self.supported_languages
            }
        
        logger.info(f"💻 Generating {language} code for: {description}")
        
        # Generate code
        code = await self._generate_code(description, language, requirements, style)
        
        # Analyze code if enabled
        analysis = None
        if self.enable_code_analysis:
            analysis = await self._analyze_code(code, language)
            
            # Auto-fix if enabled and issues found
            if self.enable_auto_fix and analysis.get('issues'):
                code = await self._auto_fix_code(code, language, analysis.get('issues'))
                # Re-analyze after fixing
                analysis = await self._analyze_code(code, language)
        
        # Optimize if requested
        if optimize:
            code = await self._optimize_code(code, language)
        
        result = {
            'success': True,
            'description': description,
            'language': language,
            'code': code,
            'requirements': requirements,
            'style': style,
            'timestamp': datetime.now().isoformat()
        }
        
        if analysis:
            result['analysis'] = analysis
        
        # Generate tests if requested
        if include_tests:
            tests = await self._generate_tests(description, language, code)
            result['tests'] = tests
        
        # Generate documentation
        documentation = await self._generate_documentation(code, language, description)
        result['documentation'] = documentation
        
        return result
    
    async def _generate_code(
        self,
        description: str,
        language: str,
        requirements: List[str],
        style: str = 'standard'
    ) -> str:
        """
        Generate code using AI or templates
        
        Args:
            description: Code description
            language: Programming language
            requirements: List of requirements
            style: Code style
            
        Returns:
            Generated code
        """
        if self.enable_ai_generation:
            # Use AI model for generation
            return await self._generate_with_ai(description, language, requirements, style)
        else:
            # Use template-based generation
            return await self._generate_with_template(description, language, requirements, style)
    
    async def _generate_with_ai(
        self,
        description: str,
        language: str,
        requirements: List[str],
        style: str
    ) -> str:
        """
        Generate code using AI model
        
        Note: This requires API integration with AI models
        """
        # Placeholder for AI generation
        # In production, integrate with:
        # - OpenAI Codex
        # - DeepSeek Coder
        # - GitHub Copilot API
        # - Anthropic Claude
        
        logger.info(f"🤖 Using AI model: {self.ai_model}")
        
        # For now, fall back to template generation
        return await self._generate_with_template(description, language, requirements, style)
    
    async def _generate_with_template(
        self,
        description: str,
        language: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate code using templates"""
        templates = {
            'python': self._generate_python_code,
            'javascript': self._generate_javascript_code,
            'typescript': self._generate_typescript_code,
            'java': self._generate_java_code,
            'go': self._generate_go_code,
            'rust': self._generate_rust_code,
            'c++': self._generate_cpp_code,
            'cpp': self._generate_cpp_code,
            'php': self._generate_php_code,
            'ruby': self._generate_ruby_code,
            'sql': self._generate_sql_code,
            'html': self._generate_html_code,
            'css': self._generate_css_code,
            'bash': self._generate_bash_code,
            'shell': self._generate_bash_code
        }
        
        generator = templates.get(language, self._generate_generic_code)
        return generator(description, requirements, style)
    
    def _generate_python_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate Python code"""
        imports = []
        for req in requirements:
            if req.startswith('import ') or req.startswith('from '):
                imports.append(req)
            else:
                imports.append(f"import {req}")
        
        imports_str = "\n".join(imports) if imports else "# No specific imports required"
        
        # Extract key functionality from description
        func_name = self._extract_function_name(description)
        
        return f'''"""
{description}

Generated by DL+ Code Generator
تم توليده بواسطة مولد الأكواد DL+
"""

{imports_str}


def {func_name}(*args, **kwargs):
    """
    {description}
    
    Args:
        *args: Positional arguments
        **kwargs: Keyword arguments
        
    Returns:
        Result of the operation
    """
    # TODO: Implement {description}
    pass


def main():
    """
    Main function
    الدالة الرئيسية
    """
    # Example usage
    result = {func_name}()
    print(f"Result: {{result}}")


if __name__ == "__main__":
    main()
'''
    
    def _generate_javascript_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate JavaScript code"""
        imports = []
        for req in requirements:
            if req.startswith('import ') or req.startswith('const ') or req.startswith('require'):
                imports.append(req)
            else:
                imports.append(f"const {req} = require('{req}');")
        
        imports_str = "\n".join(imports) if imports else "// No specific imports required"
        func_name = self._extract_function_name(description)
        
        return f'''/**
 * {description}
 * 
 * Generated by DL+ Code Generator
 */

{imports_str}

/**
 * {description}
 * @param {{*}} args - Function arguments
 * @returns {{*}} Result
 */
function {func_name}(...args) {{
    // TODO: Implement {description}
    return null;
}}

// Main execution
function main() {{
    const result = {func_name}();
    console.log(`Result: ${{result}}`);
}}

// Run if executed directly
if (require.main === module) {{
    main();
}}
'''
    
    def _generate_typescript_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate TypeScript code"""
        imports = []
        for req in requirements:
            imports.append(f"import {{ {req} }} from '{req}';")
        
        imports_str = "\n".join(imports) if imports else "// No specific imports required"
        func_name = self._extract_function_name(description)
        
        return f'''/**
 * {description}
 * 
 * Generated by DL+ Code Generator
 */

{imports_str}

/**
 * {description}
 */
function {func_name}(...args: any[]): any {{
    // TODO: Implement {description}
    return null;
}}

// Main execution
function main(): void {{
    const result = {func_name}();
    console.log(`Result: ${{result}}`);
}}

// Run if executed directly
if (require.main === module) {{
    main();
}}
'''
    
    def _generate_java_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate Java code"""
        imports = []
        for req in requirements:
            imports.append(f"import {req};")
        
        imports_str = "\n".join(imports) if imports else "// No specific imports required"
        class_name = self._extract_class_name(description)
        
        return f'''/**
 * {description}
 * 
 * Generated by DL+ Code Generator
 */

{imports_str}

public class {class_name} {{
    
    /**
     * {description}
     * @param args Function arguments
     * @return Result
     */
    public static Object {class_name.lower()}(Object... args) {{
        // TODO: Implement {description}
        return null;
    }}
    
    /**
     * Main method
     * @param args Command line arguments
     */
    public static void main(String[] args) {{
        Object result = {class_name.lower()}();
        System.out.println("Result: " + result);
    }}
}}
'''
    
    def _generate_go_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate Go code"""
        package_name = self._extract_package_name(description)
        func_name = self._extract_function_name(description)
        
        return f'''// {description}
// Generated by DL+ Code Generator

package {package_name}

import (
    "fmt"
)

// {func_name} {description}
func {func_name}(args ...interface{{}}) interface{{}} {{
    // TODO: Implement {description}
    return nil
}}

// main is the entry point
func main() {{
    result := {func_name}()
    fmt.Printf("Result: %v\\n", result)
}}
'''
    
    def _generate_rust_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate Rust code"""
        func_name = self._extract_function_name(description)
        
        return f'''// {description}
// Generated by DL+ Code Generator

fn {func_name}(args: &[&str]) -> Result<String, String> {{
    // TODO: Implement {description}
    Ok("Not implemented".to_string())
}}

fn main() {{
    match {func_name}(&[]) {{
        Ok(result) => println!("Result: {{}}", result),
        Err(e) => eprintln!("Error: {{}}", e),
    }}
}}
'''
    
    def _generate_cpp_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate C++ code"""
        includes = []
        for req in requirements:
            includes.append(f"#include <{req}>")
        
        includes_str = "\n".join(includes) if includes else "// No specific includes required"
        func_name = self._extract_function_name(description)
        
        return f'''/*
 * {description}
 * Generated by DL+ Code Generator
 */

{includes_str}
#include <iostream>

/**
 * {description}
 */
auto {func_name}(auto... args) {{
    // TODO: Implement {description}
    return nullptr;
}}

int main() {{
    auto result = {func_name}();
    std::cout << "Result: " << result << std::endl;
    return 0;
}}
'''
    
    def _generate_php_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate PHP code"""
        func_name = self._extract_function_name(description)
        
        return f'''<?php
/**
 * {description}
 * Generated by DL+ Code Generator
 */

/**
 * {description}
 * @param mixed ...$args Function arguments
 * @return mixed Result
 */
function {func_name}(...$args) {{
    // TODO: Implement {description}
    return null;
}}

// Main execution
function main() {{
    $result = {func_name}();
    echo "Result: " . $result . PHP_EOL;
}}

// Run if executed directly
if (php_sapi_name() === 'cli') {{
    main();
}}
?>
'''
    
    def _generate_ruby_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate Ruby code"""
        func_name = self._extract_function_name(description)
        
        return f'''# {description}
# Generated by DL+ Code Generator

# {description}
def {func_name}(*args)
  # TODO: Implement {description}
  nil
end

# Main execution
def main
  result = {func_name}()
  puts "Result: #{{result}}"
end

# Run if executed directly
main if __FILE__ == $0
'''
    
    def _generate_sql_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate SQL code"""
        return f'''-- {description}
-- Generated by DL+ Code Generator

-- TODO: Implement {description}
-- Example structure:

CREATE TABLE IF NOT EXISTS example_table (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert example
INSERT INTO example_table (name) VALUES ('Example');

-- Select example
SELECT * FROM example_table WHERE id = 1;
'''
    
    def _generate_html_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate HTML code"""
        return f'''<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{description}</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 20px;
        }}
    </style>
</head>
<body>
    <h1>{description}</h1>
    <p>Generated by DL+ Code Generator</p>
    <script>
        // JavaScript code here
        console.log('Page loaded');
    </script>
</body>
</html>
'''
    
    def _generate_css_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate CSS code"""
        return f'''/* {description} */
/* Generated by DL+ Code Generator */

/* Main styles */
body {{
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
}}

/* TODO: Add more styles for {description} */
'''
    
    def _generate_bash_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate Bash script"""
        func_name = self._extract_function_name(description)
        
        return f'''#!/bin/bash
# {description}
# Generated by DL+ Code Generator

set -e  # Exit on error

{func_name}() {{
    # TODO: Implement {description}
    echo "Not implemented"
}}

# Main execution
main() {{
    result=$({func_name})
    echo "Result: $result"
}}

# Run if executed directly
if [[ "${{BASH_SOURCE[0]}}" == "${{0}}" ]]; then
    main "$@"
fi
'''
    
    def _generate_generic_code(
        self,
        description: str,
        requirements: List[str],
        style: str
    ) -> str:
        """Generate generic code template"""
        return f'''/*
 * {description}
 * Generated by DL+ Code Generator
 * 
 * Requirements: {", ".join(requirements) if requirements else "None"}
 * 
 * TODO: Implement the functionality
 */
'''
    
    def _extract_function_name(self, description: str) -> str:
        """Extract function name from description"""
        # Simple extraction - in production, use NLP
        words = description.split()
        if words:
            # Use first meaningful word
            first_word = words[0].lower()
            # Remove common words
            if first_word in ['اكتب', 'أنشئ', 'أنشأ', 'إنشاء', 'توليد', 'generate', 'create', 'make', 'build']:
                if len(words) > 1:
                    first_word = words[1].lower()
            
            # Clean and format
            func_name = re.sub(r'[^a-z0-9_]', '', first_word)
            if not func_name:
                func_name = 'main_function'
            
            return func_name
        return 'main_function'
    
    def _extract_class_name(self, description: str) -> str:
        """Extract class name from description"""
        func_name = self._extract_function_name(description)
        # Capitalize first letter
        return func_name.capitalize()
    
    def _extract_package_name(self, description: str) -> str:
        """Extract package name from description"""
        func_name = self._extract_function_name(description)
        return func_name
    
    async def _analyze_code(self, code: str, language: str) -> Dict[str, Any]:
        """
        Analyze generated code for issues
        
        Args:
            code: Generated code
            language: Programming language
            
        Returns:
            Analysis results
        """
        analysis = {
            'language': language,
            'lines_of_code': len(code.split('\n')),
            'issues': [],
            'warnings': [],
            'suggestions': [],
            'complexity': 'low',
            'quality_score': 0.8
        }
        
        # Language-specific analysis
        if language == 'python':
            analysis.update(await self._analyze_python(code))
        elif language in ['javascript', 'typescript']:
            analysis.update(await self._analyze_javascript(code))
        
        # General analysis
        if 'TODO' in code or 'FIXME' in code:
            analysis['warnings'].append('Code contains TODO/FIXME comments')
        
        if len(code.split('\n')) < 5:
            analysis['warnings'].append('Code is very short - may be incomplete')
        
        # Calculate quality score
        issues_count = len(analysis['issues'])
        warnings_count = len(analysis['warnings'])
        analysis['quality_score'] = max(0.0, 1.0 - (issues_count * 0.2) - (warnings_count * 0.1))
        
        return analysis
    
    async def _analyze_python(self, code: str) -> Dict[str, Any]:
        """Analyze Python code"""
        issues = []
        warnings = []
        
        try:
            # Try to parse Python code
            ast.parse(code)
        except SyntaxError as e:
            issues.append(f'Syntax error: {str(e)}')
        
        # Check for common issues
        if 'pass' in code and code.count('pass') > 2:
            warnings.append('Multiple pass statements - code may be incomplete')
        
        if not any(keyword in code for keyword in ['def ', 'class ', 'import ']):
            warnings.append('No functions, classes, or imports found')
        
        return {
            'issues': issues,
            'warnings': warnings,
            'syntax_valid': len(issues) == 0
        }
    
    async def _analyze_javascript(self, code: str) -> Dict[str, Any]:
        """Analyze JavaScript code"""
        issues = []
        warnings = []
        
        # Check for common issues
        if 'function' not in code and '=>' not in code:
            warnings.append('No functions found')
        
        if 'console.log' in code or 'console.error' in code:
            warnings.append('Debug statements found - consider removing for production')
        
        return {
            'issues': issues,
            'warnings': warnings
        }
    
    async def _auto_fix_code(
        self,
        code: str,
        language: str,
        issues: List[str]
    ) -> str:
        """
        Automatically fix code issues
        
        Args:
            code: Code to fix
            language: Programming language
            issues: List of issues to fix
            
        Returns:
            Fixed code
        """
        fixed_code = code
        
        # Fix common issues
        for issue in issues:
            if 'syntax error' in issue.lower():
                # Try to fix common syntax errors
                # This is simplified - in production, use proper parsers
                pass
        
        return fixed_code
    
    async def _optimize_code(self, code: str, language: str) -> str:
        """
        Optimize generated code
        
        Args:
            code: Code to optimize
            language: Programming language
            
        Returns:
            Optimized code
        """
        # Basic optimizations
        optimized = code
        
        # Remove excessive blank lines
        optimized = re.sub(r'\n{3,}', '\n\n', optimized)
        
        # Remove trailing whitespace
        lines = optimized.split('\n')
        optimized = '\n'.join(line.rstrip() for line in lines)
        
        return optimized
    
    async def _generate_tests(
        self,
        description: str,
        language: str,
        code: str
    ) -> str:
        """Generate unit tests for code"""
        if language == 'python':
            return self._generate_python_tests(description, code)
        elif language in ['javascript', 'typescript']:
            return self._generate_javascript_tests(description, code)
        else:
            return f"// TODO: Generate tests for {language}"
    
    def _generate_python_tests(self, description: str, code: str) -> str:
        """Generate Python unit tests"""
        func_name = self._extract_function_name(description)
        
        return f'''"""
Tests for: {description}
"""

import unittest
from unittest.mock import patch, MagicMock


class Test{func_name.capitalize()}(unittest.TestCase):
    """Test cases for {func_name}"""
    
    def setUp(self):
        """Set up test fixtures"""
        pass
    
    def tearDown(self):
        """Clean up after tests"""
        pass
    
    def test_basic_functionality(self):
        """Test basic functionality"""
        # TODO: Implement test
        self.assertTrue(True)
    
    def test_edge_cases(self):
        """Test edge cases"""
        # TODO: Implement test
        pass
    
    def test_error_handling(self):
        """Test error handling"""
        # TODO: Implement test
        pass


if __name__ == '__main__':
    unittest.main()
'''
    
    def _generate_javascript_tests(self, description: str, code: str) -> str:
        """Generate JavaScript unit tests"""
        func_name = self._extract_function_name(description)
        
        return f'''/**
 * Tests for: {description}
 */

const assert = require('assert');

describe('{func_name}', function() {{
    describe('#basic functionality', function() {{
        it('should work correctly', function() {{
            // TODO: Implement test
            assert.ok(true);
        }});
    }});
    
    describe('#edge cases', function() {{
        it('should handle edge cases', function() {{
            // TODO: Implement test
        }});
    }});
}});
'''
    
    async def _generate_documentation(
        self,
        code: str,
        language: str,
        description: str
    ) -> Dict[str, Any]:
        """Generate documentation for code"""
        return {
            'description': description,
            'language': language,
            'functions': self._extract_functions(code, language),
            'classes': self._extract_classes(code, language),
            'usage_examples': self._generate_usage_examples(code, language)
        }
    
    def _extract_functions(self, code: str, language: str) -> List[str]:
        """Extract function names from code"""
        functions = []
        
        if language == 'python':
            # Extract Python functions
            pattern = r'def\s+(\w+)\s*\('
            functions = re.findall(pattern, code)
        elif language in ['javascript', 'typescript']:
            # Extract JavaScript functions
            pattern = r'(?:function\s+(\w+)|const\s+(\w+)\s*=\s*(?:function|\(|\w+\s*=>))'
            matches = re.findall(pattern, code)
            functions = [m[0] or m[1] for m in matches if any(m)]
        
        return functions
    
    def _extract_classes(self, code: str, language: str) -> List[str]:
        """Extract class names from code"""
        classes = []
        
        if language == 'python':
            pattern = r'class\s+(\w+)'
            classes = re.findall(pattern, code)
        elif language in ['java', 'javascript', 'typescript', 'c++', 'cpp']:
            pattern = r'class\s+(\w+)'
            classes = re.findall(pattern, code)
        
        return classes
    
    def _generate_usage_examples(self, code: str, language: str) -> List[str]:
        """Generate usage examples"""
        examples = []
        
        functions = self._extract_functions(code, language)
        for func in functions[:3]:  # Limit to 3 examples
            if language == 'python':
                examples.append(f"result = {func}()")
            elif language in ['javascript', 'typescript']:
                examples.append(f"const result = {func}();")
        
        return examples
    
    async def generate_with_tests(
        self,
        description: str,
        language: str
    ) -> Dict[str, Any]:
        """
        Generate code with unit tests
        
        Args:
            description: Code description
            language: Programming language
            
        Returns:
            Code and tests
        """
        return await self.execute({
            'description': description,
            'language': language,
            'include_tests': True
        })
    
    async def review_code(self, code: str, language: str) -> Dict[str, Any]:
        """
        Review and improve existing code
        
        Args:
            code: Code to review
            language: Programming language
            
        Returns:
            Review results with suggestions
        """
        analysis = await self._analyze_code(code, language)
        
        suggestions = []
        
        # Add improvement suggestions
        if analysis['quality_score'] < 0.7:
            suggestions.append('Consider refactoring for better code quality')
        
        if len(analysis['warnings']) > 0:
            suggestions.append('Address warnings to improve code reliability')
        
        return {
            'success': True,
            'analysis': analysis,
            'suggestions': suggestions,
            'improved_code': await self._optimize_code(code, language) if suggestions else code
        }
