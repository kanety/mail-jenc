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

      def enabled?
        @@config.enabled
      end

      def enable!
        @@config.enabled = true
      end

      def disable!
        @@config.enabled = false
      end

      def configure
        yield @@config
      end

      def config
        @@config
      end

      def with_config(hash = {})
        Config.set_current(hash)
        yield
      ensure
        Config.unset_current
      end
    end
  end
end
