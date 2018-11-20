fake_bank = fake(
  balance: 5000,
  print_balance: '$50.00',
  withdraw: proc { |amount| [50, amount].min }
)

on(fake_bank).does(:withdraw).with(70).eq?(50)
