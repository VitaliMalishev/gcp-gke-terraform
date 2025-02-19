FROM golang:1.21-alpine AS builder
WORKDIR /apps
COPY app/go.mod ./
COPY app/go.sum ./
RUN go mod download
COPY app/ ./
RUN CGO_ENABLED=0 GOOS=linux go build -o hello-app .

FROM alpine:3.2
WORKDIR /app
COPY --from=builder /apps/hello-app .
EXPOSE 8080
CMD ["./hello-app"]