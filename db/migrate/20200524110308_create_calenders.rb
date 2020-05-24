class CreateCalenders < ActiveRecord::Migration[6.0]
  def change
    create_table :calenders do |t|
      t.date :date
      t.integer :garbage_type

      t.timestamps
    end

    add_index :calenders, :date
    add_index :calenders, :garbage_type
  end
end
