describe 'feature toggles' do
  before do
    FeatureToggleHistory.destroy_all
    FeatureToggle.destroy_all
  end

  it 'tests feature toggles' do
    @ft = FeatureToggle.create(name: 'ft_test')
    @ft_history = @feature_toggle.histories.create(
      description: 'Toggled on'
    )

    # ...
  end
end