describe 'feature toggles' do
  before do
    DeveloperTools::FeatureToggleHistory.destroy_all
    DeveloperTools::FeatureToggle.destroy_all
  end

  it 'tests feature toggles' do
    @feature_toggle = DeveloperTools::FeatureToggle.create(name: 'ft_test')
    @feature_toggle_history = @feature_toggle.feature_toggle_histories.create(description: 'Toggled on')

    # ...
  end
end