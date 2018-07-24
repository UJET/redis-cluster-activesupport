# Redis Elasticache stores for ActiveSupport [![Build Status](https://travis-ci.org/film42/redis-cluster-activesupport.svg?branch=master)](https://travis-ci.org/film42/redis-cluster-activesupport)

This gem is an extension to [redis-activesupport](https://github.com/redis-store/redis-activesupport) that adds support
for failover of an Elasticache Redis cluster. The project owes its existence to 
[redis-cluster-activesupport](https://github.com/film42/redis-cluster-activesupport) that I found in a discussion about 
handling the `LOADING Redis is loading the dataset in memory` which is a message you will see when a replica is promoted 
to primary.

## Usage

This gem is a small extension to `redis-activesupport`, so refer to their documentation for most configuration. Instead
of specifying `:redis_store` you must now specify `:redis_elasticache_store` to load this extension.

```ruby
module MyProject
  class Application < Rails::Application
    config.cache_store = :redis_elasticache_store, options
  end
end
```

Additionally, there's a new configuration option: `:ignored_command_errors`. This is useful if you're using a Redis
Elasticache with automatic failover which will cause a `Redis::CommandError` with a message indicating the cluster is 
in READONLY mode. This extension allows you to whitelist certain `ignored_command_errors` that would
normally be raised by `redis-activesupport`. By default this gem whitelists the following errors:

```ruby
DEFAULT_IGNORED_COMMAND_ERRORS = [
  "READONLY You can't write against a read only slave.",
  'LOADING Redis is loading the dataset in memory',
  'A write operation was issued to an ELASTICACHE slave node.'
]
```

* You get `LOADING Redis is loading the dataset in memory` when a replica becomes a primary.
* You get `READONLY You can't write against a read only slave.` if a failover has occured and you are talking to the new replica.
* You get `A write operation was issued to an ELASTICACHE slave node.` if you are using 
[redis-elasticache](https://github.com/craigmcnamara/redis-elasticache) to override the REAONLY error.

If you need additional errors added to the whitelist, you can do this through your own configuration or open a pull
request to add it to the default whitelist. NOTE: this list is turned into a `Set` to keep lookups fast, so feel free to
make this list as big as you need. Example:

```ruby
module MyProject
  class Application < Rails::Application
    config.cache_store = :redis_elasticache_store, {:ignored_command_errors => ["Uh oh", "Please, stop", "Fire emoji"]}
  end
end
```

With this change, your cache store will now silently fail if your Elasticache Redis experiences a failover event 
 which means you won't knock your rails apps offline.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "redis-elasticache-activesupport"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-elasticache-activesupport

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/UJET/redis-elasticache-activesupport.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
