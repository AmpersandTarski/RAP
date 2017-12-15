FROM ampersandtarski/ampersand-prototype:texlive

# build RAP3 application by cloning the models repository
RUN mkdir -p ~/git \
 && cd ~/git \
 && git clone --depth=1 --branch master https://github.com/AmpersandTarski/RAP \
# build RAP3 application
 && ampersand --atlas-without-expressions --meta-tables --add-semantic-metamodel -p/var/www/html/RAP3 ~/git/RAP/RAP3/RAP3.adl --verbose \
 && mkdir -p /var/www/html/RAP3/log \
 && chown -R www-data:www-data /var/www/html/RAP3

VOLUME /var/www/html/RAP3

# build Enrollment demo, which is being used in the Ampersand-tutorial
RUN ampersand -p/var/www/html/Enroll ~/git/RAP/Demos/Enroll/Enrollment.adl --verbose \
 && chown -R www-data:www-data /var/www/html/Enroll
