FROM alpine:3.11

ENV NODE_ID=0                            \
    DNS_1=8.8.8.8                        \
    DNS_2=1.0.0.1                        \
    SPEEDTEST=0                          \
    CLOUDSAFE=0                          \
    AUTOEXEC=0                           \
    ANTISSATTACK=0                       \
    OFFSET=0                             \
    MU_SUFFIX=download.windowsupdate.com \
    MU_REGEX=%5m%id.%suffix              \
    API_INTERFACE=modwebapi              \
    WEBAPI_URL=https://zhaoj.in          \
    WEBAPI_TOKEN=glzjin                  \
    MYSQL_HOST=127.0.0.1                 \
    MYSQL_PORT=3306                      \
    MYSQL_USER=ss                        \
    MYSQL_PASS=ss                        \
    MYSQL_DB=shadowsocks                 \
    SERVER=0.0.0.0                       \
    SERVER_IPV6=::                       \
    OUT_BIND=                            \
    REDIRECT=github.com                  \
    FAST_OPEN=false

RUN apk add --no-cache                           \
        curl                                     \
        libintl                                  \
        python3-dev                              \
        py3-gevent                               \
        libsodium-dev                            \
        openssl-dev                              \
        udns-dev                                 \
        mbedtls-dev                              \
        pcre-dev                                 \
        libev-dev                                \
        libtool                                  \
        libffi-dev                            && \
    apk add --no-cache --virtual .build-deps     \
         git                                     \
         tar                                     \
         make                                    \
         gettext                                 \
         py3-pip                                 \
         autoconf                                \
         automake                                \
         build-base                              \
         linux-headers                        && \
     ln -s /usr/bin/python3 /usr/bin/python   && \
     ln -s /usr/bin/pip3    /usr/bin/pip      && \
     cp /usr/bin/envsubst  /usr/local/bin/    && \
     git clone -b manyuser https://github.com/micll/shadowsocks-mod.git "/root/shadowsocks" --depth 1 && \
     pip install --upgrade pip                && \
     cd  /root/shadowsocks                    && \
     pip install -r requirements.txt          && \
     rm -rf ~/.cache && touch /etc/hosts.deny && \
     apk del --purge .build-deps

WORKDIR /root/shadowsocks

CMD envsubst < apiconfig.py > userapiconfig.py && \
    envsubst < config.json > user-config.json  && \
    if [ $NS1 != 8.8.4.4 -a $NS2 = 1.0.0.1 ];then echo -e "$NS1 53">/root/shadowsocks/dns.conf ; else echo -e "$NS1 53\n$NS2 53">/root/shadowsocks/dns.conf ; fi && \
    python /root/shadowsocks/server.py
