# frozen_string_literal: true

module Mail
  module Jenc
    class Config
      CONFIGS = [:enabled, :rfc2231, :escape_sequence_charsets, :preferred_charsets]
      CONFIGS.each do |config|
        attr_accessor config
      end

      def initialize(config = {})
        config.each do |key, val|
          send("#{key}=", val)
        end
      end

      CONFIGS.each do |key|
        define_method key do
          if self.class.has_current?(key)
            self.class.get_current(key)
          else
            instance_variable_get("@#{key}")
          end
        end
      end

      class << self
        KEY = :_mail_jenc

        def has_current?(key)
          Thread.current[KEY] && Thread.current[KEY].key?(key)
        end

        def get_current(key)
          Thread.current[KEY][key]
        end

        def set_current(hash)
          Thread.current[KEY] = hash
        end

        def unset_current
          Thread.current[KEY] = nil
        end
      end
    end
  end
end
