FROM composer AS composer


FROM  php:apache
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
LABEL maintainer="walter20020110@gmail.com"
LABEL mysql="MySQl with mysqli"
LABEL sqlsrv="MSSQl with sqlsrv"
LABEL rabbitmq="AMQP"

#ENV
ENV WEB=/var/www/html 
ENV TZ=Europe/Budapest

#update php and addons
ENV ACCEPT_EULA=Y
RUN apt-get update && apt-get install -y gnupg2 librabbitmq-dev libssh-dev zip unzip
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list 
RUN apt-get update 
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev 
RUN docker-php-ext-install mysqli bcmath sockets
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN pecl install amqp
RUN pecl install 
RUN composer require php-amqplib/php-amqplib
RUN composer install
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv mysqli amqp

WORKDIR $WEB