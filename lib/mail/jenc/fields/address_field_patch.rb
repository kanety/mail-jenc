# frozen_string_literal: true

module Mail
  module Jenc
    module CommonAddressFieldPatch
      def initialize(value, charset = nil)
        if Jenc.enabled?
          if value.is_a?(String) && !value.ascii_only? && value.encoding == Encoding::UTF_8 && charset && charset.downcase != 'utf-8'
            list = Mail::AddressList.new(value)
            list.addresses.each do |addr|
              if addr.display_name && !addr.display_name.ascii_only?
                addr.display_name = BEncoder.encode(addr.display_name, charset)
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

klasses = ObjectSpace.each_object(Class).select { |klass| klass < Mail::CommonAddressField }
klasses.each do |klass|
  klass.prepend Mail::Jenc::CommonAddressFieldPatch
end
