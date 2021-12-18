# simplecov
require 'simplecov'
SimpleCov.start

require 'mail/jenc'
require 'base64'

def encode(str, charset)
  Mail::Encodings.transcode_charset(str, str.encoding, charset)
end

def b_encode(str, charset)
  Mail::Jenc::BEncoder.encode(str, charset)
end

def url_encode(str, charset = nil)
  str = str.encode(charset) if charset
  Mail::Jenc::PercentEncoder.encode(str)
end
