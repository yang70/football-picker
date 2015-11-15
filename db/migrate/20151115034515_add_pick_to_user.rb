class AddPickToUser < ActiveRecord::Migration
  def change
    add_reference :picks, :user, index: true, foreign_key: true
  end
end
