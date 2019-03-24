module Mail
  module Jenc
    module AttachmentsListPatch
      def []=(name, value)
        if Jenc.enabled?
          if name && !name.ascii_only? && name.encoding == Encoding::UTF_8 && value.is_a?(Hash) && (charset = value.delete(:header_charset))
            mime_type = set_mime_type(name)
            transcoded = Mail::Encodings.transcode_charset(name, name.encoding, charset)
            if value.key?(:rfc2231) ? value[:rfc2231] : Jenc.rfc2231
              encoded = RFC2231Encoder.encode(transcoded, charset: charset)
              value[:content_disposition] ||= %Q|#{@content_disposition_type}; #{encoded}|
              encoded = Mail::Encodings.b_value_encode(transcoded)
              value[:content_type] ||= %Q|#{mime_type}; name="#{encoded}"|
            else
              encoded = Mail::Encodings.b_value_encode(transcoded)
              value[:content_disposition] ||= %Q|#{@content_disposition_type}; filename="#{encoded}"|
              value[:content_type] ||= %Q|#{mime_type}; name="#{encoded}"|
            end
            value[:transfer_encoding] = 'binary'
          end
        end
        super
      end
    end
  end
end

unless Mail::AttachmentsList.included_modules.include?(Mail::Jenc::AttachmentsListPatch)
  Mail::AttachmentsList.prepend Mail::Jenc::AttachmentsListPatch
end
