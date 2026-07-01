FROM golang:1.23-alpine AS builder

WORKDIR /build

COPY go.mod go.sum* ./
RUN go mod download

COPY . .
RUN go build -o worker .

FROM alpine:3.20

WORKDIR /app

RUN addgroup -S user && adduser -S user -G user

COPY --from=builder /build/worker .

USER user

CMD [ "./worker" ]
