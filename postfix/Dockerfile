FROM alpine:3.21

# Update and Install required packages.
RUN apk update && \
    apk add postfix=3.9.3-r0 bash gettext

# Install utility packages.
RUN apk add vim

WORKDIR /app

COPY config /app/config
COPY script /app/script
RUN chmod +x /app/script/*.sh

EXPOSE 25 587 465

CMD ["/bin/sh", "-c", "/app/script/main.sh"]
