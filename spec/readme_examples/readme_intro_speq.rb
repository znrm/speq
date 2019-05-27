is([]).empty?
is(Array(nil), 'an array created by calling Array(nil)').eq?([nil])

speq("Does Ruby properly calculate Euler's identity?") do
  e = Math::E
  π = Math::PI
  i = (1i)

  true?(e**(i*π) + 1 == 0)
end

is(Math::E**((1i) * Math::PI ) + 1, 'e^iπ + 1').eq?(0)