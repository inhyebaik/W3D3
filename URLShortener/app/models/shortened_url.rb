# == Schema Information
#
# Table name: shortened_urls
#
#  id        :integer          not null, primary key
#  short_url :string           not null
#  long_url  :string           not null
#  submitter :integer          not null
#

class ShortenedUrl < ActiveRecord::Base
validates :short_url, presence: true, uniqueness: true
validates :long_url, presence: true

  belongs_to :url_submitter,
    primary_key: :id,
    foreign_key: :submitter,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
  Proc.new { distinct },
    through: :visits,
    source: :visitors

  def self.random_code

    url = SecureRandom.urlsafe_base64(16)
    while ShortenedUrl.exists?(short_url: url)
      url = SecureRandom.urlsafe_base64(16)
    end
    url
  end

  def self.create_shortened_url(user, long_url)
    ShortenedUrl.create(submitter: user.id, long_url: long_url, short_url: ShortenedUrl.random_code)
  end

  def num_clicks
    Visit.where(url_id: self.id).length
  end

  def num_uniques
    # visits.select(:user_id).distinct.length
    visitors.length
  end

  def num_recent_uniques(recent_time)
    Visit.where(["updated_at > :recent_time", { recent_time: recent_time}]).length
  end
end
