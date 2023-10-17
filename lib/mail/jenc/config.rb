# frozen_string_literal: true

module Mail
  module Jenc
    class Config
      NAMES = [:enabled, :rfc2231, :escape_sequence_charsets, :preferred_charsets]
      NAMES.each do |name|
        attr_accessor name
      end

      def initialize(attrs = {})
        attrs.each do |key, val|
          send("#{key}=", val)
        end
      end

      def attributes
        NAMES.each_with_object({}) do |name, hash|
          hash[name] = send(name)
        end
      end
    end
  end
end
