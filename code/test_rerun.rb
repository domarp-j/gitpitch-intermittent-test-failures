output_file = File.new 'test_output.txt', 'w'

100.times do |run_count|
  output_file << "\nTEST RUN #{run_count}\n"
  output_file << `bundle exec rake test:unit`
end