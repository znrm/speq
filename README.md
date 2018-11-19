# Speq

## Build specs with fewer words

Speq is a testing library for rapid prototyping in Ruby.

Speq favors simplicity and minimalism.

```ruby
is(Array.new).empty?
# Passed (1/1)
#   [] is empty.
```

But also values flexibility.

```ruby
speq(Array(nil), 'an array created by calling Array(nil)').eq?([nil])

# Failed (1/1)
#   An array created by calling Array(nil) is NOT equal to [nil]. ( [] != [nil] )
```

Speq is ideal whenever it would feel excessive to use one of the existing frameworks, but it's not enough to just print & inspect outputs.

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

Speq is loosely based on the given-when-then or arrange-act-assert testing pattern. Speq's design choices are guided by the competing motivations of having tests be as short and simple as possible while maintaining the flexibility to be as descriptive as needed.

In contrast to similar tools, speqs are typically framed as _questions_ about a program's behavior rather than assertions about the desired behavior. The most basic test involves passing a string to the method `speq` followed by `pass?` and a block that evaluates strictly to true or false.

```ruby
speq("Does Ruby properly calculate Euler's identity?").pass? do
  e = Math::E
  π = Math::PI
  i = (1i)

  e**(i*π) + 1 == 0
end

# Passed (1/1)
#   Testing 'does Ruby properly calculate Euler's identity?' passes.
```

The above works, but it's not much shorter than existing solutions. More importantly, it's missing vital information about what action was taken, what the outcome was, and what assertion led to the success.

Shown below is the basic two-part pattern for most speqs and the resulting report combining explicit and implicit descriptions:

```ruby
speq(Math::E**((1i) * Math::PI ) + 1, 'e^iπ + 1').eq?(0)
# Passed (1/1)
#     e^iπ + 1 is equal to 0. ( (0.0+0.0i) == 0 )
```

### Actions

Descriptions for simple unit tests are often closely tied to the source code, and as such, Speq tries to eliminate them wherever possible. To automatically generate descriptions, the action or subject of interest is supplied to be evaluated dynamically.

More specifically, we begin by setting up the program state and then explicitly supply the action being tested using the methods below. By breaking down the expression's method/message, arguments, and receiver, Speq can use the additional information to help generate an often sufficiently detailed description of the test. Actions are evaluated when they reach a [matcher](#matchers).

- message: `does(*:symbol` or `is(*:symbol)`, default: `:itself`
- arguments: `with(...)` or `of(...)`, default: `*[]`
- receiver: `on(object, description(optional))`, default: `Object`

```ruby
is(:prime?).of(2).true?

on((1..4).to_a.reverse).does(:sort).eq?([1, 2, 3, 4])

# .with() accepts arguments with the exact same format as any other method
does(:map).with { |idx| idx * idx }.on(0..3).eq?([0, 1, 4, 9])

# Passed (3/3)
#   prime? of 2 is true.
#   sort on [4, 3, 2, 1] equals [1, 2, 3, 4].
#   map with a block on 1..4 equals [0, 1, 4, 9].
```

Chaining methods can be accomplished by providing multiple symbols. If an intermediate value needs to be tested or a method needs to be given arguments, this can be accomplished by using `.then(:next_method).with`. An example of this is shown below. An alternative, unconventional syntax for accomplishing the same can be found in the section on [syntactic sugar](#Sugar)

```ruby
on(1..4)
  .does(:to_a, :shuffle, :sort)
  .eq?([1, 2, 3, 4])
  .then(:sort).with { | a, b | b <=> a }
  .eq?([4, 3, 2, 1])

# Passed (1/1)
#   to_a on 1..4 then reverse (on [1, 2, 3, 4]) then sort on [4, 3, 2, 1] equals [1, 2, 3, 4]
```

### Matchers

All speq methods that end with a question mark are matchers.

The matcher `pass?` is the most general and simply expects to be given a code block that evaluates to true or false. The output from the action is passed along as the first piped variable.

```ruby
does(:strip)
  .on(' speq ')
  .pass? { |str|  str == 'speq' && !str.include?(' ') }

does(:rand)
  .pass? { |val| val.is_a?(Float) }

does(:prime?)
  .with(-1)
  .raise?('Prime is not defined for negative numbers')

on(User)
  .does(:new)
  .with(id: 1, name: 'user name')
  .have?(:id)
```

#### Prefixes and Compound Matchers

Multiple matchers can follow an action. By default, all matchers must pass for the test to be considered successful. To run multiple tests on the same action, see the section on [test subjects](#subjects)

The logical inverse of any matcher can be achieved by prefixing the matcher with `not_`.

```ruby
# Equivalent to the previous speq
does(:strip).on(' speq ').not_include?(' ').eq?('speq')
```

For simple combinations, it's sufficient to prefix the second matcher with one of the following: `or_, nand_, nor_, xor_, xnor_`

```ruby
arr = Array.new(10, rand.round)
speq(arr, '10 element array filled with zeros or ones').has?(length: 100).all?(0).or_all?(1)

# arr.length == 100 && (arr.all?(0) || arr.all?(1))
```

Although it's best to avoid complex combinations of matchers, logical operators can be combined unambiguously if absolutely needed by chaining operators with prefix notation.

```ruby
default = rand.round(1) <=> 0.5
length = default.zero? ? 0 : 100

arr = Array.new(length, default)
speq(arr, 'Either empty, all 1, or all -1').or?.empty?.xor?.include?(-1).include?(1)
```

#### Generated & built-in matchers

If the object being tested responds to the method ending with `?`, then an appropriate matcher is automatically generated. As a result, existing methods such as `instance_of?`, `nil?`, or `empty?` can be used despite the fact that they are not in the list below.

```ruby
pass?(*description, &block)
has?(*:message, **(message: val)) # alias: have?

eq?(obj)   # result == obj
case?(obj) # obj === result

true?
false?
truthy?
falsy?

raise?('The following error message')
raise?(ErrorClass)

# Compound matchers
either?(*matcher)  # matcher1 || matcher2 || ...
neither?(*matcher) # !matcher1 || !matcher2 ||  ...

```

#### Matcher name precedence

Parsing the name of a matcher gives highest precedence to the object being tested. For example, consider the following test:

```ruby
class Display
  attr_reader :type

  def initialize(type = :case)
    @type = type.to_sym
  end

  def case?
    @type == :case
  end
end

window_display = Display.new('window')

speq(window_display).not_case? # Will use Display#case
on(window_display).is(:type).case?(Symbol) # Will use Speq#case?
```

To resolve `not_case?`, speq will do the following:

1. Checks for the prefix `speq_`, reserved in case of name conflicts.
2. Generates a matcher if the object responds to `not_case?`.
3. Generates a matcher if the object responds to `case?` and applies prefixes.
4. Uses the built-in `case?` and applies prefixes.

### Additional Functionality

#### Object Descriptions

It may be advantageous to describe an object in advance such that, from there on, the report will automatically include the object description anytime that object is encountered.

```ruby
MyClass = Class.new

call(MyClass, 'my class, an instance of the class Class')
speq(MyClass).instance_of?(Class)

# call tracks both object identity and object equality
my_arr = []
call(my_arr, 'a specific empty array')
call([], 'an empty array')

speq(my_arr).eq?([])

# Passed (2/2)
#   Is 'my class, an instance of the class Class' an instance of the class Class?
#   Is 'my specific empty array' equal to 'an empty array'?
```

#### Fakes

Fakes are Speq's simple implementation of a test double. Most closely resembling a stub, fakes provide canned or computed responses, allowing for additional test isolation for objects that rely on objects not within the scope of testing.

```ruby
fake_bank = fake(
  balance: 5000,
  print_balance: '$50.00',
  withdraw: proc {|amount| [50, amount].min }
)
```

#### Subjects

Speq has the distinct advantage of making it particularly easy to run many similar tests on the same subject.
Opening a block on an action that has not been clo

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

# Can start with the usual syntax and switch when convenient
on(1..4).does(:to_a, :shuffle, :sort).eq?([1, 2, 3, 4])
  << :sort << with { | a, b | b <=> a } << eq?([4, 3, 2, 1])

# Broadcasting
def add(a, b)
  a + b
end

a = [1, 2, 3]
b = [4, 5, 6]

does(:add).with[a, b].eq?([5, 7, 9])
```

## Usage

### CLI: Speq Files

Speq offers a simple CLI that lets you run tests written in dedicated spec files. This is the preferred way to run speq consistent with the examples shown above.

Executing `speq` (or `bundle exec speq` if using bundle) will recursively search the working directory and run all files that end with `_speq.rb`.

To run individual files, specify a list of speq file prefixes. For example, to run tests that are within the files `example_speq.rb` and `sample_speq.rb`, simply execute:

    speq example sample

Speq files only `require 'speq'` by default, so any external code being tested will still need to be required.

### Anywhere: Speq.test

Speq can be used anywhere as long as it is required and all tests are written within a block passed to Speq.test.

```ruby
require 'speq'

Speq.test(self) do | context |
  # You can pass the surrounding context if needed.
  # Calling 'report' prints the tests seen so far to $stdout.

  # By default, Speq.test Returns the instance of Speq::Test created here.
  # Using the return keyword, you can choose to return the following instead:
  # 'return score': returns the proportion of tests passed as a Rational number
  # 'return pass?': returns true or false for whether all the tests passed
end
```

Speq can also be included to be used in a more direct manner. Here is an example of using Speq within another class for added functionality.

```ruby
require 'speq'

class Exam
  include Speq

  def initialize(questions)
    @questions = questions
  end

  def grade
    @questions.each do | question |
      speq(question.response, question.to_s).eq?(question.answer)
    end

    score
  end
end
```

## Contributing

Bug reports and pull requests are welcome on [Speq's GitHub](https://github.com/znrm/speq).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
