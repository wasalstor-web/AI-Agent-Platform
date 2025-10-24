"""
Code Generator Agent
وكيل توليد الأكواد

Agent for generating code in various programming languages.
"""

import logging
from typing import Dict, Any, List
from .base_agent import BaseAgent

logger = logging.getLogger(__name__)


class CodeGeneratorAgent(BaseAgent):
    """
    Code Generator Agent
    وكيل توليد الأكواد
    
    Generates code based on natural language descriptions.
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the code generator agent"""
        super().__init__("Code Generator Agent", config)
        self.supported_languages = [
            'python', 'javascript', 'java', 'c++', 'go',
            'rust', 'typescript', 'php', 'ruby', 'swift'
        ]
        self.default_language = 'python'
        # Prefer DeepSeek for code generation, fallback to LLaMA 3
        self.set_preferred_models(['deepseek', 'llama3', 'mistral'])
    
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate code
        
        Args:
            task: Task containing 'description', 'language', and optional 'requirements'
            
        Returns:
            Generated code
        """
        description = task.get('description')
        language = task.get('language', self.default_language).lower()
        requirements = task.get('requirements', [])
        
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
        code = await self._generate_code(description, language, requirements)
        
        return {
            'success': True,
            'description': description,
            'language': language,
            'code': code,
            'requirements': requirements
        }
    
    async def _generate_code(
        self,
        description: str,
        language: str,
        requirements: List[str]
    ) -> str:
        """
        Generate the actual code
        
        Uses AI models if available, otherwise falls back to templates.
        """
        # Try to use AI model if available
        if self.model_manager:
            for model_id in self.preferred_models:
                try:
                    # Create prompt for code generation
                    prompt = self._create_code_generation_prompt(
                        description, language, requirements
                    )
                    
                    # Use model
                    result = await self.use_model(model_id, prompt, {
                        'max_length': 2048,
                        'temperature': 0.7
                    })
                    
                    if result.get('success'):
                        logger.info(f"✅ Code generated using model '{model_id}'")
                        return result.get('output', '')
                        
                except Exception as e:
                    logger.warning(f"⚠️ Model '{model_id}' failed: {e}, trying next...")
                    continue
        
        # Fallback to template-based generation
        logger.info("📝 Using template-based code generation")
        templates = {
            'python': self._generate_python_template,
            'javascript': self._generate_javascript_template,
            'java': self._generate_java_template
        }
        
        generator = templates.get(language, self._generate_generic_template)
        return generator(description, requirements)
    
    def _create_code_generation_prompt(
        self,
        description: str,
        language: str,
        requirements: List[str]
    ) -> str:
        """Create prompt for AI model code generation"""
        prompt = f"""Generate {language} code for the following task:

Task: {description}

Requirements: {', '.join(requirements) if requirements else 'None'}

Please provide clean, well-commented code following best practices."""
        
        return prompt
    
    def _generate_python_template(
        self,
        description: str,
        requirements: List[str]
    ) -> str:
        """Generate Python code template"""
        imports = "\n".join([f"import {req}" for req in requirements])
        
        return f'''"""
{description}
"""

{imports if requirements else "# No specific requirements"}

def main():
    """
    Main function
    الدالة الرئيسية
    """
    # TODO: Implement {description}
    pass


if __name__ == "__main__":
    main()
'''
    
    def _generate_javascript_template(
        self,
        description: str,
        requirements: List[str]
    ) -> str:
        """Generate JavaScript code template"""
        imports = "\n".join([f"const {req} = require('{req}');" for req in requirements])
        
        return f'''/**
 * {description}
 */

{imports if requirements else "// No specific requirements"}

function main() {{
    // TODO: Implement {description}
}}

main();
'''
    
    def _generate_java_template(
        self,
        description: str,
        requirements: List[str]
    ) -> str:
        """Generate Java code template"""
        imports = "\n".join([f"import {req};" for req in requirements])
        
        return f'''/**
 * {description}
 */

{imports if requirements else "// No specific requirements"}

public class Main {{
    public static void main(String[] args) {{
        // TODO: Implement {description}
    }}
}}
'''
    
    def _generate_generic_template(
        self,
        description: str,
        requirements: List[str]
    ) -> str:
        """Generate generic code template"""
        return f'''/*
 * {description}
 * 
 * Requirements: {", ".join(requirements) if requirements else "None"}
 * 
 * TODO: Implement the functionality
 */
'''
    
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
        # Generate main code
        result = await self.execute({
            'description': description,
            'language': language
        })
        
        if not result['success']:
            return result
        
        # Generate tests
        tests = await self._generate_tests(description, language)
        
        result['tests'] = tests
        return result
    
    async def _generate_tests(self, description: str, language: str) -> str:
        """Generate unit tests for the code"""
        if language == 'python':
            return f'''"""
Tests for: {description}
"""

import unittest


class TestMain(unittest.TestCase):
    """Test cases"""
    
    def test_example(self):
        """Example test"""
        # TODO: Implement test
        self.assertTrue(True)


if __name__ == '__main__':
    unittest.main()
'''
        else:
            return "// TODO: Implement tests"
