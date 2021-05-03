FROM registry.symbiote.com.au/docker/php:7.1

RUN apt-get update && apt-get install -y \
    git

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME "/usr/local/composer" 
ENV COMPOSER_VERSION 2.0.13
ENV PATH "${COMPOSER_HOME}/vendor/bin:${PATH}"

RUN mkdir -p ${COMPOSER_HOME} \
    && curl --silent https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar --output /usr/bin/composer \
    && chmod +x /usr/bin/composer

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
