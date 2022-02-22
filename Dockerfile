ARG RUNMODE=fpm
ARG PHP_MAJOR="7.4"
ARG PHP_MINOR=28
ARG ALPINE_VERSION=3.15
# 在 FROM 之后上述 ARG 会失效

FROM php:${PHP_MAJOR}.${PHP_MINOR}-${RUNMODE}-alpine${ALPINE_VERSION}

# 镜像构建时 PHP 默认版本
ARG COMPOSER_VER=2.2.6
ARG PHP_MAJOR="7.4"
ARG PHP_MINOR=28
ENV PHP_VERSION ${PHP_MAJOR}.${PHP_MINOR}

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
ARG EXT_MYSQL_ENABLE=true
ARG EXT_PCNTL_ENABLE=true
ARG EXT_PGSQL_ENABLE=true
ARG EXT_SHMOP_ENABLE=true
ARG EXT_SNMP_ENABLE=true
ARG EXT_SOAP_ENABLE=true
ARG EXT_SOCKETS_ENABLE=false
ARG EXT_SEMAPHORE_ENABLE=true
ARG EXT_TIDY_ENABLE=true
ARG EXT_XSL_ENABLE=true
ARG EXT_ZIP_ENABLE=true

ARG EXTRA_AMQP_ENABLE=true
ARG EXTRA_AMQP_VERSION=1.11.0
ARG EXTRA_APCU_ENABLE=true
ARG EXTRA_APCU_VERSION=5.1.21
ARG EXTRA_BROTLI_ENABLE=true
ARG EXTRA_BROTLI_VERSION=0.13.1
ARG EXTRA_COMPOSER_ENABLE=true
ARG EXTRA_COMPOSER_VERSION=2.2.6
ARG EXTRA_CSV_ENABLE=true
ARG EXTRA_CSV_VERSION=0.4.1
ARG EXTRA_EVENT_ENABLE=true
ARG EXTRA_EVENT_VERSION=3.0.6
ARG EXTRA_IGBINARY_ENABLE=true
ARG EXTRA_IGBINARY_VERSION=3.2.7
ARG EXTRA_IMAGICK_ENABLE=true
ARG EXTRA_IMAGICK_VERSION=3.7.0
ARG EXTRA_INOTIFY_ENABLE=true
ARG EXTRA_INOTIFY_VERSION=3.0.0
ARG EXTRA_LZ4_ENABLE=true
ARG EXTRA_LZ4_VERSION=0.4.3
ARG EXTRA_LZF_ENABLE=true
ARG EXTRA_LZF_VERSION=1.7.0
ARG EXTRA_MCRYPT_ENABLE=true
ARG EXTRA_MCRYPT_VERSION=1.0.4
ARG EXTRA_MONGODB_ENABLE=true
ARG EXTRA_MONGODB_VERSION=1.12.0
ARG EXTRA_MSGPACK_ENABLE=true
ARG EXTRA_MSGPACK_VERSION=2.1.2
ARG EXTRA_PROTOBUF_ENABLE=true
ARG EXTRA_PROTOBUF_VERSION=3.19.4
ARG EXTRA_PSR_ENABLE=true
ARG EXTRA_PSR_VERSION=1.2.0
ARG EXTRA_REDIS_ENABLE=true
ARG EXTRA_REDIS_VERSION=5.3.7
ARG EXTRA_SWOOLE_ENABLE=true
ARG EXTRA_SWOOLE_VERSION=4.8.7
ARG EXTRA_UUID_ENABLE=true
ARG EXTRA_UUID_VERSION=1.2.0
ARG EXTRA_YAML_ENABLE=true
ARG EXTRA_YAML_VERSION=2.2.2
ARG EXTRA_ZEPHIR_ENABLE=true
ARG EXTRA_ZEPHIR_VERSION=1.5.0

RUN set -ex && \
    # 安装 Composer
    curl -sfL https://github.com/composer/composer/releases/download/${COMPOSER_VER}/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && \
    # 修改 APK 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && apk upgrade && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS git
RUN set -ex && \
    # 安装 PHP 内置扩展模块
    docker-php-source extract && \
    if test ${EXT_BCMATH_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-bcmath.ini bcmath; \
    fi && \
    if test ${EXT_BZ2_ENABLE} = true; then \
        apk add --no-cache libbz2 && \
        apk add --no-cache --virtual .ext-bz2-deps \
            bzip2-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-bz2.ini bz2 && \
        apk del .ext-bz2-deps; \
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
        docker-php-ext-install -j$(nproc) --ini-name 00-ffi.ini ffi && \
        apk del .ext-ffi-deps; \
    fi && \
    if test ${EXT_GD_ENABLE} = true; then \
        apk add --no-cache freetype libjpeg-turbo libpng libwebp libxpm && \
        apk add --no-cache --virtual .ext-gd-deps \
            libpng-dev freetype-dev libxpm-dev libwebp-dev zlib-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-gd.ini gd && \
        apk del .ext-gd-deps; \
    fi && \
    if test ${EXT_GETTEXT_ENABLE} = true; then \
        apk add --no-cache gettext && \
        apk add --no-cache --virtual .ext-gettext-deps \
            gettext-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-gettext.ini gettext && \
        apk del .ext-gettext-deps; \
    fi && \
    if test ${EXT_GMP_ENABLE} = true; then \
        apk add --no-cache gmp && \
        apk add --no-cache --virtual .ext-gmp-deps \
            gmp-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-gmp.ini gmp && \
        apk del .ext-gmp-deps; \
    fi && \
    if test ${EXT_IMAP_ENABLE} = true; then \
        apk add --no-cache c-client imap && \
        apk add --no-cache --virtual .ext-imap-deps \
            imap-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-imap.ini imap && \
        apk del .ext-imap-deps; \
    fi && \
    if test ${EXT_INTL_ENABLE} = true; then \
        apk add --no-cache icu-libs && \
        apk add --no-cache --virtual .ext-intl-deps \
            icu-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-intl.ini intl && \
        apk del .ext-intl-deps; \
    fi && \
    if test ${EXT_LDAP_ENABLE} = true; then \
        apk add --no-cache libldap && \
        apk add --no-cache --virtual .ext-ldap-deps \
            openldap-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-ldap.ini ldap; \
    fi && \
    if test ${EXT_MYSQL_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-mysqli.ini mysqli && \
        docker-php-ext-install -j$(nproc) --ini-name 01-pdo_mysql.ini pdo_mysql; \
    fi && \
    if test ${EXT_PCNTL_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-pcntl.ini pcntl; \
    fi && \
    if test ${EXT_PGSQL_ENABLE} = true; then \
        apk add --no-cache libpq && \
        apk add --no-cache --virtual .ext-pgsql-deps \
            libpq-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-pgsql.ini pgsql && \
        docker-php-ext-install -j$(nproc) --ini-name 01-pdo_pgsql.ini pdo_pgsql && \
        apk del .ext-pgsql-deps; \
    fi && \
    if test ${EXT_SHMOP_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-shmop.ini shmop; \
    fi && \
    if test ${EXT_SNMP_ENABLE} = true; then \
        apk add --no-cache net-snmp-libs && \
        apk add --no-cache --virtual .ext-snmp-deps \
            net-snmp-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-snmp.ini snmp && \
        apk del .ext-snmp-deps; \
    fi && \
    if test ${EXT_SOAP_ENABLE} = true; then \
        apk add --no-cache libxml2 && \
        apk add --no-cache --virtual .ext-soap-deps \
            libxml2-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-soap.ini soap && \
        apk del .ext-soap-deps; \
    fi && \
    if test ${EXT_SOCKETS_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-sockets.ini sockets; \
    fi && \
    if test ${EXT_SEMAPHORE_ENABLE} = true; then \
        docker-php-ext-install -j$(nproc) --ini-name 00-sysvmsg.ini sysvmsg && \
        docker-php-ext-install -j$(nproc) --ini-name 00-sysvsem.ini sysvsem && \
        docker-php-ext-install -j$(nproc) --ini-name 00-sysvshm.ini sysvshm; \
    fi && \
    if test ${EXT_TIDY_ENABLE} = true; then \
        apk add --no-cache tidyhtml-libs && \
        apk add --no-cache --virtual .ext-tidy-deps \
            tidyhtml-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-tidy.ini tidy && \
        apk del .ext-tidy-deps; \
    fi && \
    if test ${EXT_XSL_ENABLE} = true; then \
        apk add --no-cache libxslt && \
        apk add --no-cache --virtual .ext-xsl-deps \
            libxslt-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-xsl.ini xsl && \
        apk del .ext-xsl-deps; \
    fi && \
    if test ${EXT_ZIP_ENABLE} = true; then \
        apk add --no-cache libzip && \
        apk add --no-cache --virtual .ext-zip-deps \
            libzip-dev && \
        docker-php-ext-install -j$(nproc) --ini-name 00-zip.ini zip && \
        apk del .ext-zip-deps; \
    fi && \
    # 启用已安装 PHP 扩展
    rm -f /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    docker-php-ext-enable --ini-name 00_sodium.ini sodium && \
    docker-php-ext-enable --ini-name 00_opcache.ini opcache
RUN \
    # 安装第三方扩展模块
    if test ${EXTRA_AMQP_ENABLE} = true; then \
        curl -sfL https://github.com/php-amqp/php-amqp/archive/refs/tags/v${EXTRA_AMQP_VERSION}.tar.gz -o /tmp/amqp.tar.gz && \
        mkdir /usr/src/php/ext/amqp && tar xfz /tmp/amqp.tar.gz --strip-components=1 -C /usr/src/php/ext/amqp && \
        apk add --no-cache rabbitmq-c && \
        apk add --no-cache --virtual .ext-amqp-deps rabbitmq-c-dev && \
        docker-php-ext-configure amqp && \
        docker-php-ext-install -j$(nproc) --ini-name 20-amqp.ini amqp && \
        apk del .ext-amqp-deps; \
    fi && \
    if test ${EXTRA_SWOOLE_ENABLE} = true; then \
        if test ${EXT_SOCKETS_ENABLE} != true; then \
            docker-php-ext-install -j$(nproc) --ini-name 00-sockets.ini sockets; \
        fi && \
        curl -sfL https://github.com/swoole/swoole-src/archive/v${EXTRA_SWOOLE_VERSION}.tar.gz -o /tmp/swoole.tar.gz && \
        mkdir /usr/src/php/ext/swoole && tar xfz /tmp/swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole && \
        apk add --no-cache brotli-libs libstdc++ && \
        apk add --no-cache --virtual .ext-swoole-deps \
            openssl-dev curl-dev brotli-dev pcre-dev && \
        docker-php-ext-configure swoole \
            --enable-sockets --enable-openssl --enable-http2 --enable-mysqlnd --enable-swoole-json --enable-swoole-curl && \
        docker-php-ext-install -j$(nproc) --ini-name 80-swoole.ini swoole && \
        apk del .ext-swoole-deps; \
    fi && \
    if test ${EXTRA_BROTLI_ENABLE} = true; then \
        curl -sfL https://github.com/kjdev/php-ext-brotli/archive/refs/tags/${EXTRA_BROTLI_VERSION}.tar.gz -o /tmp/brotli.tar.gz && \
        mkdir /usr/src/php/ext/brotli && tar xfz /tmp/brotli.tar.gz --strip-components=1 -C /usr/src/php/ext/brotli && \
        apk add --no-cache brotli-libs && \
        apk add --no-cache --virtual .ext-brotli-deps brotli-dev && \
        docker-php-ext-configure brotli --with-libbrotli && \
        docker-php-ext-install -j$(nproc) --ini-name 10-brotli.ini brotli && \
        apk del .ext-brotli-deps; \
    fi && \
    if test ${EXTRA_APCU_ENABLE} = true; then \
        curl -sfL https://github.com/krakjoe/apcu/archive/refs/tags/v${EXTRA_APCU_VERSION}.tar.gz -o /tmp/apcu.tar.gz && \
        mkdir /usr/src/php/ext/apcu && tar xfz /tmp/apcu.tar.gz --strip-components=1 -C /usr/src/php/ext/apcu && \
        docker-php-ext-configure apcu --enable-apcu-spinlocks && \
        docker-php-ext-install -j$(nproc) --ini-name 10-apcu.ini apcu && \
    fi && \
    if test ${EXTRA_EVENT_ENABLE} = true; then \
        if test ${EXT_SOCKETS_ENABLE} != true; then \
            docker-php-ext-install -j$(nproc) --ini-name 00-sockets.ini sockets; \
        fi && \
        git clone -q -b ${EXTRA_EVENT_VERSION} --depth 1 https://bitbucket.org/osmanov/pecl-event.git /usr/src/php/ext/event && \
        apk add --no-cache libevent && \
        apk add --no-cache --virtual .ext-event-deps openssl-dev libevent-dev && \
        docker-php-ext-configure event --with-event-core --with-event-extra --with-event-openssl --enable-event-sockets && \
        docker-php-ext-install -j$(nproc) --ini-name 10-event.ini event && \
        apk del .ext-event-deps; \
    fi && \
    if test ${EXTRA_IGBINARY_ENABLE} = true; then \
        curl -sfL https://github.com/igbinary/igbinary/archive/refs/tags/${EXTRA_IGBINARY_VERSION}.tar.gz -o /tmp/igbinary.tar.gz && \
        mkdir /usr/src/php/ext/igbinary && tar xfz /tmp/igbinary.tar.gz --strip-components=1 -C /usr/src/php/ext/igbinary && \
        docker-php-ext-configure igbinary && \
        docker-php-ext-install -j$(nproc) --ini-name 10-igbinary.ini igbinary ; \
    fi && \
    if test ${EXTRA_IMAGICK_ENABLE} = true; then \
        curl -sfL https://github.com/Imagick/imagick/archive/refs/tags/${EXTRA_IMAGICK_VERSION}.tar.gz -o /tmp/imagick.tar.gz && \
        mkdir /usr/src/php/ext/imagick && tar xfz /tmp/imagick.tar.gz --strip-components=1 -C /usr/src/php/ext/imagick && \
        apk add --no-cache imagemagick && \
        apk add --no-cache --virtual .ext-imagick-deps imagemagick-dev && \
        docker-php-ext-configure imagick && \
        docker-php-ext-install -j$(nproc) --ini-name 10-imagick.ini imagick && \
        apk del .ext-imagick-deps; \
    fi && \
    if test ${EXTRA_INOTIFY_ENABLE} = true; then \
        curl -sfL https://github.com/arnaud-lb/php-inotify/archive/refs/tags/${EXTRA_INOTIFY_VERSION}.tar.gz -o /tmp/inotify.tar.gz && \
        mkdir /usr/src/php/ext/inotify && tar xfz /tmp/inotify.tar.gz --strip-components=1 -C /usr/src/php/ext/inotify && \
        docker-php-ext-configure inotify && \
        docker-php-ext-install -j$(nproc) --ini-name 10-inotify.ini inotify ; \
    fi && \
    if test ${EXTRA_LZF_ENABLE} = true; then \
        curl -sfL https://github.com/php/pecl-file_formats-lzf/archive/refs/tags/LZF-${EXTRA_LZF_VERSION}.tar.gz -o /tmp/lzf.tar.gz && \
        mkdir /usr/src/php/ext/lzf && tar xfz /tmp/lzf.tar.gz --strip-components=1 -C /usr/src/php/ext/lzf && \
        apk add --no-cache liblzf && \
        apk add --no-cache --virtual .ext-liblzf-deps liblzf-dev && \
        docker-php-ext-configure lzf && \
        docker-php-ext-install -j$(nproc) --ini-name 10-lzf.ini lzf && \
        apk del .ext-liblzf-deps; \
    fi && \
    if test ${EXTRA_MONGODB_ENABLE} = true; then \
        git clone -q -b ${EXTRA_MONGODB_VERSION} --depth 1 https://github.com/mongodb/mongo-php-driver.git /usr/src/php/ext/mongodb && \
        cd /usr/src/php/ext/mongodb && git submodule update --init && \
        apk add --no-cache snappy icu-libs libsasl libcrypto1.1 zstd-libs && \
        apk add --no-cache --virtual .ext-mongodb-deps openssl-dev icu-dev snappy-dev zstd-dev cyrus-sasl-dev && \
        docker-php-ext-configure mongodb && \
        docker-php-ext-install -j$(nproc) --ini-name 10-mongodb.ini mongodb ; \
        apk del .ext-mongodb-deps; \
    fi && \
    if test ${EXTRA_MSGPACK_ENABLE} = true; then \
        curl -sfL https://github.com/msgpack/msgpack-php/archive/refs/tags/msgpack-${EXTRA_MSGPACK_VERSION}.tar.gz -o /tmp/msgpack.tar.gz && \
        mkdir /usr/src/php/ext/msgpack && tar xfz /tmp/msgpack.tar.gz --strip-components=1 -C /usr/src/php/ext/msgpack && \
        docker-php-ext-configure msgpack && \
        docker-php-ext-install -j$(nproc) --ini-name 10-msgpack.ini msgpack; \
    fi && \
    if test ${EXTRA_MCRYPT_ENABLE} = true; then \
        curl -sfL https://github.com/php/pecl-encryption-mcrypt/archive/refs/tags/${EXTRA_MCRYPT_VERSION}.tar.gz -o /tmp/mcrypt.tar.gz && \
        mkdir /usr/src/php/ext/mcrypt && tar xfz /tmp/mcrypt.tar.gz --strip-components=1 -C /usr/src/php/ext/mcrypt && \
        apk add --no-cache libmcrypt && \
        apk add --no-cache --virtual .ext-mcrypt-deps libmcrypt-dev && \
        docker-php-ext-configure mcrypt && \
        docker-php-ext-install -j$(nproc) --ini-name 10-mcrypt.ini mcrypt && \
        apk del .ext-mcrypt-deps; \
    fi && \
    if test ${EXTRA_PROTOBUF_ENABLE} = true; then \
        # protobuf v3.19 以下不支持 8.1
        if test ${PHP_MAJOR} != "8.1"; then \
            curl -sfL https://github.com/protocolbuffers/protobuf/releases/download/v${EXTRA_PROTOBUF_VERSION}/protobuf-php-${EXTRA_PROTOBUF_VERSION}.tar.gz -o /tmp/protobuf.tar.gz && \
            mkdir /tmp/protobuf && tar xfz /tmp/protobuf.tar.gz --strip-components=1 -C /tmp/protobuf && \
            mv /tmp/protobuf/php/ext/google/protobuf /usr/src/php/ext/ && \
            apk add --no-cache protoc && \
            docker-php-ext-configure protobuf && \
            docker-php-ext-install -j$(nproc) --ini-name 10-protobuf.ini protobuf ; \
        fi; \
    fi && \
    if test ${EXTRA_PSR_ENABLE} = true; then \
        curl -sfL https://github.com/jbboehr/php-psr/archive/refs/tags/v${EXTRA_PSR_VERSION}.tar.gz -o /tmp/psr.tar.gz && \
        mkdir /usr/src/php/ext/psr && tar xfz /tmp/psr.tar.gz --strip-components=1 -C /usr/src/php/ext/psr && \
        docker-php-ext-configure psr && \
        docker-php-ext-install -j$(nproc) --ini-name 10-psr.ini psr ; \
    fi && \
    if test ${EXTRA_LZ4_ENABLE} = true; then \
        curl -sfL https://github.com/kjdev/php-ext-lz4/archive/refs/tags/${EXTRA_LZ4_VERSION}.tar.gz -o /tmp/lz4.tar.gz && \
        mkdir /usr/src/php/ext/lz4 && tar xfz /tmp/lz4.tar.gz --strip-components=1 -C /usr/src/php/ext/lz4 && \
        apk add --no-cache lz4-libs && \
        apk add --no-cache --virtual .ext-lz4-deps lz4-dev && \
        docker-php-ext-configure lz4 --with-lz4-includedir=/usr && \
        docker-php-ext-install -j$(nproc) --ini-name 10-lz4.ini lz4 && \
        apk del .ext-lz4-deps; \
    fi && \
    if test ${EXTRA_REDIS_ENABLE} = true; then \
        curl -sfL https://github.com/phpredis/phpredis/archive/refs/tags/${EXTRA_REDIS_VERSION}.tar.gz -o /tmp/redis.tar.gz && \
        mkdir /usr/src/php/ext/redis && tar xfz /tmp/redis.tar.gz --strip-components=1 -C /usr/src/php/ext/redis && \
        apk add --no-cache liblzf lz4-libs zstd-libs && \
        apk add --no-cache --virtual .ext-redis-deps liblzf-dev lz4-dev zstd-dev && \
        docker-php-ext-configure redis \
            --enable-redis-igbinary --enable-redis-msgpack \
            --enable-redis-lzf --with-liblzf=/usr --enable-redis-zstd --enable-redis-lz4 --with-liblz4=/usr && \
        docker-php-ext-install -j$(nproc) --ini-name 20-redis.ini redis && \
        apk del .ext-redis-deps; \
    fi && \
    # curl -sfL https://github.com/php/pecl-networking-uuid/archive/refs/tags/uuid-${UUID}.tar.gz -o /tmp/uuid.tar.gz && \
    # mkdir /usr/src/php/ext/uuid && tar xfz /tmp/uuid.tar.gz --strip-components=1 -C /usr/src/php/ext/uuid && \
    # docker-php-ext-configure uuid && \
    # docker-php-ext-install -j$(nproc) --ini-name 10_uuid.ini uuid && \
    # # yaml
    # curl -sfL https://github.com/php/pecl-file_formats-yaml/archive/refs/tags/${YAML}.tar.gz -o /tmp/yaml.tar.gz && \
    # mkdir /usr/src/php/ext/yaml && tar xfz /tmp/yaml.tar.gz --strip-components=1 -C /usr/src/php/ext/yaml && \
    # docker-php-ext-configure yaml && \
    # docker-php-ext-install -j$(nproc) --ini-name 10_yaml.ini yaml && \
    # # csv
    # curl -sfL https://gitlab.com/Girgias/csv-php-extension/-/archive/${CSV}/csv-php-extension-${CSV}.tar.gz -o /tmp/csv.tar.gz && \
    # mkdir /usr/src/php/ext/csv && tar xfz /tmp/csv.tar.gz --strip-components=1 -C /usr/src/php/ext/csv && \
    # docker-php-ext-configure csv && \
    # docker-php-ext-install -j$(nproc) --ini-name 10_csv.ini csv && \
    # # zephir-parser
    # curl -sfL https://github.com/zephir-lang/php-zephir-parser/archive/refs/tags/v${ZEPHIR}.tar.gz -o /tmp/zephir.tar.gz && \
    # mkdir /usr/src/php/ext/zephir && tar xfz /tmp/zephir.tar.gz --strip-components=1 -C /usr/src/php/ext/zephir && \
    # docker-php-ext-configure zephir && \
    # docker-php-ext-install -j$(nproc) --ini-name 90_zephir.ini zephir && \
    # # snappy
    # curl -sfL https://github.com/kjdev/php-ext-snappy/archive/refs/tags/0.2.1.tar.gz -o /tmp/snappy.tar.gz && \
    # mkdir /usr/src/php/ext/snappy && tar xfz /tmp/snappy.tar.gz --strip-components=1 -C /usr/src/php/ext/snappy && \
    # docker-php-ext-configure snappy --with-snappy-includedir=/usr && \
    # docker-php-ext-install -j$(nproc) --ini-name 10_snappy.ini snappy && \
    # 清理构建过程临时文件
    docker-php-source delete && apk del .build-deps && rm -rf /tmp/* && \
    # 链接常用路径
    ln -s /usr/local/bin/php /usr/bin/ && \
    ln -s /usr/local/etc/php /etc/ && \
    ln -s /usr/local/etc/php-fpm.d /etc/

WORKDIR /usr/src/php/ext
