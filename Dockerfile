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

# build release
COPY . .
RUN mix release prod

# prepare release image
FROM alpine:3
RUN apk add --update bash openssl

RUN mkdir /app && chown -R nobody: /app
WORKDIR /app
USER nobody

COPY --from=build _build/prod/rel/derivico ./

ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=8000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

ENTRYPOINT ["/app/bin/derivico"]