module Mail
  module Jenc
    module Ruby19Patch
      def transcode_charset(str, from_encoding, to_encoding = Encoding::UTF_8)
        if Jenc.enabled?
          coded = super(str, from_encoding, Ruby19Patch.preferred_charset(to_encoding))
          coded.force_encoding(to_encoding)
        else
          super
        end
      end

      class << self
        def preferred_charset(charset)
          Jenc.preferred_charsets[charset.to_s.downcase] || charset
        end
      end
    end
  end
end

unless Mail::Ruby19.singleton_class.included_modules.include?(Mail::Jenc::Ruby19Patch)
  Mail::Ruby19.singleton_class.prepend Mail::Jenc::Ruby19Patch
end
