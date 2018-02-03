describe 'test object' do
  BAR = 'some value'

  it 'is equal to BAR' do
    assert_equal test_obj, BAR
  end
end

describe 'another test object' do
  BAR = 'another value'

  it 'is equal to BAR' do
    assert_equal another_test_obj, BAR
  end
end