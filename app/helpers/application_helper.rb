module ApplicationHelper
  def get_current_week
    start = Time.parse("2015-09-01 01:00:00 -800")

    (Time.now.to_date - start.to_date).to_i / 7
  end
end
