$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mail/jenc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mail-jenc"
  s.version     = Mail::Jenc::VERSION
  s.authors     = ["Yoshikazu Kaneta"]
  s.email       = ["kaneta@sitebridge.co.jp"]
  s.homepage    = "https://github.com/kanety/mail-jenc"
  s.summary     = "A mail patch for encoding conventional mail"
  s.description = "A mail patch for encoding conventional mail"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "mail", ">= 2.7.1", "< 2.8.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
end
