describe 'User' do
  let(:users) { all_users_except_user_3 }

  it 'gets all users except user_3 because we hate him'
    assert_equal 2, users.count
    assert_includes users, user_1
    assert_includes users, user_2
    refute_includes users, user_3
  end
end