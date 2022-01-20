FROM alpine
RUN apk add jq curl bash
WORKDIR /
COPY . .
CMD ["sh","-c","while true;do bash /uptime.sh;sleep 60;done;"]

