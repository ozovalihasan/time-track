class Task < ApplicationRecord
  def self.to_csv
    attributes = %w[id comment time_type start_time end_time]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
