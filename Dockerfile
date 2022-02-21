ARG RUNMODE=fpm
ARG PHP_MAJOR=7.4
ARG PHP_MINOR=28
ARG ALPINE_VERSION=3.15

FROM php:${PHP_MAJOR}.${PHP_MINOR}-${RUNMODE}-alpine${ALPINE_VERSION} as build

ARG COMPOSER_VER=2.2.6
ARG EXT_BCMATH_ENABLE=true
ARG EXT_BZ2_ENABLE=true
ARG EXT_CALENDAR_ENABLE=true
ARG EXT_EXIF_ENABLE=true
ARG EXT_FFI_ENABLE=true
ARG EXT_GD_ENABLE=true
ARG EXT_GETTEXT_ENABLE=true
ARG EXT_GMP_ENABLE=true
ARG EXT_IMAP_ENABLE=true
ARG EXT_INTL_ENABLE=true
ARG EXT_LDAP_ENABLE=true
ARG EXT_MYSQLI_ENABLE=true
ARG EXT_PCNTL_ENABLE=true
ARG EXT_PGSQL_ENABLE=true
ARG EXT_SHMOP_ENABLE=true
ARG EXT_SNMP_ENABLE=true
ARG EXT_SOAP_ENABLE=true
ARG EXT_SOCKETS_ENABLE=true
ARG EXT_SYSVMSG_ENABLE=true
ARG EXT_SYSVSEM_ENABLE=true
ARG EXT_SYSVSHM_ENABLE=true
ARG EXT_TIDY_ENABLE=true
ARG EXT_XSL_ENABLE=true
ARG EXT_ZIP_ENABLE=true

ENV PHP_VERSION ${PHP_MAJOR}.${PHP_MINOR}

RUN set -ex && \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && apk upgrade && \
    # PHP 编译环境
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    docker-php-source extract && \
    # 安装 PHP 内置扩展模块
    docker-php-ext-install -j$(nproc) --ini-name 01-pdo_mysql.ini pdo_mysql && \
    if test ${EXT_BCMATH_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-bcmath.ini bcmath; \
    fi && \
    if test ${EXT_BZ2_ENABLE} = true; then \
        apk add --no-cache libbz2 && \
        apk add --no-cache --virtual .ext-bz2-deps \
            bzip2-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-bz2.ini bz2; \
    fi && \
    if test ${EXT_CALENDAR_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-calendar.ini calendar; \
    fi && \
    if test ${EXT_EXIF_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-exif.ini exif; \
    fi && \
    if test ${EXT_FFI_ENABLE} = true; then \
        apk add --no-cache libffi && \
        apk add --no-cache --virtual .ext-ffi-deps \
            libffi-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-ffi.ini ffi; \
    fi && \
    if test ${EXT_GD_ENABLE} = true; then \
        apk add --no-cache freetype libjpeg-turbo libpng libwebp libxpm && \
        apk add --no-cache --virtual .ext-gd-deps \
            libpng-dev freetype-dev libxpm-dev libwebp-dev zlib-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-gd.ini gd; \
    fi && \
    if test ${EXT_GETTEXT_ENABLE} = true; then \
        apk add --no-cache gettext && \
        apk add --no-cache --virtual .ext-gettext-deps \
            gettext-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-gettext.ini gettext; \
    fi && \
    if test ${EXT_GMP_ENABLE} = true; then \
        apk add --no-cache gmp && \
        apk add --no-cache --virtual .ext-gmp-deps \
            gmp-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-gmp.ini gmp; \
    fi && \
    if test ${EXT_IMAP_ENABLE} = true; then \
        apk add --no-cache c-client imap && \
        apk add --no-cache --virtual .ext-imap-deps \
            imap-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-imap.ini imap; \
    fi && \
    if test ${EXT_INTL_ENABLE} = true; then \
        apk add --no-cache icu-libs && \
        apk add --no-cache --virtual .ext-intl-deps \
            icu-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-intl.ini intl; \
    fi && \
    if test ${EXT_LDAP_ENABLE} = true; then \
        apk add --no-cache libldap && \
        apk add --no-cache --virtual .ext-ldap-deps \
            openldap-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-ldap.ini ldap; \
    fi && \
    if test ${EXT_MYSQLI_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-mysqli.ini mysqli; \
    fi && \
    if test ${EXT_PCNTL_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-pcntl.ini pcntl; \
    fi && \
    if test ${EXT_PGSQL_ENABLE} = true; then \
        apk add --no-cache libpq && \
        apk add --no-cache --virtual .ext-pgsql-deps \
            libpq-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-pgsql.ini pgsql; \
        docker-php-ext-install -j$(nproc) --ini-name 01-pdo_pgsql.ini pdo_pgsql; \
    fi && \
    if test ${EXT_SHMOP_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-shmop.ini shmop; \
    fi && \
    if test ${EXT_SNMP_ENABLE} = true; then \
        apk add --no-cache net-snmp-libs && \
        apk add --no-cache --virtual .ext-snmp-deps \
            net-snmp-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-snmp.ini snmp; \
    fi && \
    if test ${EXT_SOAP_ENABLE} = true; then \
        apk add --no-cache libxml2 && \
        apk add --no-cache --virtual .ext-soap-deps \
            libxml2-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-soap.ini soap; \
    fi && \
    if test ${EXT_SOCKETS_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-sockets.ini sockets; \
    fi && \
    if test ${EXT_SYSVMSG_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-sysvmsg.ini sysvmsg; \
    fi && \
    if test ${EXT_SYSVSEM_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-sysvsem.ini sysvsem; \
    fi && \
    if test ${EXT_SYSVSHM_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-sysvshm.ini sysvshm; \
    fi && \
    if test ${EXT_TIDY_ENABLE} = true; then \
        apk add --no-cache tidyhtml-libs && \
        apk add --no-cache --virtual .ext-tidy-deps \
            tidyhtml-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-tidy.ini tidy; \
    fi && \
    if test ${EXT_XSL_ENABLE} = true; then \
        apk add --no-cache libxslt && \
        apk add --no-cache --virtual .ext-xsl-deps \
            libxslt-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-xsl.ini xsl; \
    fi && \
    if test ${EXT_ZIP_ENABLE} = true; then \
        apk add --no-cache libzip && \
        apk add --no-cache --virtual .ext-zip-deps \
            libzip-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-zip.ini zip; \
    fi && \
    # 启用已安装 PHP 扩展
    rm -f /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    docker-php-ext-enable --ini-name 00_sodium.ini sodium && \
    docker-php-ext-enable --ini-name 00_opcache.ini opcache && \
    # 清理构建过程临时文件
    if test ${EXT_BZ2_ENABLE} = true; then apk del .ext-bz2-deps; fi && \
    if test ${EXT_FFI_ENABLE} = true; then apk del .ext-ffi-deps; fi && \
    if test ${EXT_GD_ENABLE} = true; then apk del .ext-gd-deps; fi && \
    if test ${EXT_GMP_ENABLE} = true; then apk del .ext-gmp-deps; fi && \
    if test ${EXT_IMAP_ENABLE} = true; then apk del .ext-imap-deps; fi && \
    if test ${EXT_INTL_ENABLE} = true; then apk del .ext-intl-deps; fi && \
    if test ${EXT_LDAP_ENABLE} = true; then apk del .ext-ldap-deps; fi && \
    if test ${EXT_PGSQL_ENABLE} = true; then apk del .ext-pgsql-deps; fi && \
    if test ${EXT_SNMP_ENABLE} = true; then apk del .ext-snmp-deps; fi && \
    if test ${EXT_SOAP_ENABLE} = true; then apk del .ext-soap-deps; fi && \
    if test ${EXT_TIDY_ENABLE} = true; then apk del .ext-tidy-deps; fi && \
    if test ${EXT_XSL_ENABLE} = true; then apk del .ext-xsl-deps; fi && \
    if test ${EXT_ZIP_ENABLE} = true; then apk del .ext-zip-deps; fi && \
    docker-php-source delete && apk del .build-deps && rm -rf /tmp/* && \
    # 链接常用路径
    ln -s /usr/local/bin/php /usr/bin/ && \
    ln -s /usr/local/etc/php /etc/ && \
    ln -s /usr/local/etc/php-fpm.d /etc/ && \
    # Composer
    curl -sfL https://getcomposer.org/download/${COMPOSER_VER}/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

