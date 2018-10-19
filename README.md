# Speq

## A tiny library to build specs with fewer words

Speq is TDD library for rapid prototyping in Ruby. It aims to work well anytime testing is desired but writing specs with existing tools may feel excessive.

Speq favors simplicity and minimalism, which may not always be compatible with rigorous testing. The existing TDD tools for Ruby are exceptional, and Speq is not a replacement.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'speq'
```

And then execute:

    bundle

Or install it yourself as:

    gem install speq

## Design

Speq's design choices are influenced by the competing motivations of having tests be as short and simple as possible while maintaining the flexibility to be as descriptive as needed.

Speq is loosely based on the given-when-then or arrange-act-assert testing pattern. Whereas one would typically need to make each step explicit, Speq tests focus on making it easy to simply assert the expected behavior with an implicit arrangement and action.

## Syntax

## Usage

### Wherever you want

```ruby
require 'speq'

Speq.test do
  # Tests here can access local variables.
  # Test results are printed to $stdout.
  # The method returns true if all tests pass, false otherwise.
end
```

### With dedicated spec files

Speq also offers a simple CLI that lets you run tests written in dedicated spec files.

Executing `bundle exec speq` will recursively search the working directory and run all files that end with `_speq.rb`.

To run individual files, specify a list of speq file prefixes. For example, to run tests that are within the files `example_speq.rb` and `sample_speq.rb`, simply execute:

    bundle exec speq example sample

Speq files are not expected to require `speq`, but they should require other files that may be needed to run the specs.

## Contributing

Bug reports and pull requests are welcome on [Speq's GitHub](https://github.com/znrm/speq).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
