require_relative 'examples'

is([]).empty?

is(:prime?).of(2).true?
on((1..4).to_a.reverse).does(:sort).eq?([1, 2, 3, 4])
does(:map).with { |idx| idx * idx }.on(0..3).eq?([0, 1, 4, 9])

# on(1..4)
#   .does(:to_a, :shuffle, :sort)
#   .eq?([1, 2, 3, 4])
#   .then(:sort).with { |a, b| b <=> a }
#   .eq?([4, 3, 2, 1])

on('3 2 1') do
  does(:split).have?(length: 3)
  does(:to_i).eq?(3)
end

does(:strip)
  .on(' speq ')
  .pass? { |str| str == 'speq' && !str.include?(' ') }

does(:rand)
  .pass? { |val| val.is_a?(Float) }

does(:prime?)
  .with(-1)
  .raise?('Prime is not defined for negative numbers')
