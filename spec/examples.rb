def prime?(num)
  highest = Math.sqrt(num).to_i

  (2..highest).none? { |factor| (num % factor).zero? }
end

class Array
  def my_map
    Array.new(length) { |index| yield(self[index]) }
  end
end

class Receipt
  attr_reader :items

  def initialize(items)
    @items = items
  end

  def total
    items.map(&:cost).reduce(:+)
  end

  def names
    items.map(&:names)
  end
end
