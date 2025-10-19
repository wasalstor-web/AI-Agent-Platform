# GitHub Copilot Instructions for AI-Agent-Platform

## Project Overview
This is an AI Agent Platform project designed to provide infrastructure and tools for building, deploying, and managing AI agents. The platform aims to facilitate the development of intelligent agents with focus on scalability, maintainability, and best practices.

## Tech Stack
- **Language**: To be determined based on project development
- **Architecture**: Platform-based architecture for AI agents
- **Version Control**: Git with GitHub

## Code Style Guidelines
- Use clear and descriptive variable names that reflect their purpose
- Follow consistent indentation (2 or 4 spaces based on the language conventions)
- Keep functions small and focused on a single responsibility
- Write self-documenting code with minimal but meaningful comments
- Use camelCase for variables and functions, PascalCase for classes
- Maximum line length: 100-120 characters
- Add blank lines to separate logical blocks of code

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

## AI Agent Specific Guidelines
- Design agents with clear, single responsibilities
- Implement proper agent lifecycle management
- Use message passing for agent communication
- Implement monitoring and observability for agent behavior
- Design for scalability with multiple concurrent agents
- Include proper agent state management
- Implement graceful agent shutdown procedures
- Consider agent resource consumption and optimization
