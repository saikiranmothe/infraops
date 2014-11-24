class CreateOsVersions < ActiveRecord::Migration
  def self.up
    create_table :os_versions do |t|
      t.string :name, limit: 56
      t.string :version, limit: 8
      t.string :description, limit: 512
      t.references :operation_system
      t.timestamps
    end
  end

  def self.down
    drop_table :os_versions
  end
end