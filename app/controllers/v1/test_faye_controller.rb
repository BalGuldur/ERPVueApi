class V1::TestFayeController < V1::BaseController
  include ApplicationHelper

  def test
    broadcast('/new', message: 'test')
  end
end
