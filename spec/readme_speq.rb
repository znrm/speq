require_relative 'examples'

is([]).empty?

is(:prime?).of(2).true?
on((1..4).to_a.reverse).does(:sort).eq?([1, 2, 3, 4])
does(:map).with { |idx| idx * idx }.on(0..3).eq?([0, 1, 4, 9])

on(1..4)
  .does(:to_a, :shuffle, :sort)
  .eq?([1, 2, 3, 4])
  .then(:sort).with { |a, b| b <=> a }
  .eq?([4, 3, 2, 1])

on('3 2 1').does(:split).have?(length: 3)
