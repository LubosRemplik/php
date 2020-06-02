FROM php:5.6-fpm-alpine

# GD & Imagick
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"

# Dependencies
RUN apk --no-cache --update add \
    icu-dev \
	libxml2-dev \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	autoconf \
	g++ \
	make \
	py-setuptools \
	imagemagick-dev \
	libtool \
	bash git openssh \
	bind-tools \
	zlib-dev libzip-dev

# Install supervisord
RUN easy_install-2.7 supervisor

# PHP extensions
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure gd \
	--with-gd \
	--with-freetype-dir=/usr/include/ \
	--with-png-dir=/usr/include/ \
	--with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-install json
RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install zip
RUN docker-php-ext-install pcntl
RUN pecl install imagick-3.4.3
RUN docker-php-ext-enable imagick
RUN docker-php-ext-install soap
RUN docker-php-ext-install calendar
RUN docker-php-ext-install exif

# Composer
COPY ./getcomposer.sh /root/getcomposer.sh
RUN chmod +x /root/getcomposer.sh && \
	sh /root/getcomposer.sh && \
	mv composer.phar /usr/local/bin/composer && \
	composer --version
RUN git config --global url."https://d558f9a98f1fe0f81eacf9370988b7b6480ac16c:@github.com/".insteadOf "https://github.com/"
