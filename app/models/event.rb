class Event < ActiveRecord::Base

  attr_accessor :date
  validates :title, :since, presence: true
  enum periodicity: { once: 'once', daily: 'daily', weekly: 'weekly', monthly: 'monthly', yearly: 'yearly' }

  scope :since, ->(date) { where("date ? >= since", date) }
  scope :at, ->(date) { since(date).where(at_statement, { date: date }) }

  def self.between(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    (start_date..end_date-1).reduce([]) do |memo, date|
      events = at(date).each { |event| event.date = date }
      memo.concat events
    end
  end

  private

  def self.at_statement
    <<-EOF
      CASE periodicity
        WHEN 'once' THEN date :date = since
        WHEN 'daily' THEN (date :date - since) % 1 = 0
        WHEN 'weekly' THEN (date :date - since) % 7 = 0
        WHEN 'monthly' THEN to_char(date :date, 'DD') = to_char(since, 'DD')
        WHEN 'yearly' THEN to_char(date :date, 'MM-DD') = to_char(since, 'MM-DD')
      END
    EOF
  end
end
