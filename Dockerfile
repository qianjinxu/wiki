# syntax=docker/dockerfile:1
FROM docker.io/library/golang:1.21.5 as stage1
WORKDIR /go/src/wiki
COPY . .
RUN go mod download
RUN go mod verify
# RUN go vet -v
# RUN go test -v
RUN CGO_ENABLED=0 go build -o /go/bin/wiki
COPY ./*.txt /go/bin/
COPY ./*.html /go/bin/
# WORKDIR /go/bin
# ENTRYPOINT ["./wiki"]
# EXPOSE 8080/tcp

FROM gcr.io/distroless/static-debian12 as stage2
# MAINTAINER Qianjin Xu <xuqianjinchn@gmail.com>
LABEL org.opencontainers.image.authors="Qianjin Xu <xuqianjinchn@gmail.com>"
COPY --from=stage1 /go/bin /go/bin
WORKDIR /go/bin
ENTRYPOINT ["./wiki"]
EXPOSE 8080/tcp