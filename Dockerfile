FROM docker.io/golang:1.22 as builder

WORKDIR /build
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY main.go main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a

FROM gcr.io/distroless/static:nonroot
LABEL \
	org.opencontainers.image.title="go-import-redirector" \
	org.opencontainers.image.url="https://github.com/slrz/go-import-redirector" \
	org.opencontainers.image.source="https://github.com/slrz/go-import-redirector"

WORKDIR /
COPY --from=builder /build/go-import-redirector .
USER nonroot:nonroot

ENTRYPOINT ["/go-import-redirector"]
