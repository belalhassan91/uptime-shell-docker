# uptime-shell-docker

uptime shell script loop to all microservices you defined and curl them with status check and send slack notification when status code different than 200

# How to use

First clone repository

```bash
git clone https://github.com/belalhassan91/uptime-shell-docker.git
cd uptime-shell-docker
```

create services.json

```bash
touch services.json
```

copy the following example

```
[
  {
        "url": "nginx",
        "port": 80,
        "path": "/"
  }
]
```

create slack webhook url and public channel then create slack.json

```
{
  "webhook_url": "https://hooks.slack.com/services/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "channel": "#test"
}
```

docker-compose.yml example

```
  uptime:
    build:
      context: src/uptime/
      dockerfile: Dockerfile
    image: uptime-${env}
    container_name: uptime-${env}
    environment:
      env: ${env}
```
