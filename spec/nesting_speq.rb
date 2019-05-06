on('3 2 1') do
  does(:to_i).eq?(3)
  does(:split).have?(length: 3)
  does(:first).eq?(3)
end