# == Schema Information
#
# Table name: visits
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#  url_id  :integer          not null
#

class Visit < ActiveRecord::Base

  belongs_to :visitors,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :visited_urls,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl

    def self.record_visit!(user, shortened_url)
      Visit(user_id: user.id, url_id: shortened_url)
    end
end
