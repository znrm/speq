require_relative 'examples'

does :prime? do
  given 0, 1, 8, match: false
  given 2, 3, 97, match: true
end
