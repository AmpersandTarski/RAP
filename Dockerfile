# This script is meant to build from the root directory of your RAP-repo.
FROM ampersandtarski/ampersand-prototype:texlive

ENV AMPERSAND_DB_HOST=db

# link to the current directory to get application sources
RUN mkdir /src
ADD ./RAP3 /src
RUN mkdir /SIAM
ADD ./SIAM /SIAM
RUN mkdir /Sequences
ADD ./Sequences /Sequences

# build RAP3 application from folder
RUN ampersand /src/RAP3dev.adl --config=/src/RAP3dev.yaml -p/var/www/html/RAP3 \
 && mkdir -p /var/www/html/RAP3/log \
 && chown -R www-data:www-data /var/www/html/RAP3

VOLUME /var/www/html/RAP3

# build Enrollment demo, which is being used in the Ampersand-tutorial
#RUN ampersand -p/var/www/html/Enroll /src/RAP/Demos/Enroll/Enrollment.adl --verbose \
# && mkdir -p /var/www/html/Enroll/log \
# && chown -R www-data:www-data /var/www/html/Enroll
