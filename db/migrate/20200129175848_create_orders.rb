class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :device_model
      t.string :imei
      t.decimal :anual_price
      t.integer :installments

      t.timestamps
    end
  end
end
