FROM php:7.4.28-fpm-alpine3.15

RUN \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update --no-cache && \
    apk add --no-cache \
        bash \
        brotli-libs \
        c-client \
        curl \
        gdbm \
        gettext-libs \
        icu-libs \
        libbz2 \
        libffi \
        libgd \
        libldap \
        libsasl \
        libstdc++
RUN \
    # 编译环境
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        brotli-dev \
        brotli-dev \
        build-base \
        bzip2-dev \
        curl-dev \
        gd-dev \
        gdbm-dev \
        gettext-dev \
        imap-dev \
        libffi-dev \
        openldap-dev \
        openssl-dev \
        pcre-dev \
        pcre2-dev \
        mysql-dev \
        zlib-dev
RUN
RUN \
    # 编译 PHP 扩展
    docker-php-ext-install \
      bcmath \
      bz2 \
      calendar \
      exif
RUN docker-php-ext-install \
      ffi \
      gd \
      gettext \
      iconv
RUN docker-php-ext-install \
      imap \
      intl \
      ldap \
      mysqli \
      pcntl \
      pdo \
      pdo_mysql \
      pdo_pgsql \
      pdo_sqlite \
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
      zip
RUN \
    # 清理环境
    docker-php-source delete && \
    apk del .build-deps
RUN \
    # 启用 opcache
    docker-php-ext-enable opcache && \
    # 修改 bashrc
    echo "PS1='\033[1;33m\h \033[1;34m[\w] \033[1;35m\D{%D %T}\n\[\033[1;36m\]\u@\l \[\033[00m\]\$ '" > /root/.bashrc && \
    echo "alias ll='ls -l'" >> /root/.bashrc


WORKDIR "/var/www/"
