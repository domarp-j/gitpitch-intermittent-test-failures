ENV['TZ'] = 'UTC'
Time.zone = 'America/Chicago'

early_morning_utc = Time.utc(2017, 11, 10, 2)
Timecop.travel(early_morning_utc) do
  assert_equal Date.current, Date.today
end