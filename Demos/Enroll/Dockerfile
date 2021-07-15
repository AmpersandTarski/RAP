FROM ampersandtarski/prototype-framework:v1.8.5

COPY . /usr/local/project/

# Generate prototype application from folder
RUN ampersand proto /usr/local/project/Enrollment.adl \
  --proto-dir /var/www \
  --build-recipe Prototype \
  --verbose

RUN chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics \
  && cd /var/www
  # && composer install --prefer-dist --no-dev --profile \
  # && npm install \
  # && gulp build-ampersand \
  # && gulp build-project

# SJ:
# When the container starts, I want to inform the Apache server
# what the fully qualified domain name is.
# For example by:
#  echo $SERVER_HOST_NAME  >> /etc/apache2/apache2.conf
# However, I cannot get it done... :-(