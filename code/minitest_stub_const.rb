module Foo
  BAR = :original
end

Foo.stub_const(:BAR, :stubbed) do
  Foo::BAR
  # execute any other code that needs a stubbed BAR
end
# => :stubbed

Foo::BAR
# => :original