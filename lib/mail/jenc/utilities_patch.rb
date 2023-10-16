# frozen_string_literal: true

module Mail
  module Jenc
    module UtilitiesPatch
      def transcode_charset(str, from_encoding, to_encoding = Encoding::UTF_8)
        if Jenc.enabled?
          coded = super(str, from_encoding, UtilitiesPatch.preferred_charset(to_encoding))
          coded.force_encoding(to_encoding)
        else
          super
        end
      end

      class << self
        def preferred_charset(charset)
          Jenc.config.preferred_charsets[charset.to_s.downcase] || charset
        end
      end
    end
  end
end

Mail::Utilities.singleton_class.prepend Mail::Jenc::UtilitiesPatch
