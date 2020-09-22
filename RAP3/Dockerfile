# This script is meant to build from the root directory of your RAP-repo.
# Ampersand compiler is also needed for RAP3 to compile student scripts

FROM ampersandtarski/prototype-framework:v1.7.0

COPY . /usr/local/project/

# Generate prototype application from folder
RUN ampersand proto /usr/local/project/RAP3.adl \
  --proto-dir /var/www \
  --build-recipe RAP \
  --verbose

# Copy customizations into generated application
COPY customizations /var/www/

RUN chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics \
  && cd /var/www \
  && composer install --prefer-dist --no-dev --profile --optimize-autoloader \
  && npm install \
  && gulp build-ampersand \
  && gulp build-project
