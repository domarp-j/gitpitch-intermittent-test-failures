module Foo
  BAR = :original
end

Foo.stub_const(:BAR, :stubbed) do
  Foo::BAR
end # => :stubbed

Foo::BAR # => :original