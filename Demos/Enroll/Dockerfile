FROM ampersandtarski/prototype-framework:v1.7.0

COPY . /usr/local/project/

# Generate prototype application from folder
RUN ampersand proto /usr/local/project/Enrollment.adl \
  --proto-dir /var/www \
  --verbose

RUN chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics \
  && cd /var/www \
  # && composer install --prefer-dist --no-dev --profile \
  # && npm install \
  # && gulp build-ampersand \
  # && gulp build-project