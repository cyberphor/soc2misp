FROM alpine:latest

LABEL Author="Victor Fernandez III, @cyberphor"

RUN apk add --no-cache \
    python3 \
    py3-pip \
    openssl

RUN python3 -m pip install netmiko && \
    mkdir /opt/so2ban/

WORKDIR /opt/so2ban/
 
RUN openssl req -new -x509 -days 365 -nodes -subj \
    /CN="so2ban" \
    -keyout "private.key" \
    -out "public.key"

COPY so2ban.py so2ban.py 

ENTRYPOINT [
    "python3",
    "so2ban.py","--start",
    "--ip-address","172.17.0.69",
    "--acl-name", "BLOCK_ADVERSARY",
    "--acl-command-prefix","ip access-list standard",
    "--block-command-prefix", "1 deny",
    "--audit-only"
]
