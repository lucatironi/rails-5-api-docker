require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:authentication_token) do
    AuthenticationToken.create(user_id: user.id,
                               body: 'token', last_used_at: DateTime.current)
  end

  let(:valid_session) do
    { 'HTTP_X_USER_EMAIL' => user.email,
      'HTTP_X_AUTH_TOKEN' => authentication_token.body }
  end

  let(:invalid_session) do
    { 'HTTP_X_USER_EMAIL' => user.email,
      'HTTP_X_AUTH_TOKEN' => nil }
  end

  describe 'POST /sessions' do
    it 'logs in the user' do
      post sessions_path, params: { user: { email: user.email, password: 'password' }, format: :json }
      expect(response).to have_http_status(200)
    end

    it "doesn't log in the user with invalid credentials" do
      post sessions_path, params: { user: { email: user.email, password: 'not-password' }, format: :json }
      expect(response).to have_http_status(401)
    end
  end

  describe 'DELETE /sessions' do
    it 'logs out the user' do
      delete sessions_path, params: { format: :json }, headers: valid_session
      expect(response).to have_http_status(200)
    end

    it "doesn't log the user with invalid session" do
      delete sessions_path, params: { format: :json }, headers: invalid_session
      expect(response).to have_http_status(401)
    end
  end
end
