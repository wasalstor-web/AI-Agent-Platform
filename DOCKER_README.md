````markdown name=DOCKER_README.md
```markdown
# Docker Deployment for AI-Agent-Platform

This folder provides Docker-based deployment files for running the DL+ backend and OpenWebUI together via Docker Compose.

Files added:
- `Dockerfile` - builds a lightweight image to run the DL+ Python backend
- `.dockerignore` - files to exclude from the Docker build context
- `docker-compose.yml` - composes `dlplus` (backend) and `openwebui` services
- `run-ngrok.sh` - helper script to expose local services via ngrok (for testing)

Quick start (local testing):

1. Copy an environment file from the examples and fill secrets:
   ```bash
   cp .env.instant-deploy.example .env.instant-deploy
   # Edit .env.instant-deploy and set DLPLUS_API_KEY, WEBUI_SECRET_KEY, DLPLUS_JWT_TOKEN
   ```

2. Build and run with Docker Compose:
   ```bash
   docker compose up -d --build
   ```

3. Access services:
   - DL+ API: http://localhost:8000
   - DL+ Docs: http://localhost:8000/api/docs
   - OpenWebUI: http://localhost:3000

4. For a temporary public URL (testing only), use ngrok:
   ```bash
   ./run-ngrok.sh openwebui
   ```

Security notes:
- Do NOT commit `.env.instant-deploy` or any real secrets to GitHub.
- Ensure production deployments use HTTPS and proper authentication.
- Some models require significant resources (GPU/large RAM); this compose file only runs the OpenWebUI frontend and DL+ backend. Connect model runners (Ollama, local runners, or cloud) as needed.
```
````