require "redis-activesupport"
require "set"

module ActiveSupport
  module Cache
    class RedisElasticacheStore < RedisStore
      attr_reader :ignored_command_errors

      DEFAULT_IGNORED_COMMAND_ERRORS = [
        "READONLY You can't write against a read only slave.",
        'LOADING Redis is loading the dataset in memory',
        'A write operation was issued to an ELASTICACHE slave node.'
      ].freeze

      def initialize(*)
        super
        @ignored_command_errors = ::Set.new(
          @options.fetch(
            :ignored_command_errors,
            DEFAULT_IGNORED_COMMAND_ERRORS
          )
        )
      end

      def delete_entry(key, options)
        super
      rescue Redis::CommandError => error
        raise unless ignored_command_errors.include?(error.message)
        raise if raise_errors?
        false
      end

      def delete_matched(matcher, options = nil)
        super
      rescue Redis::CommandError => error
        raise unless ignored_command_errors.include?(error.message)
        raise if raise_errors?
        false
      end

      def fetch_multi(*names)
        super
      rescue Redis::CommandError => error
        raise unless ignored_command_errors.include?(error.message)
        raise if raise_errors?
        false
      end

      def increment(key, amount = 1, options = {})
        super
      rescue Redis::CommandError => error
        raise unless ignored_command_errors.include?(error.message)
        raise if raise_errors?
        false
      end

      def read_entry(key, options)
        super
      rescue Redis::CommandError => error
        raise unless ignored_command_errors.include?(error.message)
        raise if raise_errors?
        nil
      end

      def write_entry(key, entry, options)
        super
      rescue Redis::CommandError => error
        raise unless ignored_command_errors.include?(error.message)
        raise if raise_errors?
        false
      end

    end
  end
end
