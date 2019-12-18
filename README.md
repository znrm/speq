# Speq

**Ready to use! Issue reports are welcome!**

## Build specs with fewer words

Speq is a testing library for rapid prototyping in Ruby.

Speq favors simplicity and minimalism.

```ruby
is([]).empty?
#  ✔ [] is empty.
```

Speq is ideal whenever it would feel excessive to use one of the existing frameworks, but it's not enough to just print & inspect outputs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'speq'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install speq
```

## Design & Syntax

Speq's design choices are guided by the competing motivations of having tests be as short and simple as possible while maintaining the flexibility to be as descriptive as needed. In contrast to similar tools, speqs are typically framed as _questions_ about a program's behavior rather than assertions about the desired behavior.

Descriptions for simple unit tests are often closely tied to the source code, and as such, Speq tries to eliminate them wherever possible. By breaking down an expression's method/message, arguments, and receiver, Speq can use the additional information to help generate an often sufficiently detailed description of the test.

- receiver: `on(object [, description])`
- message: `does(symbol [, description])`
- arguments: `with(*args , &block)` or `of(*args, &block)`
- question: `*?(*args, &block)`

Note that Speq executes expressions immediately, avoiding the unintuitive execution order of most testing libraries.

```ruby
speq('Example test') do
  on((1..4).to_a.shuffle, 'a shuffled array').does(:sort).eq?([1, 2, 3, 4])

  does(:reverse) do
    on('3 2 1').eq?('1 2 3')
    on([3, 2, 1]).eq?([1, 2, 3])
  end

  with(&->(idx) { idx * idx }).does(:map).on(0..3).eq?([0, 1, 4, 9])

  is(:rand).a?(Float) # symbol -> does
  is([]).empty? # not symbol -> on
end
```

```
✔ Example test
  ✔ sort on a shuffled array equals [1, 2, 3, 4].
  ✔ reverse...
    ✔ "3 2 1" equals "1 2 3".
    ✔ [3, 2, 1] equals [1, 2, 3].
  ✔ map(&{ ... }) on 0..3 equals [0, 1, 4, 9].
  ✔ rand is a Float.
  ✔ [] is empty.
pass: 5, fail: 0, errors: 0
```

## Usage

### CLI: Speq Files

Speq offers a simple CLI that lets you run tests written in dedicated spec files. This is the preferred way to run speq consistent with the examples shown above.

Executing `speq` (or `bundle exec speq` if using bundle) will recursively search the working directory and run all files that end with `_speq.rb`.

To run individual files, specify a list of speq file prefixes. For example, to run tests that are within the files `example_speq.rb` and `sample_speq.rb`, simply execute:

    speq example sample

Note that you don't need to require 'speq' within a speq file if running from the CLI.

### Anywhere: Speq.test

Speq can be used anywhere as long as it is required and all tests are written within a block passed to Speq.test.

```ruby
require 'speq'

speq("testing anywhere") do
  ...
end
# '.score': returns the proportion of tests passed as a Rational number
# '.pass?': returns true or false for whether all the tests passed
```

## Contributing

Bug reports and pull requests are welcome on [Speq's GitHub](https://github.com/znrm/speq).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
