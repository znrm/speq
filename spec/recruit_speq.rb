# frozen_string_literal: true

speq(Recruit::Duck) do
  account = Recruit.duck(
    balance: 5000,
    print_balance: -> { format('$%.2f', account.balance / 100.0) },
    withdraw: ->(amount) { account.balance -= amount }
  )

  on(account, 'an account starting with a balance of 5000') do
    does(:print_balance).eq?('$50.00')

    account.withdraw(250)
    does(:print_balance, 'after withdrawing $2.50').eq?('$47.50')
  end
end
