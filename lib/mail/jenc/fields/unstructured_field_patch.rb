# frozen_string_literal: true

module Mail
  module Jenc
    module UnstructuredFieldPatch
      def initialize(name, value, charset = nil)
        if Jenc.enabled?
          if value.is_a?(String) && value.encoding == Encoding::UTF_8 && charset && charset.downcase != 'utf-8'
            if !value.ascii_only?
              value = BEncoder.encode(value, charset)
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

Mail::UnstructuredField.prepend Mail::Jenc::UnstructuredFieldPatch
