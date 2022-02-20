FROM php:7.4.28-fpm-alpine3.15

RUN \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update --no-cache && \
    apk add --no-cache \
        bash \
        curl \
        libbz2 \
        libstdc++ \
        brotli-libs
RUN \
    # 编译环境
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        brotli-dev \
        build-base \
        curl-dev \
        openssl-dev \
        pcre-dev \
        pcre2-dev \
        zlib-dev \
        bzip2-dev \
        brotli-dev
RUN \
    # 编译 PHP 扩展
    docker-php-ext-install \
      sockets && \
      bcmath && \

      bz2
RUN \
    # 清理环境
    docker-php-source delete && \
    apk del .build-deps

WORKDIR "/var/www/"
