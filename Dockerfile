ARG RUNMODE
ARG PHP_VERSION

FROM php:${PHP_VERSION}-${RUNMODE}-alpine3.15 as build

ARG EXT_BCMATH_ENABLE=true
ARG EXT_BZ2_ENABLE=true
ARG EXT_CALENDAR_ENABLE=true
ARG EXT_EXIF_ENABLE=true
ARG EXT_FFI_ENABLE=true
ARG EXT_GD_ENABLE=true

RUN \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && apk upgrade && \
    # PHP 编译环境
    touch /tmp/.build_deps && apk add --no-cache --virtual .build_deps $PHPIZE_DEPS && \
    docker-php-source extract
RUN \
    # 安装 PHP 内置扩展模块
    # if test ${EXT_BCMATH_ENABLE} = true; then \
    #     docker-php-ext-install -j$(nproc) --ini-name 00-bcmath.ini bcmath; \
    # fi && \
    if test ${EXT_BZ2_ENABLE} = true; then \
        apk add --no-cache libbz2 && \
        touch /tmp/.ext_bz2_deps && apk add --no-cache --virtual .ext_bz2_deps bzip2-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-bz2.ini bz2; \
    fi
    # if test ${EXT_CALENDAR_ENABLE} = true; then \
    #     docker-php-ext-install -j$(nproc) --ini-name 00-calendar.ini calendar; \
    # fi && \
    # if test ${EXT_CALENDAR_ENABLE} = true; then \
    #     docker-php-ext-install -j$(nproc) --ini-name 00-calendar.ini calendar; \
    # fi
RUN \
    # 清理构建过程临时文件
    if test -f /tmp/.ext_bz2_deps; then apk del .ext_bz2_deps; fi && \
    if test -f /tmp/.build_deps; then apk del .build_deps; fi &&  \
    docker-php-source delete && rm -rf /tmp/* && rm -f /tmp/.*_deps

