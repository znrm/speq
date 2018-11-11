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

## Design & Syntax

_Speq's syntax and report format is still in flux and likely to change dramatically until an effective setup is established._

Speq is loosely based on the given-when-then or arrange-act-assert testing pattern. Speq's design choices are guided by the competing motivations of having tests be as short and simple as possible while maintaining the flexibility to be as descriptive as needed.

A speq should ask the question or indicate whatan action should do.
The simplest way to achieve this is to describe the behavior followed by a code block that returns true or false.

This can be achieved with the method `speq`, the simplest construct in Speq.

```ruby
speq '2 is prime' { prime?(2) }
```

### Actions

The above works decently, but it's not much better than existing solutions. Furthermore, the description should have easily been inferred from the action.

To automatically generate descriptions of the action taken, we need to only be a bit more explicit about the action.

Specifically, we can be explicit about the method, arguments being passed, and receiver using the methods `does`, `with`, and `on`, respectively.

```ruby
does(:to_s).eq('main')

on([3,2,1]).does(:sort).
```

Doing so also has the distinct advantage of making it easy to run many similar tests on the same subject.

#### Multiple testing pattern

```ruby

```

#### `does`

```ruby
on([3,2,1]).does(:sort).eq()
```

#### `with`

#### `on`

```ruby

# 1 / 1 test passed

# Does calling prime? with the argument 2 return true?

```

`call`:
`on` : Object
`with`:

```ruby
# Example for testing an entire class
speq Array do
  let(:empty) { [] }
  let(:unsorted) { [3, 4, 2, 0, 1] }
  let(:random) { Array.new(10) { rand } }

  does :is_a do
    given Module
  end

end
```

### Matchers

Built in matchers

```ruby
# Expected
eq(value)
is(object)
raises('The following error message')
raises(ErrorClass)
truthy()
falsey()
```

### Fakes

Fakes are Speq's simple implementation of a test double. Most closely resembling a stub, fakes provide canned or computed responses, allowing for additional test isolation for objects that rely on objects not within the scope of testing.

```ruby
fake_bank = fake(
  balance: 5000,
  print_balance: '$50.00',
  withdraw: proc {|amount| [50, amount].min }
)
```

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
