fake_bank = fake(
  class: 'Account',
  balance: 5000,
  print_balance: '$50.00',
  withdraw: proc { |amount| [50, amount].min }
)

on(fake_bank, 'a fake bank').does(:withdraw).with(70).eq?(50)
