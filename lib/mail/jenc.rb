# frozen_string_literal: true

require 'mail'

Dir["#{__dir__}/jenc/**/*.rb"].each do |file|
  require file
end

module Mail
  module Jenc
    class << self
      attr_reader :enabled
      attr_accessor :rfc2231
      attr_accessor :escape_sequence_charsets
      attr_accessor :preferred_charsets

      def enabled?
        @@enabled
      end

      def enable
        @@enabled = true
      end

      def disable
        @@enabled = false
      end
    end

    self.enable
    self.rfc2231 = false
    self.escape_sequence_charsets = ['iso-2022-jp']
    self.preferred_charsets = {
      'iso-2022-jp' => 'cp50221',
      'shift_jis' => 'cp932'
    }
  end
end
