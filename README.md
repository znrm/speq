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

### CLI

Executing the following command:

    $ bundle exec speq

will recursively search the working directory and run all files that end with `_speq.rb`.

To run individual files, specify a list of speq file prefixes. For example, to run tests that are within the files `example_speq.rb` and `sample_speq.rb`, simply execute:

    $ bundle exec speq example sample

Speq files are not expected to require `speq`, but they should require other files that may be needed to run the speqs.

### A simple test

Speq excels at running many similar tests and checks. It omits explicit descriptions and outputs simple reports.

```ruby
does :prime? do
  given 0, 1, 8, match: false
  given 2, 3, 97, match: true
end
```

## Contributing

Bug reports and pull requests are welcome on [Speq's GitHub](https://github.com/znrm/speq).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
