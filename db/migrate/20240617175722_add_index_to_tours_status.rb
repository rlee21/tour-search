class AddIndexToToursStatus < ActiveRecord::Migration[7.1]
  def change
    add_index :tours, :status
  end
end
