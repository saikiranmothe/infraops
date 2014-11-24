class CreateOperatingSystems < ActiveRecord::Migration
  def self.up
    create_table :operating_systems do |t|
      t.string :name, limit: 56
      t.string :short_name, limit: 16
      t.string :description, limit: 512
      t.timestamps
    end
  end

  def self.down
    drop_table :operating_systems
  end
end