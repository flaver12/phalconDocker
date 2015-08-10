#author: Flavio Kleiber
#desc: Dockerfile for phalcon 2 with ubuntu 14.04

##############################
# ONLY USE THIS FOR DEV!!!!  #
##############################

#Wich OS and the maintainer of it
FROM ubuntu:latest
MAINTAINER Flavio Kleiber <flaverkleiber@yahoo.de>

#Install's all needed stuff for the image
#Like php, phalcon etc.
RUN \
    apt-get update && \
    apt-get install -y apache2 \
        php5-cli \
        php5-fpm \
        php5-mysql \
        php5-pgsql \
        php5-sqlite \
        php5-curl \
        php5-gd \
        php5-mcrypt \
        php5-redis \
        php5-dev \
        build-essential\
        libapache2-mod-php5 \
        vim

#Download the phalcon extension
RUN \
    apt-get install -y \
        libpcre3-dev \
        git && \
    mkdir       /phalcon && \
    git clone   https://github.com/phalcon/cphalcon.git /phalcon/ && \
    chmod +x    /phalcon/build/install

#Set new workdir
WORKDIR /phalcon/build

#Compile now phalcon source and ad it to the php extensions
RUN \
    ./install && \
    /bin/echo 'extension=phalcon.so' >/etc/php5/mods-available/phalcon.ini && \
    /usr/sbin/php5enmod phalcon

#Set modrewrite for pretty urls
RUN a2enmod rewrite
RUN sed -i "s/AllowOverride None/AllowOverride FileInfo/" /etc/apache2/apache2.conf

#Set write permissions for the log folder
RUN chmod -R  777 /var/www/html/

#Run now apache
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

# set workdir
WORKDIR /var/www/html
