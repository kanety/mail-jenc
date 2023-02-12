# frozen_string_literal: true

module Mail
  module Jenc
    class PercentEncoder
      class << self
        def encode(str)
          encode_to_array(str).join
        end

        def encode_to_array(str)
          str.unpack('H*').first.scan(/.{2}/).map { |hex| "%#{hex.upcase}" }
        end
      end
    end
  end
end
