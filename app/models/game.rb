class Game < ActiveRecord::Base
  has_many :users
  has_many :questions
end
