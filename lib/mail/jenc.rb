# frozen_string_literal: true

require 'mail'

Dir["#{__dir__}/jenc/**/*.rb"].each do |file|
  require file
end

module Mail
  module Jenc
    class << self
      @@config = Config.new(
        enabled: true,
        rfc2231: false,
        escape_sequence_charsets: ['iso-2022-jp'],
        preferred_charsets: {
          'iso-2022-jp' => 'cp50221',
          'shift_jis' => 'cp932'
        }
      )

      def configure
        yield @@config
      end

      THREAD_KEY = :_mail_jenc

      def config
        Thread.current[THREAD_KEY] || @@config
      end

      def with_config(hash = {})
        old = Thread.current[THREAD_KEY]
        Thread.current[THREAD_KEY] = Config.new(config.attributes.merge(hash))
        yield
      ensure
        Thread.current[THREAD_KEY] = old
      end

      def enabled?
        config.enabled
      end

      def enable!
        config.enabled = true
      end

      def disable!
        config.enabled = false
      end
    end
  end
end
