class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :comment
      t.string :time_type
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
