require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:product) {create(:product)}

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'paginates the products' do
      create_list(:product, 5)
      get :index
      expect(assigns(:products).count).to eq(5)
    end
  end

  describe 'GET #show' do
    
    it 'returns a successful response' do
      get :show, params: { id: product.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'when user is an admin' do
      before do
        sign_in admin
        allow(controller).to receive(:current_user).and_return(admin)
      end
      
      it 'creates a new product' do
        post :create, params: { product: { name: 'New Product', description: 'New Description', price: 10.0 } }
        puts Product.last.errors.full_messages unless Product.last
        expect(Product.last.name).to eq('New Product')
      end
    end

    context 'when user is not an admin' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'does not create a new product' do
        post :create, params: { product: { name: 'New Product', description: 'New Description', price: 10.0 } }

        expect(Product.last).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when admin is logged in' do
      before do
        sign_in admin
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'updates the product' do
        patch :update, params: { id: product.id, product: { name: 'Updated Name' } }
        expect(Product.last.name).to eq('Updated Name')
      end
    end

    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'Does not update the product' do
        patch :update, params: { id: product.id, product: { name: 'Updated Name' } }
        expect(Product.last.name).not_to eq('Updated Name')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is an admin' do
      before do
        sign_in admin
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'destroys the product' do
        product = create(:product)
        expect {delete :destroy, params: { id: product.id }}.to change(Product, :count).by(-1)
      end
    end

    context 'when user is not an admin' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
    
      it 'raises an error when unauthorized' do
        product = create(:product)
        delete :destroy, params: { id: product.id }
        expect(response).to redirect_to(root_path)
      end
    end    
  end

end