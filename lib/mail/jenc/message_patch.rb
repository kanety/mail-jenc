# frozen_string_literal: true

module Mail
  module Jenc
    module MessagePatch
      def body=(value)
        if Jenc.enabled?
          if value.is_a?(String) && !value.ascii_only? && value.encoding == Encoding::UTF_8 && charset && charset.downcase != 'utf-8' && @transport_encoding.to_s != '8bit'
            value = Mail::Encodings.transcode_charset(value, value.encoding, charset)
            value.force_encoding('us-ascii') if @transport_encoding.to_s == '7bit' && charset.downcase == 'iso-2022-jp'
            value = @transport_encoding.encode(value)
          end
        end
        super
      end

      def add_file(values)
        if Jenc.enabled?
          if values.is_a?(Hash)
            values[:charset] ||= nil
            values[:header_charset] = header.charset if header.charset
          end
        end
        super
      end

      def convert_to_multipart
        unless has_content_type?
          content_type = 'text/plain'
          content_type += "; charset=#{charset}" if charset
          self.content_type = content_type
        end
        super
      end
    end
  end
end

Mail::Message.prepend Mail::Jenc::MessagePatch
