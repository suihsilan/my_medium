class AddSlugToStory < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :slug, :string
    add_index :stories, :slug, unique: true
  end
end

