FROM ubuntu/apache2
LABEL maintainer="walter20020110@gmail.com"

#apache root dir
ENV WEB=/var/www/html 
ENV TZ=Europe/Budapest

USER root
#basic php
	RUN apt install php php-mysqli -y
	
# Install prerequisites required for tools and extensions installed later on.
	RUN apt-get update \
		&& apt-get install -y apt-transport-https gnupg2 libpng-dev libzip-dev nano unzip \
		&& rm -rf /var/lib/apt/lists/*


# Install prerequisites for the sqlsrv and pdo_sqlsrv PHP extensions.
	RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
		&& curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
		&& apt-get update \
		&& apt-get install -y msodbcsql17 mssql-tools unixodbc-dev \
		&& rm -rf /var/lib/apt/lists/*
		
# Install required PHP extensions and all their prerequisites available via apt.
	RUN chmod uga+x /usr/bin/install-php-extensions \
		&& sync \
		&& install-php-extensions amqp bcmath ds exif gd intl opcache pcntl pcov pdo_sqlsrv redis sqlsrv zip

		

	WORKDIR $WEB

RUN ["mv","index.html","apache.html"]