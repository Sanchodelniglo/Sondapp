class CreateProbings < ActiveRecord::Migration[5.2]
  def change
    create_table :probings do |t|
      t.references :user, foreign_key: true
      t.integer :count
      t.integer :quantity
      t.integer :hydratation
      t.string :quality
      t.integer :fleed
      t.string :collect_methode
      t.date :date

      t.timestamps
    end
  end
end
