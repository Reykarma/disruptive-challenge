class CreateInvestments < ActiveRecord::Migration[6.1]
  def change
    create_table :investments do |t|

      t.timestamps
    end
  end
end
