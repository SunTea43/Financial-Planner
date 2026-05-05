class CreateExchangeRates < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:exchange_rates)
      create_table :exchange_rates do |t|
        t.string :base_currency, null: false
        t.string :quote_currency, null: false
        t.decimal :rate, precision: 20, scale: 10, null: false
        t.datetime :fetched_at, null: false
        t.string :source, null: false, default: "open_er_api"

        t.timestamps
      end
    end

    unless index_exists?(:exchange_rates, [ :base_currency, :quote_currency, :fetched_at ],
                         name: "index_exchange_rates_on_base_quote_fetched_at")
      add_index :exchange_rates,
                [ :base_currency, :quote_currency, :fetched_at ],
                unique: true,
                name: "index_exchange_rates_on_base_quote_fetched_at"
    end

    unless index_exists?(:exchange_rates, [ :base_currency, :quote_currency, :fetched_at ],
                         name: "index_exchange_rates_on_base_quote_fetched_at_desc")
      add_index :exchange_rates,
                [ :base_currency, :quote_currency, :fetched_at ],
                order: { fetched_at: :desc },
                name: "index_exchange_rates_on_base_quote_fetched_at_desc"
    end
  end
end
