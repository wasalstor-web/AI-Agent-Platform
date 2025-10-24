# GitHub Copilot Instructions for AI-Agent-Platform

## Project Overview
This is an AI Agent Platform project designed to provide infrastructure and tools for building, deploying, and managing AI agents. The platform aims to facilitate the development of intelligent agents with focus on scalability, maintainability, and best practices.

### Key Features
- **DL+ Arabic Intelligence System**: A unified system for Arabic-first AI with advanced language processing
- **Multi-Model Support**: Integration with LLaMA 3, Qwen Arabic, AraBERT, Mistral, DeepSeek, and Phi-3
- **OpenWebUI Integration**: Web interface for interactive AI model interaction
- **FastAPI Backend**: RESTful API for agent communication and command execution
- **Automated Deployment**: Scripts for VPS deployment, GitHub Pages hosting, and Hostinger integration
- **Bilingual Support**: Full Arabic and English interface and documentation

### Project Structure
```
AI-Agent-Platform/
├── dlplus/                  # DL+ system core
│   ├── core/               # Intelligence core, Arabic processor, context analyzer
│   ├── agents/             # AI agents (base, code generator, web retrieval)
│   ├── api/                # FastAPI connectors and internal APIs
│   ├── config/             # Settings, model configs, agent configs
│   ├── utils/              # Helper functions and logging
│   └── main.py             # FastAPI application entry point
├── tests/                  # pytest test suite
│   ├── test_core.py
│   ├── test_agents.py
│   └── test_arabic_processor.py
├── api/                    # API documentation and examples
├── examples/               # Usage examples and demos
├── .github/                # GitHub configuration and workflows
├── requirements.txt        # Python dependencies
└── *.sh                   # Deployment and management scripts
```

## Tech Stack
- **Architecture**: Platform-based architecture for AI agents
- **Languages**: Python (primary), Shell scripting, HTML/JavaScript
- **Web Framework**: FastAPI for REST APIs
- **AI/ML**: Support for various models (LLaMA 3, Qwen Arabic, AraBERT, etc.)
- **Testing**: pytest, pytest-asyncio, pytest-cov
- **Code Quality**: black (formatter), flake8 (linter), mypy (type checker)
- **Deployment**: Docker, Nginx, OpenWebUI integration
- **Version Control**: Git with GitHub

## Installation and Setup

### Python Dependencies
```bash
# Install Python dependencies
pip install -r requirements.txt

# For development, install with all dev dependencies
pip install -r requirements.txt
```

### DL+ System Setup
```bash
# Start the DL+ system (FastAPI server on port 8000)
./start-dlplus.sh

# Alternative: Run directly with uvicorn
cd dlplus
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### OpenWebUI Setup
```bash
# Install and configure OpenWebUI
./setup-openwebui.sh

# Deploy OpenWebUI integration
./deploy-openwebui-integration.sh
```

## Build Commands

This project primarily uses Python and doesn't require compilation. However, for deployment:

```bash
# Verify Python environment
python3 --version

# Install/update dependencies
pip install -r requirements.txt

# Validate DL+ system configuration
./validate-dlplus.sh
```

## Test Commands

```bash
# Run all tests with pytest
pytest

# Run tests with coverage report
pytest --cov=dlplus --cov-report=html --cov-report=term

# Run specific test file
pytest tests/test_core.py

# Run tests with verbose output
pytest -v

# Run async tests specifically
pytest -v tests/ -k "async"
```

## Lint Commands

```bash
# Format code with black (auto-fix)
black .
black dlplus/ tests/

# Check code style with flake8
flake8 dlplus/ tests/

# Type checking with mypy
mypy dlplus/

# Run all quality checks at once
black --check . && flake8 dlplus/ tests/ && mypy dlplus/
```

## Code Style Guidelines
- Use clear and descriptive variable names that reflect their purpose
- Follow PEP 8 style guide for Python code
- Use 4 spaces for indentation in Python
- Keep functions small and focused on a single responsibility
- Write self-documenting code with minimal but meaningful comments
- Use snake_case for variables and functions, PascalCase for classes in Python
- Maximum line length: 120 characters (configured in black and flake8)
- Add blank lines to separate logical blocks of code
- Use type hints in Python for better code clarity and IDE support

## Security Best Practices
- Never commit sensitive data (API keys, credentials, tokens) to the repository
- Use environment variables for configuration and secrets
- Validate all external input to prevent injection attacks
- Implement proper authentication and authorization mechanisms
- Follow OWASP security guidelines for web applications
- Keep dependencies up to date and regularly check for vulnerabilities
- Use secure communication protocols (HTTPS, WSS)
- Implement rate limiting for API endpoints

## Testing Requirements
- Write unit tests for all new functionality
- Aim for at least 80% code coverage
- Include integration tests for critical workflows
- Write tests before fixing bugs (test-driven debugging)
- Use descriptive test names that explain what is being tested
- Mock external dependencies in unit tests
- Include both positive and negative test cases
- Ensure tests are deterministic and can run in isolation

## Documentation Standards
- Document all public APIs and functions
- Include README files in major directories
- Keep documentation up to date with code changes
- Use markdown for documentation files
- Include code examples in documentation where helpful
- Document complex algorithms and business logic
- Add inline comments for non-obvious code sections
- Maintain a changelog for version releases

## Common Patterns and Best Practices
- Use dependency injection for better testability
- Implement proper error handling with meaningful error messages
- Log important events and errors with appropriate severity levels
- Use configuration files for environment-specific settings
- Follow the DRY (Don't Repeat Yourself) principle
- Implement graceful degradation and fallback mechanisms
- Use design patterns appropriately (Factory, Strategy, Observer, etc.)
- Optimize for readability first, then performance

## Error Handling
- Always handle errors explicitly, never silently ignore them
- Provide meaningful error messages that help with debugging
- Use try-catch blocks appropriately
- Implement proper error logging
- Return appropriate error codes/responses
- Clean up resources in finally blocks or using equivalent mechanisms
- Distinguish between recoverable and non-recoverable errors

## API Design
- Follow RESTful principles for HTTP APIs
- Use appropriate HTTP methods (GET, POST, PUT, DELETE, PATCH)
- Implement proper status codes
- Version your APIs appropriately
- Include proper request/response validation
- Document API endpoints clearly
- Implement pagination for list endpoints
- Use consistent naming conventions for endpoints

## Performance Considerations
- Implement caching where appropriate
- Optimize database queries
- Use async/await for I/O operations
- Avoid unnecessary computations
- Profile code to identify bottlenecks
- Implement lazy loading where beneficial
- Consider memory usage for large datasets

## Git and Version Control
- Write clear, descriptive commit messages
- Use feature branches for development
- Keep commits atomic and focused
- Reference issue numbers in commit messages
- Squash commits when appropriate before merging
- Maintain a clean commit history
- Use pull requests for code review

## Deployment and Environment Configuration

### Environment Variables
The project uses `.env` files for configuration. Never commit `.env` files with actual credentials.

```bash
# Available example configurations
.env.example                    # Basic configuration template
.env.dlplus.example            # DL+ system configuration
.env.instant-deploy.example    # Instant deployment configuration
.env.openwebui                 # OpenWebUI configuration

# Copy and configure for your environment
cp .env.example .env
# Edit .env with your settings
```

### Key Environment Variables
- `VPS_HOST` - VPS hostname or IP address
- `VPS_USER` - SSH username
- `VPS_PORT` - SSH port
- `OPENWEBUI_PORT` - OpenWebUI port (default: 3000)
- `OLLAMA_API_BASE_URL` - Ollama API URL
- `WEBUI_SECRET_KEY` - Secret key for OpenWebUI (generate with `openssl rand -hex 32`)
- API keys for various AI models (never commit these)

### Deployment Scripts
```bash
# Deploy to GitHub Pages
git push origin main  # Automatic deployment via GitHub Actions

# Deploy DL+ system
./start-dlplus.sh

# Check VPS deployment status
./deploy.sh --host your-vps.com

# Smart deployment with menu
./smart-deploy.sh

# Complete deployment
./complete-deployment.sh
```

## AI Agent Specific Guidelines
- Design agents with clear, single responsibilities
- Implement proper agent lifecycle management
- Use message passing for agent communication
- Implement monitoring and observability for agent behavior
- Design for scalability with multiple concurrent agents
- Include proper agent state management
- Implement graceful agent shutdown procedures
- Consider agent resource consumption and optimization

### Working with DL+ System
- All DL+ core components are in the `dlplus/` directory
- Use FastAPI dependency injection for services
- Implement async/await for all I/O operations
- Arabic text processing should use the `arabic_processor.py` module
- All agents must inherit from `BaseAgent` class
- Configuration should be loaded from `dlplus/config/` modules
- Use structured logging from `dlplus/utils/logger.py`

### FastAPI Development Guidelines
- Define routes in appropriate API modules
- Use Pydantic models for request/response validation
- Implement proper error handling with HTTPException
- Use dependency injection for database and service access
- Document all endpoints with proper OpenAPI descriptions
- Implement rate limiting and authentication where needed
- Test API endpoints with pytest-asyncio

### Arabic Language Processing
- Use the `arabic_processor.py` for all Arabic text operations
- Support both Modern Standard Arabic (MSA) and dialectal variants
- Implement proper Arabic text normalization
- Handle right-to-left (RTL) text correctly
- Consider Arabic-specific NLP models (AraBERT, CAMeLBERT)
- Test with both Arabic and English inputs
