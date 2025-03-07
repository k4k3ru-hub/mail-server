FROM debian:latest

RUN apt-get update && \
    apt-get install -y opendkim opendkim-tools && \
    mkdir -p /etc/opendkim/keys

COPY config/opendkim/opendkim.conf /etc/opendkim.conf

CMD ["opendkim", "-f"]
