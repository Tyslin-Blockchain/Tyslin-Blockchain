FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /tyslinchain
RUN cd /tyslinchain && make tyslin

FROM alpine:latest

LABEL maintainer="etienne@tyslinchain.com"

WORKDIR /tyslinchain

COPY --from=builder /tyslinchain/build/bin/tyslin /usr/local/bin/tyslin

RUN chmod +x /usr/local/bin/tyslin

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/usr/local/bin/tyslin"]

CMD ["--help"]
