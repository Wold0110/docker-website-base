FROM ubuntu/apache2
LABEL maintainer="walter20020110@gmail.com"

#apache root dir
ENV WEB=/var/www/html 
ENV TZ=Europe/Budapest

#update and install php and addon
RUN apt update && apt upgrade -y
RUN apt install php php-mysqli -y
WORKDIR $WEB
RUN ["mv","index.html","apache.html"]