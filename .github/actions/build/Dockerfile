FROM golang:1.11-alpine
MAINTAINER Atsushi Nagase <a@ngs.io> (https://ngs.io)

RUN apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
