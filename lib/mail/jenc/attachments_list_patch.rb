module Mail
  module Jenc
    module AttachmentsListPatch
      def []=(name, value)
        if Jenc.enabled? && value.is_a?(Hash)
          charset = value.delete(:header_charset)
          rfc2231 = value.key?(:rfc2231) ? value.delete(:rfc2231) : Jenc.rfc2231

          if name && !name.ascii_only? && name.encoding == Encoding::UTF_8 && charset
            mime_type = set_mime_type(name)
            if rfc2231
              encoded = RFC2231Encoder.encode(name, charset)
              value[:content_disposition] ||= %Q|#{@content_disposition_type}; #{encoded}|
              encoded = BEncoder.encode(name, charset)
              value[:content_type] ||= %Q|#{mime_type}; name="#{encoded}"|
            else
              encoded = BEncoder.encode(name, charset)
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
