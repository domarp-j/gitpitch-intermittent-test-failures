describe 'test object' do
  let(:bar) { 'some value' }

  it 'is equal to bar' do
    assert_equal test_obj, bar
  end
end

describe 'another test object' do
  let(:bar) { 'another value' }

  it 'is equal to bar' do
    assert_equal another_test_obj, bar
  end
end