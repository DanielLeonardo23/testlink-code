FROM php:7.4-apache

# Actualizar sistema base
RUN apt-get update && apt-get upgrade -y

# Instalar dependencias necesarias
RUN apt-get install -y \
  default-mysql-client \
  zlib1g-dev \
  libpng-dev \
  libjpeg-dev \
  libfreetype-dev \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Extensiones PHP necesarias para TestLink
RUN docker-php-ext-install mysqli pdo_mysql pgsql pdo_pgsql && \
    docker-php-ext-enable mysqli pdo_mysql pgsql pdo_pgsql && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Limpiar
RUN apt-get clean

# Configuración del entorno
WORKDIR /var/www/html

# Copiar código fuente
COPY . .
COPY ./docker/php.ini-production /usr/local/etc/php/conf.d/php.ini

# Permisos para Smarty (templates compilados)
RUN chown -R www-data:www-data /var/www/html/gui/templates_c
