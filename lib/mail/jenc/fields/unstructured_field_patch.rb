module Mail
  module Jenc
    module UnstructuredFieldPatch
      def initialize(name, value, charset = nil)
        if Jenc.enabled?
          if value.is_a?(String) && !value.ascii_only? && value.encoding == Encoding::UTF_8 && charset && charset != 'utf-8'
            value = Mail::Encodings.b_value_encode(
              Mail::Encodings.transcode_charset(value, value.encoding, charset)
            )
          elsif value.is_a?(String) && value.ascii_only?
            charset = 'us-ascii'
          end
        end
        super
      end
    end
  end
end

unless Mail::UnstructuredField.included_modules.include?(Mail::Jenc::UnstructuredFieldPatch)
  Mail::UnstructuredField.prepend Mail::Jenc::UnstructuredFieldPatch
end
