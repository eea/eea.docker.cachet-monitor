
# Docker image for cachet-monitor

cachet-monitor documentation - https://github.com/castawaylabs/cachet-monitor


# Variables

You need to provide the cachet-monitor configuration either in `CONFIG` variable or in a mounted /etc/cachet-monitor.yaml file.

It is not mandatory to provide the `api:` part of the configuration if you are using this variables:

-  CACHET_API      override API url from configuration
-  CACHET_TOKEN    override API token from configuration
-  CACHET_DEV      set to enable dev logging


# Usage
The Cachet token and api should be taken from your cachet instance.

    docker run --rm -e CONFIG=$(cat example.config.yml) -e CACHET_API=http://cachet/api/v1  -e CACHET_TOKEN=9yMHsdioQosnyVK4iCVR eeacms/cachet-monitor
    docker run --rm -v ./example.config.yml:/etc/cachet-monitor.yaml eeacms/cachet-monitor




