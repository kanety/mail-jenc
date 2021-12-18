module Mail
  module Jenc
    class RFC2231Encoder
      class << self
        def encode(name, charset, **options)
          encode_to_hash(name, charset, **options).map { |k, v| "#{k}=#{v}" }.join(";\r\n\s")
        end

        def encode_to_hash(name, charset, key: 'filename')
          hexes = PercentEncoder.encode_to_array(
            Mail::Encodings.transcode_charset(name, name.encoding, charset)
          )

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
