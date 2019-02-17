module Mail
  module Jenc
    module PercentEncoder
      class << self
        def encode(str)
          encode_to_array(str).join
        end

        def encode_to_array(str)
          str.unpack('H*').first.scan(/.{2}/).map { |hex| "%#{hex.upcase}" }
        end
      end
    end

    module RFC2231Encoder
      class << self
        def encode(name, options = {})
          encode_to_hash(name, options).map { |k, v| "#{k}=#{v}" }.join(";\r\n\s")
        end

        def encode_to_hash(name, key: 'filename', charset: 'utf-8')
          hexes = name.unpack('H*')[0].scan(/.{2}/).map { |hex| "%#{hex.upcase}" }

          first_hex_num = hex_num(charset.size + key.size + 3)
          if hexes.size <= first_hex_num
            params = { "#{key}*" => "#{charset.downcase}''#{hexes.join}" }
          else
            params = { "#{key}*0*" => "#{charset.downcase}''#{hexes.shift(first_hex_num).join}" }
            slices = hexes.each_slice(hex_num(key.size + 3))
            slices.each_with_index do |sliced, i|
              kc = "#{key}*#{i+1}*"
              params[kc] = sliced.join
            end
          end

          params
        end

        private

        def hex_num(size)
          ((80 - 4 - size).to_f / 3).to_i
        end
      end
    end
  end
end
