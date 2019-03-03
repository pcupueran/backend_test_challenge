class Zombie < ApplicationRecord
  has_many :armors
  has_many :weapons
  accepts_nested_attributes_for :armors, :weapons
  validates :name, presence: true
end
