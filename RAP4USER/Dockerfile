FROM prototype:new_frontend

# RUN apt-get update \
#     && apt-get install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg-agent \
#     software-properties-common

#unzip is needed in .sh scripts later
RUN apt-get install -y unzip

COPY scripts /scripts

#WORKDIR /scripts
WORKDIR /var/www/frontend

ENTRYPOINT bash /scripts/run-student-prototype.sh