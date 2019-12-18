# frozen_string_literal: true

is(Math::E**(1i * Math::PI) + 1, 'e^iπ + 1').eq?(0)

def prime?(num)
  raise 'Prime is not defined for negative numbers' if num.negative?

  highest = Math.sqrt(num).to_i

  (2..highest).none? { |factor| (num % factor).zero? }
end

on(self).is(:prime?) do
  of(2).true?
  of(-1).raise?('Prime is not defined for negative numbers')
end

speq('Examples') do
  on((1..4).to_a.shuffle, 'a shuffled array').does(:sort).eq?([1, 2, 3, 4])

  does(:reverse) do
    on('3 2 1').eq?('1 2 3')
    on([3, 2, 1]).eq?([1, 2, 3])
  end

  with(&->(idx) { idx * idx }).does(:map).on(0..3).eq?([0, 1, 4, 9])

  is(:rand).a?(Float) # symbol -> does
  is([]).empty? # not symbol -> on
end
