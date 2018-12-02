FROM amberframework/amber:v0.9.0

RUN apt update -q
RUN apt install -y --no-install-recommends imagemagick

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

CMD amber watch
