require_relative 'examples'

is(:prime?).of(2).true?

on('3 2 1').does(:split).have?(length: 3)
