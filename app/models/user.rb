class User < ApplicationRecord
  belongs_to :squad, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
