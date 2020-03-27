FROM docker.pkg.github.com/ampersandtarski/prototype/prototype-framework:latest

COPY run-student-proto.sh /

RUN chmod +x /run-student-proto.sh

# RUN chown -R www-data:www-data /var/www/log /var/www/data /var/www/generics \
#  && cd /var/www \
#  # uncomment lines below if customizations are added to default prototype framework
#  # && composer install --prefer-dist --no-dev --optimize-autoloader --profile \
#  # && npm install \
#  # && gulp build-ampersand \
#  # && gulp build-project

ENTRYPOINT /run-student-proto.sh