FROM golang:1.27-alpine AS builder

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . ./
RUN CGO_ENABLED=0 go build -v -o /usr/local/bin/mkcert ./...

FROM alpine

COPY --from=builder /usr/local/bin/mkcert /usr/local/bin/mkcert

RUN mkdir /.local && chmod 777 /.local

WORKDIR /tmp/certs

ENTRYPOINT ["/usr/local/bin/mkcert"]
CMD ["--help"]
