FROM alpine

ENV VERSION=v3.0

ADD https://github.com/CastawayLabs/cachet-monitor/releases/download/${VERSION}/cachet_monitor_linux_amd64 /usr/bin/cachet-monitor

RUN  apk add --no-cache --virtual ca-certificates \ 
    && chmod 755 /usr/bin/cachet-monitor

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "cachet-monitor","-c", "/etc/cachet-monitor.yaml"]
