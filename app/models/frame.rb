class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy
  accepts_nested_attributes_for :circles

  validates :center_x, :center_y, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than: 0 }

  

  def self.search(center_x, center_y, radius)
    where(
      "center_x BETWEEN :min_x AND :max_x AND center_y BETWEEN :min_y AND :max_y",
      min_x: center_x - radius,
      max_x: center_x + radius,
      min_y: center_y - radius,
      max_y: center_y + radius
    )
  end

  
end