# An intentionally invalid function
def prime?(num)
  highest = Math.sqrt(num).to_i

  (2..highest).none? { |factor| (num % factor).zero? }
end
