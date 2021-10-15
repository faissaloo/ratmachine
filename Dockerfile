FROM amberframework/amber:0.36.0

#debug output
RUN crystal --version
RUN amber --version

#shoddy workaround for the crystal repository being missing which causes a hard error
RUN apt-get update -q || true
RUN apt-get install -y --no-install-recommends imagemagick

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

RUN rm -rf /app/node_modules

CMD amber watch --error-trace
