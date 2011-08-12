class CreateSuperUsages < ActiveRecord::Migration
  def change
    create_table :super_usages do |t|
      t.string :name

      t.timestamps
    end
  end
end
