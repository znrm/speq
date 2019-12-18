# frozen_string_literal: true

on((1..4).to_a.shuffle, 'a shuffled array').does(:sort) do
  eq?([1, 2, 3, 4])
  with { |a, b| b <=> a }.eq?([4, 3, 2, 1])
end

is(Math::E**(1i * Math::PI) + 1, 'e^iπ + 1').eq?(0)

def prime?(num)
  raise 'Prime is not defined for negative numbers' if num.negative?

  highest = Math.sqrt(num).to_i

  (2..highest).none? { |factor| (num % factor).zero? }
end

speq(Array) do
  is([]).empty?
  does(:map).with { |idx| idx * idx }.on(0..3).eq?([0, 1, 4, 9])
  is(Array(nil), 'An array created by calling "Array(nil)"').eq?([nil])
  does(:Array).with(nil).eq?([nil])
end

on(self).is(:prime?) do
  of(2).true?
  of(-1).raise?('Prime is not defined for negative numbers')
end

on('3 2 1') do
  does(:split).have?(length: 3)
  does(:to_i).eq?(3)
end

does(:strip)
  .on(' speq ')
  .eq?('speq')
  .match?('not including space') { |str| !str.include?(' ') }

is(1.0).a?(Float)
