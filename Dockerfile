FROM php:7.4.28-fpm-alpine3.15

RUN \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update --no-cache && apk upgrade --no-cache && \
    apk add --no-cache \
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
        libgd \
        libldap \
        libpq \
        libsasl \
        libstdc++ \
        libxml2 \
        net-snmp-libs \
        pcre2 \
        tidyhtml-libs \
        xz-libs && \
    # 编译环境
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        argon2-dev \
        brotli-dev \
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
        libpq-dev \
        libxml2-dev \
        mysql-dev \
        net-snmp-dev \
        openldap-dev \
        pcre-dev \
        pcre2-dev \
        tidyhtml-dev \
        zlib-dev && \
    # 编译 PHP 扩展
    docker-php-ext-install -j $(nproc) \
      bcmath \
      bz2 \
      calendar \
      exif \
      ffi \
      gd \
      gettext \
      iconv \
      imap \
      intl \
      ldap \
      mysqli \
      pcntl \
      pdo \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      phar \
      shmop \
      snmp \
      soap \
      sockets \
      sysvmsg \
      sysvsem \
      sysvshm \
      tidy \
      xmlrpc \
      xsl \
      zip && \
    # 清理编译环境
    docker-php-source delete && \
    apk del .build-deps && \
    # 启用 opcache
    docker-php-ext-enable opcache && \
    # 修改 bashrc
    echo "PS1='\033[1;33m\h \033[1;34m[\w] \033[1;35m\D{%D %T}\n\[\033[1;36m\]\u@\l \[\033[00m\]\$ '" > /root/.bashrc && \
    echo "alias ll='ls -l'" >> /root/.bashrc


WORKDIR "/var/www/"
