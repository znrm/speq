# Speq

## A tiny library to build specs with fewer words

Speq is TDD library for rapid prototyping in Ruby. It aims to work well anytime testing is desired but writing specs with existing tools may feel excessive.

Speq favors simplicity and minimalism, which may not always be compatible with rigorous testing. The existing TDD tools for Ruby are exceptional, and Speq is not meant to be a replacement.

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

In contrast to similar tools, speqs are typically framed as _questions_ about a program's behavior rather than _descriptions_ of what it does. The simplest way to run a single test is to use the method `pass?`, which accepts a string and a code block that should evaluate to true or false.

```ruby
pass?("Does Ruby properly calculate Euler's identity?") do
  e = Math::E
  π = Math::PI
  i = (1i)

  e**(i*π) + 1 == 0
end

# Passed (1/1)
#   'Can Ruby show that e^iπ + 1 = 0?'
```

The above works, but it's not much shorter than existing solutions. More importantly, it's missing vital information about what action was taken, what the outcome was, and what assertion led to the success.

```ruby
speq(Math::E**((1i) * Math::PI) + 1, 'e^iπ + 1').eq?(0)
# Passed (1/1)
# 'Is 'e^iπ + 1' equal 0?' ( (0.0+0.0i) == 0 )
```

### Actions

Descriptions for simple unit tests are often closely tied the semantics of the source code, and as such, Speq . To automatically generate descriptions, we can simply be a bit more explicit about the action of interest.

More specifically, we can be explicit about the method/message, the arguments being passed, and the receiver by using the following methods:

- message: `does(:symbol)` or `is(:symbol)`, default: `:itself`
- arguments: `with(...)` or `of(...)`, default: `*[]`
- receiver: `on(object, description(optional))`, default: `Object`

```ruby
is(:prime?).of(2).true?

on((1..10)).does(:sort).eq?([1, 2, 3, 4])

does(:new).with(4) {|idx| idx * idx}.on(Array).eq?([0, 1, 4, 9])

# Alternative for when explicit description might be simpler:
arr = Array.new(4) {|idx| idx * idx}

on(arr, 'Array constructed with block').eq?([0,1,4,9])
```

Actions begin when any of the methods above are invoked. The action is evaluated when it reaches a matcher such as `eq?`. Note that matchers always end with a question mark.

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

#### Test subject

Speq has the distinct advantage of making it particularly easy to run many similar tests on the same subject.
Opening a block on an action that has not been closed

```ruby
not_prime = [0, 1, 4, 6, 8, 9]
prime = [2, 3, 5, 7]

#
does(:prime?) do
  with[not_prime].false?
  with[prime].true?
end

does(:my_sort) do
  small_array = [3, 2, 1]
  large_array = Array.new(10**6) {rand}

  on(small_array).eq?(small_array.sort)
  on(large_array).eq?(large_array.sort)
end
```

#### Sugar

```ruby
# Action-Question Chains
on('3 2 1')
  << :split
  << has?(length: 3)
  << :map << with(&:to_i)
  << :reduce << with(&:+)
  << eq?(6)

# Broadcasting
def add(a, b)
  a + b
end

a = [1, 2, 3]
b = [4, 5, 6]

does(:add).with[a,b].eq?([5, 7, 9])
```

### Matchers

`pass` is the most general

#### Examples

```ruby
does(:rand).pass? {|val| val.is_a(Float)}
```

```ruby
does(:prime?).with(-1).raise?('Prime is not defined for negative numbers')

on(User).does(:new).with(id: 1, name: 'user name').has?(:id)
```

Matchers can be combined with the usual boolean operators: `not`, `and`, & `or`

```ruby
pass?(*description, &block)

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
has?(*:message, **(message: val))

map?()
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
