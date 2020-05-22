FROM amberframework/amber:0.33.0

RUN apt update -q
RUN apt install -y --no-install-recommends imagemagick

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

RUN rm -rf /app/node_modules

CMD amber watch
