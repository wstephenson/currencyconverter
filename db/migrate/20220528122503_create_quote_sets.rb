class CreateQuoteSets < ActiveRecord::Migration[6.1]
  def change
    create_table :quote_sets do |t|
      t.datetime :timestamp
      t.string :source

      t.timestamps
    end
  end
end
