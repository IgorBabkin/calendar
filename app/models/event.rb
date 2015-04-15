class Event < ActiveRecord::Base

  attr_accessor :date
  validates :title, :since, presence: true
  enum periodicity: { once: 'once', daily: 'daily', weekly: 'weekly', monthly: 'monthly', yearly: 'yearly' }

  scope :between, ->(start_date, end_date) { select("events.*, start").joins(at_statement({ start: start_date, end: end_date })) }
  belongs_to :user

  private

    def self.at_statement(options)
      sql_string = "INNER JOIN (#{dates_statement}) AS d ON #{condition_statement}"
      ActiveRecord::Base::sanitize_sql_array([sql_string, options])
    end

    def self.condition_statement
      <<-EOF
        start >= since AND
        CASE periodicity
          WHEN 'once' THEN start = since
          WHEN 'daily' THEN (start - since) % 1 = 0
          WHEN 'weekly' THEN (start - since) % 7 = 0
          WHEN 'monthly' THEN to_char(start, 'DD') = to_char(since, 'DD')
          WHEN 'yearly' THEN to_char(start, 'MM-DD') = to_char(since, 'MM-DD')
        END
      EOF
    end

    def self.dates_statement
      <<-EOF
        SELECT date_trunc('day', dd)::date AS start
        FROM generate_series
          (:start::timestamp
          ,:end::timestamp
          ,'1 day'::interval) dd
      EOF
    end
end
