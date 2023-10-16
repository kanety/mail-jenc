# frozen_string_literal: true

require 'mail'

Dir["#{__dir__}/jenc/**/*.rb"].each do |file|
  require file
end

module Mail
  module Jenc
    class << self
      @@enabled = true
      @@config = Config.new(
        rfc2231: false,
        escape_sequence_charsets: ['iso-2022-jp'],
        preferred_charsets: {
          'iso-2022-jp' => 'cp50221',
          'shift_jis' => 'cp932'
        }
      )

      def enabled?
        @@enabled
      end

      def enable!
        @@enabled = true
      end

      def disable!
        @@enabled = false
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
