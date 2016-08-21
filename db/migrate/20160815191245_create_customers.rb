class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
