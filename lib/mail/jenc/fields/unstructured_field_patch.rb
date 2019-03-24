module Mail
  module Jenc
    module UnstructuredFieldPatch
      def initialize(name, value, charset = nil)
        if Jenc.enabled?
          if value.is_a?(String) && value.encoding == Encoding::UTF_8 && charset && charset.downcase != 'utf-8'
            if !value.ascii_only?
              value = Mail::Encodings.b_value_encode(
                Mail::Encodings.transcode_charset(value, value.encoding, charset)
              )
            elsif value !~ Mail::Encodings::ENCODED_VALUE
              charset = 'us-ascii'
            end
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
