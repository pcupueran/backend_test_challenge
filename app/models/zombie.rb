class Zombie < ApplicationRecord
  has_many :armors
  accepts_nested_attributes_for :armors
  validates :name, presence: true
end
