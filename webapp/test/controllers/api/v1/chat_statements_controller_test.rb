require 'test_helper'

class ChatStatementsControllerTest < ActionDispatch::IntegrationTest

  test 'Bot send an answer to a user statement' do
    post "/api/v1/chat_sessions/#{chat_sessions(:one).id}/statements.json", params: {
      statement: {
        nature: 'text',
        content: 'Hello'
      }
    }
    assert_equal '201', response.code
  end
end
