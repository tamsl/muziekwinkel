class CreateUitgelichts < ActiveRecord::Migration
  def self.up
    create_table :uitgelichts do |t|
      t.references :album_id
      t.text :omschrijving

      t.timestamps
    end
  end

  def self.down
    drop_table :uitgelichts
  end
end
