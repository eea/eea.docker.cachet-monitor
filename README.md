


docker run --rm -e CONFIG=$(cat /etc/cachet-monitor.yaml)  cachet-monitor


docker run --rm -v ./example.config.yml:/etc/cachet-monitor.yaml cachet-monitor



