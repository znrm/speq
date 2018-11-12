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

In contrast to similar tools, speqs are typically framed as _questions_ about a program's behavior rather than _descriptions_ of what it does. If descriptions are preferred, this can still be achieved with the method `speq`, which accepts a string and a code block that should evaluate to true or false.

```ruby
speq '2 is prime' { prime?(2) }
```

### Actions

The above works, but it's not much better than existing solutions. Furthermore, the description should have easily been inferred from the action. To automatically generate descriptions of the action taken, we need only be a bit more explicit about the action:

```ruby
is(:prime?).of(2).true?

on([3,2,1]).does(:sort).eq?([1, 2, 3])
```

More specifically, we can be explicit about the method/message, the arguments being passed, and the receiver by using the following methods:

- message/method: `does(:message)` or `is(:message)`
- arguments (optional): `with(args)` or `of(args)`
- receiver (optional, default: Object): `on`

#### Ending an Action

Actions begin when any of the methods above are invoked and are evaluated
A

See [Matchers](#matchers) for a details of built-in matchers.

### Additional Functionality

#### Fakes

Fakes are Speq's simple implementation of a test double. Most closely resembling a stub, fakes provide canned or computed responses, allowing for additional test isolation for objects that rely on objects not within the scope of testing.

```ruby
fake_bank = fake(
  balance: 5000,
  print_balance: '$50.00',
  withdraw: proc {|amount| [50, amount].min }
)
```

#### Consistent State

```ruby
let(:empty) { [] }
let(:unsorted) { [3, 4, 2, 0, 1] }
let(:random) { Array.new(10) { rand } }
```

#### Action Chains

Typically, if may be sufficient to set up the program state

Occasionally, we may want to describe an entire series of actions.

#### Multiple testing pattern

Speq has the distinct advantage of making it particularly easy to run many similar tests on the same subject.

### Matchers

### Examples

```ruby
does(:prime?).with(-1).raise?('Prime is not defined for negative numbers')

on(User).does(:new).with(id: 1, name: 'user name').private?(:id)
```

Built in matchers allow for

Matchers can be combined with the usual boolean operators: `not`, `and`, & `or`

```ruby
eq?(obj)      # result == obj
eql?(obj)     # result.eql?(obj)
case_of?(obj) # result === obj
same_as?(obj) # result.equal?(obj)

true?
false?
truthy?
falsey?

raise?('The following error message')
raise?(ErrorClass)

instance_of?(SomeClass)
private?(:message)
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
