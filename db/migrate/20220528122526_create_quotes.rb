class CreateQuotes < ActiveRecord::Migration[6.1]
  def change
    create_table :quotes do |t|
      t.string :currencies
      t.decimal :rate
      t.references :quote_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
