class Event < ActiveRecord::Base

  validates :name, :start, presence: true
  enum periodicity: { once: 'once', daily: 'daily', weekly: 'weekly', monthly: 'monthly', yearly: 'yearly' }

  scope :since, ->(date) { where("date ? >= start", date) }
  scope :at, ->(date) { since(date).where(at_statement, { date: date }) }

  def self.between(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    (start_date..end_date-1).reduce([]) do |memo, date|
      events = at(date).each { |event| event.start = date }
      memo.concat events
    end
  end

  private

  def self.at_statement
    <<-EOF
      CASE periodicity
        WHEN 'once' THEN date :date = start
        WHEN 'daily' THEN (date :date - start) % 1 = 0
        WHEN 'weekly' THEN (date :date - start) % 7 = 0
        WHEN 'monthly' THEN to_char(date :date, 'DD') = to_char(start, 'DD')
        WHEN 'yearly' THEN to_char(date :date, 'MM-DD') = to_char(start, 'MM-DD')
      END
    EOF
  end
end
