class Task < ApplicationRecord
  belongs_to :user

  scope :descending_order, -> { order(created_at: :desc) }
  scope :ascending_order, -> { order(created_at: :asc) }

  def self.to_csv
    attributes = %w[id comment time_type start_time end_time user_id]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
