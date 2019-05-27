is([]).empty?
is(Array(nil), "an array created by calling Array(nil)").eq?([nil])

# speq("Does Ruby properly calculate Euler's identity?").pass? do
#   e = Math::E
#   π = Math::PI
#   i = 1i

#   e ** (i * π) + 1 == 0
# end

# is(Math::E ** (1i * Math::PI) + 1, "e^iπ + 1").eq?(0)

# is(:prime?).of(2).true?

# on((1..4).to_a.reverse).does(:sort).eq?([1, 2, 3, 4])

# does(:map).with { |idx| idx * idx }.on(0..3).eq?([0, 1, 4, 9])

# on(1..4)
#   .does(:to_a, :shuffle, :sort)
#   .eq?([1, 2, 3, 4])
#   .then(:sort).with { |a, b| b <=> a }
#   .eq?([4, 3, 2, 1])

# does(:strip)
#   .on(" speq ")
#   .pass? { |str| str == "speq" && !str.include?(" ") }

# does(:rand)
#   .pass? { |val| val.is_a?(Float) }

# does(:prime?)
#   .with(-1)
#   .raise?("Prime is not defined for negative numbers")

# User = Class.new
# on(User)
#   .does(:new)
#   .with(id: 1, name: "user name")
#   .have?(:id)

# does(:strip).on(" speq ").not_include?(" ").eq?("speq")

# arr = Array.new(10, rand.round)
# on(arr, "10 element array filled with zeros or ones")
#   .has?(length: 100)
#   .all?(0)
#   .or_all?(1)

# default = rand.round(1) <=> 0.5
# length = default.zero? ? 0 : 100

# arr = Array.new(length, default)
# on(arr, "Either empty, all 1, or all -1")
#   .or?
#   .empty?
#   .xor?
#   .include?(-1)
#   .include?(1)

# class Display
#   attr_reader :type

#   def initialize(type = :case)
#     @type = type.to_sym
#   end

#   def case?
#     @type == :case
#   end
# end

# MyClass = Class.new

# call(MyClass, "my class, an instance of the class Class")
# is(MyClass).instance_of?(Class)

# my_arr = []
# call(my_arr, "a specific empty array")
# call([], "an empty array")

# is(my_arr).eq?([])

# not_prime = [0, 1, 4, 6, 8, 9]
# prime = [2, 3, 5, 7]

# does(:prime?) do
#   with(not_prime).false?
#   with(prime).true?
# end

# does(:my_sort) do
#   small_array = [3, 2, 1]
#   large_array = Array.new(10) { rand }

#   on(small_array).eq?(small_array.sort)
#   on(large_array).eq?(large_array.sort)
# end

# def add(a, b)
#   a + b
# end

# a = [1, 2, 3]
# b = [4, 5, 6]

# does(:add).with(a, b).eq?([5, 7, 9])
