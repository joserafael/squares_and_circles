class Circle < ApplicationRecord
  belongs_to :frame

  validates :center_x, :center_y, :diameter, presence: true
  validates :diameter, numericality: { greater_than: 0 }

  validate :circle_must_fit_within_frame
  validate :no_overlapping_circles

  def self.search(center_x, center_y, radius, frame_id = nil)
    query = where(
      "SQRT(POW(circles.center_x - ?, 2) + POW(circles.center_y - ?, 2)) + (circles.diameter / 2) <= ?",
      center_x, center_y, radius
    )
    query = query.where(frame_id: frame_id) if frame_id
    query
  end

  private

  def circle_must_fit_within_frame
    return unless frame

    unless (center_x - diameter / 2) >= (frame.center_x - frame.width / 2) &&
           (center_x + diameter / 2) <= (frame.center_x + frame.width / 2) &&
           (center_y - diameter / 2) >= (frame.center_y - frame.height / 2) &&
           (center_y + diameter / 2) <= (frame.center_y + frame.height / 2)
      errors.add(:base, "Circle must fit completely within the frame")
    end
  end

  def no_overlapping_circles
    return unless frame

    frame.circles.where.not(id: id).each do |other_circle|
      distance = Math.sqrt((center_x - other_circle.center_x)**2 + (center_y - other_circle.center_y)**2)
      if distance < (diameter / 2 + other_circle.diameter / 2)
        errors.add(:base, "Circle cannot overlap with another circle")
        break
      end
    end
  end
end
