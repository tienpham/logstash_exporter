FROM golang:1.12.7-alpine as builder

ENV GO111MODULE=on
RUN apk add bash ca-certificates git gcc g++ libc-dev make

WORKDIR /go/src/logstash_exporter

COPY . . 
RUN ls -la
RUN CGO_ENABLED=1 GOARCH=amd64 GOOS=linux go test ./... && go install -a -tags netgo

FROM alpine:latest

RUN apk add bash ca-certificates
RUN update-ca-certificates

WORKDIR /root/

COPY --from=builder /go/bin/logstash_exporter .

EXPOSE 9198
ENTRYPOINT ["/root/logstash_exporter"]  