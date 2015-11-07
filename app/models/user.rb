class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :game
  has_many :guesses

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
