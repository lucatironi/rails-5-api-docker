require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  before do
    allow_message_expectations_on_nil
    user = User.create(email: 'user@example.com', password: 'password')
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  it_behaves_like 'api_controller'

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { full_name: 'John Doe', email: 'john.doe@example.com', phone: '123456789' }
  end

  let(:invalid_attributes) do
    { full_name: nil, email: 'john.doe@example.com', phone: '123456789' }
  end

  let!(:customer) { Customer.create(valid_attributes) }

  describe 'GET #index' do
    it 'assigns all customers as @customers' do
      get :index, params: { format: :json }
      expect(assigns(:customers)).to eq([customer])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested customer as @customer' do
      get :show, params: { id: customer.id, format: :json }
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Customer' do
        expect do
          post :create, params: { customer: valid_attributes, format: :json }
        end.to change(Customer, :count).by(1)
      end

      it 'assigns a newly created customer as @customer' do
        post :create, params: { customer: valid_attributes, format: :json }
        expect(assigns(:customer)).to be_a(Customer)
        expect(assigns(:customer)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved customer as @customer' do
        post :create, params: { customer: invalid_attributes, format: :json }
        expect(assigns(:customer)).to be_a_new(Customer)
      end

      it 'returns unprocessable_entity status' do
        put :create, params: { customer: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { full_name: 'John F. Doe', phone: '234567890' }
      end

      it 'updates the requested customer' do
        put :update, params: { id: customer.id, customer: new_attributes, format: :json }
        customer.reload
        expect(customer.full_name).to eq('John F. Doe')
        expect(customer.phone).to eq('234567890')
      end

      it 'assigns the requested customer as @customer' do
        put :update, params: { id: customer.id, customer: valid_attributes, format: :json }
        expect(assigns(:customer)).to eq(customer)
      end
    end

    context 'with invalid params' do
      it 'assigns the customer as @customer' do
        put :update, params: { id: customer.id, customer: invalid_attributes, format: :json }
        expect(assigns(:customer)).to eq(customer)
      end

      it 'returns unprocessable_entity status' do
        put :update, params: { id: customer.id, customer: invalid_attributes, format: :json }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested customer' do
      expect do
        delete :destroy, params: { id: customer.id, format: :json }
      end.to change(Customer, :count).by(-1)
    end

    it 'redirects to the customers list' do
      delete :destroy, params: { id: customer.id, format: :json }
      expect(response.status).to eq(204)
    end
  end
end
