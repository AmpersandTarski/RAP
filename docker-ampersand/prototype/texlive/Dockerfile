# This Dockerfile can be used to generate prototype applications from Ampersand scripts.
# To generate functional specification documents use Dockerfile.fspec
FROM php:7-apache

ENV AMP_DEPS \
             curl \
             git \
             less \
             netbase \
             vim \
             wget \
             zlib1g-dev \
             graphviz \
             ghostscript

# install required php packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    $AMP_DEPS \
 && curl -sSL https://get.haskellstack.org/ | /bin/sh \
 && docker-php-ext-install mysqli \
 && a2enmod rewrite \
 # enable ZipArchive for importing .xlsx files on runtime
 && docker-php-ext-install zip \
 # install composer (php's package manager)
 && php  -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && php -r "unlink('composer-setup.php');" \
 && rm -rf /var/lib/apt/lists/*

ENV COMPOSER_HOME /usr/local/bin/

# install texlive from network
ENV PATH /texlive/bin/x86_64-linux:$PATH
ADD texlive.profile /tmp
RUN cd ~ \
 && curl http://ctan.mirrors.hoobly.com/systems/texlive/tlnet/install-tl-unx.tar.gz | tar -vxz \
 && cd install-tl* \
 && ./install-tl -profile /tmp/texlive.profile -repository http://ftp.uni-erlangen.de/mirrors/CTAN/systems/texlive/tlnet/ \
 && cd .. \
 && rm -rf install-tl* \
 && rm /tmp/texlive.profile

# clone git ampersand compiler repository
RUN mkdir ~/git \
 && cd ~/git \
 && git clone --depth=1 --branch development https://github.com/AmpersandTarski/Ampersand \
 && cd ~/git/Ampersand \
 && stack setup \
 && stack install --local-bin-path /usr/local/bin \
 && rm -rf ~/.stack ~/git/Ampersand/.stack-work
