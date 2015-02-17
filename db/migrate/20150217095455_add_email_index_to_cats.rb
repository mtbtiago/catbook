class AddEmailIndexToCats < ActiveRecord::Migration
  def change
    add_index :cats, :email
  end
end
