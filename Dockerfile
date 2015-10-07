FROM ubuntu:14.04
MAINTAINER Thomas Stevens <thomas.stevens89@icloud.com>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Install software
RUN apt-get install -y git vim curl wget build-essential software-properties-common python-software-properties\
						 pwgen python-setuptools supervisor
RUN add-apt-repository ppa:ondrej/php5
RUN add-apt-repository ppa:nginx/stable
RUN apt-get install -y nginx
RUN apt-get install -y --force-yes php5-cli php5-fpm php5-mysql php5-curl php5-mcrypt\
		       php5-gd php5-intl php5-tidy php5-imagick php5-mongo php-pear php5-dev make
RUN php5enmod mcrypt
RUN pecl install mongo && php5enmod mongo

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Environment helper tool
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.7/ep-linux && chmod +x /usr/local/bin/ep

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*