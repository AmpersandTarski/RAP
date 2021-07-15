FROM ampersandtarski/prototype-framework:v1.8.5

COPY --from=ampersandtarski/ampersand:local /bin/ampersand /usr/local/bin
RUN chmod +x /usr/local/bin/ampersand

COPY run-student-proto.sh /

COPY templates /templates

RUN chmod +x /run-student-proto.sh

# RUN chown -R www-data:www-data /var/www/log /var/www/data /var/www/generics \
#  && cd /var/www \
#  # uncomment lines below if customizations are added to default prototype framework
#  # && composer install --prefer-dist --no-dev --optimize-autoloader --profile \
#  # && npm install \
#  # && gulp build-ampersand \
#  # && gulp build-project

ENTRYPOINT bash /run-student-proto.sh