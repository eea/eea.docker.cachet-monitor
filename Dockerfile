FROM golang:1.23-alpine AS build

ENV VERSION=v3.0

RUN apk add --no-cache git

WORKDIR /src

RUN git clone --depth 1 --branch ${VERSION} \
      https://github.com/CastawayLabs/cachet-monitor .

# fix: escalate to Major when component is already Partial(3) OR Major(4), not only ==3
RUN sed -i 's/componentStatus == 3/componentStatus >= 3/' incident.go

RUN sed -i 's#github.com/Sirupsen/logrus#github.com/sirupsen/logrus#g' *.go cli/*.go

RUN go mod init github.com/castawaylabs/cachet-monitor \
 && go mod edit \
      -require=github.com/sirupsen/logrus@v1.4.2 \
      -require=github.com/mitchellh/mapstructure@v1.1.2 \
      -require=gopkg.in/yaml.v2@v2.4.0 \
      -require=github.com/miekg/dns@v1.1.27 \
 && go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o /usr/bin/cachet-monitor ./cli

FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

COPY --from=build /usr/bin/cachet-monitor /usr/bin/cachet-monitor

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "cachet-monitor","-c", "/etc/cachet-monitor.yaml"]
