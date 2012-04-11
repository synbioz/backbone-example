class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.float :value
      t.references :category
      t.datetime :at

      t.timestamps
    end
  end
end
