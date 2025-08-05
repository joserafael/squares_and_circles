class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy
  accepts_nested_attributes_for :circles

  validates :center_x, :center_y, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than: 0 }

  validate :no_overlapping_frames

  def self.search(center_x, center_y, radius)
    where(
      "center_x BETWEEN :min_x AND :max_x AND center_y BETWEEN :min_y AND :max_y",
      min_x: center_x - radius,
      max_x: center_x + radius,
      min_y: center_y - radius,
      max_y: center_y + radius
    )
  end

  private

  def no_overlapping_frames
    return unless Frame.where.not(id: id).any? do |other_frame|
      (center_x - width / 2) < (other_frame.center_x + other_frame.width / 2) &&
      (center_x + width / 2) > (other_frame.center_x - other_frame.width / 2) &&
      (center_y - height / 2) < (other_frame.center_y + other_frame.height / 2) &&
      (center_y + height / 2) > (other_frame.center_y - other_frame.height / 2)
    end

    errors.add(:base, "Frame cannot overlap with another frame")
  end
end
