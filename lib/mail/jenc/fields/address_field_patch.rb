module Mail
  module Jenc
    module AddressFieldPatch
      def initialize(value, charset = nil)
        if Jenc.enabled?
          if value.is_a?(String) && !value.ascii_only? && value.encoding == Encoding::UTF_8 && charset && charset.downcase != 'utf-8'
            list = Mail::AddressList.new(value)
            list.addresses.each do |addr|
              if addr.display_name && !addr.display_name.ascii_only?
                addr.display_name = Mail::Encodings.b_value_encode(
                  Mail::Encodings.transcode_charset(addr.display_name, addr.display_name.encoding, charset)
                )
              end
            end
            value = list.addresses.map(&:encoded).join(', ')
          end
        end
        super
      end
    end
  end
end

klasses = ObjectSpace.each_object(Class).select { |klass| klass < Mail::CommonAddress }
klasses.each do |klass|
  unless klass.included_modules.include?(Mail::Jenc::AddressFieldPatch)
    klass.prepend Mail::Jenc::AddressFieldPatch
  end
end
