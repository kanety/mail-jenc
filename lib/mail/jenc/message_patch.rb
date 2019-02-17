module Mail
  module Jenc
    module MessagePatch
      def body=(value)
        if Jenc.enabled?
          if value.is_a?(String) && !value.ascii_only? && charset && charset != 'utf-8' && @transport_encoding.to_s != '8bit'
            value = Mail::Encodings.transcode_charset(value, value.encoding, charset)
            value.force_encoding('us-ascii') if @transport_encoding.to_s == '7bit'
            value = @transport_encoding.encode(value)
          end
        end
        super
      end

      def add_file(values)
        if Jenc.enabled?
          if values.is_a?(Hash) && charset
            values[:header_charset] = charset
          end
        end
        super
      end
    end
  end
end

unless Mail::Message.included_modules.include?(Mail::Jenc::MessagePatch)
  Mail::Message.prepend Mail::Jenc::MessagePatch
end
