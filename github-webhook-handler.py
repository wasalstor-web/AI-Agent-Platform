from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.security import APIKeyHeader
import hmac
import hashlib

app = FastAPI()

API_KEY = "aip_bb1dc27e182e83edcf6ea1e6b989d3c8d32d0e54a00b26f39cfda657fc493cea"
api_key_header = APIKeyHeader(name="x-api-key")

async def authenticate(api_key: str = Depends(api_key_header)):
    if api_key != API_KEY:
        raise HTTPException(status_code=403, detail="Forbidden")

@app.post("/webhook")
async def handle_webhook(request: Request, api_key: str = Depends(authenticate)):
    event = request.headers.get("X-GitHub-Event")
    payload = await request.json()

    # Process the webhook event (e.g., push, pull request)
    if event == "push":
        # Handle push event
        return {"message": "Push event received", "payload": payload}
    elif event == "pull_request":
        # Handle pull request event
        return {"message": "Pull request event received", "payload": payload}
    else:
        return {"message": "Event not handled", "event": event}