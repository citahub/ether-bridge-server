# EtherBridgeServer

[![Build Status](https://travis-ci.org/cryptape/ether-bridge-server.svg?branch=master)](https://travis-ci.org/cryptape/ether-bridge-server)

Ether Bridge DApp Server.

## Required Packages

- [postgresql](https://www.postgresql.org/) 9.4 and above
- [redis](https://redis.io/) 3.0.6 and above
- [secp256k1](https://github.com/bitcoin-core/secp256k1.git) see `.travis.yml` for install command

## Initialize Project

```shell
$ bundle
$ touch .env.local (overwrite `.env` config if you need in `.env.local`, such as DB_USERNAME, DB_PASSWORD)
$ rails db:setup (or rails db:create db:migrate db:seed)
```

## Run Project

```shell
# start server
$ rails s

# start loop tasks, run `rake -T` for more details
$ rails bg:start

# start background tasks
$ bundle exec sidekiq -C config/sidekiq.yml
```

## Deploy

We deploy it by [mina](https://github.com/mina-deploy/mina), you can use this too.

```shell
# replace `dev` with you environment
$ mina dev deploy
```
