FROM ampersandtarski/prototype-framework:v1.18.1

COPY . /usr/local/project/

# Generate prototype application from folder
RUN ampersand proto /usr/local/project/Klantkaart.adl \
  --proto-dir /var/www \
  --verbose

RUN chown -R www-data:www-data /var/www/ \
  && cd /var/www \
  # && composer install --prefer-dist --no-dev --profile \
  # && npm install \
  # && gulp build-ampersand \
  # && gulp build-project