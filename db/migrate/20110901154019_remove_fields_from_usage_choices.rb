class RemoveFieldsFromUsageChoices < ActiveRecord::Migration
  def change
    remove_column :usage_choices, :weight_for_user
    remove_column :usage_choices, :is_selected
  end
end
