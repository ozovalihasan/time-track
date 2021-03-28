class Task < ApplicationRecord
  belongs_to :user

  scope :descending_order, -> { order(created_at: :desc) }
  scope :ascending_order, -> { order(created_at: :asc) }
  scope :filter_by_users_id, ->(users_id) { where user_id: users_id }
  scope :filter_by_time_type, ->(time_type) { where time_type: time_type }
  scope :filter_by_start_time, ->(start_time) { where ['start_time > ?', start_time] }
  scope :filter_by_end_time, ->(end_time) { where ['end_time < ?', end_time] }
end
