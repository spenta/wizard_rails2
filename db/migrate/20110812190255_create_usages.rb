class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.string :name
      t.references :super_usage

      t.timestamps
    end
    add_index :usages, :super_usage_id
  end
end
