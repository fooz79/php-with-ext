FROM php:7.4.28-fpm-alpine3.15

RUN \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update --no-cache && apk upgrade --no-cache && apk add --no-cache \
        argon2-libs \
        bash \
        brotli-libs \
        c-client \
        curl \
        gdbm \
        gettext-libs \
        icu-libs \
        libbz2 \
        libedit \
        libffi \
        libgcrypt \
        libgd \
        libgpg-error \
        libldap \
        libpq \
        libsasl \
        libstdc++ \
        libxml2 \
        libxslt \
        libzip \
        net-snmp-libs \
        pcre2 \
        tidyhtml-libs \
        zstd-libs \
        xz-libs && \
    # 编译环境
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        argon2-dev \
        brotli-dev \
        build-base \
        bzip2-dev \
        curl-dev \
        gd-dev \
        gdbm-dev \
        gettext-dev \
        icu-dev \
        imap-dev \
        libedit-dev \
        libffi-dev \
        libgcrypt-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        mysql-dev \
        net-snmp-dev \
        openldap-dev \
        pcre2-dev \
        tidyhtml-dev \
        zlib-dev && \
    # 编译 PHP 扩展
    docker-php-ext-install -j $(nproc) --ini-name 00_bcmath.ini bcmath && \
    docker-php-ext-install -j $(nproc) --ini-name 00_bz2.ini bz2 && \
    docker-php-ext-install -j $(nproc) --ini-name 00_calendar.ini calendar && \
    docker-php-ext-install -j $(nproc) --ini-name 00_exif.ini exif && \
    docker-php-ext-install -j $(nproc) --ini-name 00_ffi.ini ffi && \
    docker-php-ext-install -j $(nproc) --ini-name 00_gd.ini gd && \
    docker-php-ext-install -j $(nproc) --ini-name 00_gettext.ini gettext && \
    docker-php-ext-install -j $(nproc) --ini-name 00_iconv.ini iconv && \
    docker-php-ext-install -j $(nproc) --ini-name 00_imap.ini imap && \
    docker-php-ext-install -j $(nproc) --ini-name 00_intl.ini intl && \
    docker-php-ext-install -j $(nproc) --ini-name 00_ldap.ini ldap && \
    docker-php-ext-install -j $(nproc) --ini-name 00_mysqli.ini mysqli && \
    docker-php-ext-install -j $(nproc) --ini-name 00_pcntl.ini pcntl && \
    docker-php-ext-install -j $(nproc) --ini-name 00_pdo.ini pdo && \
    docker-php-ext-install -j $(nproc) --ini-name 00_pgsql.ini pgsql && \
    docker-php-ext-install -j $(nproc) --ini-name 00_shmop.ini shmop && \
    docker-php-ext-install -j $(nproc) --ini-name 00_snmp.ini snmp && \
    docker-php-ext-install -j $(nproc) --ini-name 00_soap.ini soap && \
    docker-php-ext-install -j $(nproc) --ini-name 00_sockets.ini sockets && \
    docker-php-ext-install -j $(nproc) --ini-name 00_sysvmsg.ini sysvmsg && \
    docker-php-ext-install -j $(nproc) --ini-name 00_sysvsem.ini sysvsem && \
    docker-php-ext-install -j $(nproc) --ini-name 00_sysvshm.ini sysvshm && \
    docker-php-ext-install -j $(nproc) --ini-name 00_tidy.ini tidy && \
    docker-php-ext-install -j $(nproc) --ini-name 00_xmlrpc.ini xmlrpc && \
    docker-php-ext-install -j $(nproc) --ini-name 00_xsl.ini xsl && \
    docker-php-ext-install -j $(nproc) --ini-name 00_zip.ini zip && \
    docker-php-ext-install -j $(nproc) --ini-name 01_pdo_mysql.ini pdo_mysql && \
    docker-php-ext-install -j $(nproc) --ini-name 01_pdo_pgsql.ini pdo_pgsql && \
    docker-php-ext-install -j $(nproc) --ini-name 01_phar.ini phar && \
    # 清理编译环境
    docker-php-source delete && \
    apk del .build-deps && \
    # 启用 opcache
    docker-php-ext-enable --ini-name 00_opcache.ini opcache && \
    mv /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini /usr/local/etc/php/conf.d/00_sodium.ini && \
    # 修改 bashrc
    echo "PS1='\033[1;33m\h \033[1;34m[\w] \033[1;35m\D{%D %T}\n\[\033[1;36m\]\u@\l \[\033[00m\]\$ '" > /root/.bashrc && \
    echo "alias ll='ls -l'" >> /root/.bashrc


WORKDIR "/var/www/"
