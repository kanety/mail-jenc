# Mail::Jenc

A mail patch for encoding conventional mail.

## Dependencies

* ruby 2.5+
* mail 2.8

## Installation

Add to your application's Gemfile:

```ruby
gem 'mail-jenc'
```

Then run:

    $ bundle install

## Usage

Use mail as usual. You can enable/disable patched features as follows:

```ruby
# disable patch
Mail::Jenc.disable

# enable patch
Mail::Jenc.enable
```

## Contributing

Pull requests are welcome on GitHub at https://github.com/kanety/mail-jenc.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
