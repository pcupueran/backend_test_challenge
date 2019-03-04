class Zombie < ApplicationRecord
  has_many :armors
  has_many :weapons
  accepts_nested_attributes_for :armors, :weapons
  validates :name, presence: true

  scope :associated_with, -> (search_term) { 
    joins(:armors, :weapons).group('zombies.id').where('zombies.name LIKE :search_term
      OR armors.name LIKE :search_term 
      OR weapons.name LIKE :search_term', 
      search_term: "%#{search_term}%"
    )
  }
end
