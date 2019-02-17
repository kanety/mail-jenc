# simplecov
require 'simplecov'
SimpleCov.start

require 'mail/jenc'
require 'base64'

def encode(str, charset)
  str.encode(charset)
end

def b_encode(str, charset = nil)
  str = str.encode(charset, undef: :replace, invalid: :replace) if charset
  Base64.encode64(str).chomp
end

def url_encode(str, charset = nil)
  str = str.encode(charset) if charset
  Mail::Jenc::PercentEncoder.encode(str)
end
