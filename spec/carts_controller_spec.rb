require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user, status: :in_progress) }
  let(:order_item) { create(:order_item, order: order, product: product, quantity:3) }
  let(:product) { create(:product) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_order).and_return(order)
  end

  describe 'GET #show' do
    it 'assigns the current order items' do
      get :show
      expect(assigns(:order_items)).to eq(order.order_items)
    end

    it 'renders the show template' do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #placed' do
    context 'when the order is in progress' do
      it 'sends a confirmation email and updates the order status to placed' do
        expect(OrderMailMailer).to receive(:confirmation).with(order).and_return(double(deliver_now: true))

        post :placed, params: { order: { shipping: 'lahore', billing: 'karachi' } }

        expect(order.reload.status).to eq('placed')
        expect(response).to redirect_to(carts_path)
      end
    end

    context 'when the order is not in progress' do
      before { order.update(status: :placed) }

      it 'does not place the order and redirects with an alert' do
        post :placed, params: { order: { status: "delivered" } }

        expect(order.reload.status).to eq('placed')
        expect(response).to redirect_to(carts_path)
        expect(flash[:alert]).to eq('Order cannot be placed.')
      end
    end
  end
end