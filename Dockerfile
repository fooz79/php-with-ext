FROM php:7.4.28-fpm-alpine3.15

ARG AMQP_VER=1.11.0
ARG APCU_VER=5.1.21
ARG BROTLI_VER=0.13.1
ARG CSV_VER=0.3.1
ARG EVENT_VER=3.0.6
ARG IGBINARY_VER=3.2.7
ARG IMAGICK_VER=3.7.0
ARG INOTIFY_VER=3.0.0
ARG LZ4_VER=0.4.3
ARG LZF_VER=1.7.0
ARG MCRYPT_VER=1.0.4
ARG MONGODB_VER=1.12.0
ARG MSGPACK_VER=2.1.2
ARG PROTOBUF_VER=3.19.4
ARG PSR_VER=1.2.0
ARG REDIS_VER=5.3.7
ARG SWOOLE_VER=4.8.7
ARG UUID_VER=1.2.0
ARG YAML_VER=2.2.2
ARG ZEPHIR_VER=1.5.0
ARG COMPOSER_VER=2.2.6

RUN \
    # 替换 apk 源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update --no-cache && apk upgrade --no-cache && apk add --no-cache \
        argon2-libs \
        brotli-libs \
        c-client \
        curl \
        gdbm \
        gettext-libs \
        icu-libs \
        imagemagick \
        imagemagick-libs \
        libbz2 \
        libedit \
        libevent \
        libffi \
        libgcrypt \
        libgd \
        libgomp \
        libgpg-error \
        libldap \
        liblzf \
        libmcrypt \
        libpq \
        libsasl \
        libstdc++ \
        libxml2 \
        libxslt \
        libzip \
        lz4-libs \
        net-snmp-libs \
        pcre \
        pcre2 \
        protoc \
        rabbitmq-c \
        snappy \
        tidyhtml-libs \
        xz-libs \
        yaml \
        zstd-libs && \
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
        git \
        icu-dev \
        imagemagick-dev \
        imap-dev \
        libedit-dev \
        libffi-dev \
        libgcrypt-dev \
        liblzf-dev \
        libmcrypt-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        lz4-dev \
        mysql-dev \
        net-snmp-dev \
        openldap-dev \
        pcre-dev \
        pcre2-dev \
        rabbitmq-c-dev \
        snappy-dev \
        tidyhtml-dev \
        tzdata \
        yaml-dev \
        zlib-dev && \
    # 安装 PHP 扩展
    docker-php-source extract && \
    docker-php-ext-install -j$(nproc) --ini-name 00_bcmath.ini bcmath && \
    docker-php-ext-install -j$(nproc) --ini-name 00_bz2.ini bz2 && \
    docker-php-ext-install -j$(nproc) --ini-name 00_calendar.ini calendar && \
    docker-php-ext-install -j$(nproc) --ini-name 00_exif.ini exif && \
    docker-php-ext-install -j$(nproc) --ini-name 00_ffi.ini ffi && \
    docker-php-ext-install -j$(nproc) --ini-name 00_gd.ini gd && \
    docker-php-ext-install -j$(nproc) --ini-name 00_gettext.ini gettext && \
    docker-php-ext-install -j$(nproc) --ini-name 00_iconv.ini iconv && \
    docker-php-ext-install -j$(nproc) --ini-name 00_imap.ini imap && \
    docker-php-ext-install -j$(nproc) --ini-name 00_intl.ini intl && \
    docker-php-ext-install -j$(nproc) --ini-name 00_ldap.ini ldap && \
    docker-php-ext-install -j$(nproc) --ini-name 00_mysqli.ini mysqli && \
    docker-php-ext-install -j$(nproc) --ini-name 00_pcntl.ini pcntl && \
    docker-php-ext-install -j$(nproc) --ini-name 00_pdo.ini pdo && \
    docker-php-ext-install -j$(nproc) --ini-name 00_pgsql.ini pgsql && \
    docker-php-ext-install -j$(nproc) --ini-name 00_shmop.ini shmop && \
    docker-php-ext-install -j$(nproc) --ini-name 00_snmp.ini snmp && \
    docker-php-ext-install -j$(nproc) --ini-name 00_soap.ini soap && \
    docker-php-ext-install -j$(nproc) --ini-name 00_sockets.ini sockets && \
    docker-php-ext-install -j$(nproc) --ini-name 00_sysvmsg.ini sysvmsg && \
    docker-php-ext-install -j$(nproc) --ini-name 00_sysvsem.ini sysvsem && \
    docker-php-ext-install -j$(nproc) --ini-name 00_sysvshm.ini sysvshm && \
    docker-php-ext-install -j$(nproc) --ini-name 00_tidy.ini tidy && \
    docker-php-ext-install -j$(nproc) --ini-name 00_xmlrpc.ini xmlrpc && \
    docker-php-ext-install -j$(nproc) --ini-name 00_xsl.ini xsl && \
    docker-php-ext-install -j$(nproc) --ini-name 00_zip.ini zip && \
    docker-php-ext-install -j$(nproc) --ini-name 01_pdo_mysql.ini pdo_mysql && \
    docker-php-ext-install -j$(nproc) --ini-name 01_pdo_pgsql.ini pdo_pgsql && \
    docker-php-ext-install -j$(nproc) --ini-name 05_phar.ini phar && \
    # brotli
    curl -sfL https://github.com/kjdev/php-ext-brotli/archive/refs/tags/${BROTLI_VER}.tar.gz -o /tmp/brotli.tar.gz && \
    mkdir /usr/src/php/ext/brotli && tar xfz /tmp/brotli.tar.gz --strip-components=1 -C /usr/src/php/ext/brotli && \
    docker-php-ext-configure brotli \
        --with-libbrotli && \
    docker-php-ext-install -j$(nproc) --ini-name 50_brotli.ini brotli && \
    # swoole
    curl -sfL https://github.com/swoole/swoole-src/archive/v${SWOOLE_VER}.tar.gz -o /tmp/swoole.tar.gz && \
    mkdir /usr/src/php/ext/swoole && tar xfz /tmp/swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole && \
    docker-php-ext-configure swoole \
        --enable-sockets --enable-openssl --enable-http2 --enable-mysqlnd --enable-swoole-json --enable-swoole-curl && \
    docker-php-ext-install -j$(nproc) --ini-name 60_swoole.ini swoole && \
    # amqp
    curl -sfL https://github.com/php-amqp/php-amqp/archive/refs/tags/v${AMQP_VER}.tar.gz -o /tmp/amqp.tar.gz && \
    mkdir /usr/src/php/ext/amqp && tar xfz /tmp/amqp.tar.gz --strip-components=1 -C /usr/src/php/ext/amqp && \
    docker-php-ext-configure amqp && \
    docker-php-ext-install -j$(nproc) --ini-name 40_amqp.ini amqp && \
    # apcu
    curl -sfL https://github.com/krakjoe/apcu/archive/refs/tags/v${APCU_VER}.tar.gz -o /tmp/apcu.tar.gz && \
    mkdir /usr/src/php/ext/apcu && tar xfz /tmp/apcu.tar.gz --strip-components=1 -C /usr/src/php/ext/apcu && \
    docker-php-ext-configure apcu --enable-apcu-spinlocks && \
    docker-php-ext-install -j$(nproc) --ini-name 10_apcu.ini apcu && \
    # event
    git clone -q -b ${EVENT_VER} --depth 1 https://bitbucket.org/osmanov/pecl-event.git /usr/src/php/ext/event && \
    docker-php-ext-configure event --with-event-core --with-event-extra --with-event-openssl --enable-event-sockets && \
    docker-php-ext-install -j$(nproc) --ini-name 20_event.ini event && \
    # igbinary
    curl -sfL https://github.com/igbinary/igbinary/archive/refs/tags/${IGBINARY_VER}.tar.gz -o /tmp/igbinary.tar.gz && \
    mkdir /usr/src/php/ext/igbinary && tar xfz /tmp/igbinary.tar.gz --strip-components=1 -C /usr/src/php/ext/igbinary && \
    docker-php-ext-configure igbinary && \
    docker-php-ext-install -j$(nproc) --ini-name 10_igbinary.ini igbinary && \
    # imagick
    curl -sfL https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VER}.tar.gz -o /tmp/imagick.tar.gz && \
    mkdir /usr/src/php/ext/imagick && tar xfz /tmp/imagick.tar.gz --strip-components=1 -C /usr/src/php/ext/imagick && \
    docker-php-ext-configure imagick && \
    docker-php-ext-install -j$(nproc) --ini-name 40_imagick.ini imagick && \
    # inotify
    curl -sfL https://github.com/arnaud-lb/php-inotify/archive/refs/tags/${INOTIFY_VER}.tar.gz -o /tmp/inotify.tar.gz && \
    mkdir /usr/src/php/ext/inotify && tar xfz /tmp/inotify.tar.gz --strip-components=1 -C /usr/src/php/ext/inotify && \
    docker-php-ext-configure inotify && \
    docker-php-ext-install -j$(nproc) --ini-name 40_inotify.ini inotify && \
    # lzf
    curl -sfL https://github.com/php/pecl-file_formats-lzf/archive/refs/tags/LZF-${LZF_VER}.tar.gz -o /tmp/lzf.tar.gz && \
    mkdir /usr/src/php/ext/lzf && tar xfz /tmp/lzf.tar.gz --strip-components=1 -C /usr/src/php/ext/lzf && \
    docker-php-ext-configure lzf && \
    docker-php-ext-install -j$(nproc) --ini-name 50_lzf.ini lzf && \
    # mongodb
    git clone -q -b ${MONGODB_VER} --depth 1 https://github.com/mongodb/mongo-php-driver.git /usr/src/php/ext/mongodb && \
    cd /usr/src/php/ext/mongodb && git submodule update --init && \
    docker-php-ext-configure mongodb && \
    docker-php-ext-install -j$(nproc) --ini-name 40_mongodb.ini mongodb && \
    # msgpack
    curl -sfL https://github.com/msgpack/msgpack-php/archive/refs/tags/msgpack-${MSGPACK_VER}.tar.gz -o /tmp/msgpack.tar.gz && \
    mkdir /usr/src/php/ext/msgpack && tar xfz /tmp/msgpack.tar.gz --strip-components=1 -C /usr/src/php/ext/msgpack && \
    docker-php-ext-configure msgpack && \
    docker-php-ext-install -j$(nproc) --ini-name 10_msgpack.ini msgpack && \
    # mcrypt
    curl -sfL https://github.com/php/pecl-encryption-mcrypt/archive/refs/tags/${MCRYPT_VER}.tar.gz -o /tmp/mcrypt.tar.gz && \
    mkdir /usr/src/php/ext/mcrypt && tar xfz /tmp/mcrypt.tar.gz --strip-components=1 -C /usr/src/php/ext/mcrypt && \
    docker-php-ext-configure mcrypt && \
    docker-php-ext-install -j$(nproc) --ini-name 10_mcrypt.ini mcrypt && \
    # protobuf
    curl -sfL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VER}/protobuf-php-${PROTOBUF_VER}.tar.gz -o /tmp/protobuf.tar.gz && \
    mkdir /tmp/protobuf && tar xfz /tmp/protobuf.tar.gz --strip-components=1 -C /tmp/protobuf && \
    mv /tmp/protobuf/php/ext/google/protobuf /usr/src/php/ext/ && \
    docker-php-ext-configure protobuf && \
    docker-php-ext-install -j$(nproc) --ini-name 10_protobuf.ini protobuf && \
    # psr
    curl -sfL https://github.com/jbboehr/php-psr/archive/refs/tags/v${PSR_VER}.tar.gz -o /tmp/psr.tar.gz && \
    mkdir /usr/src/php/ext/psr && tar xfz /tmp/psr.tar.gz --strip-components=1 -C /usr/src/php/ext/psr && \
    docker-php-ext-configure psr && \
    docker-php-ext-install -j$(nproc) --ini-name 10_psr.ini psr && \
    # lz4
    curl -sfL https://github.com/kjdev/php-ext-lz4/archive/refs/tags/${LZ4_VER}.tar.gz -o /tmp/lz4.tar.gz && \
    mkdir /usr/src/php/ext/lz4 && tar xfz /tmp/lz4.tar.gz --strip-components=1 -C /usr/src/php/ext/lz4 && \
    docker-php-ext-configure lz4 --with-lz4-includedir=/usr && \
    docker-php-ext-install -j$(nproc) --ini-name 10_lz4.ini lz4 && \
    # redis
    curl -sfL https://github.com/phpredis/phpredis/archive/refs/tags/${REDIS_VER}.tar.gz -o /tmp/redis.tar.gz && \
    mkdir /usr/src/php/ext/redis && tar xfz /tmp/redis.tar.gz --strip-components=1 -C /usr/src/php/ext/redis && \
    docker-php-ext-configure redis \
        --enable-redis-igbinary --enable-redis-msgpack \
        --enable-redis-lzf --with-liblzf=/usr --enable-redis-zstd --enable-redis-lz4 --with-liblz4=/usr && \
    docker-php-ext-install -j$(nproc) --ini-name 40_redis.ini redis && \
    # uuid
    curl -sfL https://github.com/php/pecl-networking-uuid/archive/refs/tags/uuid-${UUID_VER}.tar.gz -o /tmp/uuid.tar.gz && \
    mkdir /usr/src/php/ext/uuid && tar xfz /tmp/uuid.tar.gz --strip-components=1 -C /usr/src/php/ext/uuid && \
    docker-php-ext-configure uuid && \
    docker-php-ext-install -j$(nproc) --ini-name 10_uuid.ini uuid && \
    # yaml
    curl -sfL https://github.com/php/pecl-file_formats-yaml/archive/refs/tags/${YAML_VER}.tar.gz -o /tmp/yaml.tar.gz && \
    mkdir /usr/src/php/ext/yaml && tar xfz /tmp/yaml.tar.gz --strip-components=1 -C /usr/src/php/ext/yaml && \
    docker-php-ext-configure yaml && \
    docker-php-ext-install -j$(nproc) --ini-name 10_yaml.ini yaml && \
    # csv
    curl -sfL https://gitlab.com/Girgias/csv-php-extension/-/archive/${CSV_VER}/csv-php-extension-${CSV_VER}.tar.gz -o /tmp/csv.tar.gz && \
    mkdir /usr/src/php/ext/csv && tar xfz /tmp/csv.tar.gz --strip-components=1 -C /usr/src/php/ext/csv && \
    docker-php-ext-configure csv && \
    docker-php-ext-install -j$(nproc) --ini-name 10_csv.ini csv && \
    # zephir-parser
    curl -sfL https://github.com/zephir-lang/php-zephir-parser/archive/refs/tags/v${ZEPHIR_VER}.tar.gz -o /tmp/zephir.tar.gz && \
    mkdir /usr/src/php/ext/zephir && tar xfz /tmp/zephir.tar.gz --strip-components=1 -C /usr/src/php/ext/zephir && \
    docker-php-ext-configure zephir && \
    docker-php-ext-install -j$(nproc) --ini-name 90_zephir.ini zephir && \
    # snappy
    curl -sfL https://github.com/kjdev/php-ext-snappy/archive/refs/tags/0.2.1.tar.gz -o /tmp/snappy.tar.gz && \
    mkdir /usr/src/php/ext/snappy && tar xfz /tmp/snappy.tar.gz --strip-components=1 -C /usr/src/php/ext/snappy && \
    docker-php-ext-configure snappy --with-snappy-includedir=/usr && \
    docker-php-ext-install -j$(nproc) --ini-name 10_snappy.ini snappy && \
    # 启用已安装 PHP 扩展
    rm -f /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    docker-php-ext-enable --ini-name 00_sodium.ini sodium && \
    docker-php-ext-enable --ini-name 00_opcache.ini opcache && \
    # 安装 OpenRC
    apk add --no-cache openrc bash vim && \
    # Disable getty's
    sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab && \
    # Change rc.conf
    sed -i \
        # Change subsystem type to "docker"
        -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
        # Allow all variables through
        -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
        # Start crashed services
        -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
        -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
        # Define extra dependencies for services
        -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
        /etc/rc.conf && \
    # Remove unnecessary services
    rm -f /etc/init.d/hwdrivers /etc/init.d/hwclock /etc/init.d/hwdrivers /etc/init.d/modules \
        /etc/init.d/modules-load /etc/init.d/modloop /etc/init.d/machine-id && \
    # Don't do cgroups
    sed -i 's/\tcgroup_add_service/\t#cgroup_add_service/g' /lib/rc/sh/openrc-run.sh && \
    sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh && \
    # 修改时区
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    # 修改 bash 环境配置
    echo "PS1='\033[1;33m\h \033[1;34m[\w] \033[1;35m\D{%D %T}\n\[\033[1;36m\]\u@\l \[\033[00m\]\$ '" > /root/.bashrc && \
    echo "alias ll='ls -l'" >> /root/.bashrc && \
    # 清理构建过程临时文件
    docker-php-source delete && apk del .build-deps && rm -rf /tmp/* && \
    # 链接常用路径
    ln -s /usr/local/bin/php /usr/bin/ && ln -s /usr/local/etc/php /etc/ && ln -s /usr/local/etc/php-fpm.d /etc/ && \
    # Composer
    curl -sfL https://getcomposer.org/download/${COMPOSER_VER}/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

CMD ["/sbin/init"]
