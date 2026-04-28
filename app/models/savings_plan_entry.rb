class SavingsPlanEntry < ApplicationRecord
  belongs_to :savings_plan

  validates :entry_date, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  enum :frequency, { manual: "manual", automatic: "automatic" }, default: :manual

  scope :by_date, -> { order(entry_date: :desc) }
  scope :recent, -> { by_date.limit(10) }

  def self.total_saved(savings_plan)
    where(savings_plan: savings_plan).sum(:amount)
  end

  def self.average_monthly_savings(savings_plan)
    entries = where(savings_plan: savings_plan)
    return 0 if entries.empty?

    first_date = entries.minimum(:entry_date)
    last_date = entries.maximum(:entry_date)
    months = ((last_date.year * 12 + last_date.month) - (first_date.year * 12 + first_date.month)) + 1
    months = 1 if months <= 0

    (total_saved(savings_plan).to_d / months).round(2)
  end
end
