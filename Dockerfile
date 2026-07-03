# syntax=docker/dockerfile:labs@sha256:7d49dad25a050e14338ba7028b0460243f9d911dedc160a8fe20c34738fef3af
FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b
COPY update.sh /usr/local/bin/update.sh
RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates tzdata tini curl jq

USER nobody
ENTRYPOINT ["tini", "--", "update.sh"]
