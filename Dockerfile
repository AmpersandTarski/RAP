# This script is meant to build from the root directory of your RAP-repo.
FROM ampersandtarski/ampersand-prototype:texlive

ENV AMPERSAND_DB_HOST=db

# link to the current directory to get application sources
RUN mkdir /src
ADD . /src
RUN mkdir /SIAM
ADD ./SIAM /SIAM
RUN mkdir /Sequences
ADD ./Sequences /Sequences

# stuff needed for gulp
RUN apt update \
 && apt install -y gnupg \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && npm i -g gulp-cli

# build RAP3 application from folder
RUN ampersand /src/RAP3/RAP3dev.adl --config=/src/RAP3/RAP3dev.yaml -p/var/www/html/RAP3 \
 && mkdir -p /var/www/html/RAP3/log \
 && chown -R www-data:www-data /var/www/html/RAP3 \
 && cd /var/www/html/RAP3 \
# && npm i gulp \
 && npm install \
 && gulp build-ampersand \
 && gulp build-project

VOLUME /var/www/html/RAP3

# build Enrollment demo, which is being used in the Ampersand-tutorial
RUN ampersand -p/var/www/html/Enroll /src/Demos/Enroll/Enrollment.adl --verbose \
 && mkdir -p /var/www/html/Enroll/log \
 && chown -R www-data:www-data /var/www/html/Enroll
