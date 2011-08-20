class CreateUsageChoices < ActiveRecord::Migration
  def change
    create_table :usage_choices do |t|
      t.float :weight_for_user
      t.integer :usage_id
      t.integer :user_request_id
      t.boolean :is_selected

      t.timestamps
    end
  end
end
