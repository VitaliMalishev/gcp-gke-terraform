FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o hello-app .

FROM alpine:3.2
WORKDIR /app
COPY --from=builder /app/hello-app .
EXPOSE 8080
CMD ["./hello-app"]