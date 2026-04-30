last_month_start = Date.current.last_month.beginning_of_month
last_month_end = Date.current.last_month.end_of_month
last_month_recorded_at = last_month_end.to_time.change(hour: 12)

user = User.find_or_create_by!(email: "seed.user@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.preferred_currency = User::DEFAULT_CURRENCY
end

account = user.accounts.find_or_create_by!(name: "Cuenta Principal", account_type: "checking") do |a|
  a.description = "Cuenta semilla para desarrollo"
end

balance_sheet = user.balance_sheets.find_or_initialize_by(account: account, recorded_at: last_month_recorded_at)
balance_sheet.notes = "Balance semilla para #{last_month_start.strftime('%Y-%m')}"
balance_sheet.save!

asset_items = [
  { name: "Efectivo", item_type: "liquid", amount: 4_500_000 },
  { name: "Inversiones", item_type: "fixed", amount: 12_000_000 }
]

liability_items = [
  { name: "Tarjeta de credito", item_type: "short_term", amount: 1_500_000 },
  { name: "Prestamo educativo", item_type: "long_term", amount: 5_000_000 }
]

asset_items.each do |attrs|
  asset = balance_sheet.assets.find_or_initialize_by(name: attrs[:name], item_type: attrs[:item_type])
  asset.amount = attrs[:amount]
  asset.save!
end

liability_items.each do |attrs|
  liability = balance_sheet.liabilities.find_or_initialize_by(name: attrs[:name], item_type: attrs[:item_type])
  liability.amount = attrs[:amount]
  liability.save!
end

# Ensure totals include the latest seed values.
balance_sheet.save!

budget = user.budgets.find_or_initialize_by(
  name: "Presupuesto #{last_month_start.strftime('%Y-%m')}",
  start_date: last_month_start,
  end_date: last_month_end,
  periodicity: "monthly"
)
budget.account = account
budget.save!

budget_items = [
  { name: "Salario", item_type: "income", amount: 8_000_000 },
  { name: "Freelance", item_type: "income", amount: 1_200_000 },
  { name: "Vivienda", item_type: "expense", amount: 2_200_000 },
  { name: "Alimentacion", item_type: "expense", amount: 1_300_000 },
  { name: "Transporte", item_type: "expense", amount: 500_000 }
]

budget_items.each do |attrs|
  item = budget.budget_items.find_or_initialize_by(name: attrs[:name], item_type: attrs[:item_type])
  item.amount = attrs[:amount]
  item.save!
end

# Ensure totals include the latest seed values.
budget.save!

savings_plan = user.savings_plans.find_or_initialize_by(
  name: "Fondo de emergencia",
  start_date: last_month_start,
  target_date: last_month_end.next_month.end_of_month
)
savings_plan.goal_amount = 18_000_000
savings_plan.initial_capital = 3_000_000
savings_plan.annual_interest_rate = 8.5
savings_plan.save!

entry = savings_plan.entries.find_or_initialize_by(entry_date: last_month_end, frequency: "manual")
entry.amount = 2_000_000
entry.notes = "Aporte semilla del mes"
entry.save!

puts "Seed data ready for #{user.email}"
