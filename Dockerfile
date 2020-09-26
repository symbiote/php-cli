FROM registry.symbiote.com.au/docker/php:latest

RUN apt-get update && apt-get install -y git

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME "/usr/local/composer" 
ENV COMPOSER_VERSION 1.8.0
ENV PATH "${COMPOSER_HOME}/vendor/bin:${PATH}"

RUN mkdir -p $COMPOSER_HOME \
	&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \ 
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \ 
  && php composer-setup.php --install-dir /usr/bin --filename=composer \ 
  && php -r "unlink('composer-setup.php');"

RUN composer global require phing/phing && chown -R www-data ${COMPOSER_HOME}

COPY sspak.phar /usr/local/bin/sspak

COPY memory.ini /usr/local/etc/php/conf.d/memory.ini

RUN mkdir -p /var/www/.ssh && \
    chmod 700 /var/www/.ssh && \
    ssh-keyscan github.com >> /var/www/.ssh/known_hosts && \
    ssh-keyscan bitbucket.org >> /var/www/.ssh/known_hosts && \
    ssh-keyscan gitlab.com >> /var/www/.ssh/known_hosts  && \
    ssh-keyscan gitlab.symbiote.com.au >> /var/www/.ssh/known_hosts  && \
    chown -R 1000:1000 /var/www/.ssh && \
    chmod 600 /var/www/.ssh/known_hosts

CMD ["/bin/bash"]
