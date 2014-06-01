class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  def self.all_ratings
    %w[G PG PG-13 R NC-17]
  end

  def other_movies_from_same_director
    self.class.where('id != :id AND director = :director', id: id, director: director)
  end
end

# == Schema Information
#
# Table name: movies
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  rating       :string(255)
#  description  :text
#  release_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  director     :string(255)
#
