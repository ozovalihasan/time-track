class Task < ApplicationRecord
  belongs_to :user

  scope :descending_order, -> { order(created_at: :desc) }
  scope :ascending_order, -> { order(created_at: :asc) }
  scope :filter_by_time_type, ->(time_type) { where time_type: time_type }
  scope :filter_by_start_time, ->(start_time) { where ['start_time > ?', start_time] }
  scope :filter_by_end_time, ->(end_time) { where ['end_time < ?', end_time] }

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
