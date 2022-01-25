FROM alpine
RUN apk add jq curl bash
ENV  INTERVAL=60
WORKDIR /
COPY . .
CMD ["sh","-c","while true;do bash /uptime.sh;sleep $INTERVAL;done;"]
