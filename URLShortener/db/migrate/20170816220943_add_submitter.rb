class AddSubmitter < ActiveRecord::Migration[5.1]
  def change
    add_column :shortened_urls, :submitter, :integer, null: false
  end
end
