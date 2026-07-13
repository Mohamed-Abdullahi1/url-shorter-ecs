FROM python:3.13.14-alpine3.23 AS builder

WORKDIR /build

COPY requirements.txt .

RUN python -m venv /opt/venv && \
    /opt/venv/bin/python -m pip install \
      --no-cache-dir \
      --upgrade pip && \
    /opt/venv/bin/python -m pip install \
      --no-cache-dir \
      -r requirements.txt

FROM python:3.13.14-alpine3.23

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appgroup src ./src

USER appuser

EXPOSE 8080

CMD ["/opt/venv/bin/python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
