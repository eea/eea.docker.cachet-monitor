FROM golang:1.16-alpine AS build

ENV VERSION=v3.0
ENV GO111MODULE=off CGO_ENABLED=0 GOOS=linux

RUN apk add --no-cache git

RUN git clone --depth 1 --branch ${VERSION} \
      https://github.com/CastawayLabs/cachet-monitor \
      /go/src/github.com/castawaylabs/cachet-monitor

WORKDIR /go/src/github.com/castawaylabs/cachet-monitor

# fix: escalate to Major when component is already Partial(3) OR Major(4), not only ==3
RUN sed -i 's/componentStatus == 3/componentStatus >= 3/' incident.go

RUN go get ./... && go build -o /usr/bin/cachet-monitor ./cli

# ---- final stage ----
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

COPY --from=build /usr/bin/cachet-monitor /usr/bin/cachet-monitor

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "cachet-monitor","-c", "/etc/cachet-monitor.yaml"]
