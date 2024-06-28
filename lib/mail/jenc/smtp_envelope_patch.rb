# frozen_string_literal: true

require 'mail/smtp_envelope'

module Mail
  module Jenc
    module SmtpEnvelopePatch
      def validate_addr(addr_name, addr)
        if Jenc.enabled?
          super(addr_name, addr.to_s)
          addr
        else
          super
        end
      end
    end
  end
end

Mail::SmtpEnvelope.prepend Mail::Jenc::SmtpEnvelopePatch
