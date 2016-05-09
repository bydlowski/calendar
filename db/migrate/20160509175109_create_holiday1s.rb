class CreateHoliday1s < ActiveRecord::Migration
  def change
    create_table :holiday1s do |t|
      t.string :holiday_city
      t.string :holiday_city_full
      t.string :holiday_name
      t.integer :holiday_date
      t.integer :holiday_date_ly
      t.boolean :national
      t.boolean :municipal
      t.boolean :servidor
      t.timestamps null: false
    end
  end
end
