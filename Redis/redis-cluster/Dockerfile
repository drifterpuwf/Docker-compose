FROM  harbor.saloon-sit.supaur.tech/slzx-test/redis:4.0.0

COPY ./conf/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

EXPOSE 7000 7001 7002

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]

