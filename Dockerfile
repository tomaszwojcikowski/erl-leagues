# Dockerfile
FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config ./
RUN mix deps.get
RUN mix test

# build release
COPY . .
RUN mix release prod

# prepare release image
FROM alpine:3.9
RUN apk add --update bash openssl curl

RUN mkdir /app && chown -R nobody: /app
WORKDIR /app
USER nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/prod ./
COPY --from=build --chown=nobody:nobody /app/priv ./priv

ENV REPLACE_OS_VARS=true
ENV JSON_PORT=8000 PROTO_PORT=8001 BEAM_PORT=14000 ERL_EPMD_PORT=24000 DATA_FILE="/app/priv/Data.csv"
EXPOSE $JSON_PORT $PROTO_PORT $BEAM_PORT $ERL_EPMD_PORT

ENTRYPOINT ["/app/bin/prod", "start"]

HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:${JSON_PORT}/ping || exit 1