module Mail
  module Jenc
    module ContentTypeFieldPatch
      def parameters
        if Jenc.enabled?
          super.tap do |parameters|
            parameters.delete('charset') if parameters.key?('boundary') || parameters.key?('name')
          end
        else
          super
        end
      end
    end
  end
end

unless Mail::ContentTypeField.included_modules.include?(Mail::Jenc::ContentTypeFieldPatch)
  Mail::ContentTypeField.prepend Mail::Jenc::ContentTypeFieldPatch
end
