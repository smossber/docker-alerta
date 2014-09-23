
FROM ubuntu:latest
MAINTAINER Nick Satterly <nick.satterly@theguardian.com>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git wget build-essential python python-setuptools python-pip python-dev nginx

RUN pip install alerta-server
RUN pip install gunicorn supervisor

RUN wget -q -O - https://github.com/alerta/angular-alerta-webui/tarball/master | tar zxf -
RUN mv alerta-angular-alerta-webui-*/app /app

ENV ALERTA_SVR_CONF_FILE /alertad.conf
ENV AUTH_REQUIRED False
ENV CLIENT_ID not-set
ENV REDIRECT_URL not-set
ENV ALLOWED_EMAIL_DOMAIN *

ADD config.js.sh /config.js.sh
ADD alertad.conf.sh /alertad.conf.sh
ADD nginx.conf /nginx.conf
ADD supervisord.conf /etc/supervisord.conf

EXPOSE 80
CMD /config.js.sh && /alertad.conf.sh && supervisord -n

