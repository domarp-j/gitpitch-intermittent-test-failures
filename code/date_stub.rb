describe '#calculate_gaps' do
  let(:date_ranges) do
    [
      [Date.parse('June 1 2017'), Date.parse('December 30 2017')],
      [Date.parse('September 3 2016'), Date.parse('April 1 2017')],
      [Date.parse('March 3 2014'), Date.parse('September 2 2016')],
      [Date.parse('February 15 2013'), Date.parse('January 10 2014')]
    ]
  end

  before do
    Date.stubs(:today).returns(Date.parse('December 31 2017'))
  end

  it 'calculates a date gap between five years ago and the current day' do
    result = calculate_gaps(date_ranges)
    assert gap_present(Date.parse('December 31 2012'), Date.parse('February 14 2013'))
  end
end
