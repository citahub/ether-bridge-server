# frozen_string_literal: true

require "redis"
# require "redis-namespace"
require "redis/objects"

redis_config = Rails.application.config_for(:redis)

$redis = Redis.new(url: redis_config["url"], driver: :hiredis)
Redis::Objects.redis = $redis
