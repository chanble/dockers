FROM alpine

RUN set -eux; \
    mkdir /app;
COPY config.yaml.example /app/config.yaml
COPY shentu-linux-dev /app/shentu
COPY docker-entrypoint.sh /usr/local/bin/
WORKDIR /app
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
EXPOSE 9001
CMD [ "/app/shentu" ]