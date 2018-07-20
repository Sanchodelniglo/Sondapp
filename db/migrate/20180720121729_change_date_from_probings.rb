class ChangeDateFromProbings < ActiveRecord::Migration[5.2]
  def change
    change_column :probings, :date, :datetime
  end
end
