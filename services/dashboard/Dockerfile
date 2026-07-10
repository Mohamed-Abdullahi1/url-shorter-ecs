FROM golang:1.25.11-alpine3.24 AS builder

WORKDIR /build

COPY go.mod go.sum* ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o dashboard .

FROM alpine:3.24

WORKDIR /app

RUN addgroup -S user && \
    adduser -S user -G user

COPY --from=builder /build/dashboard .

USER user

EXPOSE 8081

CMD ["./dashboard"]
