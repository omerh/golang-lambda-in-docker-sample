FROM golang:alpine3.15 as build

RUN apk add --update git

WORKDIR /go/src/app
RUN go env -w GOPROXY=direct
COPY . .
RUN GOOS=linux \
    CGO_ENABLED=0 \
    go build -ldflags '-w -extldflags "-static"' -o main

FROM alpine:3.15
COPY  --from=build /go/src/app/main /usr/local/bin/main
ENTRYPOINT [ "main" ]