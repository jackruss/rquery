describe 'rquery' do
  context 'receives where={"name": "foo"}' do
    it 'should render where => [{ :name => "foo"}]'
  end

  context 'receives where={"name": "foo", "desc": "bar"}' do
    it 'should render { where => [{ :name => "foo", :desc => "bar"}]}'
  end

  context 'receives where={"name": "foo", "created_at": {"$gt": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at > ?", "2012-03-01"]] '
  end

end
