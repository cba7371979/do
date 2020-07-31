FROM alpine:3.11

RUN dns_1=$(cat /etc/resolv.conf|grep nameserver|awk 'NR==1{print $2}');dns_2=$(cat /etc/resolv.conf|grep nameserver|awk 'NR==2{print $2}')
ENV NODE_ID=0                            \
    DNS1=$dns_1                          \
    DNS2=$dns_2                          \
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

CMD cp apiconfig.py userapiconfig.py &&                                            cp   config.json  user-config.json && \
    sed -i "s|NODE_ID = 0|NODE_ID = ${NODE_ID}|"                                   /root/shadowsocks/userapiconfig.py && \
    sed -i "s|SPEEDTEST = 6|SPEEDTEST = ${SPEEDTEST}|"                             /root/shadowsocks/userapiconfig.py && \
    sed -i "s|CLOUDSAFE = 1|CLOUDSAFE = ${CLOUDSAFE}|"                             /root/shadowsocks/userapiconfig.py && \
    sed -i "s|AUTOEXEC = 0|AUTOEXEC = ${AUTOEXEC}|"                                /root/shadowsocks/userapiconfig.py && \
    sed -i "s|ANTISSATTACK = 0|ANTISSATTACK = ${ANTISSATTACK}|"                    /root/shadowsocks/userapiconfig.py && \
    sed -i "s|OFFSET = 0|OFFSET = ${OFFSET}|"                                      /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MU_SUFFIX = \'zhaoj.in\'|MU_SUFFIX = \'${MU_SUFFIX}\'|"              /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MU_REGEX = \'%5m%id.%suffix\'|MU_REGEX = \'${MU_REGEX}\'|"           /root/shadowsocks/userapiconfig.py && \
    sed -i "s|API_INTERFACE = \'modwebapi\'|API_INTERFACE = \'${API_INTERFACE}\'|" /root/shadowsocks/userapiconfig.py && \
    sed -i "s|WEBAPI_URL = \'https://zhaoj.in\'|WEBAPI_URL = \'${WEBAPI_URL}\'|"   /root/shadowsocks/userapiconfig.py && \
    sed -i "s|WEBAPI_TOKEN = \'glzjin\'|WEBAPI_TOKEN = \'${WEBAPI_TOKEN}\'|"       /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_HOST = \'127.0.0.1\'|MYSQL_HOST = \'${MYSQL_HOST}\'|"          /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_PORT = 3306|MYSQL_PORT = ${MYSQL_PORT}|"                       /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_USER = \'ss\'|MYSQL_USER = \'${MYSQL_USER}\'|"                 /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_PASS = \'ss\'|MYSQL_PASS = \'${MYSQL_PASS}\'|"                 /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_DB = \'shadowsocks\'|MYSQL_DB = \'${MYSQL_DB}\'|"              /root/shadowsocks/userapiconfig.py && \
    sed -i "s|\"server\": \"0.0.0.0\"|\"server\": \"${SERVER}\"|"                  /root/shadowsocks/user-config.json && \
    sed -i "s|\"server_ipv6\": \"::\"|\"server_ipv6\": \"${SERVER_IPV6}\"|"        /root/shadowsocks/user-config.json && \
    sed -i "s|\"out_bind\": \"\"|\"out_bind\": \"${OUT_BIND}\"|"                   /root/shadowsocks/user-config.json && \
    sed -i "s|\"redirect\": \"\"|\"redirect\": \"${REDIRECT}\"|"                   /root/shadowsocks/user-config.json && \
    sed -i "s|\"fast_open\": true|\"fast_open\": ${FAST_OPEN}|"                    /root/shadowsocks/user-config.json && \
    echo -e "${DNS1}\n${DNS2}\n" >                                                 /root/shadowsocks/dns.conf         && \
    python /root/shadowsocks/server.py
