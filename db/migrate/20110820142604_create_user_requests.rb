class CreateUserRequests < ActiveRecord::Migration
  def change
    create_table :user_requests do |t|
      t.boolean :is_complete
      t.text :user_response

      t.timestamps
    end
  end
end
