class CreateSuperUsageChoices < ActiveRecord::Migration
  def change
    create_table :super_usage_choices do |t|
      t.references :super_usage
      t.integer :weight_for_user
      t.references :user_request

      t.timestamps
    end
    add_index :super_usage_choices, :super_usage_id
    add_index :super_usage_choices, :user_request_id
  end
end
