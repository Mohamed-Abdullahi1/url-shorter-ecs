from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse

import hashlib
import os
import time

from .db import (
    get_backend_type,
    get_mapping,
    increment_clicks,
    put_mapping,
)
from .events import publish_click_event

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "https://url.moabdullahi.uk",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/healthz")
def health():
    return {
        "status": "ok",
        "ts": int(time.time()),
        "db": get_backend_type(),
        "version": "v2",
    }


@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()

    url = body.get("url")
    if not url:
        raise HTTPException(status_code=400, detail="url required")

    short = hashlib.sha256(url.encode()).hexdigest()[:8]

    put_mapping(short, url)

    base_url = os.environ.get("BASE_URL", "").rstrip("/")

    return {
        "short": short,
        "url": url,
        "short_url": f"{base_url}/r/{short}" if base_url else f"/r/{short}",
    }


@app.get("/stats/{short_id}")
def stats(short_id: str):
    item = get_mapping(short_id)

    if not item:
        raise HTTPException(status_code=404, detail="not found")

    return {
        "short": short_id,
        "url": item["url"],
        "clicks": item.get("clicks", 0),
    }


@app.get("/r/{short_id}")
def resolve(short_id: str, request: Request):
    item = get_mapping(short_id)

    if not item:
        raise HTTPException(status_code=404, detail="not found")

    increment_clicks(short_id)

    publish_click_event(
        short_code=short_id,
        ip=request.client.host if request.client else "unknown",
        user_agent=request.headers.get("user-agent", ""),
        referer=request.headers.get("referer", ""),
    )

    return RedirectResponse(url=item["url"])
