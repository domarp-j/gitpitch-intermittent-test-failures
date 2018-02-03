describe '#inc_user_count' do
  it 'increments user count' do
    inc_user_count
    assert_equal 1, User.count
  end
end
