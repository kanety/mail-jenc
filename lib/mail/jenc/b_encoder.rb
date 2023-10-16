# frozen_string_literal: true

module Mail
  module Jenc
    class BEncoder
      class << self
        def encode(str, charset)
          if Jenc.config.escape_sequence_charsets.include?(charset.to_s.downcase)
            split(str).map { |s| transcode_and_encode(s, charset) }.join(' ')
          else
            transcode_and_encode(str, charset)
          end
        end

        private

        def transcode_and_encode(str, charset)
          Mail::Encodings.b_value_encode(Mail::Encodings.transcode_charset(str, str.encoding, charset))
        end

        def split(str, max: 40)
          results = []
          work = ''
          str.chars.each do |char|
            if work.bytesize + char.bytesize >= max
              results << work
              work = ''
            end
            work += char
          end
          results << work unless work.empty?
          results
        end
      end
    end
  end
end
