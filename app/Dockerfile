FROM python:3.13.13-slim-bookworm AS builder

WORKDIR /build

COPY requirements.txt .

RUN python -m pip install \
    --no-cache-dir \
    --upgrade pip && \
    python -m pip install \
    --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

FROM python:3.13.13-slim-bookworm

RUN groupadd --system appgroup && \
    useradd --system --gid appgroup --create-home appuser

WORKDIR /app

COPY --from=builder /install /usr/local
COPY src ./src

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
