# Build the manager binary
FROM golang:1.16 as builder
WORKDIR /GoProject/src/github.com/woqutech/database-operator
ENV GOPATH=/GoProject
ENV GO111MODULE=off

# Copy the go source
COPY ./ ./

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -mod=vendor -a -o mongodb-exporter main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM alpine:3.13
WORKDIR /
COPY --from=builder /GoProject/src/github.com/woqutech/database-operator/mongodb-exporter .
RUN chmod +x /mongodb-exporter
ENTRYPOINT ["/mongodb-exporter"]
