class AddColumnToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deleted_at, :datetime
  end
end
