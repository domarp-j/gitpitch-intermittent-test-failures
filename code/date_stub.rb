describe '#calculate_gaps' do
  let(:date_ranges) do
    [
      ['June 1 2017', 'December 30 2017'],
      ['September 3 2016', 'April 1 2017'],
      ['March 3 2014', 'September 2 2016'],
      ['February 15 2013', 'January 10 2014']
    ]
  end

  before do
    Date.stubs(:today).returns(Date.parse('December 31 2017'))
  end

  it 'calculates date gap from five years' do
    result = calculate_gaps(date_ranges)
    assert gap_present('December 31 2012', 'February 14 2013')
  end
end
