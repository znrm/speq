# Speq

## A tiny library to build specs with fewer words.

Speq aims to work well for rapid prototyping, learning, and anytime that writing specs would otherwise feel excessive.

Speq favors simplicity and minimalism, which may not always be compatible with rigorous testing. The existing TDD tools for Ruby are exceptional, and Speq is not a replacement.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'speq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install speq

## Usage

Speq excels at running many similar tests and checks. It omits explicit descriptions and outputs simple reports.

### A simple test

```ruby
does :prime? do
  given 0, 1, 8, match: false
  given 2, 3, 97, match: true
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake none` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [speq's public repo](https://github.com/znrm/speq).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
