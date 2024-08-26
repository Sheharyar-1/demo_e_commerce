require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }
  let(:admin) { create(:user, :admin) }
  let(:p_order) {create(:order, :placed, user: user)}

  describe 'GET #index' do
    context 'when admin is logged in' do
      before do
        sign_in admin
        allow(controller).to receive(:current_user).and_return(admin)
      end
      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'returns a successful response' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'updates the order status if the user owns the order' do
        patch :update, params: { id: order.id, order: { status: 'placed' } }
        expect(order.reload.status).to eq('placed')
      end
    end

    context 'when user is logged in and changing to delivered' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'Does not update order if it is placed' do
        patch :update, params: { id: p_order.id, order: { status: 'delivered' } }
        expect(order.reload.status).not_to eq('delivered')
      end
    end

    context 'when admin is logged in and changing to delivered' do
      before do
        sign_in admin
        allow(controller).to receive(:current_user).and_return(admin)
      end
      it 'updates the order status if admin' do
        patch :update, params: { id: order.id, order: { status: 'delivered' } }
        expect(order.reload.status).to eq('delivered')
      end
    end
  end
end
