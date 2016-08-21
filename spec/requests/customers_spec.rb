require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:authentication_token) do
    AuthenticationToken.create(user_id: user.id,
                               body: 'token', last_used_at: DateTime.current)
  end
  let!(:customer) { Customer.create(full_name: 'John Doe', email: 'john.doe@example.com') }

  let(:valid_session) do
    { 'HTTP_X_USER_EMAIL' => user.email,
      'HTTP_X_AUTH_TOKEN' => authentication_token.body }
  end

  let(:invalid_session) do
    { 'HTTP_X_USER_EMAIL' => user.email,
      'HTTP_X_AUTH_TOKEN' => nil }
  end

  describe 'GET /customers' do
    it 'lists all the customers' do
      get customers_path, params: { format: :json }, headers: valid_session
      expect(response).to have_http_status(200)
    end

    it "doesn't list all the customers with invalid session" do
      get customers_path, params: { format: :json }, headers: invalid_session
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET /customers/:id' do
    it 'gets a single customer' do
      get customer_path(customer), params: { format: :json }, headers: valid_session
      expect(response).to have_http_status(200)
    end

    it "doesn't get a single customer with invalid session" do
      get customer_path(customer), params: { format: :json }, headers: invalid_session
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST /customers' do
    it 'creates a new customer' do
      post customers_path,
           params: { customer: { full_name: 'John Doe', email: 'john.doe@example.com' },
                     format: :json }, headers: valid_session
      expect(response).to have_http_status(201)
    end

    it "doesn't create a new customer with invalid session" do
      post customers_path,
           params: { customer: { full_name: 'John Doe', email: 'john.doe@example.com' },
                     format: :json }, headers: invalid_session
      expect(response).to have_http_status(401)
    end
  end

  describe 'PUT /customers/:id' do
    it 'updates a customer' do
      put customer_path(customer),
          params: { customer: { full_name: 'John F. Doe' }, format: :json },
          headers: valid_session
      expect(response).to have_http_status(204)
    end

    it "doesn't update a customer with invalid session" do
      put customer_path(customer),
          params: { customer: { full_name: 'John F. Doe' }, format: :json },
          headers: invalid_session
      expect(response).to have_http_status(401)
    end
  end

  describe 'DELETE /customers/:id' do
    it 'deletes a customer' do
      delete customer_path(customer), params: { format: :json }, headers: valid_session
      expect(response).to have_http_status(204)
    end

    it "doesn't delete a customer with invalid sesssion" do
      delete customer_path(customer), params: { format: :json }, headers: invalid_session
      expect(response).to have_http_status(401)
    end
  end
end
